#!/usr/bin/env bash
set -euo pipefail

# ╔══════════════════════════════════════════════════════════════╗
# ║  Claude Code Project Template — Installer                   ║
# ║  Deploys skills, agents, commands, and docs to your project ║
# ╚══════════════════════════════════════════════════════════════╝

REPO_URL="https://github.com/Ninety2UA/claude-code-blueprint"
TEMP_DIR=""
VERSION="2.2.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
    echo ""
    echo -e "${BOLD}  Claude Code Project Template${NC} ${DIM}v${VERSION}${NC}"
    echo -e "${DIM}  Production-grade scaffolding for AI-assisted development${NC}"
    echo ""
}

info()    { echo -e "  ${BLUE}▸${NC} $1"; }
success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }
error()   { echo -e "  ${RED}✗${NC} $1"; }

cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

usage() {
    echo "Usage: $0 [OPTIONS] [TARGET_DIR]"
    echo ""
    echo "Deploy the Claude Code project template to your project."
    echo ""
    echo "Arguments:"
    echo "  TARGET_DIR          Target directory (default: current directory)"
    echo ""
    echo "Options:"
    echo "  --claude-only       Only install .claude/ directory (skills, agents, commands)"
    echo "  --docs-only         Only install docs/ structure and CLAUDE.md"
    echo "  --no-overwrite      Skip files that already exist"
    echo "  --force             Overwrite all existing files without prompting"
    echo "  --dry-run           Show what would be installed without making changes"
    echo "  -v, --version       Show version and exit"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                              # Install to current directory"
    echo "  $0 ~/projects/my-app            # Install to specific project"
    echo "  $0 --claude-only                # Only add .claude/ configuration"
    echo "  $0 --no-overwrite .             # Install without overwriting"
    echo ""
}

# Parse arguments
TARGET_DIR="."
CLAUDE_ONLY=false
DOCS_ONLY=false
NO_OVERWRITE=false
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --claude-only)  CLAUDE_ONLY=true; shift ;;
        --docs-only)    DOCS_ONLY=true; shift ;;
        --no-overwrite) NO_OVERWRITE=true; shift ;;
        --force)        FORCE=true; shift ;;
        --dry-run)      DRY_RUN=true; shift ;;
        -v|--version)   echo "claude-code-blueprint v${VERSION}"; exit 0 ;;
        -h|--help)      usage; exit 0 ;;
        -*)             error "Unknown option: $1"; usage; exit 1 ;;
        *)              TARGET_DIR="$1"; shift ;;
    esac
done

# Resolve target directory
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"

print_banner

# Validate
if [ "$CLAUDE_ONLY" = true ] && [ "$DOCS_ONLY" = true ]; then
    error "--claude-only and --docs-only are mutually exclusive"
    exit 1
fi

# Check if target exists
if [ ! -d "$TARGET_DIR" ]; then
    info "Creating target directory: $TARGET_DIR"
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$TARGET_DIR"
    fi
fi

info "Target: ${BOLD}$TARGET_DIR${NC}"
echo ""

# Download template
info "Downloading template..."
TEMP_DIR=$(mktemp -d)

if command -v git &>/dev/null; then
    git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR/template" 2>/dev/null || {
        error "Failed to clone repository. Check your internet connection."
        exit 1
    }
else
    error "git is required. Please install git and try again."
    exit 1
fi

SOURCE_DIR="$TEMP_DIR/template"

# Copy function with conflict handling
copy_item() {
    local src="$1"
    local dest="$2"
    local rel_path="${dest#"$TARGET_DIR"/}"

    if [ -d "$src" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo -e "  ${DIM}  mkdir $rel_path/${NC}"
        else
            mkdir -p "$dest"
        fi
        return
    fi

    if [ -f "$dest" ]; then
        if [ "$NO_OVERWRITE" = true ]; then
            echo -e "  ${DIM}  skip  $rel_path (exists)${NC}"
            return
        fi
        if [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
            # Only prompt for important files
            case "$rel_path" in
                CLAUDE.md|BACKLOG.md|docs/context/*)
                    warn "$rel_path already exists"
                    read -p "    Overwrite? [y/N] " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        echo -e "  ${DIM}  skip  $rel_path${NC}"
                        return
                    fi
                    ;;
            esac
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${DIM}  copy  $rel_path${NC}"
    else
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    fi
}

# Determine what to install
INSTALLED=0

if [ "$DOCS_ONLY" = false ]; then
    info "Installing .claude/ (skills, agents, commands)..."
    if [ -d "$SOURCE_DIR/.claude" ]; then
        find "$SOURCE_DIR/.claude" -type f | while read -r file; do
            rel="${file#"$SOURCE_DIR"/}"
            copy_item "$file" "$TARGET_DIR/$rel"
        done
        INSTALLED=$((INSTALLED + 1))
        success ".claude/ installed"
    fi
fi

if [ "$CLAUDE_ONLY" = false ]; then
    info "Installing docs/ structure..."
    if [ -d "$SOURCE_DIR/docs" ]; then
        find "$SOURCE_DIR/docs" -type f | while read -r file; do
            rel="${file#"$SOURCE_DIR"/}"

            # Skip README diagram images (only needed for GitHub display)
            case "$rel" in
                docs/images/*.svg|docs/images/*.mmd|docs/images/*.png|docs/images/*.html)
                    continue ;;
            esac

            copy_item "$file" "$TARGET_DIR/$rel"
        done
        INSTALLED=$((INSTALLED + 1))
        success "docs/ installed (examples included — delete when ready)"
    fi

    # Plugin manifest
    if [ -d "$SOURCE_DIR/.claude-plugin" ]; then
        find "$SOURCE_DIR/.claude-plugin" -type f | while read -r file; do
            rel="${file#"$SOURCE_DIR"/}"
            copy_item "$file" "$TARGET_DIR/$rel"
        done
        success ".claude-plugin/ installed (plugin manifest)"
    fi

    # Core files
    for file in CLAUDE.md BACKLOG.md blueprint.local.md .gitignore; do
        if [ -f "$SOURCE_DIR/$file" ]; then
            copy_item "$SOURCE_DIR/$file" "$TARGET_DIR/$file"
        fi
    done
    success "Core files installed"
fi

# Create placeholder directories
if [ "$CLAUDE_ONLY" = false ] && [ "$DRY_RUN" = false ]; then
    for dir in src tests scripts infra; do
        mkdir -p "$TARGET_DIR/$dir"
        if [ ! -f "$TARGET_DIR/$dir/.gitkeep" ]; then
            touch "$TARGET_DIR/$dir/.gitkeep"
        fi
    done
fi

echo ""

if [ "$DRY_RUN" = true ]; then
    info "Dry run complete. No files were modified."
else
    echo -e "  ${GREEN}${BOLD}Installation complete!${NC}"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    echo -e "  ${DIM}1.${NC} cd $TARGET_DIR"
    echo -e "  ${DIM}2.${NC} claude"
    echo -e "  ${DIM}3.${NC} /init ${DIM}← interactive project setup${NC}"
    echo ""
    echo -e "  ${DIM}Quick commands: /build · /plan · /review-swarm · /deep-research · /orchestrate · /wrap${NC}"
fi

echo ""
