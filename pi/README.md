# pi

My personal pi coding agent configuration, extensions, and packages — managed as a stow package in my dotfiles.

## Setup

This package is stowed from `~/.dotfiles/pi/`:

```bash
stow pi
```

After stowing, install extension dependencies:

```bash
# Run in any extension directory that has a package.json
cd ~/.pi/agent/extensions/my-ext && npm install
```

### What's tracked vs. ignored

| Tracked (stowed) | Ignored (local only) |
|---|---|
| `.pi/agent/settings.json` | `auth.json` — API keys |
| `.pi/agent/extensions/*.ts` | `models-store.json` — cached model catalogues |
| `.pi/agent/themes/*.json` | `trust.json` — project trust decisions |
| `.pi/agent/skills/*/SKILL.md` | `npm/`, `git/` — installed packages |
| `.pi/agent/prompts/*.md` | `sessions/` — chat history |
| `.stow-local-ignore` | `node_modules/` — extension deps |

## Settings

| Setting | Value | Notes |
|---|---|---|
| Provider | `opencode` | Using local provider |
| Model | `qwen3.6-plus` | |
| Thinking | `max` | |
| Theme | `github-light-default` | + `@benvargas/pi-themes` package |

## Roadmap

### Phase 1: Permissions Extension

Gate dangerous tool calls with interactive confirmation. Subclass pi's built-in permission model with custom rules.

**Planned features:**
- Confirm before destructive commands (`rm -rf`, `sudo`, `chmod 777`, `dd`, etc.)
- Block writes to sensitive paths (`.env`, `node_modules/`, system dirs)
- Whitelist safe commands that never prompt (ls, cat, grep, etc.)
- Configurable allow/block lists via JSON
- Log of blocked prompts for review

**API:** `tool_call` event handler with `ctx.ui.confirm()` + `event.input` mutation.

---

### Phase 2: Plan Mode

Before the agent starts executing, enter a planning phase where pi outlines the approach, asks for feedback, and only proceeds when confirmed.

**Planned features:**
- Toggle plan mode on/off (command or setting)
- Agent generates a structured plan (steps, risks, estimated scope)
- User can approve, reject, or request changes
- Once approved, agent executes with the plan as system context
- Track which plans succeeded vs. failed for learning

**API:** `input` event intercept + `before_agent_start` system prompt injection + `ctx.ui` for plan display/approval.

---

### Phase 3: Context & Usage Visibility

Better visibility into what's consuming the context window — active files, tools, skills, token counts, and cost.

**Planned features:**
- TUI widget showing current token usage vs. context limit
- Breakdown: system prompt, files, tools, conversation
- Cost estimation per session
- Context pressure warnings ("80% of context used")
- Command to show what's loaded (AGENTS.md files, skills, context files)
- Optional footer status with live token count

**API:** `ctx.getContextUsage()`, `ctx.getSystemPrompt()`, `ctx.ui.setWidget()`, `ctx.ui.setStatus()`, `turn_start`/`turn_end` events.

---

### Phase 4: Web Search

Give the agent the ability to search the web for current information, documentation, and code references.

**Planned features:**
- Custom `web_search` tool the agent can call
- DuckDuckGo / Brave Search / Google via API
- Fetch and summarize search results
- Configurable search scope (code docs, general, StackOverflow, etc.)
- Cache results to avoid redundant searches

**API:** `pi.registerTool()` + `node:https` or external API client + skill definition for when to search.

**Note:** pi already has a `@pi-dev/skills` package with a `brave-search` skill — evaluate before building custom.

---

### Phase 5: Workflows & Sub-Agents

Orchestrate complex multi-step workflows with dedicated sub-agents for specialized tasks.

**Planned features:**
- Define reusable workflows (e.g., "review PR", "migrate API", "scaffold feature")
- Sub-agents with focused system prompts for specific tasks
- Workflow state management across turns
- Handoff between agents (main agent delegates to sub-agent, collects results)
- Workflow templates stored as prompt files or skills

**API:** `pi.registerCommand()` for workflow triggers, `ctx.newSession()` / `ctx.fork()` for sub-agent sessions, custom tools for inter-agent communication, `before_agent_start` for sub-agent system prompts.

---

## Extension Structure

```
pi/
  .pi/agent/
    settings.json
    extensions/
      permissions.ts          # Phase 1
      plan-mode.ts            # Phase 2
      context-widget.ts       # Phase 3
      web-search.ts           # Phase 4
      workflows/              # Phase 5
        index.ts
        review.ts
        scaffold.ts
    themes/
    prompts/
    skills/
  .stow-local-ignore
  .gitignore
  README.md
```
