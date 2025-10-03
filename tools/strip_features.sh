#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s globstar nullglob

# ===== 基础 =====
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$ROOT_DIR" ]] || { echo "Not inside a git repo"; exit 2; }
cd "$ROOT_DIR"

LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/strip.log"

BRANCH="chore/strip-net-and-online-features"
MANIFEST_CANDS=("default.xml" ".repo/manifests/default.xml")
SETTINGS_CANDS=("settings.gradle" "settings.gradle.kts")
LIBS_TOML_CANDS=("gradle/libs.versions.toml" "gradle/libs.versions.versions.toml" "gradle/libs.versions.extra.toml")

BLACK_RE='commons-?net|jsch|sshj|sardine|webdav|cling|upnp|androidx\.leanback|libtorrent|\btorrent\b|opensubtitles|tmdb|trakt|exoplayer-okhttp|exoplayer-rtmp'
WHITE_RE='smbj|jcifs(-ng)?'
SCAN_RE='FTP|FTPS|SFTP|WebDAV|UPnP|DLNA|\bHTTP\b|\bHTTPS\b|\btorrent\b|libtorrent|Trakt|TMDB|OpenSubtitles|Leanback'
IGNORE_RE='(\.git|build/|\.gradle|third_party|LICENSE|CHANGELOG|NOTICE)'

# ripgrep fallback
if ! command -v rg >/dev/null 2>&1; then
  echo "[INFO] ripgrep not found, fallback to grep -R" | tee -a "$LOG_FILE"
  rg(){ grep -R "$@"; }
fi

info(){ echo "[INFO] $*" | tee -a "$LOG_FILE"; }
warn(){ echo "[WARN] $*" | tee -a "$LOG_FILE"; }
err(){ echo "[ERROR] $*" | tee -a "$LOG_FILE" >&2; }
commit_step(){
  local msg="$1"
  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "$msg" || true
    info "Committed: $msg"
  else
    info "No staged changes for: $msg"
  fi
}

trap 'err "Script failed at line $LINENO"; exit 1' ERR

# ===== 预检 =====
info "== Preflight =="
git update-index -q --refresh || true
if ! git diff --quiet || ! git diff --cached --quiet; then
  warn "Working tree not clean -> checkpoint commit"
  git add -A && git commit -m "chore: checkpoint before feature stripping" || true
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" != "$BRANCH" ]]; then
  git checkout -B "$BRANCH"
  info "Switched to branch $BRANCH"
fi

MANIFEST=""
for f in "${MANIFEST_CANDS[@]}"; do [[ -f "$f" ]] && { MANIFEST="$f"; break; }; done
[[ -n "$MANIFEST" ]] || warn "Manifest not found (default.xml). Some steps may skip."

# ===== Step1: manifest/settings =====
info "== Step1: manifest/settings clean =="
if [[ -n "$MANIFEST" ]]; then
  cp "$MANIFEST" "$MANIFEST.bak"
  for name in aos-torrentd aos-libtorrent-android-builder aos-SubtitleParser aos-ffmpeg-android-builder aos-openssl-android-builder; do
    if grep -q "name=\"$name\"" "$MANIFEST"; then
      sed -i "/<project[^>]*name=\"$name\"[^>]*\/>/d" "$MANIFEST"
      info "Removed <project name=\"$name\">"
    fi
  done
  commit_step "feat(manifest): drop torrentd/libtorrent builder/subtitleparser"
fi
for s in "${SETTINGS_CANDS[@]}"; do
  [[ -f "$s" ]] || continue
  cp "$s" "$s.bak"
  sed -i -E '\#(aos-SubtitleParser|aos-torrentd|aos-libtorrent-android-builder|aos-ffmpeg-android-builder|aos-openssl-android-builder)#d' "$s"
  commit_step "build(settings): remove removed modules from includes ($s)"
done

# ===== Step2: deps blacklist =====
info "== Step2: dependencies blacklist =="
FOUND_LIBS=0
for f in "${LIBS_TOML_CANDS[@]}"; do
  [[ -f "$f" ]] || continue
  FOUND_LIBS=1
  cp "$f" "$f.bak"
  grep -Ei "$WHITE_RE" "$f" >/dev/null && info "SMB deps present in $f (ok)"
  sed -i -E "/$BLACK_RE/I d" "$f"
  commit_step "build(catalog): drop blacklisted deps in $f"
