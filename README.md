# Tiger Data Marketing Skills

A shared plugin marketplace for the Tiger Data marketing team. Gives Claude specialized knowledge about our brand voice, audience, positioning, terminology, and content quality standards — so it produces better, more on-brand work.

Works with both **Cowork** (Claude Desktop) and **Claude Code** (CLI).

## Install

### Cowork (Claude Desktop)

1. Switch to the **Cowork** tab in Claude Desktop
2. Click **Customize** in the left sidebar
3. Go to **Browse plugins** → **Personal** tab
4. Click the **+** button → **Add marketplace from GitHub**
5. Paste the repo URL: `https://github.com/timescale/marketing-skills`
6. Click **Sync**, then browse the available skills and click **Install now**

Skills are available immediately in new Cowork sessions.

<details>
<summary><strong>Manual install (fallback)</strong></summary>

If the marketplace method isn't working, you can install manually from a `.zip` file:

1. Go to the [latest release](https://github.com/timescale/marketing-skills/releases/latest) and download `tigerdata-marketing-skills.zip`
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
git submodule update --init --recursive
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

To update: `git pull && git submodule update --init --recursive`.

</details>

## Skills

### Native Skills

| Skill | Platforms | Description |
|-------|-----------|-------------|
| **brand-voice-writer** | Cowork, Claude Code | Write content using our brand voice, ICP profiles, positioning, and terminology |
| **skill-contributor** | Cowork | Guided workflow for submitting skill changes via git — walks non-technical contributors through branching, committing, and opening PRs |

### Community Skills

Curated from the open-source [marketingskills](https://github.com/coreyhaines31/marketingskills) repo. Controlled by [`vendor-skills.json`](plugins/tiger-marketing-skills/vendor-skills.json).

| Skill | Platforms | Description |
|-------|-----------|-------------|
| **cold-email** | Cowork, Claude Code | B2B cold outreach sequences |
| **email-sequence** | Cowork, Claude Code | Automated email flows (onboarding, nurture, re-engagement) |
| **launch-strategy** | Cowork, Claude Code | Product launch planning with ORB framework |
| **marketing-ideas** | Cowork, Claude Code | 139 proven SaaS marketing tactics |
| **paid-ads** | Cowork, Claude Code | Ad campaign planning (Google, Meta, LinkedIn) |
| **pricing-strategy** | Cowork, Claude Code | Pricing tiers and monetization planning |

> More vendor skills are available but disabled by default. Edit `vendor-skills.json` to enable them.

### Platform Compatibility

Each skill declares which platforms it supports via a `platforms` field in its SKILL.md frontmatter. The build system uses this to produce the right artifacts — the Cowork `.zip` includes only Cowork-compatible skills, while Claude Code gets everything.

## How Skills Work

Skills are folders containing a `SKILL.md` that gives Claude specialized instructions and context. Once installed, they activate automatically when Claude matches your request.

For example, ask Claude to "write a blog post about continuous aggregates" and the **brand-voice-writer** skill activates — giving Claude access to our brand voice guide, ICP profiles, positioning docs, and glossary so the output sounds like us.

Under the hood, skills are thin orchestration files. They define *what to do* and *which tools to call*, but confidential context (brand voice details, sales frameworks, competitive positioning) lives in Google Drive reference docs — not in this repo. Each skill declares its references in frontmatter and reads `REFERENCES.md` at runtime to fetch docs from the shared Drive folder. This keeps the repo public-safe while giving skills full context.

### Optional: Tiger Den MCP Server

Some skills can optionally use the [Tiger Den](https://tiger-den.vercel.app) MCP server for extra capabilities. All skills work without it, but with Tiger Den connected you get content search (find existing articles, case studies, and data points) and voice profiles (write in a specific team member's voice).

<details>
<summary><strong>Tiger Den setup instructions</strong></summary>

Requires Node.js v18+.

1. **Get an API key:** Sign in to [Tiger Den](https://tiger-den.vercel.app), go to **API Keys** in the sidebar, click **Create API Key**, and copy the key.

2. **For Cowork (Claude Desktop):** Open settings via **Settings** (hamburger menu) > **Developer** > **Edit Config** to find `claude_desktop_config.json`. Add:

   **macOS:**
   ```json
   {
     "mcpServers": {
       "tiger_den": {
         "command": "npx",
         "args": ["-y", "mcp-remote", "https://tiger-den.vercel.app/api/mcp/mcp", "--header", "Authorization: Bearer td_your_key_here"]
       }
     }
   }
   ```

   **Windows:** Same as above but use `"command": "npx.cmd"`.

3. **For Claude Code:** Add to `.mcp.json` or `~/.claude/settings.json`:
   ```json
   {
     "mcpServers": {
       "tiger_den": {
         "command": "npx",
         "args": ["-y", "mcp-remote", "https://tiger-den.vercel.app/api/mcp/mcp", "--header", "Authorization: Bearer td_your_key_here"]
       }
     }
   }
   ```

4. Restart Claude Desktop (fully quit and reopen) or restart Claude Code.

</details>

## Repository Layout

```
.claude-plugin/
  marketplace.json              ← marketplace registry (lists plugins in this repo)

plugins/
  tiger-marketing-skills/
    .claude-plugin/
      plugin.json               ← plugin metadata and version
    config.json                 ← runtime config (Drive folder ID, etc.)
    REFERENCES.md               ← how skills fetch reference docs from Google Drive
    _template/                  ← copy this to create a new skill
    content-creation/           ← blog posts, articles, brand writing
    seo/                        ← search optimization
    social-media/               ← social posts, campaigns
    analytics/                  ← reporting, dashboards
    meta/                       ← utility skills
    vendor/                     ← git submodules for community skills
    vendor-skills.json          ← config: which vendor skills to include
    skills/                     ← generated flat directory (gitignored)
    build-plugin.sh             ← builds plugin artifacts

dist/                           ← build output (gitignored)
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to create new skills, update existing ones, and get your changes reviewed.

## Questions?

Open a GitHub Issue or ask in the #marketing-tools Slack channel.


