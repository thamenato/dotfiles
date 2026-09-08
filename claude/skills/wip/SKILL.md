---
name: wip
description: Show everything currently on the user's plate across Taskwarrior and Jira, or answer a question about their own work — pending ideas, what was added or finished in a date range, what is blocked, what a project holds. Use for "what am I working on", "what's open", "what did I finish this week", or any question about their tasks.
allowed-tools: Bash, ToolSearch, mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql, mcp__claude_ai_Atlassian__atlassianUserInfo
---

# What's on my plate

Two sources, one view:

- **Taskwarrior** (always present) — personal capture: committed work, ideas,
  things blocked on other people.
- **Jira** (work machine only) — assigned tickets the team can see.

With no question, show the combined open view below. With a question, answer from
whichever source is relevant; most historical questions are Taskwarrior.

## Jira is optional

The Atlassian tools are **deferred**: load them with `ToolSearch` for
`mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql` before the first call.

If they are unavailable — a personal machine, no connector — skip Jira and add one
line: "Jira not connected; Taskwarrior only." That is not an error and does not
warrant retrying.

A 403 saying the app is not installed means the token's scopes went stale, not that
access was lost. Say so and suggest `/mcp` to reconnect.

```
cloudId: b56c01e0-8cf3-482f-8029-f236fccbe5c8   (glydways)
jql:     assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC
fields:  ["key", "summary", "status", "project", "updated", "priority"]
```

Always pass a narrow `fields` list — the default response carries avatar URLs and
project blobs that swamp the useful content. Do not filter to one project: open work
spans CP, DP, TB, and TI.

Group by `statusCategory` (`new`, `indeterminate`, `done`), never by `status.name` —
each project names its own statuses, so "To Do", "Triage", and "New" all mean the
same thing across these projects.

## The combined view

```bash
task next                          # committed work, urgency-ordered
task +waiting status:pending list  # blocked on someone else
task +idea status:pending count    # ideas, count only unless asked
```

Present as:

- **Now** — Jira `indeterminate` (In Progress, Triage) plus the top of `task next`.
- **Next** — Jira `new` (To Do, New) plus remaining pending Taskwarrior items.
- **Waiting** — `+waiting`, oldest first, with age.
- **Ideas** — count only, with a one-line pointer to `task +idea list`.

Include the Jira key and the Taskwarrior id, since those are what the user types
next. Flag any Jira issue not updated in 30+ days as stale — several long-dormant
tickets sit in this list, and silently reprinting them daily trains the user to
ignore the whole view.

## Answering questions

Two things that will trip you up:

**`task` exits 1 when a filter matches nothing.** That is an empty result, not a
failure. Report "nothing matched" and do not retry with a looser filter.

**`socw` is not a valid date.** Start-of-week is `sow`. Valid: `sow`, `eow`, `soww`,
`eoww`, `som`, `soy`, `today`, `now`, plus arithmetic — `today-2wk`, `now-14d`.

```bash
# Pending ideas
task +idea status:pending list

# Added two weeks ago (a window, not a point)
task entry.after:today-3wk entry.before:today-2wk all

# Finished this week
task end.after:sow status:completed all
```

For finished Jira work, swap the JQL: `assignee = currentUser() AND statusCategory =
Done AND resolutiondate >= -7d`.

| Need | Taskwarrior filter |
|---|---|
| Bucket | `+idea`, `+waiting`, or neither for committed work |
| State | `status:pending`, `status:completed`, `status:deleted`, `status:waiting` |
| When created | `entry.after:` / `entry.before:` |
| When finished | `end.after:` / `end.before:` |
| Grouping | `project:buildkite`; list existing with `task _projects` |
| Text match | `/pattern/` or `description.contains:word` |

`list` and `next` show pending work only; `all` includes completed and deleted. Use
`all` for any historical question, or the answer silently omits everything finished.

`status:waiting` (a `wait:` date still in the future) is unrelated to the `+waiting`
tag (blocked on a person). Both exist; do not confuse them.

Pipe through `jq` rather than parsing report output, whose columns shift with
terminal width:

```bash
task status:pending export | jq -r '.[] | "\(.id)\t\(.description)"'
```

Export dates are UTC basic-format (`20260908T174255Z`).

## Style

Lead with the answer. Keep the default view scannable — it gets read daily, so
length is what kills it. Do not print urgency scores unless asked.
