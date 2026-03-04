---
name: internal-linking-optimizer
platforms: [claude-code]
description: "Analyze and optimize internal link structure to improve site architecture, distribute page authority, and help search engines understand content relationships. Use this skill when the user asks to fix internal links, improve site architecture, optimize link structure, distribute page authority, create an internal linking strategy, find orphan pages, or mentions that pages have no links pointing to them. Also trigger when the user mentions link equity, content silos, topic clusters, anchor text optimization, or crawl depth issues. For meta title and description optimization, see seo-meta-optimizer."
---

# Internal Linking Optimizer

Analyze a site's internal link structure and provide actionable recommendations to improve SEO through strategic internal linking. Helps distribute authority, establish topical relevance, and improve crawlability.

## When to use this skill

- Improving site architecture for SEO
- Distributing authority to important pages
- Fixing orphan pages with no internal links
- Creating topic cluster internal link strategies
- Optimizing anchor text for SEO
- Recovering pages that have lost rankings
- Planning internal links for new content

## Instructions

### 1. Gather input

Ask the user to provide:

1. **Sitemap URL or list of important pages** — a sitemap.xml URL, a CSV of page URLs, or a manually curated list of the site's key pages
2. **Key page URLs that need more internal links** — specific pages to focus on
3. **Content categories or topic clusters** — how the site's content is organized (or should be)
4. **Any existing link structure documentation** — crawl exports, link maps, or notes on current architecture

If the user provides a sitemap URL, fetch and parse it to build the page list. If they provide a CSV or file, read it directly.

### 2. Analyze current internal link structure

Map the current internal linking patterns across the provided pages.

```markdown
## Internal Link Structure Analysis

### Overview

**Domain**: [domain]
**Total Pages Analyzed**: [X]
**Total Internal Links**: [X]
**Average Links per Page**: [X]

### Link Distribution

| Links per Page | Page Count | Percentage |
|----------------|------------|------------|
| 0 (Orphan) | [X] | [X]% |
| 1-5 | [X] | [X]% |
| 6-10 | [X] | [X]% |
| 11-20 | [X] | [X]% |
| 20+ | [X] | [X]% |

### Top Linked Pages

| Page | Internal Links | Authority | Notes |
|------|----------------|-----------|-------|
| [URL 1] | [X] | High | [notes] |
| [URL 2] | [X] | High | [notes] |
| [URL 3] | [X] | Medium | [notes] |

### Under-Linked Important Pages

| Page | Current Links | Traffic | Recommended Links |
|------|---------------|---------|-------------------|
| [URL 1] | [X] | [X]/mo | [X]+ |
| [URL 2] | [X] | [X]/mo | [X]+ |

**Structure Score**: [X]/10
```

### 3. Identify orphan pages

Find pages with no internal links pointing to them.

```markdown
## Orphan Page Analysis

### Orphan Pages Found: [X]

| Page | Traffic | Priority | Recommended Action |
|------|---------|----------|-------------------|
| [URL 1] | [X]/mo | High | Link from [pages] |
| [URL 2] | [X]/mo | Medium | Add to navigation |
| [URL 3] | 0 | Low | Consider deleting/redirecting |

### Fix Strategy

**High Priority Orphans** (have traffic/rankings):
1. [URL] - Add links from: [relevant pages]

**Medium Priority Orphans** (potentially valuable):
1. [URL] - Add to category/tag page

**Low Priority Orphans** (consider removing):
1. [URL] - Redirect to [better page]
```

### 4. Analyze anchor text distribution

Review anchor text patterns and flag issues (generic anchors, over-optimization, same anchor to multiple pages).

```markdown
## Anchor Text Analysis

### Current Anchor Text Patterns

| Anchor Text | Count | Target Pages | Assessment |
|-------------|-------|--------------|------------|
| "click here" | [X] | [X] pages | Not descriptive |
| "read more" | [X] | [X] pages | Not descriptive |
| "[exact keyword]" | [X] | [page] | May be over-optimized |
| "[descriptive phrase]" | [X] | [page] | Good |

### Anchor Text Recommendations

For each flagged page, suggest 3-4 anchor text variations:
- Exact match (10-20% of anchors)
- Partial match (30-40%)
- Branded (10-20%)
- Natural (20-30%)

**Anchor Score**: [X]/10
```

### 5. Create topic cluster link strategy

Map current pillar/cluster links, recommend link structure, and list specific links to add.

> **Reference**: See the [linking templates](./references/linking-templates.md) for the topic cluster link strategy template.

### 6. Find contextual link opportunities

Analyze each page for topic-relevant link opportunities and prioritize high-impact additions.

> **Reference**: See the [linking templates](./references/linking-templates.md) for the contextual link opportunities template.

### 7. Optimize navigation and footer links

Analyze main/footer/sidebar/breadcrumb navigation and recommend pages to add or remove.

> **Reference**: See the [linking templates](./references/linking-templates.md) for the navigation optimization template.

### 8. Generate link implementation plan

Produce an executive summary, current state metrics, phased priority actions (weeks 1-4+), implementation guide, and tracking plan.

> **Reference**: See the [linking templates](./references/linking-templates.md) for the full implementation plan template.

## Validation checkpoints

### Input validation
- Site structure or sitemap provided (URL, CSV, or manual list)
- Target pages or topic clusters clearly defined
- If optimizing a specific page, page URL or content provided

### Output validation
- Every recommendation cites specific data points (not generic advice)
- All link suggestions include source page, target page, and recommended anchor text
- Orphan page lists include URLs and recommended actions
- Source of each data point clearly stated (crawl data, user-provided, or manual analysis)

## Reference docs

- [Link Architecture Patterns](./references/link-architecture-patterns.md) — Architecture models (hub-and-spoke, silo, flat, pyramid, mesh), anchor text diversity framework, link equity flow model, and measurement frameworks
- [Linking Templates](./references/linking-templates.md) — Output templates for steps 5-8 (topic clusters, contextual opportunities, navigation, implementation plan)
- [Linking Example](./references/linking-example.md) — Full worked example for internal linking opportunities

## Tips for success

1. **Quality over quantity** — add relevant links, not random ones
2. **User-first thinking** — links should help users navigate
3. **Vary anchor text** — avoid over-optimization
4. **Link to important pages** — distribute authority strategically
5. **Regular audits** — internal links need maintenance as content grows

## Related skills

- [seo-meta-optimizer](../seo-meta-optimizer/) — Optimize title tags and meta descriptions
- [brand-voice-writer](../brand-voice-writer/) — Write on-brand content that includes strategic internal links
- [content-reviewer](../content-reviewer/) — Review content quality including link structure

## Attribution

Based on [aaron-he-zhu/seo-geo-claude-skills](https://github.com/aaron-he-zhu/seo-geo-claude-skills) internal-linking-optimizer, adapted for the TigerData marketing skills plugin.
