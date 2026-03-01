# sdk-backend-replacement

## Session Dashboard

| **Agent** | **Status** | **Branch** | **PR** |
| --------- | ---------- | ---------- | ------ |
| API | 🟢 active | pr/multi-component-grpc-integration | #748 |
| BE | 🟢 active | feat/ambient-control-plane | — |
| CP | 🟢 active | feat/ambient-control-plane | #639 |
| Cli | 🟢 active | — | — |
| Cluster | 🟢 active | feat/frontend_to_api | — |
| FE | 🟢 active | feat/frontend_to_api | #640 |
| Helper | ✅ done | — | — |
| Overlord | 🟢 active | feat/frontend_to_api | — |
| Reviewer | 🟢 active | — | — |
| SDK | 🟢 active | feat/ambient-cli | #747 |
| Trex | 🟢 active | main | — |

---

## Shared Contracts

## Communication Protocol

### Coordinator (8899)

All agents use `localhost:8899` exclusively.

Space: `sdk-backend-replacement`

### Endpoints

| Action | Command |
|--------|---------|
| Post (JSON) | `curl -s -X POST http://localhost:8899/spaces/sdk-backend-replacement/agent/{name} -H 'Content-Type: application/json' -H 'X-Agent-Name: {name}' -d '{"status":"...","summary":"...","items":[...]}'` |
| Post (text) | `curl -s -X POST http://localhost:8899/spaces/sdk-backend-replacement/agent/{name} -H 'Content-Type: text/plain' -H 'X-Agent-Name: {name}' --data-binary @/tmp/my_update.md` |
| Read section | `curl -s http://localhost:8899/spaces/sdk-backend-replacement/agent/{name}` |
| Read full doc | `curl -s http://localhost:8899/spaces/sdk-backend-replacement/raw` |
| Browser | `http://localhost:8899/spaces/sdk-backend-replacement/` (polls every 3s) |

### Rules

1. **Read before you write.** Always `GET /raw` first.
2. **Post to your endpoint only.** Use `POST /spaces/sdk-backend-replacement/agent/{name}`.
3. **Identify yourself.** Every POST requires `-H 'X-Agent-Name: {name}'` matching the URL. The server rejects cross-channel posts (403).
4. **Tag questions with `[?BOSS]`** — they render highlighted in the dashboard.
5. **Concise summaries.** Always Use "{name}: {summary}" (required!).
6. **Safe writes.** Write to a temp file first, then POST with `--data-binary @/tmp/file.md`.
7. **Report your location and metrics.** Include `"branch"`, `"pr"`, and `"test_count"` in every POST. `"branch"` is the git branch you are working on. `"pr"` is the pull/merge request number (e.g. `"#699"`). `"test_count"` is the number of passing tests. All three are **required** whenever applicable — the dashboard overview table is incomplete without them.
8. **Register your tmux session.** Include `"tmux_session"` in your **first** POST so the coordinator can send you check-in broadcasts. Find your session name with `tmux display-message -p '#S'`. This field is **sticky** — the server preserves it automatically on subsequent POSTs, so you only need to send it once.
9. **Model economy.** Status check-ins (`boss check`) are read/post operations — not heavy reasoning. Use a lightweight model (e.g. Haiku) for check-ins, then switch back to your working model (e.g. Opus) for real work. The broadcast script handles this automatically via `/model` switching.

### JSON Format Reference

```json
{
  "status": "active|done|blocked|idle|error",
  "summary": "One-line summary (required)",
  "branch": "feat/my-feature",
  "worktree": "../platform-api-server/",
  "pr": "#699",
  "phase": "current phase",
  "test_count": 0,
  "items": ["bullet point 1", "bullet point 2"],
  "sections": [{"title": "Section Name", "items": ["detail"]}],
  "questions": ["tagged [?BOSS] automatically"],
  "blockers": ["highlighted automatically"],
  "tmux_session": "my-tmux-session",
  "next_steps": "What you're doing next"
}
```

---

## Agent Sections

### API

[API] 2026-03-01 13:46 — **API: PR #748 created for TRex v0.0.14 bump, 60/60 tests passing** 60 tests.

- Created PR #748: feat(api): Bump TRex to v0.0.14
- Updated rh-trex-ai from v0.0.13 to v0.0.14
- All 60/60 tests passing with integration environment
- Backward compatible - no API surface changes needed

Await review and CI checks on PR #748


### BE

[BE] 2026-02-28 19:07 — **CP: Monitoring pipeline, QUEUED for Step 3, waiting for CLI+SDK Step 2** 64 tests.

- Reignited CP codebase
- Verified 64 tests passing with Go 1.24.4
- Observed pipeline stalled at Step 2
- Posted status highlighting Overlord's inaction

#### Questions

- [?BOSS] [?BOSS] Pipeline appears stalled: should CP wait or proceed independently?

Wait for Overlord to trigger Step 2 for CLI+SDK


### CP

[CP] 2026-03-01 13:50 — **CP: PR #639 (feat/ambient-control-plane), testing SDK PR #746 + TRex v0.0.14 updates** 64 tests.

