<h1 align="center">키맵 치트시트</h1>

<p align="center">
  순수 lazy.nvim + 네이티브 <code>vim.*</code> 설정 &nbsp;·&nbsp; Leader <kbd>Space</kbd> &nbsp;·&nbsp; Localleader <kbd>,</kbd>
</p>

> **팁:** `<Leader>fk`로 모든 키맵을 실시간 검색할 수 있고(picker), prefix를 누르고 있으면(예: `<Leader>f`) **which-key**가 자동으로 뜹니다. 아래 설명은 설정 자체의 키맵 설명입니다.

일반 모드가 아닌 매핑은 모드 표기가 붙습니다: `(x)` 비주얼/선택, `(o)` operator-pending, `(i)` 삽입, `(t)` 터미널. 표기 없음 = 일반 모드.

---

## 편집 & 레지스터

레지스터 규칙: `y`→inner 레지스터 `i`, `d`→delete 레지스터 `d`, `Y`/`·s` 계열→시스템 클립보드 `+`, `x`/`c`→blackhole. 기본 `p`/`P`/`s`는 비활성화 — `p{i,d,s}`로 명시적으로 붙여넣기.

### Yank / Delete / Change

| 키 | 동작 |
| --- | --- |
| `y` | inner 레지스터 `i`로 yank (motion) |
| `yy` | 줄을 inner 레지스터로 yank |
| `Y` | 시스템 클립보드 `+`로 yank |
| `Yy` / `YY` | 줄을 시스템 클립보드로 yank |
| `d` | delete 레지스터 `d`로 삭제 |
| `dd` | 줄을 delete 레지스터로 삭제 |
| `x` | 문자를 blackhole로 삭제 |
| `c` | blackhole로 change |
| `s` | 비활성화 (`<Nop>`) |
| `<Leader>c` | 단어 편집 — inner word change (blackhole) |
| `<Leader>x` | 단어 제거 (inner 레지스터) — cut word |
| `<Leader>d` | 단어 제거 (delete 레지스터) — delete word |

### 붙여넣기

| 키 | 동작 |
| --- | --- |
| `pi` / `Pi` | inner 레지스터 `i`에서 붙여넣기 (뒤 / 앞) |
| `pd` / `Pd` | delete 레지스터 `d`에서 붙여넣기 |
| `ps` / `Ps` | 시스템 클립보드 `+`에서 붙여넣기 |
| `p` / `P` | 비활성화 (`<Nop>`) — 위 키 사용 |
| `<Leader>pi` | 단어를 inner 레지스터 내용으로 교체 |
| `<Leader>pd` | 단어를 delete 레지스터 내용으로 교체 |
| `<Leader>ps` | 단어를 시스템 클립보드 내용으로 교체 |

### 줄 & 기타

| 키 | 동작 |
| --- | --- |
| `<Leader>o` / `<Leader>O` | 아래/위로 한줄 띄기 — blank line below / above |
| `<Leader><CR>` | 현재 커서 위치에서 줄바꿈 — split line at cursor |
| `]<Space>` / `[<Space>` | 커서 아래 / 위에 빈 줄 추가 |
| `<C-a>` | 전체 선택 |
| `<Leader>y` | 단어 surround (`ysiw`) |
| `jk` / `jj` (i) | 일반 모드로 탈출 |

---

## 이동 & 내비게이션

| 키 | 동작 |
| --- | --- |
| `(` / `)` | 7줄 위/아래로 이동 |
| `j` / `k` | 스마트 아래/위 (count 없을 때 `gj`/`gk`) |
| `H` / `L` | 오타 방지 — `h` / `l`과 동일 |
| `<C-p>` | jumplist 뒤로 (`<C-o>`) |
| `<C-n>` | jumplist 앞으로 (`<C-i>`) |
| `<C-o>` | 비활성화 (`<C-p>` 사용) |
| `<C-h/j/k/l>` | 좌/하/상/우 분할창으로 이동 (smart-splits) |
| `<C-Left/Down/Up/Right>` | 분할창 크기 조절 |
| `]t` / `[t` | 다음 / 이전 탭 |
| `]r` / `[r` | 다음 / 이전 reference (snacks words) |
| `gx` | 커서 아래 경로/URI를 시스템 핸들러로 열기 |

