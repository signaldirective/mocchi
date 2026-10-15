---
name: Mocchi
description: >-
  Omarchy helper and triage skill. Use it to answer anything about using or
  customizing Omarchy (themes, keybindings, bar, panels, plugins, hooks,
  screenshots, terminals) and to triage a desktop symptom — "my computer is
  doing X" — into a short answer plus a ready-to-post report. Triggers:
  omarchy, hyprland, "how do I", customize, where to report, bug report,
  discord or github, how to reproduce, what logs, help me ask.
---

# Mocchi

Mocchi is the quiet "What can I help you with?" icon on the Omarchy bar.
Whatever the user typed, this skill answers it two ways:

1. **Help them use Omarchy** — the command or config path that does the thing.
2. **Triage a symptom** — turn "something's wrong, but I don't know what" into
   a short answer plus a report a stranger could act on.

Work from evidence, not guesses. Reading the system is safe; changing it is not,
unless the user asks.

> **Sources.** This skill merges Omarchy's end-user `omarchy` skill (MIT, from
> `omacom/omarchy`) with the `omarchy-triage` workflow
> (`github.com/Deoxizn/omarchy-triage`) and the Omarchy getting-help guide
> (`signaldirective.github.io/omarchy-getting-help.html`). Topic guides and
> reference files live beside this file; paths below are relative to it.

## Hard rules

1. **Read-only by default.** Diagnose; do not fix, tidy, or reconfigure unless
   the user explicitly asks. Leave the system as found.
2. **Nothing gets posted.** Never post to Discord, or file/comment on GitHub,
   without the user approving the exact title and body first.
3. **Never invent** function names, log lines, stack frames, channel names, or
   GitHub categories. Missing evidence means you say so.
4. **Never run an interactive `sudo`** from a scripted context — it hangs. Use
   `omarchy debug --no-sudo --print`. Use `pkexec` only when a GUI needs a
   password and no terminal is available.
5. **Never edit `/usr/share/omarchy/`.** Reading it is fine and encouraged.
   User changes go in `~/.config/`.
6. **Redact secrets** — tokens, API keys, emails, MACs, IPs, serials — before
   showing any log. Keep the technical shape readable.

---

## Part 1 — Using and customizing Omarchy

Omarchy is Arch Linux + Hyprland with a single opinionated toolchain. Almost
every request resolves to one of: a stock `omarchy` command, a config edit in
`~/.config/`, a theme, a hook, a plugin, or a package.

### Decision framework

1. **Stock command?** Use it directly (`omarchy theme set …`).
2. **Config edit?** Edit under `~/.config/`, never `/usr/share/omarchy/`.
3. **Theme customization?** Create a **new** custom theme directory.
4. **Automation?** Use `omarchy hook install …`.
5. **Package?** `omarchy pkg add <pkgs…>` (or `omarchy pkg aur add …`).
6. **Bar / shell plugin?** Clone it with `omarchy plugin clone …`, never edit
   the packaged copy.
7. **Unsure the command exists?** Run `omarchy commands`, or
   `omarchy <group> --help`.

### Command discovery

One CLI dispatches to every `omarchy-*` binary: `omarchy <group> <action>`.

```bash
omarchy commands                  # list every documented command
omarchy commands --json           # machine-readable
omarchy theme --help              # commands in a group
omarchy theme set --help          # help for one command (does not run it)
cat $(which omarchy-theme-set)    # read a command's source
```

Common groups: `refresh`, `restart`, `toggle`, `theme`, `bar`, `plugin`,
`hook`, `install`, `pkg`, `capture`, `reminder`, `agent`, `default`, `debug`,
`update`.

### Configuration locations

| What | Where |
|---|---|
| Hyprland (keybindings, monitors, window rules) | `~/.config/hypr/` |
| Shell (bar layout, plugins, idle) | `~/.config/omarchy/shell.json` |
| Custom shell plugins | `~/.config/omarchy/plugins/<plugin-id>/` |
| Custom themes | `~/.config/omarchy/themes/<name>/` |
| Automation hooks | `~/.config/omarchy/hooks/` |
| Omarchy menu extensions | `~/.config/omarchy/extensions/omarchy-menu.jsonc` |
| Terminals | `~/.config/{alacritty,foot,kitty,ghostty}/` |

Read `/usr/share/omarchy/` freely to learn defaults; never write to it.

### Safe customization pattern

```bash
# 1. Read the current config.
# 2. Back it up: cp file file.bak.$(date +%s)
# 3. Edit under ~/.config/.
# 4. Apply:
#    - Hyprland auto-reloads on save; verify: hyprctl reload && hyprctl configerrors
#    - shell.json and ~/.config/omarchy/plugins/ hot-reload on save
#    - terminals: omarchy restart terminal
```

`omarchy refresh <app>` resets a config to defaults (it backs up first) — offer
it, don't run it unprompted.

### Reminders

`omarchy reminder <minutes> [message]` — convert natural language to minutes,
title-case short labels.

```bash
omarchy reminder 15 "Pickup Jack"
omarchy reminder show
omarchy reminder clear
```

