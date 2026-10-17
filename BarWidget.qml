import QtQuick
import qs.Commons
import qs.Ui

// Mocchi: one quiet bar icon. Click it and `scripts/mocchi-ask` opens
// Omarchy's native input box, then hands the answer to your coding agent.
//
// The widget holds no state and starts no service. It launches three sibling
// helpers: `mocchi-start` once when the shell mounts it — which links the
// bundled skill and may greet the user — `mocchi-ask` on a click, and
// `mocchi-greeting` from the menu below. The helpers own all the logic, so the
// keybinding and the Omarchy menu entry behave the same way.
//
// Right-click opens a small menu instead of a second action. The greeting is
// the one thing here that interrupts, so it is the thing that needs an obvious
// off switch: "not now" (this login session) and "not ever" both live one
// right-click away, where a user already looks for them.
//
// Helpers run through Util.execDetached rather than bar.run: the first call
// fires from Component.onCompleted, before the host has injected `bar`.
BarWidget {
  id: root
  moduleName: "io.github.signaldirective.mocchi"

  property bool menuOpen: false

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

  // The greeting is on unless the user has turned it off. `off` is the only
  // value that silences it here; `mocchi-greeting` owns the rest of the rules.
  readonly property bool greetingOn: greeting !== "off"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function ask() {
    runHelper("mocchi-ask", [])
  }

  function close() {
    root.menuOpen = false
  }

  // Persist one widget setting the way the clock does: the host replaces the
  // whole inline entry rather than merging it, so build the full object, apply
  // it locally (the bar redraws on the click itself), then write shell.json.
  function setGreeting(value) {
    var entry = { id: root.moduleName }
    for (var key in root.settings) if (key !== "id") entry[key] = root.settings[key]
    entry.greeting = value

    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
      root.bar.shell.updateEntryInline(root.moduleName, entry)
  }

  function hideGreetingForSession() {
    runHelper("mocchi-greeting", ["session"])
  }

  // Both halves matter. The setting is what the user sees in the bar settings
  // and what actually silences the greeting; `never` closes the toast that is
  // already on screen and leaves a marker, so the promise holds even if the
  // shell.json write is refused (a layout plugin owning the bar rewrites it).
  function disableGreeting() {
    setGreeting("off")
    runHelper("mocchi-greeting", ["never"])
  }

  function restoreGreeting() {
    setGreeting("on-restart")
    runHelper("mocchi-greeting", ["restore"])
  }

  // Fires on every shell start (and once per plugin hot-reload). mocchi-start
  // re-checks the skill link, then asks mocchi-greeting whether to say hello.
  Component.onCompleted: runHelper("mocchi-start", [greeting, skillWiring])

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.iconGlyph
    tooltipText: root.hoverText

    onPressed: function(button) {
      if (button === Qt.RightButton) root.menuOpen = !root.menuOpen
      else if (button === Qt.LeftButton) root.ask()
    }
  }

  PopupCard {
    id: menu
    anchorItem: root
    owner: root
    bar: root.bar
    open: root.menuOpen
    contentWidth: menu.fittedContentWidth(Style.space(272))
    contentHeight: menu.fittedContentHeight(menuColumn.implicitHeight)

    Column {
      id: menuColumn
      anchors.fill: parent
      spacing: Style.space(6)

      Text {
        text: "Mocchi"
        color: Color.foreground
        font.family: Style.font.family
        font.pixelSize: Style.font.body
        font.bold: true
      }

      Text {
        text: root.greetingOn
          ? "Ask your computer a question. The greeting appears on a shell start."
          : "The greeting is off."
        color: Color.muted
        font.family: Style.font.family
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
        width: parent.width
      }

      Button {
        width: parent.width
        leftAlign: true
        iconText: root.iconGlyph
        text: "Ask Mocchi"
        foreground: Color.foreground
        fontSize: Style.font.bodySmall
        onClicked: {
          root.close()
          root.ask()
        }
      }

      Button {
        visible: root.greetingOn
        width: parent.width
        leftAlign: true
        iconText: "\uf070"
        text: "Hide the greeting until I log out"
        foreground: Color.foreground
        fontSize: Style.font.bodySmall
        onClicked: {
          root.close()
          root.hideGreetingForSession()
        }
      }

      Button {
        visible: root.greetingOn
        width: parent.width
        leftAlign: true
        iconText: "\uf05e"
        text: "Don't show the greeting again"
        foreground: Color.foreground
        fontSize: Style.font.bodySmall
        onClicked: {
          root.close()
          root.disableGreeting()
        }
      }

      Button {
        visible: !root.greetingOn
        width: parent.width
        leftAlign: true
        iconText: "\uf021"
        text: "Turn the greeting back on"
        foreground: Color.foreground
        fontSize: Style.font.bodySmall
        onClicked: {
          root.close()
          root.restoreGreeting()
        }
      }
    }
  }
}