### 노드 선택 (treesitter)

| 키 | 동작 |
| --- | --- |
| `an` (x/o) | 부모(outer) 노드 선택 |
| `in` (x/o) | 자식(inner) 노드 선택 |
| `]n` / `[n` (x) | 다음 / 이전 노드 선택 |
| `]N` / `[N` (x) | 다음 / 이전 형제 노드 선택 |

---

## 버퍼

| 키 | 동작 |
| --- | --- |
| `<Tab>` / `<S-Tab>` | 다음 / 이전 버퍼 |
| `]b` / `[b` | 다음 / 이전 버퍼 |
| `>b` / `<b` | 버퍼 탭 오른쪽 / 왼쪽으로 이동 |
| `<Leader>bp` | 버퍼 선택 (BufferLinePick) |
| `<Leader>bc` | 현재 버퍼 제외 전체 닫기 |
| `<Leader>bl` | 왼쪽 버퍼 전체 닫기 |
| `<Leader>br` | 오른쪽 버퍼 전체 닫기 |
| `<Leader>bse` | 확장자순 정렬 |
| `<Leader>bsp` | 디렉터리순 정렬 |
| `<Leader>bsr` | 상대 디렉터리순 정렬 |

---

## 창

| 키 | 동작 |
| --- | --- |
| `<Leader>\` | 세로 분할 |
| `<Leader>-` | 가로 분할 |
| `<Leader>=` | 분할창 순서 변경 |
| `<Leader>w` | 현재 창의 버퍼 닫기 (pane 단위) |
| `<Leader>m` | 창 최대화 / 균등화 |
| `<C-h/j/k/l>` | 분할창 이동 (smart-splits) |
| `<C-Left/Down/Up/Right>` | 분할창 크기 조절 |

---

## 찾기 / Picker

`<Leader>f*`는 Snacks picker를 사용합니다 (표기된 곳은 GrugFar / Namu).

| 키 | 동작 |
| --- | --- |
| `<Leader>ff` | 파일 찾기 |
| `<Leader>fF` | 모든 파일 찾기 |
| `<Leader>fg` | git 파일 찾기 |
| `<Leader>fa` | 설정 파일 찾기 |
| `<Leader>fz` | 디렉터리 찾기 |
| `<Leader>fc` | 커서 아래 단어 찾기 |
| `<Leader>f/` | 단어 찾기 (grep) |
| `<Leader>f?` | 단어 찾기 (숨김파일포함) |
| `<Leader>fl` | 줄 찾기 (버퍼) |
| `<Leader>fe` | CWD 내 히스토리 찾기 |
| `<Leader>fE` | 히스토리 찾기 (전체 경로) |
| `<Leader>f<CR>` | 이전 검색 재개 |
| `<Leader>fh` | 도움말 찾기 |
| `<Leader>fm` | man 페이지 찾기 |
| `<Leader>fk` | 키맵 찾기 |
| `<Leader>fC` | 명령 찾기 |
| `<Leader>f'` | 레지스터 찾기 |
| `<Leader>f\`` | 마크 찾기 |
| `<Leader>fp` | 프로젝트 찾기 |
| `<Leader>fn` | 알림 찾기 |
| `<Leader>ft` | 테마 찾기 |
| `<Leader>fT` | todo 찾기 |
| `<Leader>fy` | yank 찾기 (`(x)`도 가능) |
| `<Leader>fu` | undo 히스토리 찾기 |
| `<Leader>fr` | 찾아 바꾸기 (GrugFar) |
| `<Leader>fs` | 심볼 검색 (Namu) |
| `<Leader>fS` | 심볼 검색 (Snacks) |
| `<Leader>fd` | 진단 검색 (버퍼, LSP 연결됨) |

### `s` 서브메뉴 (Trouble / Yazi / outline)

| 키 | 동작 |
| --- | --- |
| `s` | 비활성화 prefix (`<Nop>`) |
| `sq` | Quickfix (Trouble) |
| `sd` | 진단 (Trouble) |
| `sD` | 버퍼 진단 (Trouble) |
| `sh` | 심볼 outline (Hierarchy) |
| `su` | undo 찾기 |
| `sy` | yank 찾기 |
| `sf` | Yazi (현재 파일) |
| `sF` | Yazi (cwd) |
| `sw` | Wrapped (nvim 통계) |
| `fd` | 진단 검색 |

