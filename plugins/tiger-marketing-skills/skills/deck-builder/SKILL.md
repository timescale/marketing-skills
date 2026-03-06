---
name: deck-builder
platforms: [cowork, claude-code]
description: "Turn any document into a branded slide deck using the team's Google Slides template. Accepts blog posts, briefs, white papers, case studies, meeting notes, or raw ideas and produces a structured presentation. In Claude Code, generates a .pptx file programmatically using the team's exported template via python-pptx. In Cowork, produces structured slide-by-slide markdown with layout assignments, speaker notes, and paste-ready content mapped to the template. Use this skill when the user asks to create a slide deck, make a presentation, turn a document into slides, build a pitch deck, create a talk, or mentions 'slides', 'deck', 'presentation', or 'powerpoint'. For styled HTML reports, see ghost-paper. For writing long-form content, see brand-voice-writer."
references:
  - product-marketing-context
  - brand-voice-guide
---

# Deck Builder

Turn any document into a branded slide deck. The skill reads source material, selects a deck structure, writes slide-by-slide content with speaker notes, and either generates a .pptx file (Claude Code) or produces structured markdown mapped to your template layouts (Cowork).

## When to use this skill

- Turning a blog post, white paper, brief, or case study into a presentation
- Creating a pitch deck, conference talk, or internal review deck from scratch or from notes
- When someone says "make me a deck about X" or "turn this into slides"
- When someone needs a presentation that follows the team's branded Google Slides template

## When NOT to use this skill

- Creating HTML reports or dashboards (use ghost-paper)
- Writing long-form content like blog posts or articles (use brand-voice-writer)
- Reviewing existing slide content for brand consistency (use content-reviewer)

## Instructions

### 1. Load context

Before doing anything, fetch the reference docs declared in this skill's frontmatter.

**Always fetch:**
- `product-marketing-context` — terminology, positioning, proof points, audience personas
- `brand-voice-guide` — tone and structural guidance (has a dedicated slides section)

**How to fetch:** Read `REFERENCES.md` from the plugin root for the fetching strategy and fallback chain.

**Also read** the local reference files in this skill's `references/` directory:
- [Slide Writing Guide](./references/slide-writing-guide.md) — presentation-specific writing rules, density limits, layout decision tree
- [Deck Structures](./references/deck-structures.md) — skeleton structures for common deck types

**Template layout map:** Read [Template Layout Map](./references/template-layout-map.md) for the team's slide template layouts and placeholder details. If this file contains only the example/placeholder content (not real template data), the template has not been set up yet. Jump to the **Template setup** section at the end of this skill before proceeding.

### 2. Read the source document

Read the full input document. If the user pasted content, read it in full. If they provided a URL or file path, fetch and read it.

Analyze the source and identify:
- **Document type**: blog post, white paper, brief, case study, meeting notes, raw ideas
- **Core argument/thesis**: the single main point
- **Key supporting points**: 3-7 major ideas that support the thesis
- **Data points and metrics**: numbers, benchmarks, comparisons
- **Quotes**: customer quotes, expert opinions, notable statements
- **Logical sections**: natural content groupings

Summarize the source in 2-3 sentences and present it to the user for confirmation before proceeding. This prevents building a deck from a misread document.

### 3. Choose a deck structure

Based on the document type and the user's stated purpose (if provided), select a structure from the [Deck Structures](./references/deck-structures.md) reference.

- If the user specifies a purpose ("this is for a conference talk"), use that
- If they do not, infer from the document type and ask for confirmation
- If no existing structure fits, propose a custom one

Present the structure skeleton (slide titles and roles) to the user for approval. Wait for confirmation before writing slides.

### 4. Write the slides

For each slide in the approved structure:

1. **Assign a layout** from the template layout map that matches the slide's role (use the layout decision tree in the slide writing guide)
2. **Write the title** — concise, headline-style, under the character limit for that layout
3. **Write the body content** — follow the density rules from the slide writing guide. Respect the placeholder constraints from the template layout map (max characters, max bullets)
4. **Write speaker notes** — the full argument and supporting detail goes here. Speaker notes hold everything the slide doesn't. Include data sources, context, and transition cues
5. **Apply brand voice** — use approved terminology from product-marketing-context, follow the slides section of the brand voice guide, apply the WABL principle aggressively (slides tolerate zero fluff)

### 5. Self-check

Before generating output, review all slides against:
- [ ] Every slide has a clear single message
- [ ] No slide exceeds the density limits from the slide writing guide
- [ ] Product names and technical terms match the approved terminology
- [ ] Speaker notes provide enough context for the presenter
- [ ] The narrative arc flows logically from slide to slide
- [ ] Layout assignments match the content type (data -> big number, comparison -> two-column, etc.)

### 6. Generate output

Detect the runtime and generate the appropriate output.

#### Claude Code: Generate .pptx

1. **Install python-pptx** if not already available:
   ```bash
   pip install python-pptx 2>/dev/null || pip3 install python-pptx 2>/dev/null
   ```

