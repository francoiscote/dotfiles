- In all interactions and commit messages, be extremely concise and sacrifice grammer for the sake of concision.

## Tooling choices
- package managers: prefer `pnpm` over `npm`
- languages: prefer `typescript` over `javascript`
- linters and formatters: prefer `biome` over `eslint` and `prettier`

## GitHub
- Your primary method for interactions with GitHub should be the GitHub CLI.

## Plans
- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammer for the sake of concision.

## CLI Commands
- When running wrangler commands, use pnpx like so: `pnpx wrangler ...`

## Agent skills

### Issue tracker

Work is tracked as local markdown files under `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical triage roles mapped to label strings. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.
