---
name: event-brief-planner
platforms: [cowork, claude-code]
description: "Plan and write complete event campaign briefs for Tiger Data -- event overview, full campaign copy (landing pages, emails, social posts, ads, banners, newsletters), and KPI tracking. Use this skill when the user asks to plan an event campaign, create an event brief, write event marketing assets, or fill out the event campaign template. Also trigger when they mention field event, conference, webinar, event landing page, pre-event email, post-event email, event social posts, event paid ads, booth marketing, event campaign copy, or 'what marketing do we need for [event]?' For writing individual assets in isolation (not as part of an event brief), use brand-voice-writer instead."
references:
  - product-marketing-context
  - brand-voice-guide
---

# Event Brief Planner

This skill helps marketing team members plan and produce complete event campaign briefs. It collects event details, generates on-brand copy for all campaign assets (landing pages, emails, social posts, ads, banners, newsletters), and provides a KPI tracking framework. Output is Markdown in chat, designed for iteration before finalizing.

## When to use this skill

- Planning a new event campaign (field event, conference, webinar)
- Filling out the event campaign brief template
- Writing campaign assets for an upcoming event
- When someone asks "what marketing do we need for [event name]?"

When NOT to use:
- Writing a single email or social post in isolation (use brand-voice-writer)
- Planning an email nurture sequence (use email-nurture-planner)
- Reviewing existing content (use content-reviewer)

## Instructions

### Step 1: Load brand and audience context

Fetch context before generating any copy so all assets are grounded in who we are and who we're talking to.

**Always fetch:**
- `product-marketing-context` -- audience personas, pain points, positioning, competitive landscape, proof points. Determines targeting and messaging.
- `brand-voice-guide` -- tone, structural guidance, email rules, social post conventions. The authority on how to write.

**How to fetch:** Read `REFERENCES.md` from the plugin root for runtime detection and fetch instructions.

**Freshness check:** After fetching each doc, check the "Last updated" date near the top. If either doc is more than 6 months old, flag it: "The product-marketing-context doc was last updated [date]. Some metrics or proof points may be outdated. Want me to proceed with what's there, or should we verify the numbers first?" This matters most for product-marketing-context since it contains performance benchmarks and customer metrics that change over time.

### Step 2: Collect the event overview (Part 1)

Gather event facts in conversational groups. Do not ask everything at once. Do not silently assume defaults.

**If the user provides a link to the event website,** read it first and pre-fill as many fields as possible (event name, type, dates, location, audience profile, whether we are listed as a sponsor). Present the pre-filled fields in Group A and ask the user to confirm or correct them rather than re-asking for information the page already provides.

**Group A: Event basics (always ask first)**
- Event name (required)
- Event link/URL (optional; if provided, read the page to extract details)
- Event type: Field Event / Conference / Webinar (required)
- Location: city and venue for in-person; "Virtual" for webinar (required)
- Booth number or location (if applicable; skip for webinars)
- Event date(s) and time zone (required)
- Is the contract signed? (Y/N or in progress with expected date)

**Group B: Speaking details (ask if applicable)**
- Are we speaking at this event? If no, skip this group.
- Speaker name(s) and title(s)
- Session title
- Session description
- Date/time of talk
- Stage or room
- Will the session be recorded?

**Group C: On-site attendees (in-person events only)**
- Skip this group entirely for webinars.
- Who is attending from Tiger Data? (names and titles)
- Do any attendees need headshot graphics for promotion? If yes, collect full names, titles, and note that headshots must be provided before submitting a design request.
- Are there customer speakers who need graphics?

**Group D: Target audience (always ask)**
- Target titles/roles
- Company size
- Industry vertical
- Target region
- Primary ICP (map to ICPs from product-marketing-context when possible)

Present groups one at a time. After Group A, decide which remaining groups are relevant: skip Group C for webinars, skip booth questions if no booth. Always ask Group D.

### Step 3: Confirm brief and select campaign assets

After collecting Part 1, present a formatted summary of the event overview. Then show the asset menu and ask the user to confirm which assets they need:

