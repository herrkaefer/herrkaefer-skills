#!/usr/bin/env bash
set -euo pipefail

# Claude Planner - Generate implementation plans using Claude Code CLI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
QUESTION_FILE=""
OUTPUT_FILE=""
MODEL="opus"
CWD="$(pwd)"
VERBOSE=false

# Usage message
usage() {
    cat <<EOF
Usage: $(basename "$0") <question-file|-> [-o output.md] [--model name] [--cwd path] [--verbose]

Generate a detailed implementation plan using Claude Code CLI (Opus 4.5 model).

Arguments:
  question-file     Path to file containing the planning question (use '-' for stdin)

Options:
  -o, --output      Output file path (default: /tmp/claude-plan-YYYYMMDD-HHMMSS.md)
  --model           Claude model to use (default: opus)
  --cwd             Repository root for Claude to explore (default: current directory)
  --verbose         Show Claude's stderr/progress output
  -h, --help        Show this help message

Example:
  $(basename "$0") /tmp/question.txt -o /tmp/plan.md
  echo "Add user auth" | $(basename "$0") - --verbose
EOF
}

# Generate timestamp for default output filename
timestamp() {
    date +"%Y%m%d-%H%M%S"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --cwd)
            CWD="$(cd "$2" && pwd)"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            if [[ -z "$QUESTION_FILE" ]]; then
                QUESTION_FILE="$1"
            else
                echo "Error: Multiple question files specified" >&2
                usage >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Check required argument
if [[ -z "$QUESTION_FILE" ]]; then
    echo "Error: Question file required" >&2
    usage >&2
    exit 1
fi

# Set default output file if not specified
if [[ -z "$OUTPUT_FILE" ]]; then
    OUTPUT_FILE="/tmp/claude-plan-$(timestamp).md"
fi

# Read question text
QUESTION_TEXT=""
if [[ "$QUESTION_FILE" == "-" ]]; then
    # Read from stdin
    QUESTION_TEXT="$(cat)"
    if [[ -z "${QUESTION_TEXT// /}" ]]; then
        echo "Error: Question from stdin is empty" >&2
        exit 1
    fi
else
    # Read from file
    if [[ ! -f "$QUESTION_FILE" ]]; then
        echo "Error: Question file not found: $QUESTION_FILE" >&2
        exit 1
    fi
    QUESTION_TEXT="$(cat "$QUESTION_FILE")"
    if [[ -z "${QUESTION_TEXT// /}" ]]; then
        echo "Error: Question file is empty" >&2
        exit 1
    fi
fi

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "Error: 'claude' command not found. Please install Claude Code CLI first." >&2
    exit 1
fi

# Prepare claude arguments
CLAUDE_ARGS=(
    "-p"
    "--model" "$MODEL"
    "--output-format" "text"
    "--permission-mode" "plan"
)

# Run claude
if [[ "$VERBOSE" == true ]]; then
    PLAN_OUTPUT="$(cd "$CWD" && echo "$QUESTION_TEXT" | claude "${CLAUDE_ARGS[@]}" 2>&1)"
else
    PLAN_OUTPUT="$(cd "$CWD" && echo "$QUESTION_TEXT" | claude "${CLAUDE_ARGS[@]}" 2>/dev/null)"
fi

CLAUDE_EXIT_CODE=$?

# Check exit code
if [[ $CLAUDE_EXIT_CODE -ne 0 ]]; then
    echo "Error: claude exited with code $CLAUDE_EXIT_CODE" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "$PLAN_OUTPUT" | head -40 >&2
    else
        echo "Run with --verbose to see error details" >&2
    fi
    exit $CLAUDE_EXIT_CODE
fi

# Check if output is empty
PLAN_BODY="$(echo "$PLAN_OUTPUT" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [[ -z "$PLAN_BODY" ]]; then
    echo "Error: Claude returned empty output; plan not written" >&2
    exit 1
fi

# Create frontmatter
QUESTION_FILE_DISPLAY="$QUESTION_FILE"
if [[ "$QUESTION_FILE" == "-" ]]; then
    QUESTION_FILE_DISPLAY="stdin"
fi

FRONTMATTER="---
generated_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
model: $MODEL
cwd: $CWD
question_file: $QUESTION_FILE_DISPLAY
---

"

# Write plan with frontmatter
echo "${FRONTMATTER}${PLAN_BODY}" > "$OUTPUT_FILE"

# Output the file path
echo "$OUTPUT_FILE"
