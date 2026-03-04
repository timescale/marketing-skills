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

**Future expansion:** This skill currently focuses on content/education nurture sequences. Welcome sequences, product onboarding sequences, re-engagement flows, and post-trial win-back sequences are not yet covered but are natural extensions. If a user asks for one of these, note that the skill doesn't have a dedicated framework for it yet and offer to adapt the nurture arc as a starting point.

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
- **Sender and sequence mode**: Who should these emails come from, and who will send them?
  - **Default: Marketing nurture.** Sender is "The Tiger Data Team." Tone is educational, brand-voiced. Emails read like valuable content that showed up in your inbox. This is the standard mode.
  - **Variant: Sales-assist.** If the entry trigger suggests prior human interaction (e.g., "met at AWS Summit," "post-demo follow-up," "event attendees"), ask the user: "Should this be a marketing nurture (from the brand) or a sales-assist sequence (provided to the sales team to send from their own names)?" Sales-assist sequences are still planned by marketing but are designed to be sent by reps. They're shorter (3-4 emails), more direct, can reference the prior interaction ("Great meeting you at..."), and use a named sender. The tone stays helpful and educational, not pushy, but it's warmer and more personal than a brand email.
  - If unsure whether the context calls for sales-assist, ask. Don't guess.

### 3. Design the sequence arc

Plan the sequence as a narrative arc, not a random collection of emails. Each email should build on the last and move the reader closer to the goal.

Use this progression framework for content/education nurture sequences:

1. **Hook** (Email 1): Validate the problem or curiosity that brought them in. Mirror the entry trigger. Establish what they'll learn across the sequence.
2. **Foundation** (Emails 2-3): Teach core concepts. Build understanding of the problem space. Use concrete examples and data points from our content library.
3. **Application** (Emails 3-4): Show how to apply the concepts. Link to tutorials, guides, or case studies. Start connecting ideas to TigerData's approach (without hard selling).
4. **Proof** (Email 4-5): Provide evidence — benchmarks, customer stories, comparisons. Make the case through results, not features.
5. **Action** (Final email): Clear, single CTA aligned with the sequence goal. Summarize the journey. Make the next step feel like a natural conclusion, not a sales push.

Not every sequence needs all five stages. A 3-email sequence might compress Foundation + Application into one email. Adapt the arc to the length.

**Sales-assist variant:** If the sequence mode is sales-assist (from Step 2), compress the arc. These sequences are shorter (3-4 emails), assume the reader already had a human touchpoint, and move faster to proof and action. A typical sales-assist arc: (1) Follow-up referencing the interaction + one valuable resource, (2) Proof or case study relevant to their use case, (3) Direct CTA (trial, docs, or book a call). Skip the extended foundation stage since the prior interaction already established context.

### 4. Plan each email

For each email in the sequence, produce:

- **Email number and role**: Where it sits in the arc (e.g., "Email 2: Foundation")
- **Send timing**: Days after entry trigger or previous email
- **Subject line direction**: 2-3 candidate angles for the subject line (not final copy, just directions). Follow the brand voice guide's email subject line rules.
- **Preview text direction**: A one-sentence direction for the preview text (~90-140 characters). It should extend or complement the subject line, not repeat it. This is the second line readers see in their inbox and directly affects open rates.
- **Key message**: The one thing the reader should take away from this email (one sentence)
- **Target length**: Approximate word count for the email body. Use 50-125 words for transactional/short emails, 150-300 words for educational content, 300-500 words for story-driven emails. This guides the writer during hand-off to brand-voice-writer.
- **Content outline**: 3-5 bullet points covering what the email body should address
- **CTA**: What action the email drives and where it links
- **Supporting content**: Existing TigerData content to reference or link to (blog posts, docs, case studies). If Tiger Den MCP is available, search for these; otherwise note what type of content would be ideal.

### 5. Add sequence metadata

After the per-email plans, include:

