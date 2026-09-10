# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues on
`github.com/Yobson2/Vyba`. Use the `gh` CLI for all operations.

> **Setup status:** `gh` is not yet installed / authenticated in this environment.
> Until `gh auth login` is confirmed, skills that publish (e.g. `to-spec`,
> `to-tickets`) should prepare the issue body locally and stop before creating it.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v`; `gh` does this automatically when run inside a clone.

## Triage labels

The `triage` skill is not installed in this repo, so there is no triage-label
mapping. `to-spec` applies `ready-for-agent` directly. If that label does not exist
yet, create it once: `gh label create ready-for-agent`.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests.)_

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
