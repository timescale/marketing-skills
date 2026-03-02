#!/usr/bin/env bash
set -euo pipefail

# TigerData Marketing Skills — Plugin Builder
# Assembles the plugin's skills into distributable formats.
#
# This script lives inside the plugin directory (plugins/tiger-marketing-skills/)
# and operates relative to that location. Build artifacts go to dist/ at the
# repo root for easy pickup by GitHub Actions.
#
# Usage:
#   ./build-plugin.sh                              # build for all targets
#   ./build-plugin.sh --target cowork              # Cowork .zip only (excludes claude-code-only skills)
#   ./build-plugin.sh --target claude-code         # sync skills/ for Claude Code (all skills)
#   ./build-plugin.sh --target all                 # both (default)
#   ./build-plugin.sh --version 1.2.0              # override version
#   ./build-plugin.sh --target cowork --version 1.2.0

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_CATEGORIES=("content-creation" "seo" "social-media" "analytics" "meta")
PLUGIN_NAME="tigerdata-marketing-skills"
VENDOR_CONFIG="$SCRIPT_DIR/vendor-skills.json"

# Read version from plugin.json if it exists, otherwise fall back to 0.1.0
if [ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ] && command -v jq &> /dev/null; then
  DEFAULT_VERSION=$(jq -r '.version // "0.1.0"' "$SCRIPT_DIR/.claude-plugin/plugin.json")
else
  DEFAULT_VERSION="0.1.0"
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1" >&2; }

# ── Parse args ──
VERSION="$DEFAULT_VERSION"
TARGET="all"
while [[ $# -gt 0 ]]; do
  case $1 in
    --version) VERSION="$2"; shift 2 ;;
    --target)  TARGET="$2"; shift 2 ;;
    *) error "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ "$TARGET" != "cowork" && "$TARGET" != "claude-code" && "$TARGET" != "all" ]]; then
  error "Invalid target: $TARGET (must be cowork, claude-code, or all)"
  exit 1
fi

