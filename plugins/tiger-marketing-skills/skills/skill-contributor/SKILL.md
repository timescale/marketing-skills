---
name: skill-contributor
platforms: [cowork]
description: "Guide contributors through submitting skill changes to the marketing-skills GitHub repo via git. Trigger when someone explicitly asks for help with git ('help me push this', 'how do I submit', 'create a PR', 'I need to commit'). Also trigger when it's submission time — the user signals their work is done with phrases like 'looks good, let's ship it', 'I'm done', 'this is ready', 'let's get this merged', 'let's PR this', or similar — AND the user hasn't already demonstrated git comfort in the conversation. If the user has been running git commands confidently, do NOT trigger — just provide the commands they need. Walks contributors through branching, committing, pushing, and opening a PR step by step. No git experience required."
---

# Skill Contributor — Guided Git Workflow

You are helping a contributor submit their skill changes to the marketing-skills GitHub repo. They may not be familiar with git, so guide them step by step through Terminal commands. Be encouraging and explain what each command does in plain language.

## Important context

- If the user has the marketing-skills repo selected as their Cowork workspace folder, you CAN run read-only git commands directly (e.g., `git status`, `git diff`, `git log`, `git branch`). Use these to help the user understand what's changed without making them copy-paste.
- However, Cowork cannot run write commands (`git add`, `git commit`, `git push`, `git checkout -b`, etc.) due to sandbox limitations. For these, guide the user to run them in their Terminal app.
- Always provide exact commands they can copy and paste for the write operations.
- Use the repo name `marketing-skills` to help them find their folder.

## Step 0: Find their repo folder

Before anything else, ask: "Do you know where the marketing-skills repo is on your computer? If so, tell me the path and we'll jump ahead. If not, no worries — we can find it."

**Important:** When asking for the path, remind the user to start their reply with a word, not the path itself. Paths starting with `/` get interpreted as a slash command by Cowork and will throw an "unknown skill or command" error. Tell them something like: *"Reply like: **my path is /Users/yourname/src/marketing-skills** — start with a word so Cowork doesn't get confused."*

If they don't know, tell them to open **Terminal** (on Mac: Spotlight → type 'Terminal' → Enter) and paste this:

```
find ~/src ~/repos ~/code ~/projects ~/Documents ~/Desktop -maxdepth 4 -name "marketing-skills" -type d 2>/dev/null
```

Then ask them to share what it printed so you can give them the next command.

## Step 1: Navigate to the repo

Once you know their path, tell them:

> "Great! Now paste this into Terminal:"
>
> ```
> cd /path/to/marketing-skills
> ```

Replace `/path/to/marketing-skills` with their actual path.

## Step 2: Check what's changed

> "Let's see what files you've changed. Paste this:"
>
> ```
> git status
> ```
>
> "Tell me what it shows — I'll help you understand it."

Explain the output in plain language: new files (untracked), modified files, which ones are staged, etc.

## Step 3: Create a branch

> "Before we save your changes, let's make sure we have the latest `release` branch. Paste this first:"
>
> ```
> git fetch origin release:release
> ```
>
> "Now let's create a branch off `release` (that's our integration branch — all PRs go there, not `main`). Paste this:"
>
> ```
> git checkout -b your-name/short-description release
> ```

Help them pick a good branch name based on what they changed. Examples:
- `nicole/update-brand-voice-guide`
- `jordan/add-linkedin-skill`
- `corey/fix-glossary-terms`

## Step 4: Stage the changed files

> "Now let's tell git which files to include. Paste this:"
>
> ```
> git add path/to/changed/file
> ```

List the specific files based on what `git status` showed. For example:
```
git add plugins/tiger-marketing-skills/skills/skill-name/SKILL.md
```

If they changed multiple files, give them each `git add` command separately, or use a combined command:
```
git add plugins/tiger-marketing-skills/skills/skill-name/SKILL.md plugins/tiger-marketing-skills/skills/skill-name/REFERENCES.md
```

## Step 5: Commit

> "Now let's save a snapshot of your changes with a short description. Paste this:"
>
> ```
> git commit -m "Update brand voice guide with Q1 messaging changes"
> ```

Help them write a clear, short commit message based on what they actually changed. Keep it under 72 characters.

## Step 6: Create a pull request

> "Last step! Let's upload your changes and create a pull request so the team can review them. This one command does both — it pushes your branch and opens the PR. Paste this:"
>
> ```
> gh pr create --base release --label skill --title "Your PR title" --body "Brief description of what changed and why"
> ```

Replace the title, body, and label with values appropriate for their change. Help them write a clear, short title and a sentence or two about what they changed and why.

When they run this, `gh` will ask if they want to push to `timescale/marketing-skills` — tell them to select that option (it's usually the first one). The branch gets pushed and the PR gets created in one step.

**Pick the right label** for the `--label` flag:
- `skill` — added a new skill
- `enhancement` — improved an existing skill
- `fix` — fixed a bug
- `docs` — updated documentation

If they get an authentication error, help them troubleshoot:
- **"not logged in" error:** They need to run `gh auth login` first (see CONTRIBUTING.md setup steps).
- **"Permission denied" error:** They may not have push access to the repo. Suggest asking in #marketing-tools on Slack.

<details>
<summary>Fallback if they don't have `gh` installed</summary>

If they don't have the GitHub CLI and can't install it right now, fall back to the manual approach:

1. Push the branch:
   ```
   git push -u origin your-branch-name
   ```

2. Open this link to create the PR on GitHub:

   [https://github.com/timescale/marketing-skills/compare/release...your-branch-name](https://github.com/timescale/marketing-skills/compare/release...your-branch-name)

   Replace `your-branch-name` in both the link text and URL with their actual branch name. Use a markdown link so it's clickable in Cowork.

3. Walk them through the GitHub UI: give it a title and description, add a label from the right sidebar, and click **Create pull request**.

Strongly recommend they install `gh` for next time — it makes this much simpler.

</details>

## Step 7: Celebrate

> "You're done! Your changes are up for review. Someone from the team will take a look and merge them. You'll get a notification on GitHub when it's merged."

## If they need to update an existing branch

If they've already created a branch and need to add more changes:

> "Since you already have a branch, you just need to save and push the new changes. Paste these one at a time:"
>
> ```
> git add path/to/changed/file
> git commit -m "Description of additional changes"
> git push
> ```

## If something goes wrong

- **"Not a git repository":** They're in the wrong folder. Go back to Step 0.
- **"Merge conflict":** This is tricky. Suggest they ask for help in #marketing-tools on Slack.
- **"Your branch is behind":** Run `git pull --rebase origin release` then try pushing again.
- **"index.lock":** Run `rm .git/index.lock` and try again.

## Tone

Be patient, encouraging, and non-judgmental. Many contributors are marketers, not engineers. Avoid jargon unless you explain it. Celebrate their progress at each step.
