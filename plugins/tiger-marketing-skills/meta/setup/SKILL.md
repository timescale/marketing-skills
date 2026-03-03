---
name: setup
platforms: [cowork, claude-code]
description: >
  First-time onboarding for the marketing skills plugin. Use when someone says "setup",
  "get started", "configure", "first time", "how do I set this up?", "install",
  "I just installed the plugin", or when another skill (like /doctor) suggests running setup.
  Walks through connecting Google Drive, Tiger Den, and Node.js — then recommends skills
  based on the user's role.
---

# Setup — Plugin Onboarding

Walk the user through first-time configuration of the marketing skills plugin. Check what's already working, fix what isn't, and finish by recommending skills based on their role.

Be patient and encouraging — many users are marketers, not engineers. Explain what each tool is and why it matters before asking them to configure it. Claude Code users are typically more technical, so adjust your tone accordingly — still helpful, but less hand-holding.

## Step 1: Detect runtime and OS

Determine whether you're running in Cowork or Claude Code:
- If the `google_drive_search` tool is available → **Cowork**
- Otherwise → **Claude Code**

Detect the host OS:

```bash
echo $CLAUDE_CODE_HOST_PLATFORM
```

- `darwin` → macOS
- `win32` → Windows
- `linux` → Linux

Store both for later — they affect install commands and config paths. Almost everyone will be on macOS.

## Step 2: Check Google Drive

**In Cowork**, try:

```
google_drive_search(api_query: "'1DUPUkDyG8bkQgoWWI4kvoLTyMk_sT1n2' in parents", page_size: 1)
```

**If it works:** Tell the user Google Drive is connected and move on.

**If it fails:** Walk them through it:

> "Several skills in this plugin pull reference docs (like our brand voice guide) from a shared Google Drive folder. Let's connect that now."
>
> 1. Click the **gear icon** (⚙️) in the top-right corner of Cowork to open Settings
> 2. Go to **Connectors**
> 3. Find **Google Drive** and click **Connect**
> 4. Sign in with your **Tiger Data Google account** (your @tigerdata.com email)
> 5. Grant the permissions it asks for — this lets Claude read docs from our shared folder
>
> "Let me know when that's done and I'll verify it works."

After they confirm, re-run the check. If it still fails, suggest they ask in #marketing-tools on Slack.

**In Claude Code**, try:

```bash
gdrive files list --parent 1DUPUkDyG8bkQgoWWI4kvoLTyMk_sT1n2
```

**If it works:** Move on.

**If `gdrive` is not installed:** Tell them to install and authenticate:

> ```bash
> brew install gdrive
> gdrive auth
> ```
>
> "Sign in with your @tigerdata.com Google account when prompted."

**If auth fails:** Tell them to re-authenticate with `gdrive auth`.

## Step 3: Check Node.js (Cowork only)

Node.js is required in Cowork because the Tiger Den MCP config uses `npx` to run `mcp-remote`. **Claude Code does not need Node.js** — it connects to Tiger Den directly over HTTP via `claude mcp add`.

If you're in Claude Code, skip this step entirely.

If you're in Cowork, check by seeing if the Tiger Den MCP is already working (Step 4). If Tiger Den works, skip this step — Node is clearly installed.

If Tiger Den is NOT working in Cowork, ask the user to check whether Node is installed. Use the OS detected in Step 1:

**macOS:**

> "Before we set up Tiger Den, we need to make sure Node.js is installed. Open **Terminal** (Spotlight → type 'Terminal' → Enter) and paste this:"
>
> ```
> node --version
> ```
>
> "What does it show? If you see a version number like `v20.x.x` or `v22.x.x`, you're good. If you see 'command not found', we need to install it."

**Windows:**

> "Before we set up Tiger Den, we need to make sure Node.js is installed. Open **PowerShell** (Start → type 'PowerShell' → Enter) and paste this:"
>
> ```
> node --version
> ```
>
> "What does it show? If you see a version number like `v20.x.x` or `v22.x.x`, you're good. If you see an error, we need to install it."