| Asset | Default | Notes |
|---|---|---|
| Landing page(s) | Yes | Ask how many (typically 1-2) |
| Website banner | Yes | 1 |
| Newsletter blurb(s) | Yes | Ask how many (typically 1-2) and launch dates |
| Pre-event email | Yes | Ask launch date and audience segment. Stagger at least 3-5 days from any newsletter blurb so the same audience is not hit twice in the same window. |
| Post-event email | Yes | 1 |
| Organic social posts | Yes | Ask how many per phase: pre-event, live, post-event |
| Paid ads | No | Ask if needed; if yes, which channels |

Also ask:
- **Primary CTA/offer:** What is the main action we want people to take? (e.g., "Register now," "Save your spot," "Book a meeting at booth #X")
- **Key messaging angle:** What is the one thing we want people to know about Tiger Data's presence at this event? This becomes the through-line across all assets.

**Establish UTM convention** based on the event name. Convert the event name to a lowercase, hyphenated slug (e.g., "AWS re:Invent 2026" becomes `aws-reinvent-2026`). This slug is the `campaign` parameter for all UTM links. Document the convention so it is visible in the output:
- `source` = channel (e.g., linkedin, twitter, email, website)
- `medium` = asset type (e.g., social, paid-social, email, banner)
- `campaign` = event slug
- `content` = asset identifier (e.g., pre-event-email, social-pre-1, paid-linkedin-1)

Wait for the user to confirm the asset list, quantities, CTA, and messaging angle before generating any copy.

### Step 4: Generate campaign assets (Part 2)

Generate each selected asset in order. Present each as a clearly headed section. Include all fields from the template.

#### 4a. Landing page(s)

For each landing page, generate:
- **Page title** (for the browser tab)
- **Proposed URL:** `https://www.tigerdata.com/events/[event-slug]`
- **Header (H1):** One compelling line that leads with what the attendee gets
- **Body copy:** 2-3 short paragraphs (under 200 words total). Cover: the event value prop, Tiger Data's presence (speaking, booth, demos), and what attendees will learn or gain.
- **CTA button text:** Aligned with the primary CTA from Step 3
- **Form fields:** Recommend fields (typically: first name, last name, company email, company name, job title, and an optional "Interested in a follow-up meeting?" checkbox)
- **Book a meeting integration?** Y/N based on whether we have a booth
- **Design asset notes:** Suggest what visuals are needed (hero banner, event logo, etc.)

Lead with what the attendee gets, not what Tiger Data is doing. Frame the value prop using the target audience from Part 1.

**Avoid copy overlap with the pre-event email.** The landing page and the pre-event email serve different contexts (inbound vs. push) even though they share a message. Use a different lead-in and structure for each. If the landing page opens with the audience's current stack, the email should open with the event value prop, or vice versa.

#### 4b. Website banner(s)

For each banner, generate:
- **Copy:** One punchy line. Strict 120-character limit. Count characters and rewrite if over.
- **CTA:** Short action text (2-4 words)
- **Landing page link**

#### 4c. Newsletter blurb(s)

For each blurb, generate:
- **Launch date:** Based on user input or suggest timing relative to event date
- **Copy:** 2-3 sentences. Conversational, not promotional. Focus on why the reader should care about this event.
- **CTA:** What action to take
- **Link:** Landing page URL
- **Image notes:** Suggest what visual to include

#### 4d. Pre-event email

Generate:
- **Launch date:** Based on user input (typically 2-4 weeks before event)
- **Target audience:** Specific segment from the brief, or "all subscribers" if not specified
- **Subject line:** Under 50 characters. Follow brand voice guide email rules: no clickbait, no ALL CAPS, no false urgency.
- **Preheader text:** Strict 85-character limit. Extends or complements the subject line, never repeats it. Count characters and rewrite if over.
- **Body copy:** 150-250 words. Lead with the event value prop, mention Tiger Data's presence, close with the CTA. Follow the brand voice guide's email section.
- **CTA:** Aligned with primary CTA
- **Offer URL(s):** Landing page with UTM parameters
- **Signature:** Suggest sender (default: "The Tiger Data Team")
- **Recipients/send list:** Based on target audience (e.g., "newsletter subscribers, prospects in [region], previous event attendees")
- **Design asset notes:** Suggest what visuals are needed

