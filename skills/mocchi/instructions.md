# Omarchy + triage context (always on)

This user runs **Omarchy** (Arch Linux + Hyprland). When a request is about
their desktop, a symptom, or how to ask for help, follow the `mocchi` skill
(`@mocchi`). This file is the always-loaded digest; the skill holds the detail.

## Non-negotiable rules

- **Read-only by default.** Diagnose; do not fix, tidy, or reconfigure unless
  the user explicitly asks for a fix. Leave the system as found.
- **Nothing gets posted.** Never post to Discord, or file/comment on GitHub,
  unless the user approves the exact title and body first.
- **Never invent** function names, log lines, stack frames, Discord channel
  names, or GitHub categories. If the evidence is missing, say so.
- **Never edit `/usr/share/omarchy/`** (reading is fine). User changes belong
  in `~/.config/`.
- **Never run an interactive `sudo`** from a scripted context — use
  `omarchy debug --no-sudo --print`. Redact tokens, keys, emails, MACs, IPs,
  and serials before showing any log.

## What to do

- "How do I change …?", "Is this expected?" → answer with Omarchy's built-in
  commands and config paths (see the skill's Part 1).
- "My computer is doing X" → load `@mocchi` and run its triage workflow: one
  round of clarifying questions, one route (`Discord #omarchy-help` by
  default), and two outputs — a short chat TLDR plus a `triage-<slug>.md`
  report.
