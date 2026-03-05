# Tiger Data Marketing Skills

> **Internal plugin.** This marketplace is built for the Tiger Data marketing team. The skills depend on internal Google Drive documents, Tiger Den, and org-specific context that aren't available outside our organization. You're welcome to browse the source and fork the framework for your own team, but installing the plugin as-is won't be useful outside Tiger Data.

A shared plugin marketplace for the Tiger Data marketing team. Gives Claude specialized knowledge about our brand voice, audience, positioning, terminology, and content quality standards — so it produces better, more on-brand work.

Works with both **Cowork** (Claude Desktop) and **Claude Code** (CLI).

## Install

### Cowork (Claude Desktop)

1. Switch to the **Cowork** tab in Claude Desktop
2. Click **Customize** in the left sidebar
3. Go to **Browse plugins** → **Personal** tab
4. Click the **+** button → **Add marketplace from GitHub**
5. Paste the repo URL: `timescale/marketing-skills`
6. Click **Sync**, then browse the available skills and click **Install now**

The marketplace includes our Tiger Data skills and a community plugin by Corey Haines with additional marketing skills (cold email, launch strategy, paid ads, etc.). Install whichever you'd like.

Skills are available immediately in new Cowork sessions.

<details>
<summary><strong>Manual install (fallback)</strong></summary>

If the marketplace method isn't working, you can install manually from a `.zip` file:

