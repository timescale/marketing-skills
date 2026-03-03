---
name: seo-meta-optimizer
platforms: [cowork, claude-code]
description: "Optimize title tags and meta descriptions for SEO at scale. Use when the user wants to audit, optimize, or generate meta titles and descriptions for a website, a set of URLs, or a CSV export from tools like Ahrefs or Screaming Frog. Also trigger when the user mentions SEO metadata, title tags, meta descriptions, SERP optimization, or asks to improve search snippets. CSV input works in both Cowork and Claude Code; URL crawling requires Claude Code."
references:
  - seo/title-optimization-rules
---

# SEO Meta Optimizer

Optimize title tags and meta descriptions at scale. Accepts a CSV export (from Ahrefs, Screaming Frog, Semrush, etc.) or a website URL (Claude Code only — crawls via sitemap or link discovery), then applies a multi-stage optimization pipeline with grammar validation, duplicate detection, and brand-aware formatting.

## Platform notes

- **CSV input mode** works in both Cowork and Claude Code. This is the most common workflow — export metadata from your SEO tool and bring it here for optimization.
- **URL crawling mode** requires Claude Code (terminal access for fetching sitemaps and scraping page metadata). This mode is not available in Cowork due to network restrictions.

## When to use this skill

- User wants to audit or optimize meta titles and descriptions for a site
- User provides a CSV of page URLs with current metadata (e.g., from Ahrefs, Screaming Frog, Semrush)
- User asks to fix title tag length violations or missing meta descriptions
- User mentions SERP snippets, click-through rate optimization, or metadata audits

## Instructions

### 1. Gather context

Before optimizing, ask the user for:

- **Brand name** — used in title suffixes (e.g., "| TigerData")
- **Brand description** — one sentence, used when generating descriptions from scratch
- **Website URL** — the target site (for crawling) or just context (for CSV input)
- **Input source** — either a URL to crawl (Claude Code only) or a CSV file path

Optional:
- **Audit CSV** — existing SEO audit (Ahrefs, Screaming Frog) with organic traffic data for prioritization
- **Custom terminology** — if the brand-voice-writer skill is available, load its terms-glossary.md to ensure correct product names in metadata

### 2. Crawl or ingest

**From CSV (Cowork + Claude Code):**
1. Read the provided CSV
2. Map columns to url, current_title, current_description (ask user if column mapping is ambiguous)
3. If an audit CSV is also provided, join on URL to get organic traffic data

**From URL (Claude Code only):**
1. Check for sitemap.xml at the root domain
2. Parse all page URLs from the sitemap
3. For each page, extract the current `<title>` and `<meta name="description">` tags
4. Build a working CSV with columns: url, current_title, current_description

> If a user requests URL crawling in Cowork, explain that this mode requires Claude Code due to network restrictions, and suggest they export metadata from their SEO tool as a CSV instead.

### 3. Optimize titles

Apply a progressive strategy chain — try each technique in order, stop when the title fits within 60 characters:

1. **Full title + brand suffix** — `Original Title | Brand` (if ≤60 chars, done)
2. **Apply text shortenings** — common abbreviations + brand suffix
3. **Grammar-aware truncation** — truncate at a natural break point + brand suffix
4. **Drop brand suffix** — use the title alone if brand pushes it over
5. **Parenthetical unpacking** — remove parenthetical asides
6. **Aggressive truncation** — truncate at colon/dash boundaries

At every step, validate against grammar rules:
- No trailing commas, prepositions, or articles
- No sentence fragments
- No dangling conjunctions
- Technical terms capitalized correctly (PostgreSQL, AWS, Kubernetes, etc.)

### 4. Optimize descriptions

For each page:
- Target 120–160 characters
- Include the primary keyword/topic naturally
- End with a complete sentence (no truncation mid-thought)
- If the current description is missing or very short, generate one from the page content
- Match the brand voice (refer to brand voice guide if available)

### 5. Detect duplicates

Flag any titles or descriptions that are identical or near-identical across pages. Group duplicates and suggest differentiation.

### 6. Generate output

Produce a CSV with columns:
- `url`
- `current_title`, `optimized_title`, `title_changed` (boolean)
- `current_description`, `optimized_description`, `description_changed` (boolean)
- `page_type` (blog, docs, landing, product, etc.)
- `organic_traffic` (if audit data was provided)

Optionally, organize output into `by_section/` subdirectories (blog, docs, website, learn) if the site has clear sections.

**Cowork:** Save output to the workspace folder and provide a `computer://` link.
**Claude Code:** Save to the current working directory or user-specified path.

### 7. Validate

Run a final validation pass and report:
- Title length violations (>60 chars)
- Description length violations (<120 or >160 chars)
- Grammar issues
- Remaining duplicates
- Total pages audited, total changes made

Target: **zero issues** in the final output.

## Reference docs

Before optimizing, fetch the `seo/title-optimization-rules` reference doc from Google Drive (see REFERENCES.md for how to resolve Drive references). This contains the full grammar rule set, shortening dictionary, and validation criteria for the title optimization pipeline.

If the brand-voice-writer skill is available, also read its terms-glossary.md to ensure correct product names and capitalization in metadata.

## Dependencies

- **Required:** Network access (for URL crawling mode — Claude Code only)
- **Optional:** Brand voice writer's glossary (for terminology consistency)

## Attribution

Based on [djforge/seo-meta-optimizer](https://github.com/djforge/seo-meta-optimizer), adapted for the TigerData marketing skills plugin.