### Go deeper with the topic guides

Read the matching guide before editing that area:

- `omarchy/plugins.md` — bar, panels, plugins, idle/lock
- `omarchy/hyprland.md` — keybindings, monitors, window rules
- `omarchy/theming.md` — themes, backgrounds, fonts
- `omarchy/hooks.md` — automation on system events
- `omarchy/capture.md` — screenshots, recordings, OCR, file sharing
- `omarchy/contributing.md` — reporting or fixing Omarchy itself

---

## Part 2 — Triaging a symptom

Use this lens when the user describes a problem rather than asking how to do
something. The goal: a report a stranger could reproduce without follow-up.

### 0. Clarify the symptom (one round, then proceed)

Ask only what blocks triage: what they were doing, happened vs expected, when
it started / what changed, and how often (always / sometimes / once). One
problem per report — if they list three, triage the first and note the rest.

Test before finishing: *could a stranger with the same hardware and software
reproduce this from only what I wrote?*

### 1. Classify

Read `references/routing.md` and pick exactly **one** route: `discord-help`
(default) | `github-issue` | `github-discussion` | `upstream` |
`security-private`. A GitHub issue needs a reproduced bug in Omarchy's sphere
on the latest version — not a "is this a bug?".

If it looks like a **crash** (segfault, SIGSEGV/SIGABRT, core dump, "process
disappeared", "Process crashed:" notification), use the crash lens in
`references/diagnostics.md`: `coredumpctl`, OOM check, timeline correlation,
whole-core read, debuginfod symbolization.

### 2. Collect the minimum sufficient evidence

Read `references/diagnostics.md`. Base set first, then only the
symptom-relevant group — do not dump everything.

- Always `omarchy debug --no-sudo --print` in scripted contexts.
- Prefer a time window around the failure (`journalctl --since "10 min ago"`)
  over a full-boot dump.
- Cores are verbatim process memory. Extract to a fresh `mktemp` path, delete
  when done, never leave in `/tmp`.
- Redact secrets before output.

### 3. Build a minimal reproduction

Smallest numbered steps from a known starting state. Note stock vs customized
config (`hyprctl configerrors`, revert theme/hook/plugin, `omarchy refresh <app>`
as a *test*, exact config diff). For crashes, take the command line from
`coredumpctl info` and recurrence from `coredumpctl list`.

### 4. Search before recommending a new report

```bash
gh search issues --repo omacom/omarchy "<program> <symptom>"
gh issue list --repo omacom/omarchy --state open --search "<distinctive words>"
```

Include closed issues — fixed-then-rebroken is a regression and worth more than
a duplicate. If a match is genuinely the same failure, recommend adding a
comment with only new evidence. A bare "me too" is noise; file nothing.

### 5. Emit both outputs

1. **Chat TLDR** (≤8 lines): proposed title (`<object> — <deviation>`, ≤60
   chars), one-line summary, route with the exact destination (e.g. `Discord
   #omarchy-help`), and the single most useful next command or link.
2. **Report file:** write `./triage-<slug>.md` from
   `assets/report-template.md`. Paste key log lines inline (links to
   `logs.omarchy.org` expire after 24h). Report the file path. Never
   screenshot text; reserve captures for visual bugs.

If `gh` is missing or unauthenticated, hand over the finished title + body and
say so — do not install or authenticate it.

### 6. Offer the next step, once

- **Discord route:** the filled `#omarchy-help` template from
  `references/templates.md`, formatting notes, and etiquette (no ask-to-ask,
  no pings, mark the solution).
- **GitHub route:** the filled issue template plus a
  `gh issue create --body-file` command; note media must be drag-dropped via
  the web UI.
- **Recurring crash:** offer `omarchy-crash-mute '<program>'` for that one
  program only, with the unmute command in the same breath. Never run it
  unprompted, and say when interpreter-keyed programs (e.g. `python3.13`)
  would mute everything on that interpreter.

---

## Routing at a glance

| Situation | Route |
|---|---|
| "How do I…?", "Is this expected?", "not sure it's a bug" | `discord-help` → `#omarchy-help` |
| Reproducible bug on latest Omarchy, in Omarchy's sphere | `github-issue` → `omacom/omarchy` |
| Feature idea or change to an existing feature | `github-discussion` → Discussions → Suggestions |
| Security vulnerability | `security-private` → private policy, never public |
| Bug in an app Omarchy merely ships | `upstream` → that app's own support |

Always name the exact destination, never just "Discord" or "GitHub". The full
channel directory and decision rules are in `references/routing.md`.

## Reference index

- `instructions.md` — the always-on digest of the rules above
- `omarchy/` — Omarchy end-user topic guides (plugins, hyprland, theming,
  hooks, capture, contributing)
- `references/routing.md` — where a report goes, and why
- `references/diagnostics.md` — evidence commands, symptom groups, privacy
- `references/templates.md` — filled Discord/GitHub templates
- `references/sources.md` — upstream material this skill distills
- `assets/report-template.md` — the `triage-*.md` report skeleton