**If Node is missing (macOS):**

> "The easiest way to install Node on a Mac is with Homebrew. Paste this into Terminal:"
>
> ```
> brew install node
> ```
>
> "If you don't have Homebrew either, paste this first, then run the command above:"
>
> ```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
>
> "Let me know when that finishes."

**If Node is missing (Windows):**

> "Download the Node.js installer from [nodejs.org](https://nodejs.org/) — grab the LTS version. Run the installer with the default options. Once it's done, close and reopen your terminal, then try `node --version` again."

## Step 4: Check Tiger Den MCP

Try (same in both runtimes):

```
search_content(query: "test", limit: 1)
```

**If it works:** Tell the user Tiger Den is connected and move on.

**If it fails:** Walk them through setting it up.

> "Tiger Den is our content library — some skills use it to find existing content, check what's been published, and avoid duplicating topics. Let's connect it."
>
> "First, you'll need a Tiger Den API key. Here's how to get one:"
>
> 1. Go to [Tiger Den](https://tiger-den.vercel.app) and sign in
> 2. Click **API Keys** in the sidebar (or go to `/api-keys`)
> 3. Click **Create API Key**, give it a label like "Claude Desktop", and copy the key
> 4. The key is only shown once, so don't close that page yet!
>
> "Paste your API key here and I'll give you the exact config to add. It should start with `td_`."

**After they provide the API key**, use the runtime and OS to give the right setup instructions.

### Tiger Den setup in Claude Code

Tell the user to run this in a separate terminal (not inside Claude Code):

```bash
claude mcp add --transport http tiger_den https://tiger-den.vercel.app/api/mcp/mcp \
  --header "Authorization: Bearer <their-api-key>"
