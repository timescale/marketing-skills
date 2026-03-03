# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A Claude plugin marketplace for the Tiger Data marketing team. It packages marketing skills (brand voice writing, content review, email sequences, etc.) for both **Cowork** (Claude Desktop) and **Claude Code** (CLI). Confidential context (brand voice details, sales frameworks) lives in Google Drive — not in this repo. Skills fetch reference docs at runtime.

## Before Making Any Changes

**Do this before editing any files.** Check the current branch and get onto a feature branch off `release`:

```bash
# Check current branch
git branch --show-current

# Switch to release and pull latest
git checkout release
git pull origin release

# Create a feature branch
git checkout -b feature/short-description
```

Never commit directly to `main` or `release`. All work happens on feature branches, and all PRs target `release`.

## Build Commands

All build commands run from `plugins/tiger-marketing-skills/`:

```bash
# Build both Cowork .zip and Claude Code skills/ directory
./build-plugin.sh

# Build only the Cowork plugin .zip
./build-plugin.sh --target cowork

# Build only the Claude Code skills/ flat directory
./build-plugin.sh --target claude-code

# Build with a specific version
./build-plugin.sh --version 1.2.0
```

Output: `dist/tigerdata-marketing-skills.zip` (Cowork) and `plugins/tiger-marketing-skills/skills/` (Claude Code, gitignored).

## Validation

PR validation runs automatically via `.github/workflows/validate-skills.yml`. It checks:
- SKILL.md frontmatter has required fields (`name`, `platforms`, `description`)
- `platforms` values are valid (`cowork`, `claude-code`)
- Referenced files exist (no broken `../` references)
- SKILL.md is under 500 lines

There is no formal test suite. Skills are tested manually on 2-3 realistic prompts.

## Architecture

### Plugin structure

```
plugins/tiger-marketing-skills/
├── .claude-plugin/plugin.json    ← version and metadata (source of truth for version)
├── config.json                   ← runtime config (Google Drive folder ID)
├── REFERENCES.md                 ← how skills fetch docs from Google Drive
├── _template/                    ← copy to create new skills
├── build-plugin.sh               ← build script (produces both targets)
├── vendor-skills.json            ← controls which vendor skills are included
├── vendor/marketingskills/       ← git submodule (coreyhaines31/marketingskills)
├── <category>/<skill-name>/      ← native skills organized by category
│   ├── SKILL.md                  ← frontmatter + instructions (the skill itself)
│   └── references/               ← markdown reference docs Claude reads at runtime
└── skills/                       ← generated flat output (gitignored)
```

### Skill categories (native)

Skills live in category subdirectories: `content-creation/`, `seo/`, `social-media/`, `analytics/`, `meta/`. The folder name inside a category becomes the skill name.

### How the build works

`build-plugin.sh` collects native skills from category dirs and enabled vendor skills from submodules (filtered by `vendor-skills.json`), then:
- For Cowork: packages into a `.zip` (only cowork-compatible skills)
- For Claude Code: copies into `skills/` flat directory (all compatible skills)

### Vendor skills

Community skills from external repos via git submodules in `vendor/`. Controlled by `vendor-skills.json` — toggle `"enabled": true/false`. Never edit files inside `vendor/` directly; copy to a native category if customization is needed.

## Branching and Release Flow

- **`release`** — integration branch; all PRs target this branch
- **`main`** — release-ready; only updated by automated PRs from `release`
- Feature branches: `feature/*`, `fix/*`, `docs/*` — branch from `release`, PR back to `release`

Always branch from `release`, not `main`. `release` has the latest merged work; `main` only catches up after a release is published, so it may be behind.

Release process: merge to `release` → publish GitHub Release with semver tag (e.g. `v1.2.0`) → CI builds .zip, bumps version in `plugin.json`, opens auto-merge PR to `main`.

## Creating a New Skill

1. Copy `_template/` to `<category>/your-skill-name/`
2. Edit `SKILL.md`: fill in frontmatter (`name`, `platforms`, `description`) and write instructions
3. Set `platforms` correctly: `[cowork, claude-code]` for instruction-only skills, `[claude-code]` for skills requiring terminal/file access
4. Add reference docs to `references/` if needed
5. PR to `release` branch

## Skill Writing Conventions

- Write instructions in imperative form ("Read the glossary" not "You should read the glossary")
- SKILL.md contains core instructions; lengthy reference material goes in `references/`
- The `description` field in frontmatter controls when the skill triggers — make it specific
- Keep SKILL.md under 500 lines

## Git Submodules

After cloning, initialize submodules:
```bash
git submodule update --init --recursive
```
