# Contributing to Marketing Skills

Everyone on the team is welcome to create new skills or improve existing ones. All changes go through pull requests to the `release` branch so someone can give them a quick review before they go live.

## Setting up for skill development

### Using Cowork (Claude Desktop)

The easiest way to work on skills is with Cowork mode in Claude Desktop. This gives you Claude as a collaborator that can read your skill files, help you write SKILL.md instructions, and test changes in real time.

> **New to the terminal?** You'll need a terminal app to run the commands below. On **Mac**, open **Terminal** (press Cmd+Space to open Spotlight, type "Terminal", and hit Enter). On **Windows**, open **PowerShell** (click Start, type "PowerShell", and hit Enter). Once it's open, you can paste commands directly into it.

1. **Install the `gh` command line tool:** We strongly recommend this — it handles GitHub authentication, cloning, and pull requests all in one tool, so you won't have to wrestle with SSH keys or personal access tokens. Install it from [GitHub CLI](https://cli.github.com/). On Mac with Homebrew, that's just `brew install gh`.

1. **Clone the repo** (if you haven't already):
   ```bash
   gh repo clone timescale/marketing-skills
   ```

1. **Fetch the `release` branch:** After cloning, the `release` branch may not exist locally yet. Fetch it so you can branch from it later:
   ```bash
   cd marketing-skills
   git fetch origin release:release
   ```

2. **Set up your name and email for `git`**: If this is your first time using `git` you need to tell it who you are and what email address is associated with your GitHub account. Run these two commands in your terminal:
   ```bash
   git config --global user.name "Your Name"
   ```
   ```bash
   git config --global user.email "your.email@example.com"
   ```

2. **Authenticate to GitHub** (if you haven't already): If you haven't used `git` in the terminal before, you will need to authenticate so that you can push changes. Run this command:
   ```bash
   gh auth login
   ```

This will have you sign in via the GitHub website and now `git` will know who you are.

1. **Open Claude Desktop** and start a new **Cowork session** (click the Cowork tab or start a new Cowork conversation).

3. **Select the repo folder:** Cowork has the option to "work in a folder". Navigate to wherever you cloned `marketing-skills/` and select it. This gives Claude read/write access to the skill files.

4. **Start working:** You can now ask Claude things like:
   - "Create a new skill for LinkedIn articles"
   - "Review the brand-voice-writer SKILL.md and suggest improvements"
   - "Update the terms glossary with these new terms: ..."
   - "Help me write a SKILL.md for an SEO skill"

Claude can read your existing skills, reference docs, and the `_template/` folder — so it has full context on the repo structure and conventions.

**Tip:** If you have the marketing skills plugin installed, Claude will also have access to those skills while you work. This means you can use the brand-voice-writer skill to help draft content for new skills, or the content-reviewer skill to evaluate reference docs.

### Using Claude Code (CLI)

If you prefer the terminal, you can develop skills with Claude Code:

1. **Clone the repo:**
   ```bash
   git clone https://github.com/timescale/marketing-skills.git
   cd marketing-skills
   git fetch origin release:release
   ```

2. **Start Claude Code with the plugin loaded:**
   ```bash
   claude --plugin-dir plugins/tiger-marketing-skills
   ```

3. Claude Code has access to the full skill set and can help you create or refine skills.

## Creating a new skill

All skills live in `plugins/tiger-marketing-skills/skills/`. Each skill is its own folder.

1. **Copy the template:**
   ```bash
   cd plugins/tiger-marketing-skills
   cp -r _template/ skills/your-skill-name/
   # Example: cp -r _template/ skills/email-drip-writer/
   ```

2. **Edit `SKILL.md`:** Fill in the frontmatter (`name`, `platforms`, and `description`) and write the instructions. The template has comments explaining each section.

3. **Set the `platforms` field:** Decide where your skill can run:
   - `platforms: [cowork, claude-code]` — for skills that only need prompt instructions and reference docs (most skills)
   - `platforms: [claude-code]` — for skills that require terminal access, file I/O, web crawling, or other CLI capabilities
   - `platforms: [cowork]` — for skills that use Cowork-specific features (rare)

   **How to decide:** If your skill tells Claude to run commands, process files on disk, crawl websites, or do anything that needs a terminal, it's `[claude-code]` only. If it's purely instructions + reference docs that Claude reads, it works on both platforms.

4. **Add reference docs** (if needed) to the `references/` folder. These are markdown files that Claude reads when it needs deeper context (brand guidelines, glossary, etc.).

5. **Test it:** Try your skill in a Claude conversation to make sure it triggers correctly and produces good output. You don't need a formal test suite — just verify it works on 2-3 realistic prompts.

**Testing in Cowork:** Skills are loaded from the installed plugin, not from local files. To test a new or modified skill in Cowork, you need to build and install the plugin locally:
```bash
cd plugins/tiger-marketing-skills
./build-plugin.sh --target cowork
```
Then upload `dist/tigerdata-marketing-skills-<version>.zip` to Cowork (Browse plugins → My Plugins → + → Upload plugin) and **start a new session** — updated skills only take effect in new sessions, not the current one.

6. **Submit a PR:** Push your branch and open a pull request **targeting the `release` branch**. The PR template includes a checklist to make sure everything's in order. If you're not comfortable with git, ask Claude in Cowork to "help me submit my changes" — the **skill-contributor** skill will walk you through it step by step.

## Updating an existing skill

Same process — edit the files, test, submit a PR to `release`. If you're updating reference docs (like the brand voice guide), see the section below.

## Updating reference docs from Google Drive

When a source document changes in Google Drive:

1. Open the Google Doc
2. Go to **File > Download > Markdown (.md)**
3. Review the downloaded file and trim anything not relevant to the skill
4. ~~Replace the corresponding file in the skill's `references/` folder~~
5. ~~Submit a PR~~
6. Update the file in the Tiger Den web interface (currently only Corey or Matty)

Tiger Den is the source of truth for reference files. Not everything in a Google Doc needs to go into the skill — just the parts Claude needs to do its job.

## PR labels

Add **one label** to your PR so it shows up in the right section of the release notes. If your PR doesn't have a label, it'll land in "Other Changes."

| Label | When to use |
|-------|-------------|
| `skill` | Adding a new skill |
| `enhancement` | Improving an existing skill or feature |
| `fix` | Bug fixes |
| `infra` | Build scripts, CI/CD, repo config |
| `docs` | Documentation-only changes |

You can add a label when creating the PR on GitHub (right sidebar → Labels), or with the GitHub CLI:

```bash
gh pr edit --add-label skill
```

## PR checklist

The PR template includes a checklist, but here's what to verify:

- [ ] Skill folder has a `SKILL.md` with valid frontmatter (`name`, `platforms`, and `description`)
- [ ] `platforms` field is set correctly (see guidance above)
- [ ] Description is specific about when the skill should trigger
- [ ] Any files mentioned in `SKILL.md` actually exist (including cross-skill `../` references)
- [ ] `SKILL.md` is under 500 lines (put longer content in `references/`)
- [ ] You've tested the skill on at least a couple of realistic prompts
- [ ] PR has a label (`skill`, `enhancement`, `fix`, `infra`, or `docs`)

## Skill writing tips

- **Write in imperative form:** "Read the glossary" not "You should read the glossary"
- **Explain the why:** Instead of "ALWAYS use sentence case," try "Use sentence case for headlines — this matches our brand style and performs better in search results"
- **Be specific about triggers:** The description field is how Claude decides whether to use your skill. Make it clear and slightly "pushy"
- **Keep SKILL.md focused:** Core instructions go in SKILL.md. Reference material, lengthy examples, and data go in `references/`
- **Think about progressive loading:** Claude reads SKILL.md first, then only loads reference docs as needed. Structure accordingly.
- **Note CLI dependencies explicitly:** If your skill requires terminal access, say so clearly in the SKILL.md (and set `platforms: [claude-code]`). This helps contributors understand what works where.

## Repo structure

```
marketing-skills/
├── .claude-plugin/
│   └── marketplace.json        ← marketplace registry (our plugin + community plugin)
├── plugins/
│   └── tiger-marketing-skills/
│       ├── .claude-plugin/
│       │   └── plugin.json     ← plugin metadata and version
│       ├── config.json         ← runtime config (Drive folder ID, etc.)
│       ├── REFERENCES.md       ← how to fetch reference docs from Google Drive
│       ├── _template/          ← copy this to create a new skill
│       ├── build-plugin.sh     ← builds Cowork .zip for manual installs
│       └── skills/             ← all native skills
│           ├── brand-voice-writer/
│           ├── content-reviewer/
│           ├── doctor/
│           ├── ghost-paper/
│           ├── seo-meta-optimizer/
│           ├── setup/
│           └── skill-contributor/
├── dist/                       ← build output (gitignored)
├── CONTRIBUTING.md
└── README.md
```

Each skill is a folder inside `skills/`. The folder name becomes the skill name.

## Building locally

You can build the Cowork `.zip` locally to test before releasing:

```bash
cd plugins/tiger-marketing-skills
./build-plugin.sh --target cowork --version 0.2.0
```

The marketplace reads skills directly from the repo, so no build is needed for that install path. The build is only for producing the `.zip` used in manual installs and GitHub releases.

## Releasing a new version

Changes flow through `release` → `main`:

1. **Merge your PR** into the `release` branch
2. **Publish a GitHub Release** targeting the `release` branch with a semver tag (e.g. `v1.2.0`)
3. A GitHub Action will automatically:
   - Build the Cowork `.zip` and attach it to the release
   - Bump the version in `plugin.json`
   - Open a PR from `release` → `main` with auto-merge enabled
4. Once checks pass, the PR merges to `main` and a Slack notification goes out

Claude Code users just need to `git pull` to get the latest.

## Questions?

Open a GitHub Issue or ask in #marketing-tools on Slack.
