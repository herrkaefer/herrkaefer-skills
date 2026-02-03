# Agent Skills

这个仓库用于分享可复用的 Agent Skills。结构上遵循常见的 Skill 目录/收录要求（如 skills.sh）：

- 每个 skill 独立放在 `skills/` 下的子目录中
- 每个 skill 目录包含 `SKILL.md`，并在 YAML frontmatter 中提供 `name`、`description` 等信息
- 顶层 README 说明如何安装和使用
- 仓库包含许可证

## Skills

- `claude-planner`：通过 Claude Code CLI 的计划模式生成详细实现方案。
适用于需求还不够清晰、需要先把目标拆解为可执行步骤、明确范围与风险的场景。完整用法见 `skills/claude-planner/SKILL.md`。
- `codex-builder`：使用 Codex CLI 执行实现计划并输出实现报告。
适用于已经有完整计划（例如由 `claude-planner` 产出）并希望 Codex 自动完成实现、汇总改动结果的场景。完整用法见 `skills/codex-builder/SKILL.md`。

## 安装（skills CLI）

```bash
npx skills add <owner>/<repo>
# 可选：只安装指定 skill
npx skills add <owner>/<repo> --skill claude-planner
npx skills add <owner>/<repo> --skill codex-builder
```

## 本地使用

每个 skill 的使用方法都写在 `skills/<skill-name>/SKILL.md`。

## 许可证

MIT，见 `LICENSE`。
