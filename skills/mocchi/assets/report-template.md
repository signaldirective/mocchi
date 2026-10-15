# Triage report: <object> — <deviation>

> Fill this file per incident. Keep the TLDR ≤8 lines; details below.
> Paste key log lines inline (`logs.omarchy.org` expires after 24h).

## TLDR

- **Title:** ...
- **Summary:** ... (1 sentence)
- **Route:** discord-help | github-issue | github-discussion | upstream | security-private — because ...
- **Next step:** ... (single command, link, or post location)

## Routing

- Recommended channel: ...
- Why not the others: ...
- Existing thread match: none | `<issue/post URL>` (same trigger + stack, not just same program)

## Symptom

- Goal / what you were doing: ...
- What happened (verbatim errors): ...
- What you expected: ...
- Frequency: always / sometimes / once
- When it started / what changed: ...

## Reproduction

1. ...
2. ...
3. ...

Minimal case + stock-vs-custom note (config diff, theme/hook/plugin, exact command):

```
...
```

## System / hardware

- Omarchy: ...
- Kernel: ...
- CPU / GPU (+ driver): ...
- Monitors / audio / network / input / laptop model (as relevant): ...
- Compositor: ... (`hyprctl version`, `hyprctl monitors` summary)

## Diagnostics

- `omarchy debug`: <URL and/or attached path>
- Key excerpts (inline):

```log
...
```

- Other sources checked (`journalctl` window, Hyprland log, `coredumpctl info`,
  `omarchy update analyze logs`, screenrecord log): ...

## Crash lens (only if applicable)

- What crashed + what it was doing (command line): ...
- Proves vs infers: ...
- Data loss / recovery (trash checked?): ...
- Likely to recur / avoidance: ...
- Backtrace (symbolized or shape-only, never invented): ...

## Tried / workaround

- Tried (with result each): ...
- Workaround: ...

## Captures

- Screenshot/recording paths (short, focused; text pasted above, not screenshotted): ...

## Ready-to-post drafts

### Discord `#omarchy-help` (or delete if N/A)

```markdown
<paste filled Discord template>
```

### GitHub issue (or delete if N/A)

Title: ...

```markdown
<paste filled GitHub template>
```

```bash
gh issue create --repo omacom/omarchy --title "..." --body-file triage-<slug>.md
```

## Filing checklist

- [ ] Searched Discord + open/closed issues, no duplicate (or matched thread noted above)
- [ ] Secrets redacted, structure kept
- [ ] User confirmed exact title + body (required before any filing)
- [ ] `gh auth status` succeeds (else hand over text, don't install/auth)
- [ ] Signed `Filed by <model> via <harness>` only if names are certain
