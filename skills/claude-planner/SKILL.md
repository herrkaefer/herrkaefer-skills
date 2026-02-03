---
name: claude-planner
description: "Generate detailed implementation plans, roadmaps, and design approaches by delegating to Claude Code CLI (Opus 4.5) in plan mode. Use when user needs to: (1) Create an implementation plan, roadmap, strategy, or design approach for a feature or change, (2) Plan large-scale refactoring affecting multiple modules or components, (3) Design architecture for new features requiring cross-module changes, (4) Get a structured roadmap before starting complex implementation, (5) Have stakeholders review the approach before coding begins. Supports all languages - user may ask in English, Chinese, or any language for planning assistance."
---

# How to Use Claude Planner from Claude Code

Claude Planner is a specialized tool that invokes Claude Code CLI with Opus 4.5 model in plan mode to generate detailed implementation plans. When you need to plan complex changes that span multiple modules or need a structured approach before coding, use Claude Planner.

## When to Use Claude Planner

- User explicitly requests creating an implementation plan
- Large-scale refactoring that affects multiple modules or components
- New features requiring cross-module changes and architectural decisions
- Complex bug fixes that need systematic planning across the codebase
- When you need a structured roadmap before starting implementation
- Projects where stakeholders need plan review before coding begins

## The File-Based Pattern

Claude Planner works best with a file-based input/output pattern:

### Step 1: Create a Question File

Write your planning request and all relevant context to `/tmp/question.txt`:

```
Write to /tmp/question.txt:
- Clear description of the feature or change needed
- Current pain points or requirements
- Specific goals and success criteria
- Any architectural preferences or constraints
- Questions about approach or implementation details
```

Example structure:
```
I need to implement [feature/change].

Current situation:
- [What exists now]
- [What's missing or broken]
- [Current limitations]

Goals:
1. [Specific goal 1]
2. [Specific goal 2]

Requirements:
- [Must have]
- [Should have]
- [Constraints]

Please create a detailed implementation plan and save it to /tmp/plan.md
```

### Step 2: Invoke Claude Planner

Use this command pattern:

```bash
bash skills/claude-planner/scripts/plan.sh /tmp/question.txt -o /tmp/plan.md
```

Flags:
- First argument: Path to question file (or `-` for stdin)
- `-o <path>`: Output file path (default: `/tmp/claude-plan-YYYYMMDD-HHMMSS.md`)
- `--model <name>`: Claude model to use (default: `opus`)
- `--cwd <path>`: Repository root for exploration (default: current directory)
- `--verbose`: Show Claude's progress and debugging output

### Step 3: Read the Plan

```bash
Read /tmp/plan.md
```

Claude Planner will provide:
- **Summary**: Overview of the solution approach
- **Files to Modify/Create**: List of affected files and their purposes
- **Implementation Steps**: Detailed numbered steps with file, action, and rationale
- **Testing Strategy**: How to verify the implementation
- **Potential Risks**: Edge cases, uncertainties, and follow-up questions

Review the plan carefully and adjust based on your project specifics before implementation.

## Example Session

```
# 1. Create the question
Write /tmp/question.txt with:
- Feature: "Add user authentication with JWT tokens"
- Current state: "No auth system, all endpoints are public"
- Goals: "Secure API, support login/logout, token refresh"
- Requirements: "Use existing user model, minimal dependencies"

# 2. Invoke Claude Planner
bash skills/claude-planner/scripts/plan.sh /tmp/question.txt -o /tmp/auth-plan.md

# 3. Read and review
Read /tmp/auth-plan.md
# Plan includes: middleware setup, route protection, token generation/validation
# Files to modify: server.ts, routes/*.ts, add middleware/auth.ts
# Steps are numbered with specific actions and rationale
# Review plan with team, then implement
```

## Tips

1. **Provide complete context**: Include current architecture, existing patterns, and constraints. Claude Planner explores the codebase but benefits from explicit context.

2. **Be specific about goals**: "Add authentication" is vague. "Add JWT-based authentication with refresh tokens, session management, and role-based access control" is specific.

3. **Mention existing patterns**: If your codebase follows specific conventions (e.g., "we use dependency injection", "all services are in src/services/"), include that.

4. **Include constraints**: Technical constraints (libraries to use/avoid, performance requirements) and business constraints (must work with existing user table, no breaking changes).

5. **Review before implementing**: The plan is a roadmap, not a prescription. Adjust based on insights during implementation or team discussion.

6. **Iterate if needed**: If the plan doesn't address something, create a new question.txt with additional context or specific follow-up questions.

## Common Issues

**"claude: command not found"**: Install Claude Code CLI and authenticate first

**Empty plan output**: Check that the question file is not empty. Use `--verbose` to see what's happening

**Permission errors**: Ensure the output directory is writable

**Plan seems off-track**: The plan quality depends on question clarity. Revise the question with more specific requirements and try again

## Alternative: Direct Piping

For shorter planning questions:
```bash
echo "Plan how to add Redis caching to the API layer" | bash skills/claude-planner/scripts/plan.sh -
```

But for complex features, the file-based pattern is better because you can refine the question and keep a record of planning sessions.

## Output Format

Generated plans include YAML frontmatter with metadata:
```yaml
---
generated_at: 2026-02-02T10:30:00Z
model: opus
cwd: /path/to/repo
question_file: /tmp/question.txt
---
```

This helps track when plans were created and under what context, useful for reviewing stale plans or comparing different approaches.
