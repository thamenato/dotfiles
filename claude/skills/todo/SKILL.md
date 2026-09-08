---
name: todo
description: Capture a task, idea, or follow-up into Taskwarrior. Use when the user wants to note something to do later, dump an idea from a meeting or Slack thread, or record that they are blocked on someone else.
allowed-tools: Bash
---

# Capture into Taskwarrior

Taskwarrior is the single source of truth for the user's personal task list.
Capture is cheap and reversible, so prefer adding the item over asking clarifying
questions. Ask only when you cannot tell what the item actually is.

## Buckets

| Situation | Encoding |
|---|---|
| Committed work | pending, no bucket tag |
| Might happen, unrefined | `+idea` |
| Blocked on another person | `+waiting` |

Add `wait:<date>` to an idea that should disappear until later. It stays in the
list but is hidden from `task next` and `task list` until the date arrives.

```bash
task <id> modify wait:1month      # also 1mo, 4wks, 30d, eom
task <id> modify wait:someday     # park indefinitely (resolves to year 9999)
task <id> modify wait:            # bring it back now
```

Durations are strict: `1month` and `1mo` parse, `1mon` does not.

## Adding

```bash
task add project:<area> +<tag> -- <description>
```

`--` stops Taskwarrior parsing the remainder, so a description containing a colon
("Write RFC: buildkite split") is stored intact instead of being read as an
attribute. Always use it.

Infer rather than ask:

- **project** — from the repo you are in, the area under discussion, or the PR
  touched. Check `task _projects` first and reuse an existing value rather than
  inventing a synonym.
- **bucket tag** — "we should maybe", "at some point", "would be nice" → `+idea`.
  "waiting on", "blocked on", "X owes me" → `+waiting`. Otherwise no tag.
- **due** — only when a real date was stated. Never invent one; an unreal deadline
  is worse than none.

## Provenance

When the item came from somewhere specific, annotate it. This is what lets a later
review reconstruct why the task exists.

```bash
task <id> annotate "slack #dev-platform"
task <id> annotate "https://github.com/glydways/glyd/pull/35993"
```

## After adding

Report the id, description, and bucket on one line. Do not print the whole list.
