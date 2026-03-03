---
name: skill-contributor
platforms: [cowork]
description: >
  Guide contributors through submitting skill changes to the marketing-skills repo using git.
  Use this skill when someone says "help me submit my changes", "how do I push this", "I'm done
  editing, now what?", "submit my skill", "create a PR", "I need to commit", or any request
  related to saving, sharing, or submitting their work on skills to the team. Also use when
  someone seems stuck on the git workflow or mentions branches, commits, or pull requests.
  This skill is for non-technical contributors who may not be familiar with git.
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

> "Before we save your changes, let's make sure we're starting from the right place and then create a branch. Paste these one at a time:"
>
> ```
> git checkout release
> git pull origin release
> git checkout -b your-name/short-description
> ```

Help them pick a good branch name based on what they changed. Examples:
- `nicole/update-brand-voice-guide`
- `jordan/add-linkedin-skill`
- `corey/fix-glossary-terms`

> **Why `release`?** All PRs in this repo target the `release` branch — not `main`. The `release` branch is where all new work gets merged. `main` only gets updated when a release is published.

## Step 4: Stage the changed files

> "Now let's tell git which files to include. Paste this:"
>
> ```
> git add path/to/changed/file
> ```

List the specific files based on what `git status` showed. For example:
```
git add category/skill-name/SKILL.md
```

If they changed multiple files, give them each `git add` command separately, or use a combined command:
```
git add category/skill-name/SKILL.md category/skill-name/some-other-file.md
```

## Step 5: Commit

> "Now let's save a snapshot of your changes with a short description. Paste this:"
>
> ```
> git commit -m "Update brand voice guide with Q1 messaging changes"
> ```

Help them write a clear, short commit message based on what they actually changed. Keep it under 72 characters.

## Step 6: Push to GitHub

> "Now let's upload your branch to GitHub so the team can see it. Paste this:"
>
> ```
> git push -u origin your-branch-name
> ```

Use the actual branch name from Step 3.

If they get an authentication error, help them troubleshoot:
- **"Password authentication" error:** They need to use SSH or a personal access token. Suggest they ask in #marketing-tools on Slack for help setting up GitHub authentication.
- **"Permission denied" error:** They may not have push access. Suggest asking in #marketing-tools.

## Step 7: Create a pull request

> "Last step! Let's create a pull request so someone can review your changes. Click this link:"
>
> [https://github.com/timescale/marketing-skills/compare/release...your-branch-name](https://github.com/timescale/marketing-skills/compare/release...your-branch-name)

Replace `your-branch-name` in both the link text and the URL with the actual branch name from Step 3. Use a markdown link so it's clickable in Cowork. The `release...` prefix ensures the PR targets the `release` branch.

Then ask: **"Are you familiar with creating pull requests on GitHub, or would you like me to walk you through what you'll see?"**

If they're familiar, just say: "Great — give it a title and description, and hit Create. Let me know when it's done!"

If they're NOT familiar, walk them through it:

> "When you click that link, GitHub will show you a page with all the changes you made — you can scroll through to double-check everything looks right. At the top, you'll see a green **Create pull request** button. Click that."
>
> "It'll then ask you for two things:"
> - **Title:** A short summary of what you changed (I'll suggest one for you)
> - **Description:** A few sentences about what you changed and why. This helps the reviewer understand your intent.
>
> "Once you've filled those in, click the green **Create pull request** button one more time to submit it. That's it — someone on the team will review it and merge it in."

Help them write a good title and description based on what they changed.

> **Shortcut:** If they have the [GitHub CLI](https://cli.github.com/) (`gh`) installed, they can run this instead:
> ```
> gh pr create --base release --title "Your PR title" --body "Brief description of what changed and why"
> ```

## Step 8: Celebrate

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