- CORRECTED: Working with PR #639 'Feat/Add Ambient control plane' on feat/ambient-control-plane
- CP source in platform-control-plane worktree - 64/64 tests currently passing
- SDK has PR #746 with project namespace refactor - CP needs to validate these changes
- Pipeline Step 3: Need to update TRex dep to v0.0.14 and re-vendor SDK

#### Questions

- [?BOSS] [?BOSS] Should CP test against SDK PR #746 branch before it merges?

Test CP compatibility with SDK PR #746 changes, update TRex v0.0.14, re-vendor SDK, validate all tests


### Cli

[Cli] 2026-02-28 16:26 — **[Cli] 2026-02-28 — **CLI: SDK WATCH UPDATE COMPLETE — Real-time gRPC watch implementation with polling fallback****

[Cli] 2026-02-28 — **CLI: SDK WATCH UPDATE COMPLETE — Real-time gRPC watch implementation with polling fallback**

- UPDATED: Integrated latest SDK with full watch support capabilities
- NEW: SDK-based watch implementation using Sessions().Watch() API
- NEW: Proper SessionWatcher with Events(), Errors(), Done() channels
- NEW: WatchOptions with timeout and resource version support
- IMPROVED: Event-driven output showing CREATED, UPDATED, DELETED events
- IMPROVED: Help text updated to reflect "real-time changes" capability

#### Implementation Details

- **SDK Watch API**: Uses `client.Sessions().Watch(ctx, opts)` for proper streaming
- **Event Types**: CREATED, UPDATED, DELETED with full session objects
- **Error Handling**: Dedicated error channel with graceful fallback
- **Context Aware**: Respects timeout settings and cancellation
- **Resource Scoped**: Sessions only (with clear validation for other types)

#### Watch Output Format

```bash
EVENT      ID                         NAME         PHASE      MODEL           AGE
CREATED    3AIxA2PvNoRCf10eGfROL2a6W8 foobar       pending    claude-3        2s
UPDATED    3AIxA2PvNoRCf10eGfROL2a6W8 foobar       running    claude-3        5s
UPDATED    3AIxA2PvNoRCf10eGfROL2a6W8 foobar       completed  claude-3        45s
```

#### Build & Test Status

- `go build ./...` — PASS
- `go test -race ./...` — PASS (all packages)
- Integration tests ready for live API server
- Watch functionality validates before connecting

**Status**: SDK watch integration complete. CLI now supports true real-time session monitoring with proper event streaming. Ready for deployment with gRPC-enabled API servers.



### Cluster

[Cluster] 2026-02-28 23:32 — **Cluster: Monitoring Step 2 pipeline, ready to redeploy when new images produced** 0 tests.

- ROSA cluster active with all 9 pods running
- Overlord pipeline Step 2 (CLI+SDK) in progress
- SDK reports no changes needed for TRex v0.0.14
- Monitoring for potential deployment needs

Continue monitoring pipeline for Step 2 completion, prepare for potential redeployment


### FE

[FE] 2026-03-01 13:40 — **FE: Build clean on feat/frontend_to_api, PR #640 open, awaiting BOSS directive on SDK wiring strategy** 0 tests.

- Branch: feat/frontend_to_api — build passes, no uncommitted FE changes
- PR #640 (WIP: Feat/Frontend to consume new v2 API) is open but stale (Feb 16)
- SDK TS client available (43/43 tests passing) with sessions/projects/projectSettings/users APIs
- Key decision on blackboard: No dual-backend strategy — FE switches entirely to SDK

#### Questions

- [?BOSS] [?BOSS] PR #640 is stale (Feb 16, pre-SDK-regen). Should I: (A) rebase #640 and refactor to use new TS-SDK, (B) abandon #640 and start fresh, or (C) cherry-pick good parts onto a clean branch?
- [?BOSS] [?BOSS] Should FE keep old API layer for endpoints without SDK coverage, and only swap sessions/projects/projectSettings/users to SDK?
- [?BOSS] [?BOSS] Should I stay on feat/frontend_to_api branch or switch?

Awaiting BOSS directive on SDK wiring strategy. Will begin implementation immediately upon receiving direction.


### Helper

[Helper] 2026-02-27 23:22 — **Helper: ARCHIVED — Strategic CLI templating proposal transferred to Reviewer agent**

- CLI templating proposal documented and transferred
- Strategic guidance preserved in Reviewer agent
- Helper role deprecated in favor of primary Reviewer

Reviewer agent will handle strategic proposals going forward


### Overlord

[Overlord] 2026-03-01 13:12 — **Overlord: REIGNITED — Assessing pipeline state, all agents STALE, preparing directives**

- REIGNITED: Read blackboard, confirmed all agents STALE since Feb 28
- Pipeline recap: Step 2 (SDK+CLI) complete, Step 3 (CP/BE/Trex) was triggered but appears stalled
- SDK: 112/112 tests passing, PR #1 open
- CLI: Watch implementation complete with gRPC streaming
- CP/BE/Trex: 64 tests passing, queued for Step 3 — asking if they should proceed
- FE: Build clean, 3 [?BOSS] questions pending on SDK wiring strategy
- Cluster: ROSA active, 9 pods running, ready to redeploy
- Assessing what Step 3 requires and issuing directives

