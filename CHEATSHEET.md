<h1 align="center">Keymap Cheatsheet</h1>

<p align="center">
  Pure lazy.nvim + native <code>vim.*</code> config &nbsp;·&nbsp; Leader <kbd>Space</kbd> &nbsp;·&nbsp; Localleader <kbd>,</kbd>
</p>

> **Tip:** `<Leader>fk` searches every keymap live (picker), and **which-key** pops up automatically when you hold a prefix (e.g. `<Leader>f`). Descriptions below are the config's own (mixed Korean/English is intentional).

Mode annotations mark non-normal maps: `(x)` visual/select, `(o)` operator-pending, `(i)` insert, `(t)` terminal. Unmarked = normal.

---

## Editing & Registers

Register discipline: `y`→inner reg `i`, `d`→delete reg `d`, `Y`/`·s` family→system clipboard `+`, `x`/`c`→blackhole. Plain `p`/`P`/`s` are disabled — paste explicitly with `p{i,d,s}`.

### Yank / Delete / Change

| Key | Action |
| --- | --- |
| `y` | yank into inner reg `i` (motion) |
| `yy` | yank line into inner reg |
| `Y` | yank into system clipboard `+` |
| `Yy` / `YY` | yank line into system clipboard |
| `d` | delete into del reg `d` |
| `dd` | delete line into del reg |
| `x` | delete char to blackhole |
| `c` | change to blackhole |
| `s` | disabled (`<Nop>`) |
| `<Leader>c` | 단어 편집 — change inner word (blackhole) |
| `<Leader>x` | 단어 제거 (inner reg) — cut word |
| `<Leader>d` | 단어 제거 (del reg) — delete word |

### Paste

| Key | Action |
| --- | --- |
| `pi` / `Pi` | paste from inner reg `i` (after / before) |
| `pd` / `Pd` | paste from del reg `d` |
| `ps` / `Ps` | paste from system clipboard `+` |
| `p` / `P` | disabled (`<Nop>`) — use the above |
| `<Leader>pi` | replace word with inner-reg content |
| `<Leader>pd` | replace word with del-reg content |
| `<Leader>ps` | replace word with system-clipboard content |

### Lines & Misc

| Key | Action |
| --- | --- |
| `<Leader>o` / `<Leader>O` | 아래/위로 한줄 띄기 — blank line below / above |
| `<Leader><CR>` | 현재 커서 위치에서 줄바꿈 — split line at cursor |
| `]<Space>` / `[<Space>` | add empty line below / above cursor |
| `<C-a>` | 전체 선택 — select all |
| `<Leader>y` | Surround word (`ysiw`) |
| `jk` / `jj` (i) | escape to normal mode |

---

## Motion & Navigation

| Key | Action |
| --- | --- |
| `(` / `)` | 7줄 위/아래로 — jump 7 lines up / down |
| `j` / `k` | smart down/up (`gj`/`gk` when no count) |
| `H` / `L` | 오타 방지 — same as `h` / `l` (typo guard) |
| `<C-p>` | jumplist back (`<C-o>`) |
| `<C-n>` | jumplist forward (`<C-i>`) |
| `<C-o>` | disabled (use `<C-p>`) |
| `<C-h/j/k/l>` | move to left/below/above/right split (smart-splits) |
| `<C-Left/Down/Up/Right>` | resize split |
| `]t` / `[t` | next / previous tab |
| `]r` / `[r` | next / previous reference (snacks words) |
| `gx` | open filepath/URI under cursor with system handler |

### Node selection (treesitter)

| Key | Action |
| --- | --- |
| `an` (x/o) | select parent (outer) node |
| `in` (x/o) | select child (inner) node |
| `]n` / `[n` (x) | select next / previous node |
| `]N` / `[N` (x) | select next / previous sibling node |

---

## Buffers

| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | next / previous buffer |
| `]b` / `[b` | next / previous buffer |
| `>b` / `<b` | move buffer tab right / left |
| `<Leader>bp` | pick buffer (BufferLinePick) |
| `<Leader>bc` | close all buffers except current |
| `<Leader>bl` | close all buffers to the left |
| `<Leader>br` | close all buffers to the right |
| `<Leader>bse` | sort by extension |
| `<Leader>bsp` | sort by directory |
| `<Leader>bsr` | sort by relative directory |