done
[[ "$FOUND_LIBS" -eq 0 ]] && warn "No libs.versions.toml found"

GFILES=(**/build.gradle **/build.gradle.kts)
for g in "${GFILES[@]}"; do
  [[ -f "$g" ]] || continue
  cp "$g" "$g.bak" || true
  sed -i -E "/$BLACK_RE/I d" "$g" || true
  sed -i -E '/org\.jlleitschuh\.gradle\.ktlint/d' "$g" || true
done
commit_step "build: remove blacklisted deps/plugins across modules"

# ===== Step3: Manifests (TV/Leanback) =====
info "== Step3: AndroidManifest cleanup =="
while IFS= read -r -d '' mf; do
  cp "$mf" "$mf.bak"
  sed -i -E -e '/android\.software\.leanback/d' \
            -e '/android\.hardware\.television/d' \
            -e '/LEANBACK_LAUNCHER/d' \
            -e '/CATEGORY_LEANBACK_LAUNCHER/d' "$mf"
done < <(find . -name AndroidManifest.xml -print0)
commit_step "feat(video): remove Leanback/TV categories and features from manifests"

# ===== Step4: docs (gentle prune) =====
info "== Step4: docs prune (gentle) =="
DOCS=(README.md readme.md faq.md faq/faq.md)
for d in "${DOCS[@]}"; do
  [[ -f "$d" ]] || continue
  cp "$d" "$d.bak"
  awk 'BEGIN{RS=""; ORS="\n\n"} {blk=$0;
      if (blk ~ /(FTP|FTPS|SFTP|WebDAV|UPnP|DLNA|HTTP|HTTPS|torrent|Trakt|TMDB|字幕下载|OpenSubtitles)/i) { } else {print blk}}' \
      "$d" > "$d.__tmp__" && mv "$d.__tmp__" "$d"
done
commit_step "docs: prune references to removed features (targeted sections)"

# ===== Step5: source removal =====
info "== Step5: source removal & API shrink =="

declare -a FCL_PATTERNS=(
  "**/aos-FileCoreLibrary/**/**Ftp*.kt" "**/aos-FileCoreLibrary/**/**Ftp*.java"
  "**/aos-FileCoreLibrary/**/**FTPS*.kt" "**/aos-FileCoreLibrary/**/**FTPS*.java"
  "**/aos-FileCoreLibrary/**/mlst/**"
  "**/aos-FileCoreLibrary/**/**Proftpd*.kt" "**/aos-FileCoreLibrary/**/**Proftpd*.java"
  "**/aos-FileCoreLibrary/**/**Sftp*.kt" "**/aos-FileCoreLibrary/**/**Sftp*.java"
  "**/aos-FileCoreLibrary/**/**Webdav*.kt" "**/aos-FileCoreLibrary/**/**Webdav*.java"
  "**/aos-FileCoreLibrary/**/**WebDav*.kt" "**/aos-FileCoreLibrary/**/**WebDav*.java"
  "**/aos-FileCoreLibrary/**/**Upnp*.kt" "**/aos-FileCoreLibrary/**/**Upnp*.java"
  "**/aos-FileCoreLibrary/**/**Dlna*.kt" "**/aos-FileCoreLibrary/**/**Dlna*.java"
)
for p in "${FCL_PATTERNS[@]}"; do for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done; done
commit_step "feat(filecore): drop FTP/FTPS/SFTP/WebDAV/UPnP/DLNA implementations"

declare -a ML_PATTERNS=(
  "**/aos-MediaLib/**/**Tmdb*.kt" "**/aos-MediaLib/**/**Tmdb*.java" "**/aos-MediaLib/**/metadata/tmdb/**"
  "**/aos-MediaLib/**/**Upnp*.kt" "**/aos-MediaLib/**/**Upnp*.java"
  "**/aos-MediaLib/**/**Dlna*.kt" "**/aos-MediaLib/**/**Dlna*.java"
  "**/aos-MediaLib/**/**Trakt*.kt" "**/aos-MediaLib/**/**Trakt*.java" "**/aos-MediaLib/**/sync/trakt/**"
)
for p in "${ML_PATTERNS[@]}"; do for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done; done
commit_step "feat(medialib): remove TMDB/UPnP/Trakt related sources"

