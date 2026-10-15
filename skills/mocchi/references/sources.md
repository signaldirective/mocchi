# Sources

Upstream material this skill distills. Read these when the summaries here
aren't enough.

## Getting help (SignalDirective)

- Guide (primary): <https://signaldirective.github.io/omarchy-getting-help.html>
  — where to ask (§0), universal rules (§1), Discord `#omarchy-help` flow
  (§2: title, 8 essentials, `omarchy debug`, logs, captures, templates),
  GitHub issue flow (§3: when to file, anatomy, diagnostics, minimal repro,
  `gh` CLI, templates), command quick reference (App. A), log locations (App. B).

## Omarchy agent skills (`omacom/omarchy`, branch `quattro`)

- `default/agents/skills/diagnose-crash/SKILL.md`
  <https://github.com/omacom/omarchy/blob/quattro/default/agents/skills/diagnose-crash/SKILL.md>
  — evidence-first crash analysis: `coredumpctl info/list`, OOM check, timeline
  correlation, whole-core read, debuginfod symbolization, 4-point report, mute offer.
- `default/agents/skills/diagnose-crash/reporting.md`
  <https://github.com/omacom/omarchy/blob/quattro/default/agents/skills/diagnose-crash/reporting.md>
  — strict upstream rules: Omarchy's sphere of control, 3 filing conditions,
  search incl. closed issues, comment-vs-file, `gh` commands, signing.
- `default/agents/skills/omarchy/` (SKILL.md + topic guides)
  <https://github.com/omacom/omarchy/tree/quattro/default/agents/skills/omarchy>
  — end-user customization skill. Topic guides this triage leans on:
  `capture.md` (screenshots/recordings/OCR), `hyprland.md` (compositor config),
  `theming.md`, `hooks.md`, `plugins.md` (stock-vs-custom isolation),
  `contributing.md` (upstream contribution path).

## Omarchy project links (for routing)

- Discord: <https://omarchy.org/discord> (`#omarchy-help` forum)
- Repo: <https://github.com/omacom/omarchy>
- Discussions: <https://github.com/omacom/omarchy/discussions>