# ── Helper: collect native skills with optional platform filter ──
# Sets SKILL_COUNT as a side effect (avoids stdout conflicts with info/warn)
collect_skills() {
  local dest_dir="$1"
  local platform_filter="${2:-}"
  SKILL_COUNT=0

  mkdir -p "$dest_dir"

  for category in "${SKILL_CATEGORIES[@]}"; do
    category_dir="$SCRIPT_DIR/$category"
    [ -d "$category_dir" ] || continue

    for skill_dir in "$category_dir"/*/; do
      [ -d "$skill_dir" ] || continue
      skill_name=$(basename "$skill_dir")

      # Must have a SKILL.md
      [ -f "$skill_dir/SKILL.md" ] || continue

      # Platform filtering
      if [ -n "$platform_filter" ]; then
        platforms_line=$(head -20 "$skill_dir/SKILL.md" | grep "^platforms:" || echo "")
        if [ -n "$platforms_line" ]; then
          if ! echo "$platforms_line" | grep -q "$platform_filter"; then
            warn "  Skipped $skill_name (not compatible with $platform_filter)"
            continue
          fi
        fi
        # No platforms field = universal, include for any filter
      fi

      cp -r "$skill_dir" "$dest_dir/$skill_name"
      info "  Added skill: $skill_name"
      SKILL_COUNT=$((SKILL_COUNT + 1))
    done
  done
}

# ── Helper: collect vendor skills from vendor-skills.json ──
# Reads the config, finds enabled skills, filters by platform, copies them.
# Adds to SKILL_COUNT (call after collect_skills or reset SKILL_COUNT first).
collect_vendor_skills() {
  local dest_dir="$1"
  local platform_filter="${2:-}"

  if [ ! -f "$VENDOR_CONFIG" ]; then
    warn "  No vendor-skills.json found, skipping vendor skills"
    return
  fi

  # Check if jq is available
  if ! command -v jq &> /dev/null; then
    warn "  jq not found, skipping vendor skills (install jq to enable)"
    return
  fi

  mkdir -p "$dest_dir"

  # Iterate over each vendor
  for vendor in $(jq -r '.vendors | keys[]' "$VENDOR_CONFIG"); do
    vendor_path=$(jq -r ".vendors[\"$vendor\"].path" "$VENDOR_CONFIG")
    vendor_dir="$SCRIPT_DIR/$vendor_path"

    if [ ! -d "$vendor_dir" ]; then
      warn "  Vendor directory not found: $vendor_path (run 'git submodule update --init')"
      continue
    fi

    info "  Vendor: $vendor"

    # Iterate over enabled skills for this vendor
    for skill_name in $(jq -r ".vendors[\"$vendor\"].skills | to_entries[] | select(.value.enabled == true) | .key" "$VENDOR_CONFIG"); do
      skill_dir="$vendor_dir/$skill_name"

      if [ ! -d "$skill_dir" ] || [ ! -f "$skill_dir/SKILL.md" ]; then
        warn "    Skipped $skill_name (not found in vendor repo)"
        continue
      fi

      # Platform filtering using the config (not the SKILL.md frontmatter)
      if [ -n "$platform_filter" ]; then
        platforms=$(jq -r ".vendors[\"$vendor\"].skills[\"$skill_name\"].platforms | join(\",\")" "$VENDOR_CONFIG")
        if ! echo "$platforms" | grep -q "$platform_filter"; then
          warn "    Skipped $skill_name (not compatible with $platform_filter)"
          continue
        fi
      fi

      # Copy the skill, avoiding conflicts with native skills
      if [ -d "$dest_dir/$skill_name" ]; then
        warn "    Skipped $skill_name (name conflicts with native skill)"
        continue
      fi

      cp -r "$skill_dir" "$dest_dir/$skill_name"
      info "    Added vendor skill: $skill_name"
      SKILL_COUNT=$((SKILL_COUNT + 1))
    done
  done
}

# ── Build Cowork plugin (.zip) ──
build_cowork() {
  info "Building Cowork plugin v${VERSION}..."

  BUILD_DIR=$(mktemp -d)
  DIST_DIR="$REPO_ROOT/dist"
  mkdir -p "$DIST_DIR"
  trap 'rm -rf "$BUILD_DIR"' RETURN

  # Create plugin manifest
  mkdir -p "$BUILD_DIR/.claude-plugin"
  cat > "$BUILD_DIR/.claude-plugin/plugin.json" <<EOF
{
  "name": "${PLUGIN_NAME}",
  "version": "${VERSION}",
  "description": "Claude skills for the TigerData marketing team — brand voice, content review, SEO, and more.",
  "author": {
    "name": "TigerData Marketing"
  },
  "repository": "https://github.com/timescale/marketing-skills",
  "keywords": ["marketing", "brand-voice", "content", "tigerdata", "timescale"]
}
EOF
  info "Created plugin manifest"

  # Copy runtime config files into the zip so skills can find them
  [ -f "$SCRIPT_DIR/config.json" ] && cp "$SCRIPT_DIR/config.json" "$BUILD_DIR/config.json"
  [ -f "$SCRIPT_DIR/REFERENCES.md" ] && cp "$SCRIPT_DIR/REFERENCES.md" "$BUILD_DIR/REFERENCES.md"

  # Collect native skills (cowork-compatible only)
  collect_skills "$BUILD_DIR/skills" "cowork"
  local native_count=$SKILL_COUNT

  # Collect vendor skills (cowork-compatible only)
  collect_vendor_skills "$BUILD_DIR/skills" "cowork"
  local total_count=$SKILL_COUNT

  if [ "$total_count" -eq 0 ]; then
    error "No Cowork-compatible skills found!"
    return 1
  fi

  # Create plugin README
  cat > "$BUILD_DIR/README.md" <<'READMEEOF'
# TigerData Marketing Skills

Claude skills for the TigerData marketing team. Gives Claude specialized knowledge about our brand voice, audience, positioning, terminology, and content quality standards. Also includes curated community skills for marketing strategy, email, ads, and more.

## Optional: Tiger Den MCP server

Some skills can use the Tiger Den MCP server for voice profiles and content search. All skills work without it. See the [repo README](https://github.com/timescale/marketing-skills) for setup instructions.

## Contributing

To contribute new skills or update existing ones, see the [repo on GitHub](https://github.com/timescale/marketing-skills).
READMEEOF
  info "Created plugin README"

  # Package
  TMP_ZIP="/tmp/${PLUGIN_NAME}.zip"
  rm -f "$TMP_ZIP"
  (cd "$BUILD_DIR" && zip -r "$TMP_ZIP" . -x "*.DS_Store" -x "__MACOSX/*") > /dev/null
  cp "$TMP_ZIP" "$DIST_DIR/${PLUGIN_NAME}.zip"
  rm -f "$TMP_ZIP"

  info "Cowork plugin: $DIST_DIR/${PLUGIN_NAME}.zip ($native_count native + $((total_count - native_count)) vendor = $total_count skills)"
}

# ── Build Claude Code plugin (sync skills/ directory) ──
build_claude_code() {
  info "Syncing skills/ for Claude Code..."

  # Update the version in the plugin's plugin.json
  if [ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]; then
    if command -v jq &> /dev/null; then
      jq --arg version "$VERSION" '.version = $version' \
        "$SCRIPT_DIR/.claude-plugin/plugin.json" > "$SCRIPT_DIR/.claude-plugin/plugin.json.tmp" \
        && mv "$SCRIPT_DIR/.claude-plugin/plugin.json.tmp" "$SCRIPT_DIR/.claude-plugin/plugin.json"
    else
      sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"${VERSION}\"/" \
        "$SCRIPT_DIR/.claude-plugin/plugin.json"
    fi
    info "Updated .claude-plugin/plugin.json to v${VERSION}"
  fi

  # Clean and recreate skills/ directory
  rm -rf "$SCRIPT_DIR/skills"
  mkdir -p "$SCRIPT_DIR/skills"

  # Collect all native skills (no platform filter — Claude Code gets everything)
  collect_skills "$SCRIPT_DIR/skills" ""
  local native_count=$SKILL_COUNT

  # Collect all vendor skills (no platform filter)
  collect_vendor_skills "$SCRIPT_DIR/skills" ""
  local total_count=$SKILL_COUNT

  if [ "$total_count" -eq 0 ]; then
    error "No skills found!"
    return 1
  fi

  info "Claude Code plugin: skills/ directory synced ($native_count native + $((total_count - native_count)) vendor = $total_count skills)"
}

# ── Run targets ──
case "$TARGET" in
  cowork)
    build_cowork
    ;;
  claude-code)
    build_claude_code
    ;;
  all)
    build_cowork
    echo ""
    build_claude_code
    ;;
esac

echo ""
info "Done! Build complete for target: $TARGET"
