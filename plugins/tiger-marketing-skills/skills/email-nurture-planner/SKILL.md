---
name: email-nurture-planner
platforms: [cowork, claude-code]
description: "Plan content-driven email nurture sequences for TigerData — strategy, structure, and per-email outlines grounded in our audience and brand voice. Use this skill when the user asks to plan a drip campaign, nurture sequence, email series, onboarding emails, educational email flow, or lead nurture strategy. Also trigger when they mention email cadence, drip sequence, email funnel, subscriber journey, or ask 'what emails should we send about [topic]?' This skill plans the sequence — it does not write full email copy. For writing emails, hand off to brand-voice-writer."
references:
  - product-marketing-context
  - brand-voice-guide
---

# Email Nurture Planner

This skill helps you plan content-driven email nurture sequences for TigerData. It produces a strategic sequence plan — goals, audience mapping, email-by-email outlines with subject line directions, key messages, and CTAs — but stops short of writing full email copy. The output is a blueprint that a writer (or the brand-voice-writer skill) can execute against.

## When to use this skill

- Planning a new email drip campaign or nurture sequence
- Designing an educational email series around a topic (e.g., "time-series best practices in 5 emails")
- Mapping out a content-driven subscriber journey
- Deciding email cadence, sequencing, and content progression for a nurture flow
- When someone asks "what emails should we send to nurture [audience] around [topic]?"

## When NOT to use this skill

- Writing the actual email copy (use brand-voice-writer for that)
- One-off email campaigns or announcements (those don't need sequence planning)
- Transactional emails (password resets, invoices, etc.)

## Instructions

### 1. Load brand and audience context

Reference docs live in a shared Google Drive folder. Before planning anything, fetch context so the sequence is grounded in who we are and who we're talking to.

**Always fetch:**
- `product-marketing-context` — audience personas, pain points, positioning, competitive landscape, and proof points. This determines who the sequence targets and what messages will resonate.
- `brand-voice-guide` — email-specific tone and structural guidance. The guide has a dedicated email section with rules for subject lines, openers, CTAs, and voice.

**How to fetch:** Read `REFERENCES.md` from the plugin root for runtime detection and Drive fetch instructions.

### 2. Clarify the sequence brief

Before planning, gather these inputs from the user. Ask for anything they haven't provided. Do not silently assume defaults. If the user omits length or cadence, propose the defaults (4-6 emails, every 3-5 days) and wait for confirmation before proceeding.

- **Goal**: What should recipients do after the sequence? (e.g., start a trial, attend a webinar, adopt a feature, read a pillar piece)
- **Audience**: Which persona or segment? (Map to the personas in product-marketing-context if possible)
- **Topic or theme**: What content territory does this sequence cover?
- **Entry trigger**: How do people enter the sequence? (e.g., downloaded a guide, signed up for newsletter, attended a webinar)
- **Approximate length**: How many emails? (Suggest 4-6 if unspecified, but confirm with user)
- **Cadence preference**: How often? (Suggest every 3-5 days if unspecified, but confirm with user)

### 3. Design the sequence arc

Plan the sequence as a narrative arc, not a random collection of emails. Each email should build on the last and move the reader closer to the goal.

Use this progression framework for content/education nurture sequences:

1. **Hook** (Email 1): Validate the problem or curiosity that brought them in. Mirror the entry trigger. Establish what they'll learn across the sequence.
2. **Foundation** (Emails 2-3): Teach core concepts. Build understanding of the problem space. Use concrete examples and data points from our content library.
3. **Application** (Emails 3-4): Show how to apply the concepts. Link to tutorials, guides, or case studies. Start connecting ideas to TigerData's approach (without hard selling).
4. **Proof** (Email 4-5): Provide evidence — benchmarks, customer stories, comparisons. Make the case through results, not features.
5. **Action** (Final email): Clear, single CTA aligned with the sequence goal. Summarize the journey. Make the next step feel like a natural conclusion, not a sales push.

Not every sequence needs all five stages. A 3-email sequence might compress Foundation + Application into one email. Adapt the arc to the length.

### 4. Plan each email

For each email in the sequence, produce:

- **Email number and role**: Where it sits in the arc (e.g., "Email 2 — Foundation")
- **Send timing**: Days after entry trigger or previous email
- **Subject line direction**: 2-3 candidate angles for the subject line (not final copy — just directions). Follow the brand voice guide's email subject line rules.
- **Key message**: The one thing the reader should take away from this email (one sentence)
- **Content outline**: 3-5 bullet points covering what the email body should address
- **CTA**: What action the email drives and where it links
- **Supporting content**: Existing TigerData content to reference or link to (blog posts, docs, case studies). If Tiger Den MCP is available, search for these; otherwise note what type of content would be ideal.

### 5. Add sequence metadata

After the per-email plans, include:

- **Sequence name**: A working title for internal reference
- **Total emails**: Count
- **Total duration**: Days from first to last email
- **Primary CTA**: The ultimate action the sequence drives toward
- **Success metrics**: What to measure (open rates, click-through, conversion to goal action)
- **Branching notes**: Any conditional logic suggestions (e.g., "if they click Email 3's CTA, skip Email 4 and go to Email 5")

### 6. Cross-check against brand voice

Review the plan against the email section of the brand voice guide:

- **No em dashes.** The brand voice guide has an absolute rule: do not use em dashes in any content. Scan the entire plan (subject line directions, key messages, content outlines, metadata) and replace every em dash with a period, comma, colon, or separate sentence. This applies to the plan itself, not just final copy, because the plan feeds directly into brand-voice-writer.
- Are subject line directions following the rules? (No clickbait, no ALL CAPS, no false urgency)
- Is the CTA progression natural? (Not every email should push a demo)
- Does the sequence lead with problems and value, not features?
- Is the cadence respectful? (Not too aggressive for the audience)

Flag anything that drifts from voice guidelines.

## Output format

Present the plan directly in the conversation as structured text. Do not create a file, document, or report — just respond in chat. Use these sections:

1. **Sequence overview** (goal, audience, entry trigger, cadence, duration)
2. **Sequence arc** (visual summary of the progression)
3. **Per-email plans** (the detailed breakdown from Step 4)
4. **Sequence metadata** (from Step 5)
5. **Voice check** (results of the Step 6 cross-check: list any flags, or state "No issues found" if the plan passes all checks. Always confirm em dash compliance explicitly.)
6. **Next steps** (recommendations for execution)

Do not use Ghost Paper, markdown files, or any other document generation tool. The plan is a working artifact meant to be iterated on in conversation, not a deliverable.

## Optional: Tiger Den MCP integration

These features require the Tiger Den MCP server. If the tools aren't available, skip this section entirely — the skill works fine without them.

### Content search

If the `search_content` tool is available, use it to find existing TigerData content that each email could reference or link to. Search for topics related to each email's theme. This grounds the sequence in real content rather than hypothetical links.

### Voice profiles

If the user mentions a specific sender for the sequence (e.g., "these should come from Matty"), and the `get_voice_profile` tool is available, load that person's voice profile to inform the subject line directions and tone notes in the plan.

## Hand-off

After the plan is complete, offer to:
- Write the full email copy using the brand-voice-writer skill (hand off each email individually with the outline as context)
- Adjust the sequence based on feedback
- Plan a follow-up sequence for non-engagers or completers