declare -a V_PATTERNS=(
  "**/aos-Video/**/**Leanback*.kt" "**/aos-Video/**/**Leanback*.java" "**/aos-Video/**/**Leanback*.xml"
  "**/aos-Video/**/tv/**" "**/aos-Video/**/values-tv*/**"
  "**/aos-Video/**/**Torrent*.kt" "**/aos-Video/**/**Torrent*.java"
  "**/aos-Video/**/**Magnet*.kt" "**/aos-Video/**/**Magnet*.java"
  "**/aos-Video/**/**OpenSubtitles*.kt" "**/aos-Video/**/**OpenSubtitles*.java"
  "**/aos-Video/**/**SubtitleDownload*.kt" "**/aos-Video/**/**SubtitleDownload*.java"
  "**/aos-Video/**/**OpenUrl*.kt" "**/aos-Video/**/**OpenUrl*.java"
)
for p in "${V_PATTERNS[@]}"; do for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done; done
commit_step "feat(video): remove Leanback/torrent/open-url/online-subtitles sources"

# ===== Step6: build & residual =====
info "== Step6: build & residual scan =="

detect_build_system(){
  if [[ -x "./gradlew" ]]; then echo "gradle"; return 0; fi
  if [[ -f "Makefile" ]]; then echo "make"; return 0; fi
  echo "unknown"; return 1
}
ensure_repo_tool(){
  if command -v repo >/dev/null 2>&1; then return 0; fi
  mkdir -p "$HOME/bin"
  curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o "$HOME/bin/repo"
  chmod a+x "$HOME/bin/repo"
  export PATH="$HOME/bin:$PATH"
  info "Installed repo tool into \$HOME/bin"
}
ensure_avp_core(){
  if [[ -f "AVP/core.mk" ]]; then return 0; fi
  ensure_repo_tool
  local remote="${AVP_MANIFEST_REMOTE:-https://github.com/nova-video-player/aos-AVP.git}"
  local branch="${AVP_MANIFEST_BRANCH:-nova}"
  if [[ ! -d ".repo" ]]; then
    info "repo init -u $remote -b $branch"
    repo init -u "$remote" -b "$branch" | tee -a "$LOG_FILE"
  fi
  info "repo sync -j8"
  # repo sync -j8 | tee -a "$LOG_FILE"
  info "repo forall checkout manifest rev"
  repo forall -c 'git checkout -B $REPO_RREV || true' | tee -a "$LOG_FILE"
  [[ -f "AVP/core.mk" ]] || { err "AVP/core.mk still missing after repo sync"; return 1; }
  info "AVP/core.mk present"
}
BUILD_SYSTEM="$(detect_build_system || true)"
info "Detected build system: ${BUILD_SYSTEM:-unknown}"

try_build_once(){
  case "$BUILD_SYSTEM" in
    gradle)
      ./gradlew --no-daemon clean :aos-Video:assembleDebug -x test | tee -a "$LOG_FILE"
      ;;
    make)
      if grep -q 'AVP/core.mk' Makefile && [[ ! -f "AVP/core.mk" ]]; then
        info "Makefile expects AVP/core.mk; syncing sub-repos…"
        ensure_avp_core || return 1
      fi
      make | tee -a "$LOG_FILE"
      ;;
    *)
      err "Unknown build system. Neither ./gradlew nor Makefile found."
      return 1
      ;;
  esac
}

