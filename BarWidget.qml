import QtQuick
import qs.Commons
import qs.Ui

// Mocchi: one quiet bar icon. Click it and `scripts/mocchi-ask` opens
// Omarchy's native input box, then hands the answer to your coding agent.
//
// The widget holds no state and starts no service. It launches two sibling
// helpers: `mocchi-greet` once when the shell mounts it (so a new user notices
// the icon), and `mocchi-ask` when clicked. The helpers own all the logic, so
// the keybinding and the Omarchy menu entry behave the same way.
//
// Both helpers run through Util.execDetached rather than bar.run: the greeting
// fires from Component.onCompleted, before the host has injected `bar`.
BarWidget {
  id: root
  moduleName: "io.github.signaldirective.mocchi"

  function helperPath(name) {
    return Qt.resolvedUrl("scripts/" + name).toString().replace(/^file:\/\//, "")
  }

  // Quote a path so a home directory with spaces survives the login shell, and
  // invoke through `bash` explicitly so a checkout that lost the executable bit
  // (a plain copy, a git mode slip) still runs instead of silently doing nothing.
  function runHelper(name, argument) {
    var command = "bash " + Util.shellQuote(helperPath(name))
    if (argument !== undefined) command += " " + Util.shellQuote(argument)
    Util.execDetached(command)
  }

  readonly property string iconGlyph: setting("icon", "\uf075")
  readonly property string hoverText: setting("tooltip", "Ask mocchi")
  readonly property string greeting: setting("greeting", "on-restart")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function ask() {
    runHelper("mocchi-ask")
  }

  // Fires on every shell start (and once per plugin hot-reload); mocchi-greet
  // decides whether it is actually time to say hello.
  Component.onCompleted: {
    if (greeting !== "off") runHelper("mocchi-greet", greeting)
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.iconGlyph
    tooltipText: root.hoverText

    onPressed: function(button) {
      if (button === Qt.LeftButton) root.ask()
    }
  }
}
