import QtQuick
import qs.Commons
import qs.Ui

// Mocchi: one quiet bar icon. Click it and `scripts/mocchi-ask` opens
// Omarchy's native input box, then hands the answer to your coding agent.
//
// The widget holds no state and starts no service. It launches two sibling
// helpers: `mocchi-start` once when the shell mounts it — which links the
// bundled skill and may greet the user — and `mocchi-ask` when clicked. The
// helpers own all the logic, so the keybinding and the Omarchy menu entry
// behave the same way.
//
// Helpers run through Util.execDetached rather than bar.run: the first call
// fires from Component.onCompleted, before the host has injected `bar`.
BarWidget {
  id: root
  moduleName: "io.github.signaldirective.mocchi"

  function helperPath(name) {
    return Qt.resolvedUrl("scripts/" + name).toString().replace(/^file:\/\//, "")
  }

  // Quote every argument: a home directory with spaces must survive the login
  // shell. `bash` is named explicitly so a checkout that lost the executable
  // bit (a plain copy, a git mode slip) still runs.
  function runHelper(name, args) {
    var command = "bash " + Util.shellQuote(helperPath(name))
    for (var i = 0; i < args.length; i++)
      command += " " + Util.shellQuote(args[i])
    Util.execDetached(command)
  }

  readonly property string iconGlyph: setting("icon", "\uf075")
  readonly property string hoverText: setting("tooltip", "Ask mocchi")
  readonly property string greeting: setting("greeting", "on-restart")
  readonly property string skillWiring: setting("skill", "auto")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function ask() {
    runHelper("mocchi-ask", [])
  }

  // Fires on every shell start (and once per plugin hot-reload). mocchi-start
  // re-checks the skill link, then decides whether it is time to say hello.
  Component.onCompleted: runHelper("mocchi-start", [greeting, skillWiring])

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
