---
name: doctor
platforms: [cowork, claude-code]
description: >
  Run a health check on the marketing skills plugin environment. Use when someone
  says "doctor", "check my setup", "is everything working?", "diagnose", "health check",
  "something's not working", or reports errors with skills that depend on Google Drive
  or Tiger Den. Also useful after initial setup to confirm everything is connected.
---

# Doctor — Environment Health Check

Run diagnostic checks on the tools and connections that marketing skills depend on. Report results clearly with pass/fail status and actionable fix instructions.

## Detect runtime

Determine whether you're running in Cowork or Claude Code:
- If the `google_drive_search` tool is available → **Cowork**
- Otherwise → **Claude Code**

This affects how you check Google Drive (check 1) and Node.js (check 3).

## Checks to run

Run all checks in parallel where possible, then present a single summary.

### 1. Google Drive

**In Cowork**, try to access the shared references folder:

```
google_drive_search(api_query: "name contains 'brand' and '1DUPUkDyG8bkQgoWWI4kvoLTyMk_sT1n2' in parents")
```

- **Pass:** Search returns results (or returns zero results without error — that still means the connector works).
- **Fail:** Tool not available, auth error, or permission error.
- **Fix:** "Open Cowork settings (gear icon) → Connectors → Google Drive → Connect. Sign in with your Tiger Data Google account."

**In Claude Code**, try listing files in the shared folder:

```bash
gdrive files list --parent 1DUPUkDyG8bkQgoWWI4kvoLTyMk_sT1n2
```

- **Pass:** Returns a file listing without error.
- **Fail:** Command not found, auth error, or permission error.
- **Fix (command not found):** "Install gdrive: `brew install gdrive` then authenticate: `gdrive auth` using your Tiger Data Google account."
- **Fix (auth error):** "Re-authenticate: `gdrive auth` using your @tigerdata.com account."

### 2. Tiger Den MCP

Try a simple content search (same in both runtimes):

```
search_content(query: "test", limit: 1)
```

- **Pass:** Returns results or an empty result set without error.
- **Fail:** Tool `search_content` not available, connection refused, or auth error.
- **Fix:** "The Tiger Den MCP server isn't connected. Run `/setup` to get it configured — it takes about two minutes."

### 3. Node.js (Cowork only)

Node.js is only required in Cowork (where `npx` runs `mcp-remote` for the Tiger Den connection). Claude Code connects to Tiger Den directly over HTTP and does not need Node.js.

**In Claude Code**, skip this check entirely and report "N/A — not needed".

**In Cowork**, you cannot run host commands directly. If Tiger Den (check 2) is working, Node.js is fine. If check 2 failed, mention that Node.js is required and will be verified during `/setup`.

Use `$CLAUDE_CODE_HOST_PLATFORM` to determine which fix to show (`darwin` = macOS, `win32` = Windows).

## Presenting results

Use this format:

```
## Plugin Health Check

✅ Google Drive — Connected
✅ Tiger Den — Connected
✅ Node.js — v22.1.0
```

Or with issues:

```
## Plugin Health Check

✅ Google Drive — Connected
❌ Tiger Den — Not connected
⚠️ Node.js — Could not verify (Tiger Den not connected)

1 issue found — details below.
```

For each failed check, include the fix instructions directly in the output. Be concise — one or two sentences per fix, with exact steps.

If everything passes, end with: "You're all set — all the skills in this plugin have what they need."

If something fails, end with: "Run `/setup` for step-by-step help getting these configured."

## Tone

Be brief and diagnostic. This isn't onboarding — the user wants a quick status report, not a tutorial. Save the hand-holding for `/setup`.