```

Replace `<their-api-key>` with the actual key they provided. Give them the complete command with the real key filled in so they can copy-paste it directly.

> "Make sure the header value has no line breaks. Then restart Claude Code — the Tiger Den tools will appear as `tiger_den` MCP tools."

If it still doesn't work after restart, suggest they check `~/.claude.json` and verify the `Authorization` header is on a single line.

### Tiger Den setup in Cowork (macOS)

The config file is at `~/Library/Application Support/Claude/claude_desktop_config.json`. Tell them:

> "Great! Now we need to add Tiger Den to your Claude settings. Open **Terminal** and paste this:"
>
> ```
> open ~/Library/Application\ Support/Claude/claude_desktop_config.json
> ```
>
> "This will open the config file. You need to add the following inside the `"mcpServers"` section:"
>
> ```json
> "tiger_den": {
>   "command": "npx",
>   "args": [
>     "-y",
>     "mcp-remote",
>     "https://tiger-den.vercel.app/api/mcp/mcp",
>     "--header",
>     "Authorization: Bearer <their-api-key>"
>   ]
> }
> ```

Replace `<their-api-key>` with the actual key they provided. Give them the complete block with the real key filled in so they can copy-paste it directly.

> "If the file already has other MCP servers, add a comma after the last one and paste this before the closing `}` of `mcpServers`. If the file is empty or doesn't have an `mcpServers` section, the full file should look like:"
>
> ```json
> {
>   "mcpServers": {
>     "tiger_den": {
>       "command": "npx",
>       "args": [
>         "-y",
>         "mcp-remote",
>         "https://tiger-den.vercel.app/api/mcp/mcp",
>         "--header",
>         "Authorization: Bearer <their-api-key>"
>       ]
>     }
>   }
> }
> ```

### Tiger Den setup in Cowork (Windows)

The config file is at `%APPDATA%\Claude\claude_desktop_config.json`. Tell them:

> "Great! Now we need to add Tiger Den to your Claude settings. Open **PowerShell** and paste this:"
>
> ```
> notepad $env:APPDATA\Claude\claude_desktop_config.json
> ```
>
> "This will open the config file. You need to add the following inside the `"mcpServers"` section. **Important:** On Windows you must use `npx.cmd` instead of `npx` — Claude Desktop on Windows doesn't resolve bare command names the same way as macOS."
>
> ```json
> "tiger_den": {
>   "command": "npx.cmd",
>   "args": [
>     "-y",
>     "mcp-remote",
>     "https://tiger-den.vercel.app/api/mcp/mcp",
>     "--header",
>     "Authorization: Bearer <their-api-key>"
>   ]
> }
> ```

Replace `<their-api-key>` with the actual key they provided. Give them the complete block with the real key filled in so they can copy-paste it directly.

> "If the file is empty or doesn't have an `mcpServers` section, the full file should look like:"
>
> ```json
> {
>   "mcpServers": {
>     "tiger_den": {
>       "command": "npx.cmd",
>       "args": [
>         "-y",
>         "mcp-remote",
>         "https://tiger-den.vercel.app/api/mcp/mcp",
>         "--header",
>         "Authorization: Bearer <their-api-key>"
>       ]
>     }
>   }
> }
> ```

### After saving (Cowork only)

> "Now **restart Claude Desktop** (quit fully and reopen). Once it's back up, come back to this chat and type `/doctor` to verify everything's working."

**Important:** After they restart and run doctor, confirm Tiger Den is connected. If it still fails, common issues are:
- API key typo — double-check the key, it should start with `td_`
- JSON syntax error — offer to review the file if they paste its contents
- Node not in PATH after install — they may need to restart their terminal first

## Step 5: Role-based skill recommendations

Once all checks pass (either from this flow or from `/doctor`), ask the user about their role:

> "Everything's set up! One last thing — tell me a bit about what you do on the marketing team so I can point you to the most useful skills in this plugin."

Present options (use AskUserQuestion if available):
- Content / blog writing
- Demand gen / growth
- Product marketing
- Social media
- Sales / SDR
- Leadership / strategy
- Other (let them describe)

Then recommend skills based on their answer. Use the role map below.

### Role → Skill map

<!-- Keep this section easy to update: one role per block, alphabetical. Add new roles or skills here as the plugin grows. -->

**Content / blog writing:**
- `brand-voice-writer` — Write on-brand content with full context on our voice, audience, and terminology
- `content-reviewer` — Run drafts through our quality rubric before publishing
- `ghost-paper` — Turn drafts into polished HTML reports with charts and formatting

**Demand gen / growth:**
- `email-sequence` — Build onboarding, nurture, and re-engagement email flows
- `paid-ads` — Plan and write ad campaigns for Google, Meta, LinkedIn
- `launch-strategy` — Plan product launches with phased rollout and channel strategy
- `cold-email` — Write cold outreach sequences that get replies

**Product marketing:**
- `brand-voice-writer` — Write on-brand content with full context on our voice, audience, and terminology
- `launch-strategy` — Plan product launches with phased rollout and channel strategy
- `pricing-strategy` — Work through pricing tiers, packaging, and monetization decisions
- `content-reviewer` — Run drafts through our quality rubric before publishing

**Social media:**
- `brand-voice-writer` — Write on-brand content with full context on our voice, audience, and terminology
- `linkedin-articles` — Find articles to share and draft LinkedIn posts (requires matty-tiger-skills plugin)

**Sales / SDR:**
- `cold-email` — Write cold outreach sequences that get replies
- `email-sequence` — Build follow-up and nurture sequences

**Leadership / strategy:**
- `marketing-ideas` — Browse 139 proven SaaS marketing tactics for inspiration
- `pricing-strategy` — Work through pricing tiers, packaging, and monetization decisions
- `launch-strategy` — Plan product launches with phased rollout and channel strategy

Present the recommendations conversationally, not as a wall of text. For each skill, one sentence on what it does and an example of when to use it. End with:

> "You can use any of these by just describing what you need — you don't have to remember skill names. And if you ever want to check that everything's still connected, just type `/doctor`."

## Tone

Warm, patient, non-technical for Cowork users. These are marketers setting up developer tools. Celebrate each step. Never assume they know what a terminal is — explain it the first time you mention it.

For Claude Code users, be more concise and direct — they're comfortable with the terminal.
