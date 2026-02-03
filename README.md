# Agent Skills

This repo contains shareable Agent Skills. It is structured to meet common Skill store/index requirements (e.g. skills.sh):

- Each skill lives in its own directory under `skills/`
- Each skill directory includes a `SKILL.md` with YAML frontmatter (`name`, `description`, etc.)
- A top-level README explains how to install and use skills
- A license is included

## Skills

- `claude-planner`: Generate detailed implementation plans by delegating to Claude Code CLI (plan mode). See `skills/claude-planner/SKILL.md` for full usage.

## Install (via skills CLI)

```bash
npx skills add <owner>/<repo>
# optionally install a specific skill
npx skills add <owner>/<repo> --skill claude-planner
```

## Local Use

Each skill documents its own usage in `skills/<skill-name>/SKILL.md`.

## License

MIT. See `LICENSE`.
