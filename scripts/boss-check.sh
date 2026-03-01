#!/bin/bash
# boss-check.sh: Heartbeat broadcast — switch agents to haiku, check in, restore opus
#
# Status check-ins are read/post operations, not heavy reasoning.
# Haiku handles them at a fraction of the cost. Opus resumes after.

DELAY="${BOSS_CHECK_DELAY:-0.8}"
FILTER="${BOSS_SESSION_FILTER:-agent}"
CHECK_MODEL="${BOSS_CHECK_MODEL:-claude-3-5-haiku@20241022}"
WORK_MODEL="${BOSS_WORK_MODEL:-claude-opus-4-6@default}"

send_keys() {
    local session="$1" text="$2"
    tmux send-keys -t "$session" "$text"
    sleep "$DELAY"
    tmux send-keys -t "$session" C-m
    sleep "$DELAY"
}

is_idle() {
    local session="$1"
    local last_line
    last_line=$(tmux capture-pane -t "$session" -p | grep -v '^$' | tail -1)
    if [[ "$last_line" == *">"* ]] || [[ "$last_line" == *"$"* ]]; then
        return 0
    fi
    return 1
}

SESSIONS=$(tmux list-sessions -F "#S" 2>/dev/null)
if [[ -z "$SESSIONS" ]]; then
    echo "boss-check: no tmux sessions found"
    exit 0
fi

WORKSPACE="${BOSS_WORKSPACE:-sdk-backend-replacement}"

MATCHED=()
SKIPPED=()
for SESSION in $SESSIONS; do
    if [[ $SESSION == *"$FILTER"* ]]; then
        if is_idle "$SESSION"; then
            MATCHED+=("$SESSION")
        else
            SKIPPED+=("$SESSION")
        fi
    fi
done

for SESSION in "${SKIPPED[@]}"; do
    echo "  [$SESSION] BUSY — skipped"
done

if [[ ${#MATCHED[@]} -eq 0 ]]; then
    echo "boss-check: no idle sessions (${#SKIPPED[@]} busy)"
    exit 0
fi

echo "boss-check: pass 1 — switch ${#MATCHED[@]} agents to haiku"
for SESSION in "${MATCHED[@]}"; do
    echo "  [$SESSION] → $CHECK_MODEL"
    send_keys "$SESSION" "/model $CHECK_MODEL"
done

echo "boss-check: pass 2 — send check-in prompt"
for SESSION in "${MATCHED[@]}"; do
    echo "  [$SESSION] → /boss-check $WORKSPACE"
    send_keys "$SESSION" "/boss-check $WORKSPACE"
done

echo "boss-check: pass 3 — restore opus"
for SESSION in "${MATCHED[@]}"; do
    echo "  [$SESSION] → $WORK_MODEL"
    send_keys "$SESSION" "/model $WORK_MODEL"
done

echo "boss-check: broadcast to ${#MATCHED[@]} sessions"
