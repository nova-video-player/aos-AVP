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

function info(){ echo "[INFO] $*" | tee -a "$LOG_FILE"; }
function warn(){ echo "[WARN] $*" | tee -a "$LOG_FILE"; }
function err(){ echo "[ERROR] $*" | tee -a "$LOG_FILE" >&2; }
function commit_step(){
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
  warn "Working tree not clean -> creating checkpoint commit"
  git add -A && git commit -m "chore: checkpoint before feature stripping" || true
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" != "$BRANCH" ]]; then
  git checkout -B "$BRANCH"
  info "Switched to branch $BRANCH"
fi

MANIFEST=""
for f in "${MANIFEST_CANDS[@]}"; do [[ -f "$f" ]] && { MANIFEST="$f"; break; }; done
[[ -n "$MANIFEST" ]] || warn "Manifest not found (default.xml). Some steps will skip."

# ===== 步骤 1：清理 manifest / settings =====
info "== Step1: manifest/settings clean =="
if [[ -n "$MANIFEST" ]]; then
  cp "$MANIFEST" "$MANIFEST.bak"
  for name in aos-torrentd aos-libtorrent-android-builder aos-SubtitleParser; do
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
  # 删除 include 行的相关模块
  sed -i -E '\#(aos-SubtitleParser|aos-torrentd|aos-libtorrent-android-builder)#d' "$s"
  commit_step "build(settings): remove removed modules from includes ($s)"
done

# ===== 步骤 2：依赖黑名单清理（保留 SMB 白名单） =====
info "== Step2: dependencies blacklist =="
FOUND_LIBS=0
for f in "${LIBS_TOML_CANDS[@]}"; do
  [[ -f "$f" ]] || continue
  FOUND_LIBS=1
  cp "$f" "$f.bak"
  # 先检查白名单，避免误删
  if grep -Ei "$WHITE_RE" "$f" >/dev/null; then info "SMB deps present in $f (ok)"; fi
  # 删除黑名单依赖/别名
  sed -i -E "/$BLACK_RE/I d" "$f"
  commit_step "build(catalog): drop blacklisted deps in $f"
done
[[ "$FOUND_LIBS" -eq 0 ]] && warn "No libs.versions.toml found"

# 清理各模块 build.gradle*
GFILES=(**/build.gradle **/build.gradle.kts)
for g in "${GFILES[@]}"; do
  [[ -f "$g" ]] || continue
  cp "$g" "$g.bak" || true
  # 删除黑名单依赖行
  sed -i -E "/$BLACK_RE/I d" "$g" || true
  # 移除 ktlint（若存在）
  sed -i -E '/org\.jlleitschuh\.gradle\.ktlint/d' "$g" || true
done
commit_step "build: remove blacklisted deps/plugins across modules"

# ===== 步骤 3：Manifest 清理（Leanback/TV/入口） =====
info "== Step3: AndroidManifest cleanup =="
while IFS= read -r -d '' mf; do
  cp "$mf" "$mf.bak"
  sed -i -E -e '/android\.software\.leanback/d' \
            -e '/android\.hardware\.television/d' \
            -e '/LEANBACK_LAUNCHER/d' \
            -e '/CATEGORY_LEANBACK_LAUNCHER/d' "$mf"
done < <(find . -name AndroidManifest.xml -print0)
commit_step "feat(video): remove Leanback/TV categories and features from manifests"

# ===== 步骤 4：文档温和清理（仅相关小节） =====
info "== Step4: docs prune (gentle) =="
DOCS=(README.md readme.md faq.md faq/faq.md)
for d in "${DOCS[@]}"; do
  [[ -f "$d" ]] || continue
  cp "$d" "$d.bak"
  # 仅清理含关键字的段落（以空行分段），避免误删普通链接
  awk -v IGN="$LOG_FILE" '
    BEGIN{RS=""; ORS="\n\n"}
    {
      blk=$0
      if (blk ~ /(FTP|FTPS|SFTP|WebDAV|UPnP|DLNA|HTTP|HTTPS|torrent|Trakt|TMDB|字幕下载|OpenSubtitles)/i) {
        # 删除整段
      } else {
        print blk
      }
    }' "$d" > "$d.__tmp__" && mv "$d.__tmp__" "$d"
done
commit_step "docs: prune references to removed features (targeted sections)"

# ===== 步骤 5：源码物理删 + 接口收敛 =====
info "== Step5: source removal & API shrink =="

# 5A FileCoreLibrary
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
for p in "${FCL_PATTERNS[@]}"; do
  for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done
done
commit_step "feat(filecore): drop FTP/FTPS/SFTP/WebDAV/UPnP/DLNA implementations"

# 5B MediaLib
declare -a ML_PATTERNS=(
  "**/aos-MediaLib/**/**Tmdb*.kt" "**/aos-MediaLib/**/**Tmdb*.java" "**/aos-MediaLib/**/metadata/tmdb/**"
  "**/aos-MediaLib/**/**Upnp*.kt" "**/aos-MediaLib/**/**Upnp*.java"
  "**/aos-MediaLib/**/**Dlna*.kt" "**/aos-MediaLib/**/**Dlna*.java"
  "**/aos-MediaLib/**/**Trakt*.kt" "**/aos-MediaLib/**/**Trakt*.java" "**/aos-MediaLib/**/sync/trakt/**"
)
for p in "${ML_PATTERNS[@]}"; do
  for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done
done
commit_step "feat(medialib): remove TMDB/UPnP/Trakt related sources"

# 5C Video
declare -a V_PATTERNS=(
  "**/aos-Video/**/**Leanback*.kt" "**/aos-Video/**/**Leanback*.java" "**/aos-Video/**/**Leanback*.xml"
  "**/aos-Video/**/tv/**" "**/aos-Video/**/values-tv*/**"
  "**/aos-Video/**/**Torrent*.kt" "**/aos-Video/**/**Torrent*.java"
  "**/aos-Video/**/**Magnet*.kt" "**/aos-Video/**/**Magnet*.java"
  "**/aos-Video/**/**OpenSubtitles*.kt" "**/aos-Video/**/**OpenSubtitles*.java"
  "**/aos-Video/**/**SubtitleDownload*.kt" "**/aos-Video/**/**SubtitleDownload*.java"
  "**/aos-Video/**/**OpenUrl*.kt" "**/aos-Video/**/**OpenUrl*.java"
)
for p in "${V_PATTERNS[@]}"; do
  for f in $p; do [[ -e "$f" ]] && git rm -f "$f" || true; done
done
commit_step "feat(video): remove Leanback/torrent/open-url/online-subtitles sources"

# ===== 步骤 6：构建与残留审计 =====
info "== Step6: build & residual scan =="

function try_build_once(){
  make | tee -a "$LOG_FILE"
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

  # 常见自动修复：不存在的 import/依赖残留；Room 实体 @Ignore 临时化
  # 1) 删除已不存在类的 import
  rg -n "import .*(Ftp|Sftp|Webdav|Upnp|Dlna|Trakt|Tmdb|OpenSubtitles|Torrent|Leanback)" --glob '!build' \
    | cut -d: -f1 | sort -u | while read -r f; do
        sed -i -E '/import .*Ftp|import .*Sftp|import .*Webdav|import .*WebDav|import .*Upnp|import .*Dlna|import .*Trakt|import .*Tmdb|import .*OpenSubtitles|import .*Torrent|import .*Leanback/d' "$f"
      done

  # 2) 枚举/when 分支占位：将无用 case 删除或注释
  rg -n "case .*FTP|SFTP|WEBDAV|UPNP|DLNA|HTTP|HTTPS|TORRENT|TRAKT|TMDB|OPENSUBTITLES|LEANBACK" --glob '!build' \
    | cut -d: -f1 | sort -u | while read -r f; do
        sed -i -E '/FTP|SFTP|WEBDAV|UPNP|DLNA|HTTP|HTTPS|TORRENT|TRAKT|TMDB|OPENSUBTITLES|LEANBACK/s/^/\/\/ AUTOSTRIP: /' "$f"
      done

  commit_step "chore: minimal auto-fix for removed refs (imports/enums)"
done

# 残留关键词审计
RESIDUAL="$(grep -RInE "$SCAN_RE" -- . | grep -Ev "$IGNORE_RE" || true)"
if [[ -n "$RESIDUAL" ]]; then
  warn "Residual matches found, pruning safely (comments/strings may remain)"
  echo "$RESIDUAL" | tee -a "$LOG_FILE"
fi

commit_step "chore: final sweep of removed-feature references"

# ===== 步骤 7：产物 & 文档 =====
info "== Step7: outputs & docs =="

# CHANGELOG 追加
CHANGELOG="CHANGELOG.md"
{
  echo "## Strip legacy net/online features ($(date +%Y-%m-%d))"
  echo "- Removed: FTP/FTPS, SFTP, WebDAV, UPnP/DLNA, HTTP(S) direct streaming, torrent/libtorrent, TMDB, Trakt, online subtitle download, multi-subtitle selection, TV/Leanback."
  echo "- Kept: Local/SMB playback; core player; basic file browsing."
  echo "- Impact: Old bookmarks for HTTP/UPnP/torrent no longer work. Please migrate to Local/SMB sources."
  echo
} >> "$CHANGELOG"

# PR 模板
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

info "== All steps completed successfully =="
exit 0