1. Go to the [latest release](https://github.com/timescale/marketing-skills/releases/latest) and download the `.zip` file
2. In a Cowork session, go to **Browse plugins** → **My Plugins** → click **+** → **Upload plugin**
3. Select the `.zip` file

To update: download the latest `.zip` and upload it again. Start a **new session** after updating.

</details>

### Claude Code (CLI)

Add this repo as a marketplace, then install the plugin:

```bash
# Add the marketplace
/plugin marketplace add timescale/marketing-skills

# Install the plugin
/plugin install tigerdata-marketing-skills@marketing-skills
```

To update later:

```bash
/plugin update tigerdata-marketing-skills@marketing-skills
```

<details>
<summary><strong>Manual install (fallback)</strong></summary>

If you prefer a local checkout:

```bash
git clone https://github.com/timescale/marketing-skills.git
cd marketing-skills
```

Then point Claude Code at the plugin directory:

```bash
claude --plugin-dir /path/to/marketing-skills/plugins/tiger-marketing-skills
```

Or add it permanently in `.claude/settings.json`:

```json
{
  "plugins": ["/path/to/marketing-skills/plugins/tiger-marketing-skills"]
}
```

To update: `git pull`.

</details>

## Skills

### Tiger Data Skills

| Skill | Platforms | Description |
|-------|-----------|-------------|
| **brand-voice-writer** | Cowork, Claude Code | Write content using our brand voice, ICP profiles, positioning, and terminology |
| **content-reviewer** | Cowork, Claude Code | Evaluate marketing content drafts against Tiger Data's quality rubrics |
| **de-slop** | Cowork, Claude Code | Strip AI writing patterns from text to make it sound natural and human-written |
| **seo-meta-optimizer** | Cowork, Claude Code | Optimize title tags and meta descriptions at scale (CSV input or URL crawling) |
| **ghost-paper** | Cowork, Claude Code | Turn markdown into styled HTML reports with interactive charts and KPI strips. Invoke with `/ghost-paper` — only auto-triggers when you mention it by name. |
| **doctor** | Cowork, Claude Code | Health check for the plugin environment (Google Drive, Tiger Den, Node.js) |
| **setup** | Cowork, Claude Code | First-time onboarding — connects Google Drive, Tiger Den, and recommends skills |
| **skill-contributor** | Cowork | Guided git workflow for non-technical contributors to submit skill changes |

### Community Skills

Additional marketing skills by [Corey Haines](https://github.com/coreyhaines31/marketingskills) are available as a separate plugin in this marketplace. Install it alongside our plugin for cold email, email sequences, launch strategy, paid ads, pricing strategy, and more.

### Platform Compatibility

Each skill declares which platforms it supports via a `platforms` field in its SKILL.md frontmatter. The Cowork `.zip` build includes only Cowork-compatible skills, while Claude Code gets everything.

## How Skills Work

Skills are folders containing a `SKILL.md` that gives Claude specialized instructions and context. Once installed, they activate automatically when Claude matches your request.

For example, ask Claude to "write a blog post about continuous aggregates" and the **brand-voice-writer** skill activates — giving Claude access to our brand voice guide, ICP profiles, positioning docs, and glossary so the output sounds like us.

Under the hood, skills are thin orchestration files. They define *what to do* and *which tools to call*, but confidential context (brand voice details, sales frameworks, competitive positioning) lives outside this repo. Each skill declares its references in frontmatter and reads `REFERENCES.md` at runtime to fetch them. Skills try Tiger Den first (one API call for all docs), then fall back to Google Drive in Cowork. This keeps the repo public-safe while giving skills full context.

## Tiger Den MCP Server

Skills use the [Tiger Den](https://tiger-den.vercel.app) MCP server as the primary source for reference docs (brand voice guide, product marketing context, content rubrics). Tiger Den is also used for content search (find existing articles, case studies, and data points) and voice profiles (write in a specific team member's voice).

**For Claude Code users, Tiger Den is required** — it's the only source for reference docs. In Cowork, Google Drive serves as a transitional fallback for skills that haven't been migrated yet.

### Tiger Den setup instructions

**Get an API key:** Sign in to [Tiger Den](https://tiger-den.vercel.app), go to [**API Keys**](https://tiger-den.vercel.app/api-keys) in the sidebar, click **Create API Key**, and copy the key.

Then follow the instructions below depending if you're using Claude Cowork or Claude Code

<details>
<summary><strong>Claude Cowork Setup</strong></summary>

#### Automatic setup

Copy and paste the following into your terminal (based on your OS):

**macOS:**
```bash
if ! command -v brew >/dev/null 2>&1; then echo "Homebrew not found. Install from https://brew.sh and re-run."; exit 1; fi; brew update && brew install node && npx -y @mattstratton/tiger-den-mcp-setup
```

**Windows**
```powershell
winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements; npx -y @mattstratton/tiger-den-mcp-setup
```

#### Manual Setup (if the above commands do not work)

##### Prerequisites:
- [Node.js](https://nodejs.org/) v18+ installed (provides `npx`)

##### Setup:

1. In Claude Desktop, go to **Settings** (hamburger menu) > **Developer** > **Edit Config**. This opens the config folder. If the file `claude_desktop_config.json` doesn't exist, create it. You can also find the file directly at:
   - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

2. Add the Tiger Den server. The config differs slightly by OS:

   **macOS:**
   ```json
   {
     "mcpServers": {
       "tiger_den": {
         "command": "npx",
         "args": [
           "-y",
           "mcp-remote",
           "https://tiger-den.vercel.app/api/mcp/mcp",
           "--header",
           "Authorization: Bearer td_your_key_here"
         ]
       }
     }
   }
   ```

   **Windows:**
   ```json
   {
     "mcpServers": {
       "tiger_den": {
         "command": "npx.cmd",
         "args": [
           "-y",
           "mcp-remote",
           "https://tiger-den.vercel.app/api/mcp/mcp",
           "--header",
           "Authorization: Bearer td_your_key_here"
         ]
       }
     }
   }
   ```

   > **Windows note:** You must use `npx.cmd` instead of `npx`. Claude Desktop on Windows doesn't resolve bare command names the same way as macOS — the `.cmd` extension is required.

   Replace `td_your_key_here` with your API key from the [API Keys page](#getting-an-api-key).

3. Save the file, then fully quit Claude Desktop from the system tray (right-click the icon in the bottom-right and quit — just closing the window isn't enough). Reopen Claude Desktop and the Tiger Den tools will appear

</details>
<details>
<summary><strong>Claude Code Setup</strong></summary>

Add the server to Claude Code (run in a separate terminal, not inside Claude Code):
```bash
claude mcp add --transport http tiger_den https://tiger-den.vercel.app/api/mcp/mcp \
  --header "Authorization: Bearer td_your_key_here"
```

For local development:
```bash
claude mcp add --transport http tiger_den http://localhost:3000/api/mcp/mcp \
  --header "Authorization: Bearer td_your_key_here"
```

**Note:** Ensure the header value has no line breaks. If the server shows as "not authenticated" after adding, check `~/.claude.json` and verify the `Authorization` header is on a single line.

Restart Claude Code. The tools will appear as `tiger_den` MCP tools.

</details>

## Repository Layout

```
.claude-plugin/
  marketplace.json              ← marketplace registry (lists our plugin + community plugin)

plugins/
  tiger-marketing-skills/
    .claude-plugin/
      plugin.json               ← plugin metadata and version
    config.json                 ← runtime config (Drive folder ID, etc.)
    REFERENCES.md               ← how skills fetch reference docs (Tiger Den + Google Drive fallback)
    _template/                  ← copy this to create a new skill
    build-plugin.sh             ← builds Cowork .zip for manual installs
    skills/                     ← all native skills (flat directory)
      brand-voice-writer/
      content-reviewer/
      de-slop/
      doctor/
      ghost-paper/
      seo-meta-optimizer/
      setup/
      skill-contributor/

dist/                           ← build output (gitignored)
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to create new skills, update existing ones, and get your changes reviewed.

## License

Apache 2.0 — see [LICENSE](LICENSE) for details.

## Questions?

Open a GitHub Issue or ask in the #marketing-tools Slack channel.
