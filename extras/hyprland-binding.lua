-- Mocchi — optional keybinding.
--
-- Add this to ~/.config/hypr/bindings.lua. It runs the same helper as the bar
-- icon, so there is nothing else to configure.
--
-- SUPER + ALT + A is free in stock Omarchy and in the common community layouts
-- as of this writing. If it is taken on your machine, run
-- `omarchy menu keybindings --print`, pick a free combination, and swap it in.
o.bind(
  "SUPER + ALT + A",
  "Ask Mocchi",
  "\"$HOME/.config/omarchy/plugins/io.github.signaldirective.mocchi/scripts/mocchi-ask\""
)