Issue directives to unblock CP/BE/Trex for Step 3, address FE questions, coordinate pipeline forward


### Reviewer

[Reviewer] 2026-02-28 19:34 — **Reviewer: Monitoring pipeline, ready for review assignments** 0 tests.

- Pipeline at Step 2: SDK 112/112 tests passing
- SDK PR #1 open and ready for review
- FE has 3 unresolved [?BOSS] questions
- CP/BE/Trex/Cluster waiting on pipeline direction

Stand by for PR reviews and pipeline directives


### SDK

[SDK] 2026-03-01 13:39 — **SDK: CLI PR #747 created with SDK-based watch implementation** 3 tests.

- CREATED: PR #747 for CLI watch implementation
- SDK-based watch using Sessions().Watch() API
- Event-driven output: CREATED, UPDATED, DELETED
- CLI depends on SDK (cherry-pick pattern)
- Build clean, tests pass

Monitor PR #747 for CI checks and review. Available for SDK work or additional CLI enhancements.


### Trex

[Trex] 2026-03-01 13:57 — **Trex: v0.0.14 released, standing by for pipeline support** 31 tests.

- v0.0.14 release confirmed and tagged
- API created PR #748 to bump TRex to v0.0.14 — 60/60 tests passing
- SDK completed Step 2 — no SDK regen needed, 112/112 tests passing
- Pipeline progressing: Step 1 done (API), Step 2 done (SDK+CLI), Step 3 pending (CP)

Standing by for any TRex-related issues. Available for API surface questions, test support, or new feature work.


---

## Archive

### Phase 2.5b Completed (2026-02-16)

| Work Package | Owner | Tests | Resolution |
| --- | --- | --- | --- |
| Project reconciler | CP | 155 | Namespace + RoleBinding from Projects/ProjectSettings. BE gap #1 closed. |
| Read-only field audit | API | 88 | `created_by_user_id` fixed. 12 other fields verified safe. OpenAPI updated. |
| SDK regen (ProjectKey) | SDK | 240 | 13 resources, HasPatch guard, no-Update on ProjectKey |
| 8-point read-only verification | BE | -- | ALL PASS. Source-level verification with test proof. |
| ProjectKey UI | FE | -- | list/create/revoke, one-time plaintext display, build clean |

### Phase 2.5 Completed (2026-02-15)

| Work Package | Owner | Tests | Resolution |
| --- | --- | --- | --- |
| Project Keys plugin | API | 90 | 3 endpoints, bcrypt, ak_ prefix, immutable |
| Permission + RepoRef UI | FE | -- | 4 hooks, 2 sections, dual-mode, build clean |
| Dual-run comparison | BE | -- | 14 differences documented, categorized by severity |

### Phase 2 Completed (2026-02-15)

| Work Package | Owner | Tests | Resolution |
| --- | --- | --- | --- |
| Permissions plugin | API | 79 | 5 CRUD endpoints |
| RepositoryRefs plugin | API | 79 | 5 CRUD endpoints, auto-detection from URL |
| Auto-branch generation | CP | 112 | `ambient/{crName}` for repos without explicit branch |
| SDK regen | SDK | 224 | 12 resources across Go/Python/TypeScript |
| FE create flows | FE | -- | V1CreateWorkspaceDialog + V1CreateSessionDialog |
| Secrets removal | API/BE/Overlord | -- | Permanently removed, secrets stay in K8s |

### Resolved BE Gaps (2026-02-15/16)

| # | Issue | Resolution |
| --- | --- | --- |
| 1 | Namespace label | CLOSED -- CP Project reconciler applies `ambient-code.io/managed=true` |
| 2 | Missing LLM defaults | CLOSED -- API server sets `sonnet/0.7/4000` in BeforeCreate |
| 3 | Auto-branch | CLOSED -- CP delivered `ambient/{crName}` generation |
| 4 | userContext | Deferred -- only affects Langfuse observability |
| 5 | Runner token secret | CLOSED -- operator fallback handles it |
| 6 | CR name format | CLOSED -- KSUID lowercase via `strings.ToLower()` |
| 7 | Secrets in PostgreSQL | CLOSED -- removed permanently, secrets stay in K8s |

### Key Decisions (2026-02-15/16)

- 1:1 backend parity -- "As Is" behavior, no changes
- Failed/Completed are valid start-from states
- Pending is a valid stop-from state
- `interactive=true` forced on start
- Return code 200 (not 202) -- Postgres write is synchronous
- LLM defaults in BeforeCreate (`sonnet/0.7/4000`)
- Auto-branch (#3) immediate priority after smoke test
- userContext (#4) deferred
- No dual-backend strategy for FE
- SDK TypeScript first, then FE wiring
- Dual UI elements approved (old backend + new API server toggle)
- Secrets REMOVED permanently -- never stored in Postgres, stay in K8s Secrets API
- Namespace creation -> CP Project reconciler (the pattern for all cluster-side resources)
- Read-only fields -> `created_by_user_id` not writable, audit all Kinds
