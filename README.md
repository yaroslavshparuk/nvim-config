# nvim-config

A personal Neovim config — small, fast, and aimed for my needs. Built on top of `lazy.nvim`. Every plugin earns its place; nothing speculative.

## What's in it

| Concern | Plugin |
|---|---|
| Plugin manager | [`lazy.nvim`](https://github.com/folke/lazy.nvim) |
| Theme | [`catppuccin/nvim`](https://github.com/catppuccin/nvim) (mocha) |
| Syntax / parsing | [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) |
| LSP framework | [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) + [`mason.nvim`](https://github.com/williamboman/mason.nvim) + [`mason-lspconfig`](https://github.com/williamboman/mason-lspconfig.nvim) |
| C# language server | [`roslyn.nvim`](https://github.com/seblyng/roslyn.nvim) |
| Completion | [`blink.cmp`](https://github.com/saghen/blink.cmp) |
| Fuzzy finder | [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) |
| File tree | [`nvim-tree`](https://github.com/nvim-tree/nvim-tree.lua) |
| Git inline | [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) |
| Git porcelain | [`lazygit.nvim`](https://github.com/kdheepak/lazygit.nvim) (wraps the `lazygit` binary) |
| Format on save | [`conform.nvim`](https://github.com/stevearc/conform.nvim) |
| Keymap discovery | [`which-key.nvim`](https://github.com/folke/which-key.nvim) |
| Autopairs | [`mini.pairs`](https://github.com/echasnovski/mini.pairs) |
| Markdown render | [`render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim) |

Comment toggling is **not** a plugin — Neovim 0.10+ has built-in `gcc` / `gc`.

## LSP servers

Auto-installed via Mason: `angularls`, `vtsls`, `html`, `cssls`, `lua_ls`, `bashls`, `powershell_es`, `jsonls`, `yamlls`, `marksman`. C# is handled by `roslyn.nvim`.

## Formatters

Run on save via `conform.nvim`: `csharpier` (C#), `prettier` (web stack + JSON/YAML/MD), `stylua` (Lua), `shfmt` (sh).

`:FormatDisable` to turn off globally, `:FormatDisable!` for the buffer only, `:FormatEnable` to re-enable.

## Install

### Windows

```powershell
# From inside a clone of this repo:
.\bootstrap.ps1

# Or pass a remote URL to clone fresh into $env:LOCALAPPDATA\nvim:
.\bootstrap.ps1 -RepoUrl https://github.com/<you>/nvim-config.git
```

The script:
1. Installs Neovim, Git, ripgrep, fd, lazygit, and Node.js via `winget`.
2. Copies (or clones) this repo into `$env:LOCALAPPDATA\nvim`.
3. Reminds you to install a Nerd Font.

### Linux / macOS

```bash
./bootstrap.sh                                       # copy local repo
./bootstrap.sh -u https://github.com/<you>/nvim-config.git   # clone remote
./bootstrap.sh -f                                    # overwrite existing
```

Auto-detects macOS (Homebrew), Debian/Ubuntu (apt), and Arch (pacman). Falls back to a manual-install message on anything else.

### Manual install (any OS)

If you don't want to run the bootstrap:

1. Install: Neovim ≥ 0.10, Git, ripgrep, fd, lazygit, Node.js.
2. Install a Nerd Font (e.g. JetBrainsMono Nerd Font) and select it in your terminal.
3. Clone this repo into:
   - Windows: `$env:LOCALAPPDATA\nvim`
   - Linux / macOS: `~/.config/nvim`
4. Run `nvim`. lazy.nvim self-installs and pulls plugins.
5. Run `:Mason` once to let LSPs and formatters install.
6. `:checkhealth` to verify.

## Keymaps

Leader is `<Space>`. Pause after `<leader>` to see the which-key popup.

| Key | Action |
|---|---|
| `<leader>w` / `<leader>q` | Save / quit |
| `<leader>e` / `<leader>E` | Toggle file tree / reveal current file |
| `<leader><leader>` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fs` / `<leader>fS` | Document / workspace LSP symbols |
| `<leader>fr` | Recent files |
| `<leader>fd` | Diagnostics |
| `<leader>/` | Fuzzy search current buffer |
| `<leader>gg` / `<leader>gf` | LazyGit / LazyGit current file |
| `<leader>gs` / `<leader>gr` | Stage hunk / reset hunk |
| `<leader>gp` / `<leader>gb` | Preview hunk / blame line |
| `<leader>gd` | Diff this |
| `[c` / `]c` | Prev / next git hunk |
| `<leader>cr` / `<leader>ca` | LSP rename / code action |
| `<leader>cf` | Format buffer |
| `gd` / `gr` / `K` | LSP definition / references / hover |
| `[d` / `]d` | Prev / next diagnostic |
| `<C-h/j/k/l>` | Switch window |
| `<Esc><Esc>` | Leave terminal insert mode |

## Layout

```
init.lua                        entry point
lua/
  core/
    options.lua                 vim.opt
    keymaps.lua                 leader, motions, windows
    autocmds.lua                yank highlight, trim trailing ws, reopen at last cursor
  plugins/
    init.lua                    lazy.nvim bootstrap + spec list
    theme.lua                   catppuccin
    treesitter.lua
    lsp.lua                     mason + lspconfig + on_attach keymaps
    roslyn.lua                  C# language server
    completion.lua              blink.cmp
    telescope.lua
    nvim-tree.lua
    git.lua                     gitsigns + lazygit
    format.lua                  conform.nvim
    ui.lua                      which-key + render-markdown
    editing.lua                 mini.pairs
bootstrap.ps1                   Windows fresh-machine installer
bootstrap.sh                    Linux / macOS fresh-machine installer
```

## Notes

- **Roslyn for C#**: `roslyn.nvim` will prompt to install the Roslyn binary on first `.cs` file open; follow its instructions.
- **PowerShell on Windows**: `options.lua` sets `pwsh.exe` as the default shell so `:term` and lazygit feel native.
- **Disable autoformat for one save**: `:noa w` (writes without autocmds, hence without conform).
