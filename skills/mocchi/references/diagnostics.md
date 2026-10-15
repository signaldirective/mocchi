# Diagnostics: minimum sufficient evidence

Read-only by default. Group: base set always, then one symptom group.
Full command table is Appendix A / log map Appendix B of the getting-help guide.

## Base (every report)

```bash
omarchy version          # exact version, never "latest"
uname -r                 # kernel
inxi -Farz               # CPU/GPU/RAM/disks/network (or fastfetch for overview)
```

One-command report (most useful attachment):

```bash
# Interactive: offers upload to logs.omarchy.org (24h expiry) or save to ./omarchy-debug.log
omarchy debug
# Scripted / non-interactive: never hang on sudo
omarchy debug --no-sudo --print   # also writes /tmp/omarchy-debug.log
```

Contains: date/hostname/version, `inxi -Farz`, `journalctl -b -p 4..1`,
package list incl. AUR. Skim for hostname/secrets before posting.
No `omarchy` binary (plain Arch/CachyOS)? Use `inxi -Farz` + `uname -r` +
`journalctl -b -p 3` directly.

## General journal (time-box it)

```bash
journalctl -b -p 3                 # errors, current boot
journalctl -b -p 4..1              # warnings + errors
journalctl --since "10 min ago"    # window around the problem (preferred)
journalctl -u <unit>               # system service
journalctl --user -u <unit>        # user service
journalctl -f                      # follow live, then reproduce
journalctl -k -b                   # kernel / dmesg equivalent
```

## Symptom groups (pick what applies)

- **Display / GPU / suspend / monitors:**
  `lspci -nnk | grep -A3 -iE 'vga|3d|display'`, `hyprctl version`,
  `hyprctl monitors`, `hyprctl configerrors`, `lsusb` (docks/dongles).
  Hyprland log: `$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log`.
- **Shell / bar (Quickshell):** `journalctl --user -b -p 4..1 | grep -iE 'qs|quickshell|omarchy'`,
  then `omarchy restart shell` and re-check. Obvious fixes to try + note:
  reboot, `omarchy update`, `hyprctl reload` + `configerrors`, revert recent
  theme/hook/plugin change.
- **Audio:** `wpctl status` (sinks), user units `pipewire pipewire-pulse wireplumber`.
- **Crash / disappeared process:** `coredumpctl list` (one-off vs pattern),
  `coredumpctl info <pid>` (command line = what it was doing, timestamp),
  `free -h` + journal for OOM kills (OOM ≠ app bug). Correlate timestamp vs
  file mtimes, journal around that second, recent updates. Read all threads,
  not just frame 0 (in-flight work: thumbnailers, loaders, IPC, GPU queues);
  flag in-process third-party code only with evidence. Symbolize when possible:
  ```bash
  core=$(mktemp -t crash-XXXXXX.core); trap 'rm -f "$core"' EXIT
  coredumpctl dump <pid> --output="$core"
  DEBUGINFOD_URLS="https://debuginfod.archlinux.org" gdb -q <executable> "$core" \
    -batch -ex 'set debuginfod enabled on' -ex 'bt'
  ```
  Delete the core when done. Unresolved frames: say so, describe library-level shape.
- **Update failures:** `omarchy update analyze logs`.
- **Screenrecord failures:** `OMARCHY_SCREENRECORD_DEBUG=true omarchy screenrecord --fullscreen`,
  reproduce, `omarchy screenrecord --stop-recording`, attach `/tmp/omarchy-screenrecord.log`.
- **Visual bugs:** short focused capture beats long video; shrink with
  `omarchy transcode <input>`. Text errors: paste text (code block), never
  screenshot text; OCR pixels-only dialogs with `omarchy capture text`.

## Privacy

Redact tokens, API keys, emails, MACs, IPs, serials, personal paths.
Keep technical structure so the log stays useful.