#### 4e. Post-event email

Generate:
- **Launch date:** Suggest 1-2 business days after event ends
- **Target audience:** Segment based on engagement (e.g., "booth visitors, session attendees, meeting no-shows")
- **Subject line:** Under 50 characters.
- **Preheader text:** 85-character limit.
- **Body copy:** 150-250 words. Thank attendees, share 1-2 key takeaways or resources, provide a clear next-step CTA. If a session was recorded, mention the recording will be available (or link it).
- **CTA:** Next step (e.g., "Start a free trial," "Read the recap," "Watch the recording")
- **Offer URL(s) with UTMs**
- **Signature:** Match pre-event email sender
- **Recipients/send list:** Segmented list (e.g., "booth visitors, attendees, no-show registrants, meeting follow-ups"). Only list segments that are buildable based on how leads will be captured. If lead capture method hasn't been discussed yet, flag it: "These segments depend on how booth leads are captured. Confirm scan method in the KPI tracking section."
- **Design asset notes**

#### 4f. Organic social posts

For each requested post (pre-event, live, post-event), generate:
- **Channel(s):** LinkedIn, X, or both
- **Launch date and time:** Based on event timeline
- **Copy:** Channel-appropriate length. LinkedIn posts can be longer (up to 300 words for thought-leadership style). X posts must be under 280 characters. Write separate versions if both channels are selected and the copy differs significantly.
- **CTA:** What action to take
- **Page URL with UTMs:** Use the UTM convention from Step 3
- **Accounts to tag:** Suggest the event organizer's account, any co-speakers, partner companies
- **Image notes:** Suggest what visual to include (event graphic, speaker card, booth photo, etc.)

Pre-event posts build anticipation. Post-event posts share highlights and drive follow-up.

**Live posts are drafts, not final copy.** A pre-written "live" post cannot capture real energy. Write these as templates with bracketed placeholders for real-time details (e.g., "[specific conversation topic]", "[speaker name]", "[booth photo]"). Note in the output that live posts should be adapted on-site with actual moments, photos, and specifics.

**Platform tone:** LinkedIn posts can be longer and more narrative. X posts should be punchier, more conversational, and written as native X content, not compressed LinkedIn posts. If the same message works on both platforms without changes, the X version probably needs more personality.

#### 4g. Paid ads

For each ad, generate:
- **Channel:** As specified by user (LinkedIn, Google, Reddit, Meta, X)
- **Launch date and time**
- **Ad type:** e.g., LinkedIn Sponsored Content, Google Search, Reddit Promoted Post
- **Destination URL with UTMs**
- **Headline:** Respect platform character limits. State the limit next to the field:
  - LinkedIn Sponsored Content headline: 70 characters
  - Google RSA headline: 30 characters
  - Meta primary text: 125 characters
- **Body copy:** Respect platform limits:
  - LinkedIn Sponsored Content body: 150 characters
  - Google RSA description: 90 characters
- **CTA:** Platform CTA button or text
- **Image notes:** Suggest creative direction and platform-specific dimensions

Count characters for each field and rewrite if over the limit.

### Step 5: Brand voice cross-check

After generating all assets, review everything against the brand voice guide:

1. **No em dashes.** The brand voice guide has an absolute rule: do not use em dashes in any content. Scan all generated copy and replace every em dash with a period, comma, colon, or separate sentence.
2. **Marketing tone, not sales tone.** Check for sales patterns: "I noticed you...", "I wanted to reach out," pushy or aggressive language. Event marketing should be inviting and informative.
3. **Subject lines follow the rules.** No clickbait, no ALL CAPS, no false urgency, no misleading promises.
4. **Character limits respected.** Re-verify: banner copy (120 chars), preheader (85 chars), X posts (280 chars), ad copy (platform-specific limits).
5. **Terminology correct.** Product names, capitalization, and technical terms per the glossary in product-marketing-context.
6. **CTAs varied and natural.** Not every asset should say the same thing. Vary CTA language while keeping the action clear and consistent.
7. **No copy-paste between assets.** Read the landing page body and pre-event email body side by side. If the opening paragraph or structure is too similar, rewrite one. Each asset should stand on its own even though they share a messaging angle.

