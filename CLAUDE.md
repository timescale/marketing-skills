# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A Claude plugin marketplace for the Tiger Data marketing team. It packages marketing skills (brand voice writing, content review, SEO, etc.) for both **Cowork** (Claude Desktop) and **Claude Code** (CLI). Confidential context (brand voice details, sales frameworks) lives in Google Drive — not in this repo. Skills fetch reference docs at runtime.

The marketplace also lists a community plugin ([marketingskills](https://github.com/coreyhaines31/marketingskills) by Corey Haines) as a separate install. Users can install it alongside our plugin if they want cold email, launch strategy, paid ads, and other community skills.

## Before Making Any Changes

**Do this before editing any files.** Check the current branch and get onto a feature branch off `release`:

```bash
# Check current branch
git branch --show-current

# Fetch all remote branches (needed on first clone — release may not exist locally yet)
git fetch origin

# Switch to release and pull latest
git checkout release
git pull origin release

# Create a feature branch
git checkout -b feature/short-description
```

Never commit directly to `main` or `release`. All work happens on feature branches, and all PRs target `release`.

### Cowork sandbox limitations

In Cowork (Claude Desktop), git **read** commands work but must be run with `GIT_OPTIONAL_LOCKS=0` to prevent stale `.git/index.lock` files. Even read commands like `git status` and `git diff` can create lock files when refreshing the index, and the Cowork sandbox can't clean them up — leaving a lock file that breaks all subsequent git operations for the user.

Always prefix git commands with the environment variable:
```bash
GIT_OPTIONAL_LOCKS=0 git status
GIT_OPTIONAL_LOCKS=0 git diff
GIT_OPTIONAL_LOCKS=0 git log
```

**NEVER run git write commands in Cowork.** This includes `git add`, `git commit`, `git push`, `git checkout -b`, `git merge`, `git rebase`, `git stash`, `git reset`, and any other command that modifies the repo state. These commands will fail in the sandbox and may leave behind a `.git/index.lock` file that breaks all subsequent git operations for the user. Do not attempt write commands and then improvise when they fail — plan for this upfront.

When changes are ready to submit:

1. **Ask the user** before starting any git workflow: *"Ready to create a PR? Do you want me to walk you through the git steps, or are you comfortable running them yourself?"*
2. **If they want help:** Invoke the **skill-contributor** skill, which guides non-technical users through branching, committing, pushing, and opening a PR step by step.
3. **If they're comfortable with git:** Provide the exact terminal commands they need to copy-paste (branch, add, commit, and `gh pr create`). Skip `git push` — `gh pr create` will offer to push the branch automatically. Present each command separately so they're easy to copy one at a time. Don't assume they know the repo's branching conventions — always specify `release` as the base branch.

In Claude Code (CLI), git write commands work normally. Proceed with commits and pushes directly.

## Build Commands

The build script is only needed for producing the Cowork `.zip` for manual installs and releases. The marketplace reads skills directly from the repo — no build step required.

All build commands run from `plugins/tiger-marketing-skills/`:

```bash
# Build the Cowork plugin .zip
./build-plugin.sh --target cowork

# Build with a specific version
./build-plugin.sh --target cowork --version 1.2.0
```

Output: `dist/tigerdata-marketing-skills-<version>.zip` (Cowork manual install artifact).

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
├── build-plugin.sh               ← build script (produces Cowork .zip)
└── skills/                       ← all native skills (flat directory, committed)
    ├── brand-voice-writer/
    ├── content-reviewer/
    ├── doctor/
    ├── ghost-paper/
    ├── seo-meta-optimizer/
    ├── setup/
    └── skill-contributor/
```

### How skills are discovered

Cowork and Claude Code read skills from the flat `skills/` directory inside the plugin. Each skill is a folder containing a `SKILL.md` (frontmatter + instructions) and optionally a `references/` directory with markdown docs Claude reads at runtime.

### How the build works

`build-plugin.sh` collects skills from `skills/`, filters by platform compatibility, and packages them into a `.zip` for manual Cowork installs. The marketplace reads `skills/` directly from the repo, so no build is needed for that path.

### Community skills

Community skills from [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) are listed as a separate plugin in `marketplace.json`. Users install them independently through the marketplace — they are not bundled into our plugin.

## Branching and Release Flow

- **`release`** — integration branch; all PRs target this branch
- **`main`** — release-ready; only updated by automated PRs from `release`
- Feature branches: `feature/*`, `fix/*`, `docs/*` — branch from `release`, PR back to `release`

Always branch from `release`, not `main`. `release` has the latest merged work; `main` only catches up after a release is published, so it may be behind.

Release process: merge to `release` → publish GitHub Release with semver tag (e.g. `v1.2.0`) → CI builds .zip, bumps version in `plugin.json`, opens auto-merge PR to `main`.

**NEVER modify the version in `plugin.json`.** CI handles versioning automatically during the release process. Do not bump, set, or touch the version number for any reason.

## Creating a New Skill

1. Copy `_template/` to `skills/your-skill-name/`
2. Edit `SKILL.md`: fill in frontmatter (`name`, `platforms`, `description`) and write instructions
3. Set `platforms` correctly: `[cowork, claude-code]` for instruction-only skills, `[claude-code]` for skills requiring terminal/file access
4. Add reference docs to `references/` if needed
5. Update the skills table in `README.md` to include the new skill
6. PR to `release` branch

## Skill Writing Conventions

- Write instructions in imperative form ("Read the glossary" not "You should read the glossary")
- SKILL.md contains core instructions; lengthy reference material goes in `references/`
- The `description` field in frontmatter controls when the skill triggers — make it specific
- Keep SKILL.md under 500 lines
