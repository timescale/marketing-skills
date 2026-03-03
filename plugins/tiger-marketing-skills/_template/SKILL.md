---
name: your-skill-name
platforms: [cowork, claude-code]
description: "[One sentence explaining what this skill does.] Use this skill when the user [trigger phrases]. Also trigger when they mention [keywords]."
# ^^^  DESCRIPTION GUIDELINES:
#   IMPORTANT: Description MUST be a single line (inline with the key, not multi-line YAML).
#   The Cowork plugin UI only renders inline descriptions. Multi-line `>` or `|` YAML
#   syntax will show as blank in the plugin card. Use quotes if the text contains colons.
#
#   - Start with a plain-English summary of what the skill does (this shows in the plugin
#     card UI as a preview — make it count).
#   - Then list trigger contexts and phrases so Claude knows when to activate it.
#   - Be specific: "asks to write blog posts" > "wants to write content".
#   - Minimum 30 words — short descriptions hurt discoverability.
#   - Err on the side of being "pushy" — better for Claude to trigger when it might help
#     than to miss an opportunity.
#   - Cross-reference related skills if relevant ("For email sequences, see email-sequence").
#   - Use single quotes inside the description since the outer string uses double quotes.
---

# Skill Name

One-paragraph summary of what this skill does and why it exists.

## When to use this skill

Describe the situations where this skill should activate. Be concrete:
- "When the user asks to write a blog post or article"
- "When the user needs to optimize page titles or meta descriptions"
- "When the user mentions [specific keyword or context]"

## Instructions

The core instructions for Claude. Write in imperative form ("Read the brand voice
guide", "Always include a CTA"). Explain the *why* behind important rules so Claude
can apply good judgment in edge cases rather than blindly following rules.

### Step 1: [First thing to do]

Describe what Claude should do first.

### Step 2: [Next thing to do]

Describe the next step.

## Reference docs

**How to fetch:** Read `REFERENCES.md` from the plugin root — it explains how to detect your runtime (Cowork vs Claude Code) and fetch docs from the shared Google Drive folder.

## Output format

Describe what the final output should look like. Include a template if relevant.

## Dependencies (optional)

Remove this section if there are no dependencies.

- **Required:** [tools or access needed for this skill to work]
- **Optional:** [things that enhance the skill but aren't required]
  - Example: "If the Tiger Den MCP server is available, use `search_content` to find relevant existing content."
