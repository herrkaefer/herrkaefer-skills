# Agent Skills

This repo contains shareable Agent Skills. It is structured to meet common Skill store/index requirements (e.g. skills.sh):

- Each skill lives in its own directory under `skills/`
- Each skill directory includes a `SKILL.md` with YAML frontmatter (`name`, `description`, etc.)
- A top-level README explains how to install and use skills
- A license is included

## Skills

- `claude-planner`: Generate detailed implementation plans by delegating to Claude Code CLI (plan mode).
Use this when you have a product or engineering request that is still fuzzy and you want a concrete, step-by-step plan with scope, risks, and sequencing before anyone starts coding. See `skills/claude-planner/SKILL.md` for full usage.
- `codex-builder`: Execute implementation plans with Codex CLI and produce an implementation report.
Use this after you already have a solid plan (for example from `claude-planner`) and you want Codex to carry out the implementation steps and summarize what changed. See `skills/codex-builder/SKILL.md` for full usage.

## Install

```bash
npx skills add herrkaefer/herrkaefer-skills
# optionally install a specific skill
npx skills add herrkaefer/herrkaefer-skills --skill claude-planner
npx skills add herrkaefer/herrkaefer-skills --skill codex-builder
```

**Tips**

- Avoid installing the `claude-planner` skill for Claude Code.
- Avoid installing the `codex-builder` skill for codex.


## Local Use

Each skill documents its own usage in `skills/<skill-name>/SKILL.md`.


## License

MIT. See `LICENSE`.
