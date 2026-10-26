#!/bin/bash
#
# makechangelog.sh - Generate a succinct release changelog from manifest diffs
#
# Downloads the two most recent manifest.xml from nova-video-player/aos-AVP
# GitHub releases, diffs the git revisions for each repo, collects all commit
# messages, and uses Claude Code to summarize them into a bullet-point release.txt.
#
# Supports both repo manifest XML and git submodule status manifest formats.
#
# Requirements: gh (GitHub CLI, authenticated), claude (Claude Code CLI)
#
# Usage:
#   ./makechangelog.sh                    # compare latest vs previous release
#   ./makechangelog.sh v6.4.27 v6.4.26   # compare two specific tags
#   ./makechangelog.sh v6.4.27            # compare v6.4.27 vs previous release

set -euo pipefail

REPO="nova-video-player/aos-AVP"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="$SCRIPT_DIR/release.txt"

# --- Determine which two releases to compare ---

# Release tags, newest first, with duplicates removed: re-running the release
# workflow can leave several draft releases carrying the same tag.
list_tags() {
    gh release list -R "$REPO" --limit 30 --json tagName --jq '.[].tagName' \
        | awk '!seen[$0]++'
}

if [ $# -ge 2 ]; then
    NEW_TAG="$1"
    OLD_TAG="$2"
elif [ $# -eq 1 ]; then
    NEW_TAG="$1"
    OLD_TAG=$(list_tags \
        | grep -A1 "^${NEW_TAG}$" | tail -1)
    if [ -z "$OLD_TAG" ] || [ "$OLD_TAG" = "$NEW_TAG" ]; then
        echo "Error: cannot find the release before $NEW_TAG"
        exit 1
    fi
else
    TAGS=$(list_tags | head -2)
    NEW_TAG=$(echo "$TAGS" | head -1)
    OLD_TAG=$(echo "$TAGS" | tail -1)
    if [ -z "$OLD_TAG" ] || [ "$OLD_TAG" = "$NEW_TAG" ]; then
        echo "Error: cannot find two distinct releases to compare"
        exit 1
    fi
fi

echo "Comparing $NEW_TAG vs $OLD_TAG"
echo "---"

# --- Download manifests ---

gh release download "$NEW_TAG" -R "$REPO" -p 'manifest.xml' -O "$WORK/manifest-new.xml"
gh release download "$OLD_TAG" -R "$REPO" -p 'manifest.xml' -O "$WORK/manifest-old.xml"

# --- Parse manifests and collect commit logs ---
# Supports two formats:
#   1. Repo manifest XML: <project name="aos-Video" revision="abc123" .../>
#   2. Git submodule status (with .gitmodules header):
#        ### GITMODULES ###
#        [submodule "Video"]
#            path = Video
#            url = ../aos-Video.git
#        ### SUBMODULE STATUS ###
#         abc123 Video (heads/nova)

# Build a mapping file from submodule path to GitHub repo name
# Input: manifest file containing ### GITMODULES ### section
# Output: file with lines "path reponame"
build_submodule_map() {
    local manifest="$1"
    local mapfile="$2"
    # Extract .gitmodules section (between GITMODULES and SUBMODULE STATUS markers)
    sed -n '/^### GITMODULES ###$/,/^### SUBMODULE STATUS ###$/p' "$manifest" \
        | grep -E '(path|url) = ' \
        | paste - - \
        | sed -E 's/.*path = ([^ ]+).*url = \.\.\/([^.]+)(\.git)?$/\1 \2/' \
        > "$mapfile"
}

# Parse manifest into "reponame revision" lines
parse_manifest() {
    local manifest="$1"
    local mapfile="$2"

    if grep -q '<project ' "$manifest" 2>/dev/null; then
        # Repo manifest XML format
        grep '<project ' "$manifest" \
            | sed -E 's/.*name="([^"]+)".*revision="([^"]+)".*/\1 \2/'
    elif grep -q '### SUBMODULE STATUS ###' "$manifest" 2>/dev/null; then
        # Git submodule status format with .gitmodules header
        # Extract submodule status lines after the marker
        sed -n '/^### SUBMODULE STATUS ###$/,$ p' "$manifest" \
            | grep -v '^### ' \
            | sed -E 's/^[ +-]?([0-9a-f]+) ([^ ]+).*/\2 \1/' \
            | while read -r path rev; do
                # Map submodule path to GitHub repo name
                repo_name=$(grep "^$path " "$mapfile" | awk '{print $2}' || true)
                if [ -n "$repo_name" ]; then
                    echo "$repo_name $rev"
                else
                    echo "$path $rev"
                fi
            done
    else
        # Plain git submodule status (no .gitmodules header, legacy fallback)
        sed -E 's/^[ +-]?([0-9a-f]+) ([^ ]+).*/\2 \1/' "$manifest"
    fi
}

# Build submodule maps if needed
build_submodule_map "$WORK/manifest-new.xml" "$WORK/submodule-map-new.txt" 2>/dev/null || true
build_submodule_map "$WORK/manifest-old.xml" "$WORK/submodule-map-old.txt" 2>/dev/null || true

parse_manifest "$WORK/manifest-new.xml" "$WORK/submodule-map-new.txt" > "$WORK/projects-new.txt"
parse_manifest "$WORK/manifest-old.xml" "$WORK/submodule-map-old.txt" > "$WORK/projects-old.txt"

COMMITS_FILE="$WORK/all-commits.txt"
> "$COMMITS_FILE"

while read -r name new_rev; do
    old_rev=$(grep "^$name " "$WORK/projects-old.txt" | awk '{print $2}' || true)

    if [ -z "$old_rev" ]; then
        echo "=== $name (NEW REPO) ===" >> "$COMMITS_FILE"
        echo "(new repository added in this release)" >> "$COMMITS_FILE"
        echo "" >> "$COMMITS_FILE"
        continue
    fi

    [ "$old_rev" = "$new_rev" ] && continue

    echo "  Fetching commits for $name ..."

    commits=$(gh api "repos/nova-video-player/$name/compare/${old_rev}...${new_rev}" \
        --jq '.commits[] | "- " + (.commit.message | split("\n")[0])' 2>/dev/null || true)

    if [ -n "$commits" ]; then
        echo "=== $name ===" >> "$COMMITS_FILE"
        echo "$commits" >> "$COMMITS_FILE"
        echo "" >> "$COMMITS_FILE"
    fi
done < "$WORK/projects-new.txt"

echo ""
echo "=== Raw commits collected ==="
cat "$COMMITS_FILE"
echo "=== End raw commits ==="
echo ""

if [ ! -s "$COMMITS_FILE" ]; then
    echo "No changes found between $OLD_TAG and $NEW_TAG"
    exit 0
fi

# --- Build prompt file and summarize with Claude Code ---

cat > "$WORK/prompt.txt" <<PROMPT_EOF
You are writing a changelog entry for Nova Video Player release $NEW_TAG (compared to $OLD_TAG).

Below are all the git commit first-lines from every repository that changed between these two releases.

Produce a succinct, user-facing changelog as a bullet-point list (one dash per line).
Group related changes together.
Focus on what matters to users: bug fixes, new features, improvements.
Use imperative/present tense verbs (e.g., "Fix", "Improve", "Add") instead of past tense ("Fixed", "Improved", "Added").
Skip internal/build/chore commits (crowdin sync, version bumps, changelog updates, doc updates) unless they have user-visible impact.
Keep each bullet to one concise line.
Do not include commit hashes or repo names.
Output ONLY the bullet list, nothing else.

Commit messages:
$(cat "$COMMITS_FILE")
PROMPT_EOF

echo "Summarizing with Claude Code..."

# Unset CLAUDECODE to allow nested invocation
unset CLAUDECODE 2>/dev/null || true
claude -p "$(cat "$WORK/prompt.txt")" > "$OUTPUT"

echo ""
echo "=== Generated release.txt ==="
cat "$OUTPUT"
echo ""
echo "Output written to: $OUTPUT"