---

## Windows

| Key | Action |
| --- | --- |
| `<Leader>\` | 세로 분할 — vertical split |
| `<Leader>-` | 가로 분할 — horizontal split |
| `<Leader>=` | 분할창 순서 변경 — swap split layout |
| `<Leader>w` | close current window's buffer (per-pane) |
| `<Leader>m` | maximize / equalize window |
| `<C-h/j/k/l>` | navigate splits (smart-splits) |
| `<C-Left/Down/Up/Right>` | resize split |

---

## Find / Picker

`<Leader>f*` uses Snacks picker (GrugFar / Namu where noted).

| Key | Action |
| --- | --- |
| `<Leader>ff` | Find files |
| `<Leader>fF` | Find all files |
| `<Leader>fg` | Find git files |
| `<Leader>fa` | Find config files |
| `<Leader>fz` | Find directories |
| `<Leader>fc` | Find word under cursor |
| `<Leader>f/` | Find words (grep) |
| `<Leader>f?` | Find words (숨김파일포함 — incl. hidden) |
| `<Leader>fl` | Find lines (buffer) |
| `<Leader>fe` | Find history in CWD |
| `<Leader>fE` | Find history (all paths) |
| `<Leader>f<CR>` | Resume previous search |
| `<Leader>fh` | Find help |
| `<Leader>fm` | Find man pages |
| `<Leader>fk` | Find keymaps |
| `<Leader>fC` | Find commands |
| `<Leader>f'` | Find registers |
| `<Leader>f\`` | Find marks |
| `<Leader>fp` | Find projects |
| `<Leader>fn` | Find notifications |
| `<Leader>ft` | Find todos |
| `<Leader>fy` | Find yanks (also `(x)`) |
| `<Leader>fu` | Find undo history |
| `<Leader>fr` | Find and Replace (GrugFar) |
| `<Leader>fs` | Search symbols (Namu) |
| `<Leader>fS` | Search symbols (Snacks) |
| `<Leader>fd` | Search diagnostics (buffer, LSP-attached) |

### `s` submenu (Trouble / Yazi / outline)

| Key | Action |
| --- | --- |
| `s` | disabled prefix (`<Nop>`) |
| `sq` | Quickfix (Trouble) |
| `sd` | Diagnostics (Trouble) |
| `sD` | Buffer Diagnostics (Trouble) |
| `sh` | Symbols outline (Hierarchy) |
| `su` | Find undo |
| `sy` | Find yanks |
| `sf` | Yazi (current file) |
| `sF` | Yazi (cwd) |
| `sw` | Wrapped (nvim stats) |
| `fd` | Search diagnostics |

---

## Git

### Global pickers (`<Leader>g*`)

| Key | Action |
| --- | --- |
| `<Leader>gt` | Git status |
| `<Leader>gb` | Git branches |
| `<Leader>gc` | Git commits (repository) |
| `<Leader>gC` | Git commits (current file) |
| `<Leader>gT` | Git stash |
| `<Leader>go` | Git browse / open (also `(x)`) |

### Gitsigns (buffer-local)

| Key | Action |
| --- | --- |
| `<Leader>gs` | stage / unstage hunk (`(x)` stage hunk) |
| `<Leader>gr` | reset hunk (`(x)` reset hunk) |
| `<Leader>gS` | stage buffer |
| `<Leader>gR` | reset buffer |
| `<Leader>gp` | preview hunk |
| `<Leader>gl` | view Git blame (line) |
| `<Leader>gL` | view full Git blame |
| `<Leader>gd` | view Git diff |
| `]g` / `[g` | next / previous hunk |
| `]G` / `[G` | last / first hunk |
| `ig` (x/o) | inside Git hunk (text object) |

---

## LSP

Buffer-local, set on `LspAttach` (gated by client capability).

