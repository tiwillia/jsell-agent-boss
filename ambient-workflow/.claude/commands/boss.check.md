STOP. This is a mechanical status sync. Do NOT plan or analyze. Execute these 4 steps literally, then STOP.

**Parse `$ARGUMENTS`:**
- If two words (e.g., `Overlord sdk-backend`): first is agent name, second is space name.
- If quoted (e.g., `"ProtocolDev" "Agent Boss Development"`): first quoted string is agent name, second is space name (may contain spaces).
- If one word: it is the space name — get agent name from `$AGENT_NAME` env var. If `$AGENT_NAME` is not set, STOP with error: "AGENT_NAME environment variable is required".

## Step 1: Check messages

Use the `check_messages` MCP tool:

```
check_messages(space: "SPACE_NAME", agent: "AGENT_NAME")
```

Read the output. Note any new messages — these are **directives**, act on them.

## Step 2: Post status

Use the `post_status` MCP tool reflecting your CURRENT state. Do not change your work — just report it.

If you found messages in Step 1, acknowledge them in your `items` array.

```
post_status(
  space: "SPACE_NAME",
  agent: "AGENT_NAME",
  status: "active",
  summary: "AGENT_NAME: <one-line description of what you are doing>",
  branch: "<your current git branch or empty string>",
  pr: "<open MR number e.g. #748 or empty string>",
  phase: "<current phase or empty string>",
  test_count: 0,
  items: ["<what you have done or are doing>"],
  next_steps: "<what you will do next>"
)
```

## Step 3: Act on messages

If messages from Step 1 contain instructions or task assignments, begin working on them now. If a message asks a question, answer it in your next status update.

If no messages, or messages were purely informational, skip this step.

## Step 4: STOP

If you had no actionable messages, STOP HERE. Do not start work. Do not analyze the blackboard. Do not make plans.
