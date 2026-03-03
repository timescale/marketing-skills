#!/usr/bin/env bash
set -euo pipefail

# TigerData Marketing Skills — Plugin Builder
# Assembles the plugin's skills into a Cowork .zip for manual install / releases.
#
# The marketplace reads directly from the repo (skills/ directory), so the main
# use of this script is to produce .zip files for manual installs and GitHub
# Releases.
#
# Usage:
#   ./build-plugin.sh                              # build Cowork .zip
#   ./build-plugin.sh --target cowork              # same (explicit)
#   ./build-plugin.sh --version 1.2.0              # override version

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLUGIN_NAME="tigerdata-marketing-skills"

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
TARGET="cowork"
while [[ $# -gt 0 ]]; do
  case $1 in
    --version) VERSION="$2"; shift 2 ;;
    --target)  TARGET="$2"; shift 2 ;;
    *) error "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ "$TARGET" != "cowork" ]]; then
  error "Invalid target: $TARGET (only 'cowork' is supported — the marketplace reads skills/ directly)"
  exit 1
fi

# ── Helper: collect skills from skills/ with optional platform filter ──
collect_skills() {
  local dest_dir="$1"
  local platform_filter="${2:-}"
  SKILL_COUNT=0

  mkdir -p "$dest_dir"

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
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

  # Collect skills (cowork-compatible only)
  collect_skills "$BUILD_DIR/skills" "cowork"

  if [ "$SKILL_COUNT" -eq 0 ]; then
    error "No Cowork-compatible skills found!"
    return 1
  fi

  # Create plugin README
  cat > "$BUILD_DIR/README.md" <<'READMEEOF'
# TigerData Marketing Skills

Claude skills for the TigerData marketing team. Gives Claude specialized knowledge about our brand voice, audience, positioning, terminology, and content quality standards.

## Community Skills

For additional marketing skills (cold email, launch strategy, paid ads, etc.), install the **marketingskills** plugin from the same marketplace.

## Optional: Tiger Den MCP server

Some skills can use the Tiger Den MCP server for voice profiles and content search. All skills work without it. See the [repo README](https://github.com/timescale/marketing-skills) for setup instructions.

## Contributing

To contribute new skills or update existing ones, see the [repo on GitHub](https://github.com/timescale/marketing-skills).
READMEEOF
  info "Created plugin README"

  # Package
  ZIP_FILENAME="${PLUGIN_NAME}-${VERSION}.zip"
  TMP_ZIP="/tmp/${ZIP_FILENAME}"
  rm -f "$TMP_ZIP"
  (cd "$BUILD_DIR" && zip -r "$TMP_ZIP" . -x "*.DS_Store" -x "__MACOSX/*") > /dev/null
  cp "$TMP_ZIP" "$DIST_DIR/${ZIP_FILENAME}"
  rm -f "$TMP_ZIP"

  info "Cowork plugin: $DIST_DIR/${ZIP_FILENAME} ($SKILL_COUNT skills)"
}

# ── Run ──
build_cowork

echo ""
info "Done!"
