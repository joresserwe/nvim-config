<h1 align="center">Neovim Config</h1>

<p align="center">
  <a href="https://neovim.io"><img alt="Neovim" src="https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=flat&logo=neovim&logoColor=white" /></a>
  <a href="https://github.com/folke/lazy.nvim"><img alt="lazy.nvim" src="https://img.shields.io/badge/lazy.nvim-plugin%20manager-B7BDF8?style=flat" /></a>
  <img alt="Startup" src="https://img.shields.io/badge/startup-~50ms-F7DF1E?style=flat&logo=lightning&logoColor=black" />
  <img alt="macOS" src="https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white" />
  <img alt="WSL2" src="https://img.shields.io/badge/WSL2-4D4D4D?style=flat&logo=linux&logoColor=white" />
</p>

<p align="center">
  Personal Neovim configuration for full-stack web development.<br/>
  TypeScript/JavaScript + Java focused, AI-assisted, Korean input ready.
</p>

---

## Highlights

> **Framework-free** — pure lazy.nvim + native `vim.*` APIs. No distro, ~50ms startup.
>
> **Modular** — Drop a `.lua` file into `modules/` to add a plugin. No imports needed.
>
> **AI-native** — Claude Code IDE extension with in-editor terminal, diffs, and external wezterm panes.

<details>
<summary><strong>More features</strong></summary>

- **Native LSP** — `vim.lsp.config` / `vim.lsp.enable` + single `LspAttach` autocmd, no framework glue
- **Solarized Osaka** default + 9 alternative colorschemes, all transparent
- **Blink.cmp** completion with LSP, snippets, path, buffer, emoji sources + Copilot inline suggestions
- **Lualine + Bufferline + Dropbar** — full statusline / tabline / breadcrumb stack
- **Korean langmap** — 2-bul keyboard input without mode switching
- **Register separation** — yank, delete, cut, change each route to dedicated registers
- **Task runner** — overseer.nvim with Gradle / Spring templates

</details>

---

## Architecture

```
init.lua                leader keys -> lazy bootstrap -> core.apply (options/diagnostics)
  -> lazy_setup.lua     { import "plugins.base" } -> { import "plugins" (modules) }
  -> polish.lua         core.autocmds -> core.mappings -> lsp.setup -> highlights.setup
```

<details>
<summary><strong>Directory tree</strong></summary>

```
lsp/                       Native vim.lsp.config server settings (rtp-merged)
lua/
├── core/                  Framework-free core
│   ├── apply.lua          Options / diagnostics / commands applier
│   ├── autocmds.lua       File events, vim.t.bufs tracking, large-buf guard
│   ├── mappings.lua       Pure editing keymaps (loaded last, always wins)
│   ├── icons.lua          Shared icon table
│   ├── platform.lua       OS detection (macOS / WSL2)
│   └── winbufs.lua        Per-window buffer tracking
├── lsp/                   setup (capabilities + enable), attach (buffer maps), installer
├── highlights/            Palette resolver + ColorScheme applier
└── plugins/
    ├── base/              Per-plugin base specs (triggers, opts, default keys)
    └── modules/           User specs — auto-loaded recursively
        ├── ui/  colorscheme/  editing-support/  lsp/  utils/
```

</details>

---

## Plugins

### UI

| Plugin | Role |
|:-------|:-----|
| **lualine.nvim** | Statusline — custom bubbles theme with mode colors |
| **bufferline.nvim** | Tab-style buffer bar with LSP diagnostics |
| **dropbar.nvim** | Breadcrumb navigation (LSP + Treesitter) |
| **neo-tree.nvim** | File explorer |
| **trouble.nvim** | Diagnostics, references, quickfix |
| **snacks.picker** | Fuzzy finder |
| **snacks.dashboard** | Start screen — gradient logo, quick actions |
| **namu.nvim** | Zed-style symbol navigator |
| **outline.nvim** | Symbol outline sidebar |
| **noice.nvim** | Command line and message UI |
| **satellite.nvim** | Scrollbar with diagnostics and git signs |
| **snacks.notifier** | Notifications |
| **snacks.scroll** | Smooth scrolling |
| **smear-cursor.nvim** | Cursor trail animation |
| **nvim-colorizer.lua** | Inline color preview (CSS, Tailwind) |
| **mini.icons** | Icon provider |
| **smart-splits.nvim** | Window navigation / resize across mux panes |

### Editing

| Plugin | Role |
|:-------|:-----|
| **blink.pairs** | Auto-pairing |
| **multicursor.nvim** | Multi-cursor editing via hydra |
| **nvim-surround** | Surround operations |
| **refactoring.nvim** | Refactoring tools |
| **grug-far.nvim** | Project-wide search and replace |
| **auto-save.nvim** | Auto-save on events |
| **markview.nvim** | Markdown preview |
| **helpview.nvim** | Enhanced help viewer |

### LSP and Completion

| Plugin | Role |
|:-------|:-----|
| **blink.cmp** | Completion — LSP, snippets, path, buffer, emoji |
| **conform.nvim** | Formatter dispatcher |
| **nvim-lint** | Linter dispatcher |
| **tiny-inline-diagnostic.nvim** | Inline diagnostic display |
| **inc-rename.nvim** | Rename with preview |
| **nvim-jdtls** | Java LSP with debug / test bundles |
| **nvim-dap + dap-view** | Debugger UI |

