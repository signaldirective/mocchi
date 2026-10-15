# Templates

Fill one, delete what doesn't apply. Titles: `<object> — <deviation>`, ≤60 chars.
No "HELP!!!", no editorializing, no prescribed fix in the title.

## Discord `#omarchy-help` post

```markdown
**Title:** <object> — <deviation> (e.g. "External monitor goes black after suspend on NVIDIA")

**What I was trying to do**
...

**What happened**
... (exact error text verbatim)

**What I expected**
...

**Steps to reproduce**
1.
2.
3.
Frequency: always / sometimes / once

**System / hardware**
- Omarchy: <`omarchy version`>
- Kernel: <`uname -r`>
- CPU / GPU: ...
- Monitors / other relevant hardware: ...

**Logs / errors**
```log
<relevant lines here>
```
Full `omarchy debug` report: <logs.omarchy.org URL or attached file>

**What I already tried**
- ...

**When it started / what changed**
...

**Extra**
Screenshot/recording: <attach>
```

Format: code fences with `bash`/`log`/`text`, short inline + full log attached,
relevant config lines/diff only, clear short sentences.

## GitHub issue (`omacom/omarchy`)

```markdown
### System details

- Omarchy: <`omarchy version`>
- Kernel: <`uname -r`>
- CPU / GPU: ...
- Relevant hardware: ...

### What's wrong?

<One-paragraph summary.>

### Steps to reproduce

1.
2.
3.

Frequency: always / sometimes / once

### Expected result

...

### Actual result

...
```log
<verbatim error output / relevant log lines>
```

### Diagnostics

- Full `omarchy debug`: <logs.omarchy.org URL> and/or attached `omarchy-debug.log`
- Relevant `journalctl` / Hyprland log lines: (above)

### Minimal reproduction

<Exact config diff, command, or file. State whether stock config/theme works.>

### Regression

- Last known good version: ...
- First known bad version: ...

### Workaround

...

### Captures

<Short recording or screenshot for visual bugs.>
```

CLI:

```bash
gh search issues --repo omacom/omarchy "external monitor suspend"
gh issue list --repo omacom/omarchy --state open --search "monitor black"
gh issue create --repo omacom/omarchy --title "..." --body-file /tmp/issue.md
gh issue view <number> --repo omacom/omarchy --comments
gh issue comment <number> --repo omacom/omarchy --body "..."
```

`gh search issues --state` accepts only `open`/`closed`; omit to search both.
