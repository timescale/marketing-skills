---
name: ghost-paper
platforms: [cowork, claude-code]
description: "Turn markdown into beautiful, self-contained HTML reports with interactive charts, KPI strips, and styled tables using Ghost Paper. Use when the user wants a polished report, executive summary, quarterly review, dashboard, or visual summary. Trigger on 'make a report', 'generate a report', 'create a dashboard', 'turn this into a nice HTML', or any request to take data/markdown and make it presentation-ready. Also use when the user provides data (CSV, tables, bullet points) and asks for it to be visualized or formatted professionally."
---

# Ghost Paper Skill

Ghost Paper converts standard markdown into beautiful, self-contained HTML reports with interactive charts, KPI strips, and styled tables. Zero special syntax — just well-structured markdown.

## When to use this skill

- User wants a report, executive summary, quarterly review, or visual dashboard
- User has data (tables, metrics, lists) and wants it presentation-ready
- User asks to "make something nice" from raw data or a draft
- Output format is HTML (or PDF in Claude Code — see limitations below)

## Workflow

### Step 1: Fetch the latest Ghost Paper instructions

**Always do this first.** Run:

```bash
npx ghost-paper prompt 2>/dev/null | grep -v "^npm"
```

This prints the current markdown conventions directly from the installed version of ghost-paper. Use whatever it outputs as your guide for writing the markdown — it covers frontmatter, structure, and the table-to-chart classification rules. This ensures the skill stays in sync automatically as ghost-paper is updated.

### Step 2: Write the markdown

Using the conventions from Step 1, write the report markdown. If the user hasn't provided content yet, ask what the report should cover. If they've provided raw data, structure it into the right format.

### Step 3: Save the markdown

Write the markdown to a `.md` file in a temporary location:

```bash
cat > /tmp/report.md << 'MDEOF'
[your markdown here]
MDEOF
```

### Step 4: Determine the output directory

Pick the right output location based on the environment:

- **Cowork:** Use the workspace folder (the mounted user directory, typically the path containing `/mnt/`). This is where Cowork surfaces files to the user.
- **Claude Code:** Use the current working directory, or wherever the user specifies.

### Step 5: Build the report

**HTML output (default — works everywhere):**
```bash
npx ghost-paper build html /tmp/report.md -o "$OUTPUT_DIR/report.html"
```

**PDF output (Claude Code only):**
```bash
npx ghost-paper build pdf /tmp/report.md -o "$OUTPUT_DIR/report.pdf"
# Add --landscape for wide reports
```

**Note:** `npx` will auto-install ghost-paper on first run. This is expected and fine.

**PDF limitation in Cowork:** PDF generation requires Chrome/Chromium, which is not available in the Cowork sandbox. If a user asks for PDF output in Cowork, generate the HTML version instead and let them know: "I've generated the HTML report. To save it as a PDF, open the HTML file in Chrome and use File > Print > Save as PDF (or Cmd+P / Ctrl+P). This preserves the styling and layout." The HTML output is actually richer — it includes interactive charts and tabs that PDF cannot reproduce.

### Step 6: Present the file

- **Cowork:** Provide a `computer://` link to the output file so the user can open it directly.
- **Claude Code:** Tell the user where the file was written. If in a project directory, provide the relative path.

## Tips

- Always include frontmatter with title and subtitle
- KPI strips work best at the top of a section to anchor the reader
- Put the most important chart first in each tab
- Use blockquotes for "the one thing to remember" in each section
- For reports with many sections, use H1 tabs to keep navigation clean
- If the user wants PDF and you're in Claude Code, build both HTML and PDF in sequence

## Error handling

If `npx ghost-paper` fails:
1. Check that the markdown file exists and is valid
2. Try `npm install -g ghost-paper` then run `ghost-paper` directly
3. Check that you have write permissions to the output directory
4. If you see "Chrome not found" — this means PDF generation was attempted without Chrome. Use `build html` instead. PDF generation only works in Claude Code where Chrome can be installed.