| Key | Action |
| --- | --- |
| `gd` | go to definition |
| `gD` | go to declaration |
| `gy` | go to type definition |
| `gK` | signature help |
| `gO` | document symbols |
| `K` | hover (native `vim.lsp.buf.hover`) |
| `<C-s>` (i/x/s) | signature help |
| `;a` (n/x) | code action |
| `;r` | rename (IncRename) |
| `;f` (n/x) | format buffer |
| `<Leader>g'` | go to declaration |
| `<Leader>lh` | signature help |
| `<Leader>lG` | search workspace symbols |
| `<Leader>lA` | source action |
| `<Leader>ll` | CodeLens refresh |
| `<Leader>lL` | CodeLens run |
| `<Leader>li` | LSP information (checkhealth) |
| `<Leader>lc` | Conform information |
| `<>` (i) | JSX: expand to `<></>` (jsx/tsx buffers) |
| `sp` | toggle Markdown Preview (markdown buffers) |

---

## Diagnostics

| Key | Action |
| --- | --- |
| `gl` | hover diagnostics (float) |
| `<Leader>ld` | hover diagnostics (float) |
| `]e` / `[e` | next / previous error |
| `]w` / `[w` | next / previous warning |
| `]d` / `[d` | next / previous diagnostic |
| `]D` / `[D` | last / first diagnostic in buffer |
| `<Leader>fd` | search diagnostics (picker) |
| `sd` / `sD` | diagnostics / buffer diagnostics (Trouble) |
| `<Leader>ud` | toggle diagnostics |
| `<Leader>uv` / `<Leader>uV` | toggle virtual text / virtual lines |

---

## Treesitter Text Objects

Buffer-local per filetype (only mapped where the parser provides the capture).

### Select — `(x)` visual, `(o)` operator-pending

| Key | Text object |
| --- | --- |
| `ak` / `ik` | around / inside block |
| `ac` / `ic` | around / inside class |
| `af` / `if` | around / inside function |
| `ao` / `io` | around / inside loop |
| `aa` / `ia` | around / inside argument |
| `a?` / `i?` | around / inside conditional |

### Move (normal / `(x)` / `(o)`)

| Key | Action |
| --- | --- |
| `]k` / `[k` | next / previous block start |
| `]K` / `[K` | next / previous block end |
| `]f` / `[f` | next / previous function start |
| `]F` / `[F` | next / previous function end |
| `]a` / `[a` | next / previous argument start |
| `]A` / `[A` | next / previous argument end |

### Swap (normal)

| Key | Action |
| --- | --- |
| `>K` / `<K` | swap next / previous block |
| `>F` / `<F` | swap next / previous function |
| `>A` / `<A` | swap next / previous argument |

---

## Debugger & Tasks (localleader `,`)

### DAP (`<Leader>,*` + F-keys)

| Key | F-key | Action |
| --- | --- | --- |
| `<Leader>,c` | `<F5>` | start / continue |
| `<Leader>,q` | — | close session |
| `<Leader>,Q` | `<S-F5>` | terminate session |
| `<Leader>,b` | `<F9>` | toggle breakpoint |
| `<Leader>,B` | — | clear breakpoints |
| `<Leader>,C` | `<S-F9>` | conditional breakpoint |
| `<Leader>,o` | `<F10>` | step over |
| `<Leader>,i` | `<F11>` | step into |
| `<Leader>,O` | `<S-F11>` | step out |
| `<Leader>,r` | `<C-F5>` | restart |
| `<Leader>,p` | `<F6>` | pause |
| `<Leader>,s` | — | run to cursor |
| `<Leader>,R` | — | toggle REPL |
| `<Leader>,u` | — | toggle Debugger UI |

### Overseer tasks

| Key | Action |
| --- | --- |
| `<Leader>,t` | run task |
| `<Leader>,T` | toggle task list |
| `<Leader>,l` | restart last task |
| `<Leader>,!` | run shell command |

---

## AI (Claude Code)

| Key | Action |
| --- | --- |
| `<Leader>ab` | add buffer to Claude |
| `<Leader>as` (x) | send selection to Claude Code |
| `<Leader>aa` | accept diff |
| `<Leader>ad` | deny diff |
| `<Leader>am` | select model |
| `<Leader>ar` | resume Claude |

---

## Terminal

