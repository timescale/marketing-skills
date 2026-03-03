---
name: content-reviewer
platforms: [cowork, claude-code]
description: "Evaluate marketing content drafts against Tiger Data's quality rubrics. Use this skill whenever someone asks to review, evaluate, critique, or give feedback on a blog post, article, white paper, tutorial, or any written marketing content. Also trigger when someone pastes a draft and asks 'how does this look?', 'is this ready?', 'what would you change?', or similar. If someone shares a draft and doesn't explicitly ask for a review but the content is clearly a work-in-progress, offer to run it through the rubric. This is the quality gate — use it before anything gets published."
references:
  - product-marketing-context
  - educational-content-rubric
  - white-paper-rubric
---

# Content Reviewer

This skill evaluates marketing content drafts against structured quality rubrics. It doesn't line-edit or fix grammar. It assesses whether a piece works at the structural, narrative, and strategic level — and gives actionable feedback to make it stronger.

## When to use this skill

- Someone asks you to review, evaluate, or critique a draft
- Someone pastes content and asks "how does this look?" or "is this ready to publish?"
- Someone wants feedback on a blog post, white paper, article, or tutorial
- Someone asks "what would make this better?"
- After using the brand-voice-writer skill to create content, as a quality check

## Two rubrics, two content types

Tiger Data's blog content falls into two modes. Each has its own evaluation rubric because they're trying to do fundamentally different things:

**Systems Mode** (white papers, architectural posts): The goal is to build credibility and shape how people think about a category. The rubric evaluates thesis strength, narrative momentum, category framing, technical authority, selectivity, whether the conclusion feels earned, and memorability. Think: "Would a senior engineer share this?"

**Builder Mode** (educational posts, tutorials): The goal is to help a developer learn something and take action. The rubric evaluates outcome clarity, practical utility, step-by-step flow, concrete examples, theory discipline, CTA alignment, and builder confidence. Think: "Could someone actually build something after reading this?"

## Instructions

### 1. Get the content

The user might paste the draft directly, share a file, or point to a URL. However they provide it, read the full piece before doing anything else.

### 2. Classify the content type

Determine whether this is Systems Mode or Builder Mode content. Look at the intent of the piece:

- **Systems Mode signals**: architectural arguments, "why we built X this way," category-level framing, design philosophy, market landscape analysis, tradeoff discussions
- **Builder Mode signals**: step-by-step instructions, code examples, "how to do X," tutorials, practical walkthroughs, learning outcomes stated upfront

If it's ambiguous, ask the user. Some pieces blend both — in that case, note which mode the piece leans toward and evaluate against that rubric, but flag sections where it drifts into the other mode (this drift is usually a problem worth calling out).

If the content is neither mode (e.g., a landing page, email, social post, or one-pager), skip the rubric evaluation and instead review it against the brand voice guide. Fetch `brand-voice-guide` from the shared Google Drive folder (see `REFERENCES.md` in the plugin root for how to fetch reference docs) — it has specific tone and structural guidance for each of those content types.

### 3. Load the right rubric

Reference docs live in a shared Google Drive folder — not bundled in this plugin. Read `REFERENCES.md` from the plugin root for how to detect your runtime (Cowork vs Claude Code) and fetch docs from Drive.

Fetch the rubric for the content type you classified:

- For Systems Mode: fetch `white-paper-rubric`
- For Builder Mode: fetch `educational-content-rubric`

### 4. Also load brand context

To check terminology and positioning accuracy, also fetch `product-marketing-context` from Drive.

You don't need this for every review, but do load it if the piece mentions Tiger Data products, makes competitive claims, or positions the product. Wrong terminology or off-message positioning is worth flagging even in a structural review.

### 5. Run the evaluation

Work through each of the seven dimensions in the rubric. For each dimension, produce the specific outputs the rubric asks for. Be direct and specific — vague feedback like "could be tighter" isn't useful. Point to specific sections, paragraphs, or transitions.

The rubric is designed to surface structural issues, not nitpick. If a dimension is strong, say so briefly and move on. Spend your time on the dimensions where the piece falls short.