---

## Git

### 전역 picker (`<Leader>g*`)

| 키 | 동작 |
| --- | --- |
| `<Leader>gt` | Git status |
| `<Leader>gb` | Git 브랜치 |
| `<Leader>gc` | Git 커밋 (저장소) |
| `<Leader>gC` | Git 커밋 (현재 파일) |
| `<Leader>gT` | Git stash |
| `<Leader>go` | Git browse / open (`(x)`도 가능) |

### Gitsigns (버퍼 로컬)

| 키 | 동작 |
| --- | --- |
| `<Leader>gs` | hunk stage / unstage (`(x)` hunk stage) |
| `<Leader>gr` | hunk reset (`(x)` hunk reset) |
| `<Leader>gS` | 버퍼 stage |
| `<Leader>gR` | 버퍼 reset |
| `<Leader>gp` | hunk 미리보기 |
| `<Leader>gl` | Git blame 보기 (줄) |
| `<Leader>gL` | 전체 Git blame 보기 |
| `<Leader>gd` | Git diff 보기 |
| `]g` / `[g` | 다음 / 이전 hunk |
| `]G` / `[G` | 마지막 / 첫 hunk |
| `ig` (x/o) | Git hunk 내부 (텍스트 오브젝트) |

---

## LSP

버퍼 로컬, `LspAttach`에서 설정 (client capability로 게이팅).

| 키 | 동작 |
| --- | --- |
| `gd` | 정의로 이동 |
| `gD` | 선언으로 이동 |
| `gy` | 타입 정의로 이동 |
| `gK` | 시그니처 도움말 |
| `gO` | 문서 심볼 |
| `K` | hover (네이티브 `vim.lsp.buf.hover`) |
| `<C-s>` (i/x/s) | 시그니처 도움말 |
| `;a` (n/x) | 코드 액션 |
| `;r` | 이름 변경 (IncRename) |
| `;f` (n/x) | 버퍼 포맷 |
| `<Leader>g'` | 선언으로 이동 |
| `<Leader>lh` | 시그니처 도움말 |
| `<Leader>lG` | 워크스페이스 심볼 검색 |
| `<Leader>lA` | source action |
| `<Leader>ll` | CodeLens 새로고침 |
| `<Leader>lL` | CodeLens 실행 |
| `<Leader>li` | LSP 정보 (checkhealth) |
| `<Leader>lc` | Conform 정보 |
| `<>` (i) | JSX: `<></>`로 확장 (jsx/tsx 버퍼) |
| `sp` | Markdown Preview 토글 (markdown 버퍼) |

---

## 진단

| 키 | 동작 |
| --- | --- |
| `gl` | 진단 hover (float) |
| `<Leader>ld` | 진단 hover (float) |
| `]e` / `[e` | 다음 / 이전 에러 |
| `]w` / `[w` | 다음 / 이전 경고 |
| `]d` / `[d` | 다음 / 이전 진단 |
| `]D` / `[D` | 버퍼 내 마지막 / 첫 진단 |
| `<Leader>fd` | 진단 검색 (picker) |
| `sd` / `sD` | 진단 / 버퍼 진단 (Trouble) |
| `<Leader>ud` | 진단 토글 |
| `<Leader>uv` / `<Leader>uV` | virtual text / virtual lines 토글 |

---

## Treesitter 텍스트 오브젝트

파일타입별 버퍼 로컬 (parser가 캡처를 제공하는 곳에서만 매핑됨).

### 선택 — `(x)` 비주얼, `(o)` operator-pending

| 키 | 텍스트 오브젝트 |
| --- | --- |
| `ak` / `ik` | block 바깥 / 안쪽 |
| `ac` / `ic` | class 바깥 / 안쪽 |
| `af` / `if` | function 바깥 / 안쪽 |
| `ao` / `io` | loop 바깥 / 안쪽 |
| `aa` / `ia` | argument 바깥 / 안쪽 |
| `a?` / `i?` | conditional 바깥 / 안쪽 |