| Key | Action |
| --- | --- |
| `<Leader>t-` | terminal horizontal split |
| `<Leader>t\` | terminal vertical split |
| `<C-h/j/k/l>` (t) | navigate windows from terminal |
| `<C-w>` (t) | window command prefix |

---

## Session (persistence)

| Key | Action |
| --- | --- |
| `<Leader>ss` | load current-dir session |
| `<Leader>sl` | select session |
| `<Leader>sd` | stop session tracking |

---

## UI Toggles (`<Leader>u*`)

| Key | Action |
| --- | --- |
| `<Leader>ub` | toggle background (light/dark) |
| `<Leader>un` | change line numbering |
| `<Leader>uw` | toggle wrap |
| `<Leader>us` | toggle spellcheck |
| `<Leader>uS` | toggle conceal |
| `<Leader>ug` | toggle signcolumn |
| `<Leader>u>` | toggle foldcolumn |
| `<Leader>u\|` | toggle indent guides |
| `<Leader>ui` | change indent setting |
| `<Leader>ul` | toggle statusline |
| `<Leader>ut` | toggle tabline |
| `<Leader>uy` | toggle syntax highlight (buffer) |
| `<Leader>uz` | toggle color highlight |
| `<Leader>uZ` | toggle zen mode |
| `<Leader>ud` | toggle diagnostics |
| `<Leader>uv` | toggle virtual text |
| `<Leader>uV` | toggle virtual lines |
| `<Leader>ur` | toggle reference highlighting |
| `<Leader>uc` / `<Leader>uC` | toggle autocompletion (buffer / global) |
| `<Leader>uf` / `<Leader>uF` | toggle autoformatting (buffer / global) |
| `<Leader>uh` / `<Leader>uH` | toggle LSP inlay hints (buffer / global) |
| `<Leader>uY` | toggle LSP semantic highlight (buffer) |
| `<Leader>uL` | toggle CodeLens |
| `<Leader>uA` | toggle Autosave |
| `<Leader>uN` | toggle notifications |
| `<Leader>uD` | dismiss notifications |

---

## Refactor (`<Leader>r*`, refactoring.nvim)

| Key | Action |
| --- | --- |
| `<Leader>rr` (x) | select refactor (menu) |
| `<Leader>rb` | extract function (`(x)` extract) |
| `<Leader>rbf` | extract function to file |
| `<Leader>re` (x) | extract function |
| `<Leader>rf` (x) | extract function to file |
| `<Leader>rv` (x) | extract variable |
| `<Leader>ri` | inline variable |
| `<Leader>rp` | debug: print location (`(x)` print expression) |
| `<Leader>rd` | debug: print variable |
| `<Leader>rc` | debug: clean up |

---

## Plugin Manager (`<Leader>'*`)

| Key | Action |
| --- | --- |
| `<Leader>'i` | Lazy install |
| `<Leader>'s` | Lazy status (home) |
| `<Leader>'S` | Lazy sync |
| `<Leader>'u` | Lazy check updates |
| `<Leader>'U` | Lazy update |
| `<Leader>'m` | Mason installer |
| `<Leader>'M` | Mason tools update |
| `<Leader>'a` | update Lazy and Mason |

---

## Multicursor

| Key | Action |
| --- | --- |
| `mm` | start multicursor (also `(x)`) |
| `m/` | multicursor search (also `(x)`) |

---

## Visual Mode

| Key | Action |
| --- | --- |
| `J` / `K` | 한줄 아래로/위로 — move selection down / up |
| `<` / `>` | indent left / right (keep selection) |
| `<Tab>` / `<S-Tab>` | indent / unindent line |
| `mf` | block insert (앞) — before |
| `mb` | block append (뒤) — after |
| `gc` | toggle comment |
| `<Leader>/` | toggle comment |

---

## Misc

| Key | Action |
| --- | --- |
| `<Leader>q` | quit window (confirm) |
| `<Leader>Q` | exit Neovim (confirm all) |
| `<Leader>n` | new file |
| `<Leader>R` | rename file (Snacks) |
| `<Leader>e` | toggle Explorer (neo-tree) |
| `<C-s>` | force write (silent update) |
| `<C-q>` | force quit |
| `<C-w>` (t) | window command from terminal |
| `<Leader>/` | toggle comment line |
| `gcc` | toggle comment line |
| `gco` / `gcO` | add comment below / above |
| `gc` | comment (motion / `(x)` / `(o)`) |
| `K` | LSP hover |

---

### Native LSP defaults

Neovim's built-in `grr` (references), `grn` (rename), `gra` (code action), `gri` (implementation), `grt` (type definition), `grx` (CodeLens run) remain available alongside the custom LSP maps above. `K` is overridden to `vim.lsp.buf.hover`.
