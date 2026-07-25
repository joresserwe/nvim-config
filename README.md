# Neovim Config

Personal Neovim configuration on plain lazy.nvim and native APIs (Neovim 0.12+).
One repo serves macOS and WSL2 Ubuntu — OS differences are branched inline via
`core/platform.lua`, with a single shared `lazy-lock.json`.
Focused on TypeScript/JavaScript and Java, with Korean input support.

## 📁 Layout

```
init.lua              leader keys -> lazy.nvim bootstrap -> core.apply -> lazy_setup -> polish
lsp/                  native vim.lsp.config server settings (rtp-merged)
lua/core/             framework-free core: options, autocmds, mappings, platform, icons
lua/lsp/              setup (capabilities + enable list), attach (buffer keymaps), installer
lua/highlights/       palette resolver, applied on ColorScheme
lua/plugins/base/     per-plugin base specs (triggers, default opts and keys)
lua/plugins/modules/  user specs, auto-registered by recursive directory scan
```

Adding a plugin means dropping a spec file under `lua/plugins/modules/`.
Base and module specs for the same plugin are merged by lazy.nvim; module specs win.

## 🪶 Light profile

When `~/.local/state/dotfiles/profile` contains `light` (written by the dotfiles
installer on machines without a GPU, e.g. a Citrix VDI), the config trades polish
for input latency:

| Area | full | light |
|:-----|:-----|:------|
| `jk` escape window (better-escape) | 300ms | 600ms |
| Completion menu treesitter highlight | on | off |
| Breadcrumbs (dropbar) | on | off |
| vtsls completion entries | unlimited | 100 |
| Insert-mode plugins (blink, copilot, ...) | load on InsertEnter | pre-warmed at idle |

## 🔌 Plugins

### UI

| Plugin | Role |
|:-------|:-----|
| lualine.nvim | Statusline, custom bubbles theme |
| bufferline.nvim | Buffer tabline with LSP diagnostics |
| dropbar.nvim | Breadcrumbs (LSP + treesitter), disabled on light |
| neo-tree.nvim | File explorer |
| trouble.nvim | Diagnostics, references, quickfix lists |
| snacks.nvim | Dashboard, picker, notifier, indent guides, words, zen |
| namu.nvim | Symbol navigator |
| outline.nvim | Symbol outline sidebar |
| noice.nvim | Command line and message UI |
| satellite.nvim | Scrollbar with diagnostics and git marks |
| nvim-colorizer.lua | Inline color preview |
| mini.icons | Icon provider |
| smart-splits.nvim | Window navigation and resize across mux panes |

### Editing

| Plugin | Role |
|:-------|:-----|
| blink.pairs | Auto-pairing |
| multicursor.nvim | Multiple cursors (`m` prefix keymaps) |
| nvim-surround | Surround operations |
| grug-far.nvim | Project-wide search and replace |
| auto-save.nvim | Save on events |
| markview.nvim | In-editor markdown rendering |
| live-preview.nvim | Markdown browser preview (`sp`) |
| helpview.nvim | Enhanced help viewer |

### LSP and completion

| Plugin | Role |
|:-------|:-----|
| blink.cmp | Completion: LSP, path, snippets (LuaSnip), buffer, emoji |
| conform.nvim | Formatter dispatcher (`;f`) |
| nvim-lint | Linter dispatcher |
| tiny-inline-diagnostic.nvim | Inline diagnostic display |
| inc-rename.nvim | Rename with live preview |
| nvim-jdtls | Java LSP with debug and test bundles |
| nvim-dap + nvim-dap-view | Debugger UI |

### AI

| Plugin | Role |
|:-------|:-----|
| claudecode.nvim | Claude Code IDE integration: terminal, diffs |
| claude-pane (custom) | External Claude CLI panes over wezterm/tmux |
| copilot.lua | Inline suggestions, `<Tab>` accept via blink.cmp |

### Colorschemes

`solarized-osaka` (default), plus catppuccin, cyberdream, everforest, github,
grayveil, gruvbox, guts, kanagawa, melange, midnights, nightfox, nordic, onedark,
oxocarbon, rose-pine, tokyonight, vague, vscode. All transparent.

### Utilities