### AI

| Plugin | Role |
|:-------|:-----|
| **claudecode.nvim** | Claude Code IDE extension — terminal, diffs, model select |
| **claude-pane** | External Claude CLI panes (wezterm / tmux) |
| **copilot.lua** | Inline suggestions, `<Tab>` accept via blink.cmp |

### Colorschemes

`solarized-osaka` (default) · `tokyonight` · `catppuccin` · `kanagawa` · `rose-pine` · `cyberdream` · `onedark` · `vscode` · `midnights`

All configured with transparent backgrounds.

### Utilities

| Plugin | Role |
|:-------|:-----|
| **which-key.nvim** | Keybinding cheatsheet |
| **persistence.nvim** | Session save / restore |
| **yanky.nvim** | Yank history with picker |
| **overseer.nvim** | Task runner — Gradle / Spring templates |
| **diffview.nvim** | Git diff viewer |
| **im-select** | Auto input method switching (macOS) |

---

## Keymaps

`<Space>` Leader / `,` Local Leader — full reference: **[EN](docs/cheatsheet.en.md)** / **[KO](docs/cheatsheet.ko.md)**

### Leader Groups

| Prefix | Category | |
|:-------|:---------|:--|
| `<Leader>a` | **AI** | Send to Claude, accept/deny diff, open pane |
| `<Leader>b` | **Buffers** | Pick, close others, sort |
| `<Leader>e` | **Explorer** | Toggle / focus Neo-tree |
| `<Leader>f` | **Find** | Files, grep, diagnostics, symbols, registers, undo |
| `<Leader>g` | **Git** | Hunks, blame, branches, commits, browse |
| `<Leader>l` | **LSP** | Code action, workspace symbols, CodeLens |
| `<Leader>r` | **Refactor** | Extract, inline, debug prints |
| `<Leader>s` | **Session** | Load, select, stop |
| `<Leader>t` | **Terminal** | Horizontal / vertical split |
| `<Leader>u` | **UI Toggle** | Diagnostics, inlay hints, wrap, spell, … |
| `<Leader>w` | **Window** | Close window's buffer (pane-scoped) |
| `<Leader>,` | **Debugger** | DAP controls |
| `<Leader>'` | **Plugins** | Lazy / Mason |

### Quick Actions

| Key | Action |
|:----|:-------|
| `;f` | Format buffer (conform) |
| `;a` | Code action |
| `;r` | Rename symbol (inc-rename) |
| `mm` | Start multicursor |
| `m/` | Multicursor search |
| `<C-a>` | Select all |

### Navigation

| Key | Action |
|:----|:-------|
| `(` / `)` | Jump 7 lines up / down |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<C-p>` / `<C-n>` | Jumplist back / forward |
| `<C-h/j/k/l>` | Move between splits (smart-splits, mux-aware) |
| `<Leader>\` / `<Leader>-` | Vertical / horizontal split |

### Register System

Operations route to dedicated registers — no more accidental overwrites.

| Operation | Register | Paste back |
|:----------|:---------|:-----------|
| `y` yank | inner `"i` | `pi` |
| `Y` yank | system `"+` | `ps` |
| `d` delete | `"d` | `pd` |
| `x` / `c` | blackhole | — |

<details>
<summary><strong>Submenu &amp; visual mode maps</strong></summary>

#### Submenu (`s` prefix)

| Key | Action |
|:----|:-------|
| `sq` | Quickfix (Trouble) |
| `sd` / `sD` | Diagnostics all / buffer |
| `su` | Undo history |
| `sh` | Symbol outline |
| `sy` | Yank history |
| `sp` | Markdown preview |

#### Visual Mode

| Key | Action |
|:----|:-------|
| `J` / `K` | Move line down / up |
| `<` / `>` | Indent / dedent (keeps selection) |
| `mf` / `mb` | Block insert at start / end of lines |

</details>

---

## LSP and Tooling

Native `vim.lsp.config` + `vim.lsp.enable` — server settings live in `lsp/*.lua`, buffer
keymaps and feature toggles in one `LspAttach` autocmd.

### Language Servers

`lua_ls` · `vtsls` · `tailwindcss` · `html` · `css` · `emmet` · `bashls` · `jsonls` · `marksman` · `stylua` · `jdtls` (nvim-jdtls)

All auto-installed via Mason.

### Formatters and Linters

| Language | Formatter | Linter |
|:---------|:----------|:-------|
| Lua | stylua | — |
| HTML | stylelint / prettierd | — |
| CSS / SCSS / LESS | stylelint / prettierd | stylelint |
| Shell | shfmt | shellcheck |
| Markdown | mdformat | — |

### Debugger

`pwa-node` via js-debug-adapter for JS/TS · `java-debug` + `java-test` bundles via jdtls.

### Defaults

| Feature | State |
|:--------|:------|
| Inlay hints | **On** |
| Semantic tokens | **On** |
| Code lens | Off |
| Format on save | Off — manual `;f` |
| Virtual text | Off — tiny-inline-diagnostic |

---

## Requirements

Neovim >= 0.12 · Git · [Nerd Font](https://www.nerdfonts.com/) · Node.js · ripgrep · fd
