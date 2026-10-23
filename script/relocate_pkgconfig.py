#!/usr/bin/env python3
# Copyright 2026 Courville Software
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Make installed .pc files relative to their prebuilt repository root.

Usage: python3 AVP/script/relocate_pkgconfig.py [--check] native/prebuilt/zlib ...

Pass each library's install root, not the common native/prebuilt directory.
Only pkg-config metadata is edited; binaries, .la files and config scripts are
untouched. Run after installation, including when a builder reuses its cache.
"""

import argparse
import os
from pathlib import Path
import re
import stat
import tempfile


PREFIX = re.compile(r"^prefix[ \t]*=[ \t]*(.*)$", re.MULTILINE)


def relocated_text(text, pc, root):
    match = PREFIX.search(text)
    if not match:
        raise ValueError(f"{pc}: missing prefix assignment")
    old_prefix = match.group(1).strip().rstrip("/")
    if match.group(1).strip() == "/":
        raise ValueError(f"{pc}: refusing to relocate a filesystem-root prefix")

    # FreeType can embed literal install paths directly in Libs and Cflags.
    # Also handle a partially relocated file whose prefix is already relative.
    prefixes = {str(root)}
    if old_prefix.startswith("/"):
        prefixes.add(old_prefix)
    for prefix in sorted(prefixes, key=len, reverse=True):
        pattern = re.escape(prefix) + r"(?=/|[\s\"';]|$)"
        text = re.sub(pattern, lambda _: "${prefix}", text)

    relative = Path(os.path.relpath(root, pc.parent)).as_posix()
    value = "${pcfiledir}" if relative == "." else "${pcfiledir}/" + relative
    return PREFIX.sub(lambda _: "prefix=" + value, text)


def pc_files(root):
    # Do not walk .git or install-directory aliases (Fontconfig uses symlinks).
    for directory, dirs, files in os.walk(root, followlinks=False):
        dirs[:] = sorted(d for d in dirs if not d.startswith(".")
                         and not (Path(directory) / d).is_symlink())
        for name in sorted(files):
            path = Path(directory) / name
            if name.endswith(".pc") and not path.is_symlink():
                yield path


def replace_file(path, text):
    # Preserve permissions and avoid leaving half-written metadata behind.
    mode = stat.S_IMODE(path.stat().st_mode)
    fd, temporary = tempfile.mkstemp(prefix=".relocate-", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as output:
            output.write(text)
        os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="report files needing relocation without changing them")
    parser.add_argument("roots", type=Path, nargs="+", help="library install roots")
    args = parser.parse_args(argv)
    pending = []
    seen = set()
    try:
        for supplied in args.roots:
            root = supplied.resolve(strict=True)
            if not root.is_dir():
                raise ValueError(f"{supplied}: not a directory")
            for pc in pc_files(root):
                if pc in seen:
                    continue
                seen.add(pc)
                old = pc.read_text(encoding="utf-8")
                new = relocated_text(old, pc, root)
                if new != old:
                    pending.append((pc, new))
        for pc, text in pending:
            if not args.check:
                replace_file(pc, text)
            print(f"{'Needs relocation' if args.check else 'Relocated'}: {pc}")
    except (OSError, ValueError, UnicodeError) as error:
        parser.exit(2, f"{error}\n")
    print(f"Checked {len(seen)} pkg-config files; "
          f"{len(pending)} {'need relocation' if args.check else 'updated'}.")
    return 1 if args.check and pending else 0


if __name__ == "__main__":
    raise SystemExit(main())