| Plugin | Role |
|:-------|:-----|
| which-key.nvim | Keybinding cheatsheet |
| persistence.nvim | Session save and restore |
| yanky.nvim | Yank history with picker |
| overseer.nvim | Task runner, Gradle/Spring templates |
| diffview.nvim | Git diff viewer |
| im-select | Input method auto-switching (macOS) |

## ⌨️ Keymaps

Leader `<Space>`, local leader `,`.
Full reference: [EN](docs/cheatsheet.en.md) / [KO](docs/cheatsheet.ko.md)

### Leader groups

| Prefix | Category |
|:-------|:---------|
| `<Leader>a` | AI: send to Claude, accept/deny diff, open pane |
| `<Leader>b` | Buffers: pick, close others, sort |
| `<Leader>e` | Explorer: toggle / focus Neo-tree |
| `<Leader>f` | Find: files, grep, diagnostics, symbols, registers |
| `<Leader>g` | Git: hunks, blame, branches, commits |
| `<Leader>l` | LSP: code action, workspace symbols, CodeLens |
| `<Leader>s` | Session: load, select, stop |
| `<Leader>t` | Terminal: horizontal / vertical split |
| `<Leader>u` | UI toggles: diagnostics, inlay hints, wrap, spell |
| `<Leader>w` | Window: close window's buffer (pane-scoped) |
| `<Leader>,` | Debugger (DAP) |
| `<Leader>'` | Plugin managers (Lazy / Mason) |

### Quick actions

| Key | Action |
|:----|:-------|
| `;f` | Format buffer (conform) |
| `;a` | Code action |
| `;r` | Rename symbol (inc-rename) |
| `mm` / `mM` | Add cursor at next / previous match |
| `m*` | Add cursors to all matches |
| `m/` | Add cursors to all search results |
| `mj` / `mk` | Add cursor below / above |
| `<Esc>` | Clear cursors (when multicursor active) |
| `<C-a>` | Select all |

### Navigation

| Key | Action |
|:----|:-------|
| `(` / `)` | Jump 7 lines up / down |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<C-p>` / `<C-n>` | Jumplist back / forward |
| `<C-h/j/k/l>` | Move between splits (mux-aware) |
| `<Leader>\` / `<Leader>-` | Vertical / horizontal split |

### Register routing

Operations route to dedicated registers instead of clobbering `"` :

| Operation | Register | Paste back |
|:----------|:---------|:-----------|
| `y` yank | inner `"i` | `pi` |
| `Y` yank | system `"+` | `ps` |
| `d` delete | `"d` | `pd` |
| `x` / `c` | blackhole | — |

### Submenu (`s` prefix)

| Key | Action |
|:----|:-------|
| `sq` | Quickfix (Trouble) |
| `sd` / `sD` | Diagnostics all / buffer |
| `su` | Undo history |
| `sh` | Symbol outline |
| `sy` | Yank history |
| `sp` | Markdown browser preview |

### Visual mode

| Key | Action |
|:----|:-------|
| `J` / `K` | Move line down / up |
| `<` / `>` | Indent / dedent, keeps selection |
| `mf` / `mb` | Block insert at start / end of lines |

## 🛠️ LSP and tooling

Server settings live in `lsp/*.lua` (native `vim.lsp.config` rtp merge); buffer
keymaps and feature toggles in a single `LspAttach` autocmd (`lua/lsp/attach.lua`).
Servers and tools are auto-installed via Mason.

Language servers: `lua_ls`, `vtsls`, `tailwindcss`, `html`, `cssls`, `emmet_ls`,
`bashls`, `jsonls`, `marksman`, `stylua`, `jdtls` (nvim-jdtls).
tailwindcss only attaches when a tailwind/postcss config or dependency is present.

| Language | Formatter | Linter |
|:---------|:----------|:-------|
| Lua | stylua | — |
| HTML | stylelint / prettierd | — |
| CSS / SCSS / LESS | stylelint / prettierd | stylelint |
| Shell | shfmt | shellcheck |
| Markdown | mdformat | — |

Debugger: `pwa-node` (js-debug-adapter) for JS/TS, `java-debug` + `java-test` via jdtls.

| Feature | State |
|:--------|:------|
| Inlay hints | on |
| Semantic tokens | on |
| Code lens | off |
| Format on save | off, manual `;f` |
| Diagnostic virtual text | off, tiny-inline-diagnostic instead |

## 📦 Requirements

Neovim 0.12+, git, a Nerd Font, Node.js (copilot), ripgrep, fd
