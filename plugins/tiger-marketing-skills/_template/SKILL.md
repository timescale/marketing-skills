---
name: your-skill-name
platforms: [cowork, claude-code]
description: >
  What this skill does and when Claude should use it.
  Be specific about trigger words and contexts so Claude activates this skill
  at the right time. Err on the side of being "pushy" — it's better for Claude
  to use the skill when it might help than to miss an opportunity.
  Example: "Use this skill whenever the user asks to write blog posts, articles,
  social copy, or any marketing content. Also trigger when they mention brand voice,
  tone, or ask for on-brand writing."
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