**Builder Mode dimensions:** Outcome Clarity, Practical Utility, Step-by-Step Flow, Concrete Examples, Theory Discipline, Single Clear Next Step, Builder Confidence. For each, the rubric specifies what to output (e.g., for Builder Confidence: where authority is strong, where it feels generic).

**Systems Mode dimensions:** Core Thesis Strength, Narrative Spine, Category Framing Power, Technical Authority and Credibility, Strategic Selectivity, Conversion Without Selling, Memorability. For each, the rubric specifies what to output (e.g., for Memorability: the core mental model created, whether it's strong enough to shape future thinking).

### 6. Produce the final assessment

After all seven dimensions, provide:

**For Builder Mode:**
- A 1–10 rating for Builder Mode quality
- The three highest-impact changes to improve clarity and actionability
- Whether this is truly a tutorial or drifting into thought leadership

Assume the audience is working developers. Avoid hype language. Think in terms of buildability.

**For Systems Mode:**
- A 1–10 rating for structural quality
- The three highest-impact changes that would elevate it one tier
- A revised high-level outline that would strengthen thesis and momentum

Assume the audience is senior engineers and database architects. Avoid hype language. Think in systems.

**For both modes**, the three highest-impact changes should be specific and actionable, not generic advice. The user is going to revise based on your feedback, so prioritize the changes that would move the needle most.

### 7. Brand voice spot-check

Separately from the rubric, flag any issues with:

- **Terminology**: wrong product names, outdated branding (e.g., "Timescale Cloud" instead of "Tiger Cloud"), incorrect capitalization. Check against the glossary in `product-marketing-context`.
- **Voice violations**: em dashes (these are banned), generic AI language, passive voice, hedging ("we believe"), marketing fluff
- **Positioning drift**: claims that contradict the positioning section in `product-marketing-context`, feature-first framing instead of problem-first, competitive framing that breaks the guardrails

Keep this section short. If there are no issues, say so. This is a spot-check, not a full brand audit.

### 8. Offer next steps

After the review, ask whether the user wants:
- A deeper dive on any specific dimension
- Help rewriting specific sections (hand off to brand-voice-writer skill for this)
- A re-review after they've made changes

## Optional: Tiger Den MCP integration

These features require the Tiger Den MCP server. If the tools aren't available, skip this section entirely — the skill works fine without them. See the repo README for setup instructions.

### Content search

If the `search_content` tool is available, use it to find previously published content on the same topic. This gives you useful context: has this topic been covered before? Is this piece retreading old ground or adding something new? Are there existing pieces it should reference or link to?

### Voice-match review

If the user mentions who wrote a piece (e.g., "review Matty's draft," "this is Jacky's post," "does this sound like Mike?"), and the `get_voice_profile` tool is available:

1. Call `get_voice_profile` with the author's name to load their writing samples and voice notes
2. Add a **Voice Match** dimension to the review (in addition to the seven rubric dimensions):
   - Compare the draft's sentence rhythm, tone, humor, and paragraph style against the author's profile
   - Flag sections that deviate from their natural voice — this often signals over-editing, AI slop, or a ghost-writer who hasn't internalized the author's style
   - Note where the voice is strongest (usually the most authentic, least polished sections)

If the user doesn't mention an author, don't load a voice profile — just run the standard rubric.

## Calibration notes

A few things to keep in mind when scoring:

- **A 7 is good.** Most published content from good teams lands in the 6-8 range. A 9-10 means it's genuinely best-in-class — the kind of piece that gets shared widely and referenced months later. Don't grade-inflate.
- **The gold standards are 9s.** The reference articles linked in the rubrics represent what a 9 looks like. Use them as mental anchors.
- **Focus on the highest-leverage feedback.** Three strong suggestions beat ten scattered ones. The user is going to revise based on your feedback, so prioritize the changes that would move the needle most.
- **Be honest, not harsh.** If the piece isn't ready, say so clearly but constructively. "This has a strong core insight but the structure isn't letting it land yet" is better than "This needs major work."
