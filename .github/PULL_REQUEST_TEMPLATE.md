## What changed

<!-- Brief description of what this PR does. 1-3 sentences is fine. -->
<!-- PRs with skill changes should target the `release` branch. -->

### Checklist

- [ ] PR targets `release` (not `main` — only release automation PRs go to main)
- [ ] Skill folder has `SKILL.md` with valid frontmatter (`name`, `platforms`, and `description`)
- [ ] `platforms` field is set correctly (`[cowork, claude-code]` for universal, `[claude-code]` for CLI-only)
- [ ] Description is specific about when the skill should trigger
- [ ] Any files mentioned in `SKILL.md` exist (including cross-skill references)
- [ ] `SKILL.md` is under 500 lines
- [ ] Tested on at least a couple of realistic prompts