- **Sender**: The "from" name for the sequence (carries from the brief; include here so it's visible in the plan and gets passed to brand-voice-writer during hand-off)
- **Sequence name**: A working title for internal reference
- **Total emails**: Count
- **Total duration**: Days from first to last email
- **Primary CTA**: The ultimate action the sequence drives toward
- **Exit conditions**: When and why someone leaves the sequence early (e.g., "exits if they start a trial," "exits if they unsubscribe," "exits if they convert via another channel"). Define at least one positive exit (they converted) and one negative exit (they disengaged).
- **Success metrics**: What to measure (open rates, click-through, conversion to goal action)
- **Branching notes**: Any conditional logic suggestions (e.g., "if they click Email 3's CTA, skip Email 4 and go to Email 5")

### 6. Cross-check against brand voice

Review the plan against the email section of the brand voice guide:

- **No em dashes.** The brand voice guide has an absolute rule: do not use em dashes in any content. Scan the entire plan (subject line directions, key messages, content outlines, metadata) and replace every em dash with a period, comma, colon, or separate sentence. This applies to the plan itself, not just final copy, because the plan feeds directly into brand-voice-writer.
- **Marketing tone, not sales tone.** For standard marketing nurture sequences: check the plan for sales-sequence patterns and remove them. No "I noticed you..." or "I wanted to reach out" language, no references to "your conversation with" or "your account manager," no personalized sign-offs from a named rep. The tone should be educational and brand-voiced, like a smart blog post that arrived in your inbox, not a cold email or BDR follow-up. **Exception:** If the sequence mode is sales-assist, referencing a prior interaction and using a named sender is expected. But even sales-assist emails should stay helpful and educational, never pushy or generic-sales-y.
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

**Freshness filter:** Only use content published within the last 18 months. Use the `published_after` parameter when calling `search_content` to filter results (e.g., `published_after: "2024-09-01"` if the current date is March 2026). Older content may reference deprecated features, outdated benchmarks, or retired product names. If the only results for a topic are older than 18 months, note the gap in the supporting content field (e.g., "No recent content available on this topic; consider creating a new piece") rather than linking stale material.

### Voice profiles

If the user mentions a specific sender for the sequence (e.g., "these should come from Matty"), and the `get_voice_profile` tool is available, load that person's voice profile to inform the subject line directions and tone notes in the plan.

## Hand-off

After the plan is complete, offer to:
- Write the full email copy using the brand-voice-writer skill (one email at a time)
- Adjust the sequence based on feedback
- Plan a follow-up sequence for non-engagers or completers

**Do not auto-trigger brand-voice-writer.** The plan is meant to be reviewed and iterated on before anyone writes copy. Wait for the user to confirm the plan looks good.

### Editing the plan before writing

The user may want to tweak individual email plans before copy gets written. There are two ways to do this:

1. **Conversational edits.** The user says what to change (e.g., "Move the three evaluation tips from Email 1 to Email 2" or "Make Email 4's CTA about booking a call instead of restarting a trial"). Rewrite the affected email plan(s) and confirm before proceeding.
2. **Paste-back edits.** The user copies an email plan from the output, edits it directly (in a text editor, note, or the chat input), and pastes the revised version back. Use the pasted version as the new plan for that email, replacing the original. This gives the user full control over the outline without having to describe every change in words.

When presenting the plan, include this note at the end of the **Next steps** section: *"To edit any email plan before writing, you can tell me what to change or paste a revised version of the plan directly."*

### Writing the emails

When the user is ready to write, ask which email to start with (suggest Email 1). Then hand off to brand-voice-writer with this context for each email:

- The sequence overview (goal, audience, sender, sequence mode)
- That specific email's full plan (role, subject line directions, preview text direction, key message, target length, content outline, CTA, supporting content)
- The email's position in the arc ("This is Email 2 of 5, the Foundation email. Email 1 covered X, and Email 3 will cover Y.")

Write one email at a time. After each draft, ask if the user wants to revise it or move to the next email. This keeps the feedback loop tight and avoids throwing away bulk copy.
