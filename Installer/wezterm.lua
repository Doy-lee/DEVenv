local wezterm = require 'wezterm';

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  clink_bat = string.format("%s\\..\\binaries\\clink.bat", wezterm.executable_dir)
  default_prog = {"cmd.exe", "/s", "/k", clink_bat, "inject", "-q"}
end

return {
  font_size = 10.0,
  color_scheme = "Peppermint",
  default_prog = default_prog
}