### 이동 (일반 / `(x)` / `(o)`)

| 키 | 동작 |
| --- | --- |
| `]k` / `[k` | 다음 / 이전 block 시작 |
| `]K` / `[K` | 다음 / 이전 block 끝 |
| `]f` / `[f` | 다음 / 이전 function 시작 |
| `]F` / `[F` | 다음 / 이전 function 끝 |
| `]a` / `[a` | 다음 / 이전 argument 시작 |
| `]A` / `[A` | 다음 / 이전 argument 끝 |

### 교환 (일반)

| 키 | 동작 |
| --- | --- |
| `>K` / `<K` | 다음 / 이전 block 교환 |
| `>F` / `<F` | 다음 / 이전 function 교환 |
| `>A` / `<A` | 다음 / 이전 argument 교환 |

---

## 디버거 & 태스크 (localleader `,`)

### DAP (`<Leader>,*` + F키)

| 키 | F키 | 동작 |
| --- | --- | --- |
| `<Leader>,c` | `<F5>` | 시작 / 계속 |
| `<Leader>,q` | — | 세션 닫기 |
| `<Leader>,Q` | `<S-F5>` | 세션 종료 |
| `<Leader>,b` | `<F9>` | 브레이크포인트 토글 |
| `<Leader>,B` | — | 브레이크포인트 전체 삭제 |
| `<Leader>,C` | `<S-F9>` | 조건부 브레이크포인트 |
| `<Leader>,o` | `<F10>` | step over |
| `<Leader>,i` | `<F11>` | step into |
| `<Leader>,O` | `<S-F11>` | step out |
| `<Leader>,r` | `<C-F5>` | 재시작 |
| `<Leader>,p` | `<F6>` | 일시정지 |
| `<Leader>,s` | — | 커서까지 실행 |
| `<Leader>,R` | — | REPL 토글 |
| `<Leader>,u` | — | 디버거 UI 토글 |

### Overseer 태스크

| 키 | 동작 |
| --- | --- |
| `<Leader>,t` | 태스크 실행 |
| `<Leader>,T` | 태스크 목록 토글 |
| `<Leader>,l` | 마지막 태스크 재시작 |
| `<Leader>,!` | 셸 명령 실행 |

---

## AI (Claude Code)

| 키 | 동작 |
| --- | --- |
| `<Leader>ab` | 버퍼를 Claude에 추가 |
| `<Leader>as` (x) | 선택 영역을 Claude Code로 전송 |
| `<Leader>aa` | diff 수락 |
| `<Leader>ad` | diff 거부 |
| `<Leader>am` | 모델 선택 |
| `<Leader>ar` | Claude 재개 |

---

## 터미널

