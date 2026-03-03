---
name: brand-voice-writer
platforms: [cowork, claude-code]
description: "Write marketing content in TigerData's brand voice with full context on our audience, positioning, and terminology. Use this skill whenever the user asks to write blog posts, articles, landing page copy, email campaigns, social posts, one-pagers, case studies, or any marketing content. Also trigger when the user mentions brand voice, tone, writing style, ICP, target audience, or asks for on-brand writing. Even if the user just says 'write something about [topic]' without specifying brand voice, use this skill — all marketing content should be on-brand."
references:
  - product-marketing-context
  - brand-voice-guide
---

# Brand Voice Writer

This skill gives you deep context on TigerData's brand, audience, positioning, and
terminology so you can write marketing content that sounds like us — not generic AI output.

## When to use this skill

- Any time you're writing marketing content (blog posts, articles, emails, social, landing pages, case studies, one-pagers, ad copy)
- When the user asks for "on-brand" content or mentions brand voice / tone
- When writing about TigerData products or the Timescale/PostgreSQL ecosystem
- Basically: if it's going to be published or shared externally, use this skill

## Instructions

### 1. Load the right context

Reference docs live in a shared Google Drive folder — not bundled in this plugin. Before
writing anything, fetch the reference docs relevant to the task from Drive.

**Which docs to fetch:**

- **Always fetch:** `product-marketing-context` — the *what*: audience, positioning, terminology, competitive landscape, proof points, and marketing strategy. This is the single source of truth for who we are, who we talk to, and what we say.
- **Always fetch:** `brand-voice-guide` — the *how*: detailed writing instructions per content type (web pages, blog posts, emails, slides, data sheets, social/ads), the WABL principle, absolute rules, voice principles, intro/outro guidance, and the final filter. This tells you how to actually write each format.

Fetch both docs before writing. product-marketing-context gives you the strategic context; brand-voice-guide gives you the structural playbook.

**How to fetch:** Read `REFERENCES.md` from the plugin root — it explains how to detect your runtime (Cowork vs Claude Code) and fetch docs from the shared Google Drive folder.

### 2. Apply brand voice consistently

After reading the reference docs, internalize the voice and tone principles. The brand voice guide is the primary authority on *how* to write; the product marketing context doc is the primary authority on *what* to say.

Key things to watch for:
- Use approved terminology (product names, technical terms, capitalization) from the product marketing context glossary
- Match the tone and structural template for the content type from the brand voice guide (it has specific guidance for web pages, blog posts, emails, slides, data sheets, and social/ads)
- Apply the WABL principle throughout: "Would Anything [of value] Be Lost?" — if removing a sentence loses nothing, remove it
- Follow the absolute rules (no em dashes, one message per piece, lead with the problem, active voice, short paragraphs)

### 3. Tailor to the audience

If you know who the content is for (e.g., a specific persona from the product marketing context doc), adjust your approach:
- Lead with the pain points and motivations that matter to that persona
- Use the language and framing that resonates with their role
- Reference the use cases and scenarios relevant to their context

### 4. Write the content

Produce the content with the full context you've loaded. If the user hasn't specified a format, suggest one based on the topic and audience.

After writing, do a self-check:
- Does this sound like our brand voice, or generic AI?
- Are product names and technical terms correct per the approved terminology?
- Would this resonate with the target audience?
- Is the positioning consistent with our product marketing context?

## Optional: Tiger Den MCP integration

These features require the Tiger Den MCP server. If the tools aren't available, skip this section entirely — the skill works fine without them. See the repo README for setup instructions.

### Content search

If the `search_content` tool is available, use it to search for relevant existing content, published articles, case studies, and data points that can enrich the piece. Search for topics related to what you're writing about to find supporting material.

### Voice profiles

If the user asks to write in a specific person's voice (e.g., "write this like Matty would," "in Mike's style," "draft this as Jacky"), and the `get_voice_profile` tool is available:

1. Call `list_voice_profiles` to see who's available
2. Call `get_voice_profile` with the matching name to load their writing samples and voice notes
3. Apply that person's voice on top of the brand voice guide:
   - The voice profile takes precedence for sentence rhythm, tone, humor, paragraph style, and verbal tics
   - The brand voice guide and product marketing context still govern terminology, absolute rules (no em dashes), and positioning
   - Think of it as: the brand voice guide sets the floor and guardrails, the voice profile sets the personality

If the user doesn't mention a specific person, don't load a voice profile — just use the brand voice guide as the default voice.
