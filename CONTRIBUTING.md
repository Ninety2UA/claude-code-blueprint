# Contributing

Thank you for your interest in contributing to the Claude Code Project Template.

## How to contribute

### Reporting issues

Open an issue describing:
- What you expected to happen
- What actually happened
- Steps to reproduce (if applicable)

### Submitting skills or agents

If you've built a useful skill or agent:

1. Fork the repository
2. Create a branch: `feat/skill-name` or `feat/agent-name`
3. Add your skill in `.claude/skills/your-skill-name/SKILL.md`
4. Include a test scenario (see the `writing-skills` skill for the TDD approach)
5. Open a pull request with:
   - Description of what the skill/agent does
   - When it should be triggered
   - Example session showing it in action

### Improving existing content

- Fix typos, clarify instructions, improve examples
- Open a PR with a clear description of what changed and why

## Guidelines

- **Keep skills focused** — one skill should do one thing well
- **Include examples** — show, don't just tell
- **Test with Claude Code** — verify your changes work in practice
- **Follow the template style** — match the tone and structure of existing skills
- **Document triggers** — clearly state when a skill should activate

## Code of conduct

Be respectful and constructive. We're all here to build better tools.