| 키 | 동작 |
| --- | --- |
| `<Leader>t-` | 터미널 가로 분할 |
| `<Leader>t\` | 터미널 세로 분할 |
| `<C-h/j/k/l>` (t) | 터미널에서 창 이동 |
| `<C-w>` (t) | 창 명령 prefix |

---

## 세션 (persistence)

| 키 | 동작 |
| --- | --- |
| `<Leader>ss` | 현재 디렉터리 세션 로드 |
| `<Leader>sl` | 세션 선택 |
| `<Leader>sd` | 세션 추적 중지 |

---

## UI 토글 (`<Leader>u*`)

| 키 | 동작 |
| --- | --- |
| `<Leader>ub` | 배경 토글 (라이트/다크) |
| `<Leader>un` | 줄 번호 방식 변경 |
| `<Leader>uw` | wrap 토글 |
| `<Leader>us` | 맞춤법 검사 토글 |
| `<Leader>uS` | conceal 토글 |
| `<Leader>ug` | signcolumn 토글 |
| `<Leader>u>` | foldcolumn 토글 |
| `<Leader>u\|` | 들여쓰기 가이드 토글 |
| `<Leader>ui` | 들여쓰기 설정 변경 |
| `<Leader>ul` | statusline 토글 |
| `<Leader>ut` | tabline 토글 |
| `<Leader>uy` | 구문 강조 토글 (버퍼) |
| `<Leader>uz` | 색상 강조 토글 |
| `<Leader>uZ` | zen 모드 토글 |
| `<Leader>ud` | 진단 토글 |
| `<Leader>uv` | virtual text 토글 |
| `<Leader>uV` | virtual lines 토글 |
| `<Leader>ur` | reference 강조 토글 |
| `<Leader>uc` / `<Leader>uC` | 자동완성 토글 (버퍼 / 전역) |
| `<Leader>uf` / `<Leader>uF` | 자동 포맷 토글 (버퍼 / 전역) |
| `<Leader>uh` / `<Leader>uH` | LSP inlay hints 토글 (버퍼 / 전역) |
| `<Leader>uY` | LSP semantic 강조 토글 (버퍼) |
| `<Leader>uL` | CodeLens 토글 |
| `<Leader>uA` | Autosave 토글 |
| `<Leader>uN` | 알림 토글 |
| `<Leader>uD` | 알림 dismiss |

---

## 리팩터 (`<Leader>r*`, refactoring.nvim)

| 키 | 동작 |
| --- | --- |
| `<Leader>rr` (x) | 리팩터 선택 (메뉴) |
| `<Leader>rb` | 함수 추출 (`(x)` 추출) |
| `<Leader>rbf` | 함수를 파일로 추출 |
| `<Leader>re` (x) | 함수 추출 |
| `<Leader>rf` (x) | 함수를 파일로 추출 |
| `<Leader>rv` (x) | 변수 추출 |
| `<Leader>ri` | 변수 인라인 |
| `<Leader>rp` | 디버그: 위치 출력 (`(x)` 표현식 출력) |
| `<Leader>rd` | 디버그: 변수 출력 |
| `<Leader>rc` | 디버그: 정리 |

---

## 플러그인 매니저 (`<Leader>'*`)

| 키 | 동작 |
| --- | --- |
| `<Leader>'i` | Lazy install |
| `<Leader>'s` | Lazy status (home) |
| `<Leader>'S` | Lazy sync |
| `<Leader>'u` | Lazy 업데이트 확인 |
| `<Leader>'U` | Lazy update |
| `<Leader>'m` | Mason installer |
| `<Leader>'M` | Mason 도구 업데이트 |
| `<Leader>'a` | Lazy와 Mason 업데이트 |

---

## 멀티커서

| 키 | 동작 |
| --- | --- |
| `mm` | 멀티커서 시작 (`(x)`도 가능) |
| `m/` | 멀티커서 검색 (`(x)`도 가능) |

---

## 비주얼 모드

| 키 | 동작 |
| --- | --- |
| `J` / `K` | 한줄 아래로/위로 — 선택 영역 이동 |
| `<` / `>` | 왼쪽 / 오른쪽 들여쓰기 (선택 유지) |
| `<Tab>` / `<S-Tab>` | 줄 들여쓰기 / 내어쓰기 |
| `mf` | block insert (앞) |
| `mb` | block append (뒤) |
| `gc` | 주석 토글 |
| `<Leader>/` | 주석 토글 |

---

## 기타

| 키 | 동작 |
| --- | --- |
| `<Leader>q` | 창 닫기 (확인) |
| `<Leader>Q` | Neovim 종료 (전체 확인) |
| `<Leader>n` | 새 파일 |
| `<Leader>R` | 파일 이름 변경 (Snacks) |
| `<Leader>e` | Explorer 토글 (neo-tree) |
| `<C-s>` | 강제 저장 (silent update) |
| `<C-q>` | 강제 종료 |
| `<C-w>` (t) | 터미널에서 창 명령 |
| `<Leader>/` | 주석 줄 토글 |
| `gcc` | 주석 줄 토글 |
| `gco` / `gcO` | 아래 / 위에 주석 추가 |
| `gc` | 주석 (motion / `(x)` / `(o)`) |
| `K` | LSP hover |

---

### 네이티브 LSP 기본값

Neovim 내장 `grr` (references), `grn` (rename), `gra` (code action), `gri` (implementation), `grt` (type definition), `grx` (CodeLens run)는 위 커스텀 LSP 매핑과 함께 그대로 사용할 수 있습니다. `K`는 `vim.lsp.buf.hover`로 오버라이드됩니다.
