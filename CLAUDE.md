# CLAUDE.md

Personal Neovim config on **plain lazy.nvim** + native APIs (Neovim 0.12+). Lua. (2026-07 AstroNvim에서 완전 이탈.)

**Comments: English only, and only when they earn their place** — never justification/provenance notes ("moved from…", "safe because…", "replaces old X"); that story belongs in commit messages. Keymap `desc` strings are UI text, not comments — Korean allowed there.

Runs on **macOS (native)** and **WinOS (WSL2 Ubuntu)** from a single shared repo — no `mac/`/`win/` split. OS differences are handled inline via `core/platform.lua` + `cond =` plugin gating. Single `lazy-lock.json` shared across both. OS isolation rule: a macOS-only edit must not touch WinOS-only code, and vice versa; portable changes apply to both 1:1.

Known OS/environment-sensitive files (exploration map — open these first for cross-platform work):
- `integrations/wezterm.lua` — wezterm OSC 1337 user_var broadcast (tmux DCS passthrough included).
- `integrations/clipboard.lua` — WSL2-only clipboard provider (win32yank/clip.exe fallback).
- `modules/utils/im-select.lua` — IME switcher, macOS vs WinOS binaries.
- `modules/editing-support/ai/claude-pane.lua` — depends on wezterm/tmux env vars and hardcoded shell.

## Architecture

Load chain: `init.lua` (leader 키 → lazy bootstrap → `core.apply` → `lazy_setup` → `polish` require) → `lazy_setup.lua` (`plugins.base` → `plugins` import) → `polish.lua` (`core.autocmds` → `core.mappings` → `lsp.setup` → `highlights.setup` → `integrations/*` → claude-pane).

- **`lua/core/`** — 프레임워크 없는 코어. `options/diagnostics/commands.lua`(데이터) + `apply.lua`(적용기, 플러그인 로드 전 실행), `autocmds.lua`(파일 이벤트 emitter·`vim.t.bufs` 추적 등), `icons.lua`(공용 아이콘 테이블 + `get()`), `mappings.lua`(순수 편집 매핑, polish 시점 로드로 항상 우선), `platform.lua`(OS 감지 단일 진실), `winbufs.lua`(pane 단위 버퍼 추적).
- **`lua/plugins/base/`** — 플러그인별 기본 스펙(트리거·기본 opts·기본 키맵). 구 배포판이 공급하던 몫.
- **`lua/plugins/modules/`** — 사용자 확장 스펙. `init.lua`가 `modules/**/*.lua`를 재귀 스캔해 flat LazySpec으로 자동 등록 — 파일을 넣으면 끝, 수동 등록 없음(블랙리스트는 그 파일 상단). Categories: `ui/ editing-support/ lsp/ colorscheme/ utils/`. 같은 플러그인의 base·modules 스펙은 lazy.nvim이 병합하며 modules(나중 import)가 이긴다.
- **`lsp/`** (저장소 최상위, `lua/` 아님) — 네이티브 서버 설정(`vim.lsp.config`가 rtp 병합으로 자동 소비). `lua/lsp/setup.lua`(capabilities + `vim.lsp.enable` 목록), `lua/lsp/attach.lua`(LspAttach 버퍼 매핑/토글), `lua/lsp/installer.lua`(mason·treesitter ensure 목록).
- **`lua/highlights/`** — 팔레트 해석 + `build()`, `setup()`이 ColorScheme autocmd로 적용.

## Conventions

- Leader `<Space>`, **localleader `,`** (non-default). `init.lua` 최상단에서 설정.
- **Autoformat off by default** (`g.autoformat=false`) — don't assume format-on-save. 포맷터는 conform(`;f`).
- 플러그인 매핑은 그 플러그인 spec의 `keys =`에 콜로케이션. 순수 편집 매핑만 `core/mappings.lua`.
- `modules/ui/` one role per file: statusline→`lualine.lua`, tabline→`bufferline.lua`, winbar→`dropbar.lua`.
- `modules/`에서 방어적 `is_available` 검사 금지 — 구조(콜로케이션/스펙 병합)로 해결. `base/`는 벤더 이식 코드로 예외 허용.

## Gotchas

- **`User AstroFile`/`AstroGitFile`/`AstroLargeBuf` 이벤트는 유산 이름일 뿐** — `core/autocmds.lua`의 자체 emitter가 발화한다(AstroNvim 아님). 여러 스펙의 lazy 트리거이므로 이름 변경 시 일괄 치환 필요.
- **`vim.t.bufs`는 `core/autocmds.lua`가 유지** — `winbufs.lua`, bufferline `custom_filter`, `]b/[b`가 의존. emitter/추적 autocmd를 지우면 조용히 깨진다.
- **nvim-treesitter는 `main` 브랜치** — 구 `configs` API 없음. 설정은 `plugins/base/treesitter.lua`의 네이티브 적용기(install + FileType `vim.treesitter.start` + textobjects 키맵).
- **Cross-platform OS isolation**: when doing mac-only or WinOS-only work, never touch the other side's branch. Portable changes must apply 1:1 to both. Ask if unsure.