Fix any issues inline and note what changed. If no issues are found, state "No voice issues found."

### Step 6: KPI tracking and lead management (Part 3)

This section is optional. Ask: "Do you want me to include the KPI tracking and lead management framework?"

If yes, generate a tracking table:

| Metric | Target | Actual |
|---|---|---|
| Event registrants | | |
| Event attendees | | |
| Booth scans | | |
| Meetings/calls booked | | |
| Speaking session attendees | | |

Then ask:
- **How are scans being captured?** (badge scanner app, manual entry, QR code, etc.)
- **Who owns CRM upload?** (name or team)

Include the answers below the tracking table.

## Output format

Present everything as structured Markdown directly in chat. Organize into these sections:

1. **Event Brief Summary** -- the confirmed Part 1 inputs, formatted as a clean reference
2. **Campaign Assets** -- each asset type as a subsection with all fields filled
3. **Brand Voice Check** -- results of Step 5
4. **KPI Tracking** -- if requested (Step 6)
5. **Next Steps** -- recommendations for execution

Do not create files, documents, or reports. The brief is a working artifact meant to be iterated on in conversation.

Include this note in the Next Steps section: *"To edit any section before finalizing, you can tell me what to change or paste a revised version directly."*

## Optional: Tiger Den MCP integration

These features require the Tiger Den MCP server. If the tools are not available, skip this section entirely. The skill works without them.

### Content search

If `search_content` is available, use it when generating copy to find existing Tiger Data content to reference or link to. Search for topics related to each asset's theme. This grounds copy in real content rather than hypothetical links. Apply an 18-month freshness filter using the `published_after` parameter. If no recent content exists for a topic, note the gap (e.g., "No recent content on this topic; consider creating a new piece") rather than linking stale material.

**Actually use what you find.** Do not just search and move on. If you find a relevant blog post, case study, or guide, weave it into the copy. For example, link a specific article in the post-event email's "read the docs" CTA, or reference a case study in the landing page body. Generic "read the docs" links are weaker than specific content recommendations.

### UTM link generation

If `generate_utm_link` is available, use it for all URLs that need UTM parameters, following the convention established in Step 3. If the tool is not available, output the UTM parameters in a table next to each URL so the user can build them manually.

### Voice profiles

If the user mentions a specific sender for emails (e.g., "these should come from Matty") and `get_voice_profile` is available, load that person's voice profile to inform the email tone and style.

## Hand-off

After the brief is complete, offer to:
- **Run content-reviewer on the landing page and email copy.** These are the longest pieces and benefit most from a quality review. Do not run content-reviewer on banner copy, newsletter blurbs, or social posts since those are too short for a meaningful evaluation. Frame it as: "Want me to run the landing page and email copy through content-reviewer before we finalize?"
- **Refine individual assets** using brand-voice-writer (one asset at a time)
- **Adjust any section** based on feedback
- **Generate the KPI tracking section** if it was skipped
- **Plan a follow-up nurture sequence** for event leads using email-nurture-planner

Do not auto-trigger content-reviewer or brand-voice-writer. The brief is meant to be reviewed and iterated on before handing off. Wait for the user to confirm the brief looks good.

### Editing the brief

The user may want to tweak individual assets or sections. Support two editing modes:

1. **Conversational edits.** The user says what to change (e.g., "Make the pre-event email subject line shorter" or "Change the social posts to LinkedIn only"). Rewrite the affected section and confirm.
2. **Paste-back edits.** The user copies a section, edits it directly, and pastes the revised version back. Use the pasted version as the replacement for that section.