2. **Locate the template.** Check for a local copy first at `skills/deck-builder/deck-template.pptx` (relative to the plugin root). If not found locally, search the shared Google Drive references folder:
   - Read `config.json` from the plugin root to get the `references_folder_id`
   - Use the gdrive CLI or Google Drive tools to locate and download `deck-template.pptx` to `/tmp/deck-template.pptx`
   - If neither source has it, tell the user: "Could not find `deck-template.pptx`. Place it in the skill directory or the shared Drive folder."

3. **Use a clone-and-replace generation strategy.** The template has 50 example slides with shapes already positioned and styled. See the "Programmatic Generation Strategy" and "Clone Source Slides" sections in the template layout map for details and helper functions.

   **Step A — Load the template and note the original slide count:**
   ```python
   prs = Presentation(template_path)
   template_slide_count = len(prs.slides)
   ```

   **Step B — For each slide in the deck plan:**

   - **Placeholder slides (layouts 0-4, 11, 12, 15):** Use `prs.slides.add_slide(layout)` and set `slide.placeholders[idx].text`. These layouts have real placeholders.
   - **All other slides:** Clone the source template slide using `duplicate_slide(prs, source_slide)`. Then use `find_body_shape()` or `find_text_shapes_by_position()` to locate shapes by role and `replace_shape_text()` or `replace_bullet_list()` to set new content. Refer to the Clone Source Slides section in the template layout map for the source index and shape roles for each slide type.
   - **Always set speaker notes:** `slide.notes_slide.notes_text_frame.text = notes`

   **Step C — Remove template slides:** After generating all new slides, delete the original template slides by iterating in reverse from `template_slide_count - 1` down to 0 using `delete_slide(prs, i)`.

   **Fallback:** If cloning fails (e.g., python-pptx internal API changes), fall back to creating a slide from the layout and putting body content in speaker notes with `[REPLACE: Body]` markers. Report which slides need manual touch-up.

4. **Report the result**: file path, total slide count, and whether any slides fell back to speaker-notes mode. Suggest the user open the .pptx in Google Slides to review formatting and replace any placeholder images.

#### Cowork: Structured markdown output

Produce slide-by-slide markdown in the conversation. Format each slide as:

```
---

## Slide [N]: [Title]
**Layout:** [Layout name from template layout map]

**Title:** [Title text]

**Body:**
[Body content — bullets, paragraphs, or key metric as appropriate for the layout]

**Speaker notes:**
[Full speaker notes]

---
```

Include a preamble at the top:

> **How to apply this to your template:** Open your Google Slides template. For each slide below, find the matching example slide (referenced by number), duplicate it, and replace the placeholder content. Speaker notes go in the notes panel (View > Speaker notes). Slides marked "clone slide N" mean you should duplicate that specific template slide and swap the text.

### 7. Optional: Tiger Den content enrichment

If the `search_content` tool is available, search for related existing content (blog posts, case studies, benchmarks) that could strengthen specific slides. Use the `published_after` parameter to filter to content from the last 18 months. Add relevant links to speaker notes as supporting material.

### 8. Optional: Voice profiles

If the user mentions who will present the deck and the `get_voice_profile` tool is available, load that person's voice profile to adjust the speaker notes tone. The slide content itself stays brand-voiced; the voice profile influences speaker notes only.

## Template setup (first-time)

If the template layout map has not been configured, guide the user through setup:

### What you need

1. **The team's Google Slides template** — the canonical branded template
2. **A .pptx export** — File > Download > Microsoft PowerPoint (.pptx) from Google Slides
3. **Upload to Google Drive** — place the .pptx in the shared references folder as `deck-template.pptx`

### Auto-generate the layout map (Claude Code)

In Claude Code, inspect the .pptx programmatically to auto-generate the template layout map:

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation('/tmp/deck-template.pptx')

for i, layout in enumerate(prs.slide_layouts):
    print(f"### Layout {i}: {layout.name}")
    print(f"**Placeholders:**")
    print(f"| idx | name | type | width | height |")
    print(f"|-----|------|------|-------|--------|")
    for ph in layout.placeholders:
        print(f"| {ph.placeholder_format.idx} | {ph.name} | {ph.placeholder_format.type} | {ph.width} | {ph.height} |")
    print()
```

Run this script, review the output, and save it to `references/template-layout-map.md` in this skill's directory. Add semantic roles and content constraints for each layout based on what you see.

### Manual setup (Cowork)

If in Cowork, ask the user to describe each slide layout in their template:
- Layout name (as shown in the slide master)
- What it looks like (title only, title + bullets, two columns, big number, etc.)
- What content goes where

Write the template layout map based on their description.

## Dependencies

- **Required:** Reference docs (`product-marketing-context`, `brand-voice-guide`) — fetched at runtime from Tiger Den or Google Drive
- **Required:** Template layout map (`references/template-layout-map.md`) — must be configured before first use
- **Claude Code only:** `python-pptx` Python package (auto-installed), `deck-template.pptx` in Google Drive
- **Optional:** Tiger Den MCP for content search and voice profiles