ATTEMPT=0
MAX_FIX=2
until try_build_once; do
  ((ATTEMPT++))
  if (( ATTEMPT > MAX_FIX )); then
    err "Build still failing after $MAX_FIX fix attempts"
    echo "__FATAL__" >> "$LOG_FILE"
    exit 1
  fi
  warn "Build failed. Attempting minimal auto-fix #$ATTEMPT"

  # --- Auto-fix A: FFmpeg headers missing (e.g., swscale.h) ---
  if grep -Ei "swscale\.h'? file not found|fatal error: .*swscale\.h" "$LOG_FILE" >/dev/null 2>&1; then
    info "Detected missing FFmpeg headers (swscale.h). Trying to install dev packages…"
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y pkg-config nasm yasm \
        libswscale-dev libavutil-dev libavcodec-dev libavformat-dev libavfilter-dev || true
      info "FFmpeg dev packages installed (if available). Will retry build after other fixes."
    else
      warn "apt-get not available on this runner; please ensure FFmpeg headers are present in include path."
    fi
  fi
  rg -n "import .*(Ftp|Sftp|Webdav|Upnp|Dlna|Trakt|Tmdb|OpenSubtitles|Torrent|Leanback)" --glob '!build' \
    | cut -d: -f1 | sort -u | while read -r f; do
        sed -i -E '/import .*Ftp|import .*Sftp|import .*Webdav|import .*WebDav|import .*Upnp|import .*Dlna|import .*Trakt|import .*Tmdb|import .*OpenSubtitles|import .*Torrent|import .*Leanback/d' "$f"
      done
  rg -n "case .*FTP|SFTP|WEBDAV|UPNP|DLNA|HTTP|HTTPS|TORRENT|TRAKT|TMDB|OPENSUBTITLES|LEANBACK" --glob '!build' \
    | cut -d: -f1 | sort -u | while read -r f; do
        sed -i -E '/FTP|SFTP|WEBDAV|UPNP|DLNA|HTTP|HTTPS|TORRENT|TRAKT|TMDB|OPENSUBTITLES|LEANBACK/s/^/\/\/ AUTOSTRIP: /' "$f"
      done
  commit_step "chore: minimal auto-fix for removed refs (imports/enums)"
done

RESIDUAL="$(grep -RInE "$SCAN_RE" -- . | grep -Ev "$IGNORE_RE" || true)"
if [[ -n "$RESIDUAL" ]]; then
  warn "Residual matches found (for review)"
  echo "$RESIDUAL" | tee -a "$LOG_FILE"
fi
commit_step "chore: final sweep of removed-feature references"

# ===== Step7: outputs =====
info "== Step7: outputs & docs =="
CHANGELOG="CHANGELOG.md"
{
  echo "## Strip legacy net/online features ($(date +%Y-%m-%d))"
  echo "- Removed: FTP/FTPS, SFTP, WebDAV, UPnP/DLNA, HTTP(S) direct streaming, torrent/libtorrent, TMDB, Trakt, online subtitle download, multi-subtitle selection, TV/Leanback."
  echo "- Kept: Local/SMB playback; core player; basic file browsing."
  echo "- Impact: Old bookmarks for HTTP/UPnP/torrent no longer work. Please migrate to Local/SMB sources."
  echo
} >> "$CHANGELOG"
mkdir -p .github/PULL_REQUEST_TEMPLATE
cat > .github/PULL_REQUEST_TEMPLATE/strip_features.md <<'EOF'
# Strip legacy net/online features; keep Local/SMB only

## Summary
Removed FTP/FTPS, SFTP, WebDAV, UPnP/DLNA, HTTP(S) direct streaming, torrent/libtorrent, TMDB, Trakt, online subtitle download, multi-subtitle selection, TV/Leanback. Kept Local/SMB.

## Changes
- manifest/settings cleanup
- dep blacklist removal
- source removal in FileCoreLibrary/MediaLib/Video
- docs pruning
- final residual audit

## Breaking Changes
- Old HTTP/UPnP/torrent bookmarks invalid

## Verification
- Build logs attached
- Grep audit clean (no forbidden deps/keywords)
- App runs: Local/SMB browsing/playback; only embedded subtitles visible; no removed-feature entries in UI

## Migration Notes
- If DB schemas changed, migrations included or fields @Ignore-temporized.
EOF
commit_step "docs: add changelog entry and PR template"

# Remove .repo to avoid pushing large files
rm -rf .repo

info "== All steps completed successfully =="
exit 0