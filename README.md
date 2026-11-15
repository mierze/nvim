# Portable Neovim

The editor configuration, plugins, parsers, tools and state live under this
checkout. The launcher gives this installation its own Neovim profile. Your
normal `nvim` command continues to use its existing configuration.

Install Git, curl, and Python 3.10 or later. Tree-sitter grammars also need the
Tree-sitter CLI and a C compiler. Use `--skip-parsers` to try the editor before
installing those prerequisites.

| | macOS / Linux | Windows PowerShell |
| --- | --- | --- |
| Install | `./install.sh` | `./install.ps1` |
| Open a file | `./install.sh run file.lua` | `./install.ps1 run file.lua` |
| Update | `./install.sh update` | `./install.ps1 update` |
| Check | `./install.sh check` | `./install.ps1 check` |

Install downloads the latest stable Neovim from its GitHub release and verifies
the asset checksum. Bundled builds cover Intel and ARM Macs, x86-64 and ARM64
Linux, and x64 Windows when upstream has a matching asset. Use `install --system`
to reuse Neovim 0.12 or newer from PATH. Use `update --system` to update plugins
and parsers only. The launcher prefers a bundled binary if one exists.

Plugin sources are listed in `plugins.json`. Missing checkouts are cloned from
current upstream branches and updates use fast-forward pulls. Launching the
editor performs no updates. The previous bundled editor is retained in
`.local/neovim.previous`. Plugin updates are applied one at a time. If an update
stops, fix the reported issue and rerun it.

Copy `local.example.lua` to `local.lua` to set workspace, project and vault
paths, pinned marks, or extra executable directories. Put optional tools in
`.local/tools/bin` or install them on PATH. `check` reports missing formatters,
language servers and search tools. These are currently installed separately.
The existing Mac mappings carry over. Use `:AerialToggle`, `:Oil` and
`:Pick files` on terminals that cannot send the Mac Command combinations.

Git tracks the Lua configuration, plugin sources and installer. `local.lua`
and everything in `.local/` are ignored, including parsers, histories, Harpoon
lists and logs. The old Paragon theme is omitted because its setup and
colorscheme calls are commented out. The old Lazy and mini.deps caches are not
needed. The existing configuration, plugin tree and marks database are left in
place during installation.
