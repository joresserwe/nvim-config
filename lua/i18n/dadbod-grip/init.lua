local M = {}

M.descriptions = {
  palette = "명령 팔레트 열기",
  table_picker = "테이블 고르기",
  table_picker_alt = "테이블 고르기 (보조 키)",
  query_history = "쿼리 기록 열기",
  load_saved = "저장한 쿼리 불러오기",
  welcome = "시작 화면으로 돌아가기",
  help = "단축키 도움말 열기",
  er_diagram = "ER 다이어그램 열기",
  connections = "연결 목록 열기",
  connections_alt = "연결 목록 열기 (보조 키)",
  welcome_activate = "선택한 항목 실행",
  welcome_next = "다음 항목 선택",
  welcome_prev = "이전 항목 선택",
  welcome_close = "시작 화면 닫기",
  welcome_close_esc = "시작 화면 닫기 (Esc)",
  welcome_connect = "연결 목록 열기",
  welcome_secret = "숨겨진 Chonk 보기",
  query_pad = "SQL 패드 열기/이동",
  ai = "AI로 SQL 생성",
  schema_browser = "스키마 사이드바 열기/이동/닫기",
  zoom = "현재 창 확대/원래 배치로 복원",
  goto_grid = "그리드 창으로 이동",
  open_notebook = "SQL·Markdown 노트북을 SQL 패드로 열기",
  table_picker_go = "테이블 고르기 (짧은 키)",
  tab_1 = "첫 번째 화면 열기",
  tab_2 = "두 번째 화면 열기",
  tab_3 = "세 번째 화면 열기",
  tab_4 = "ER(관계) 보기",
  tab_5 = "컬럼 통계 보기",
  tab_6 = "컬럼 목록 보기",
  tab_7 = "외래 키 보기",
  tab_8 = "인덱스 보기",
  tab_9 = "제약 조건 보기",
  grid_row_down = "아래 행으로",
  grid_row_up = "위 행으로",
  grid_row_first = "첫 행으로",
  grid_row_last = "마지막 행으로",
  grid_col_left = "왼쪽으로 (Vim 기본 동작)",
  grid_col_right = "오른쪽으로 (Vim 기본 동작)",
  grid_col_next = "다음 컬럼으로",
  grid_col_prev = "이전 컬럼으로",
  grid_col_tab = "다음 컬럼으로 (Tab)",
  grid_col_tab_back = "이전 컬럼으로 (Shift-Tab)",
  grid_col_end = "칸 끝으로, 끝이면 다음 칸으로",
  grid_col_first = "첫 컬럼으로",
  grid_col_first2 = "첫 컬럼으로 (보조 키)",
  grid_col_last = "마지막 컬럼으로",
  grid_prev_mod = "이전 수정된 행으로",
  grid_next_mod = "다음 수정된 행으로",
  grid_edit = "현재 칸 편집",
  grid_edit_enter = "현재 칸 편집 (Enter)",
  grid_cell_buffer = "현재 칸을 분할 창에서 편집",
  grid_null = "현재 칸을 NULL로 (적용 대기)",
  grid_column_set = "보이는 모든 행의 이 컬럼에 같은 값 넣기 (적용 대기)",
  grid_paste = "클립보드를 현재 칸에 붙여넣기",
  grid_paste_rows = "여러 줄을 연속된 행에 붙여넣기",
  grid_insert = "빈 행 추가 (적용 대기)",
  grid_clone = "현재 행 복제 (기본 키는 비움)",
  grid_delete = "현재 행 삭제 표시/해제",
  grid_apply = "대기 중인 변경을 DB에 적용",
  grid_undo = "마지막 대기 변경 취소",
  grid_redo = "취소한 변경 다시 하기",
  grid_undo_all = "대기 중인 변경 모두 버리기",
  grid_v_edit = "선택한 칸들에 같은 값 넣기 (적용 대기)",
  grid_v_delete = "선택한 행들 삭제 표시/해제",
  grid_v_null = "선택한 칸들을 NULL로 (적용 대기)",
  grid_v_yank = "선택한 칸 복사",
  grid_v_compare = "선택한 두 행 비교",
  grid_hide_col = "현재 컬럼 숨기기",
  grid_restore_cols = "숨긴 컬럼 모두 다시 보이기",
  grid_col_vis = "보일 컬럼 고르기",
  grid_col_width = "현재 컬럼 너비 바꾸기",
  grid_type_row = "컬럼 타입 줄 보이기/숨기기",
  grid_live_sql = "대기 변경의 SQL 미리보기 켜기/끄기",
  grid_row_view = "현재 행(또는 선택)을 '컬럼: 값' 목록으로 보기",
  grid_sort = "현재 컬럼 정렬 (오름 → 내림 → 해제)",
  grid_sort_stack = "보조 정렬 추가/변경",
  grid_filter_cell = "현재 칸 값으로 필터",
  grid_filter_null = "현재 컬럼이 NULL인 행만",
  grid_filter_build = "필터 만들기 화면 열기",
  grid_filter_where = "WHERE 조건 직접 입력",
  grid_filter_clear = "필터 해제 (고정된 조건은 유지)",
  grid_preset_load = "저장한 필터 불러오기",
  grid_preset_save = "현재 필터 저장",
  grid_reset_view = "정렬·필터 해제하고 첫 페이지로",
  grid_next_page = "다음 페이지",
  grid_prev_page = "이전 페이지",
  grid_next_page2 = "다음 페이지 (대괄호 키)",
  grid_prev_page2 = "이전 페이지 (대괄호 키)",
  grid_last_page = "마지막 페이지",
  grid_first_page = "첫 페이지",
  grid_explain_cell = "현재 칸 설명",
  grid_json_tree = "현재 JSON 값을 트리로 보기",
  grid_preview_sql = "대기 변경의 SQL 보기",
  grid_copy_sql = "대기 변경의 SQL 복사",
  grid_table_info = "테이블 정보 (간단히)",
  grid_table_props = "테이블 속성 (자세히)",
  grid_rename_col = "DB 컬럼 이름 바꾸기 (확인 후)",
  grid_col_stats = "현재 컬럼 통계",
  grid_profile = "테이블 전체 컬럼 분석",
  grid_show_ddl = "CREATE TABLE 문 보기",
  grid_explain = "쿼리 실행 계획 보기",
  grid_url_open = "현재 칸의 URL 열기",
  grid_diff = "다른 테이블과 비교",
  grid_aggregate = "현재 컬럼(또는 선택) 집계",
  grid_export_clip = "결과를 클립보드로 내보내기",
  grid_export_file = "결과를 파일로 내보내기",
  grid_yank_cell = "현재 칸 복사",
  grid_yank_row = "현재 행을 CSV로 복사",
  grid_yank_table = "결과 전체를 CSV로 복사",
  grid_yank_md = "결과를 Markdown 표로 복사",
  grid_fk_follow = "현재 칸의 외래 키 따라가기",
  grid_fk_referencing = "현재 행을 참조하는 행 열기",
  grid_fk_back = "이전 관계 결과로 돌아가기",
  grid_refresh = "결과 새로고침",
  grid_watch = "자동 새로고침 켜기/끄기",
  grid_write_mode = "로컬 파일에 되쓰기 켜기/끄기",
  grid_open_edit = "읽기 전용 결과를 편집 가능한 테이블로 다시 열기",
  grid_fill = "AI가 만든 행 추가 (적용 대기)",
  grid_pin = "현재 결과 고정/해제",
  grid_results = "결과 전환 목록 열기",
  qpad_execute = "현재 SQL 블록(또는 선택) 실행",
  qpad_execute_new = "새 결과 창에서 SQL 실행",
  qpad_save = "쿼리 저장",
  qpad_ai = "AI로 SQL 생성 (SQL 패드)",
  qpad_format = "SQL 정렬(포맷)",
  qpad_close = "시작 화면으로 돌아가기",
  qpad_complete = "SQL 자동완성 띄우기",
  qpad_complete_next = "자동완성 띄우기/다음 항목",
  qpad_complete_prev = "이전 자동완성 항목 (없으면 Shift-Tab)",
  qpad_complete_down = "다음 자동완성 항목 (없으면 아래로)",
  qpad_complete_up = "이전 자동완성 항목 (없으면 위로)",
  qpad_complete_accept = "자동완성 선택 (없으면 줄바꿈)",
  sidebar_open = "열기, 그룹이면 펼치기/접기",
  sidebar_open_spl = "커서의 테이블을 새 분할 창에서 열기",
  sidebar_expand = "그룹 또는 테이블 컬럼 펼치기",
  sidebar_collapse = "접기, 또는 상위 항목으로",
  sidebar_expand_z = "펼치기 (fold 키)",
  sidebar_collap_z = "접기 (fold 키)",
  sidebar_expand_all = "모든 스키마 펼치기 (컬럼은 제외)",
  sidebar_collap_all = "모두 접기",
  sidebar_filter = "이름으로 찾기",
  sidebar_filter_c = "찾기 해제",
  sidebar_next = "다음 테이블/루틴으로",
  sidebar_prev = "이전 테이블/루틴으로",
  sidebar_refresh = "스키마 새로고침",
  sidebar_refresh2 = "스키마 강제 새로고침",
  sidebar_yank = "테이블·컬럼 이름 복사",
  sidebar_open_s = "최신 행부터 테이블 열기",
  sidebar_close = "사이드바 닫기",
  sidebar_drop = "테이블 삭제 (확인 후)",
  sidebar_create = "테이블 만들기",
  sidebar_attach = "DuckDB 연결에 DB 붙이기",
  sidebar_detach = "DuckDB 연결에서 DB 떼기",
  sidebar_conns = "연결 목록 열기",
  editor_save = "편집한 칸 저장",
  editor_save_alt = "편집한 칸 저장 (보조 키)",
  editor_cancel = "편집 취소",
  editor_cancel_q = "편집 취소 (normal 모드 키)",
  editor_open_url = "값이 URL이면 열기",
  editor_cancel_insert = "편집 취소 (입력 모드)",
}

M.categories = {
  navigation = "이동",
  welcome = "시작 화면",
  ai = "AI",
  views = "화면 전환",
  ["grid navigation"] = "그리드 이동",
  ["grid editing"] = "그리드 편집",
  ["grid display"] = "그리드 표시",
  ["grid filtering"] = "정렬·필터·페이지",
  ["grid inspection"] = "살펴보기",
  ["grid export"] = "복사·내보내기",
  ["grid relationships"] = "관계(외래 키)",
  ["grid workflow"] = "작업",
  ["query pad"] = "SQL 패드",
  ["query completion"] = "자동완성",
  sidebar = "사이드바",
  ["cell editor"] = "셀 편집기",
}

M.tabs = {
  grid = { "스키마 사이드바 열기/이동", "SQL 패드 열기/이동", "레코드로 돌아가기, 이미 있으면 테이블 고르기" },
  sidebar = { "연결 목록 열기", "SQL 패드 열기/이동", "결과로 이동, 없으면 선택한 테이블 열기" },
  query_pad = { "스키마 사이드바 열기/이동", "쿼리 기록 열기", "결과로 이동, 없으면 테이블 고르기" },
  welcome = { "스키마 사이드바 열기/이동", "SQL 패드 열기", "테이블 고르기" },
}

M.help_text = {
  { "Grid mappings", "그리드 단축키" },
  { "Schema sidebar mappings", "스키마 사이드바 단축키" },
  { "SQL pad mappings", "SQL 패드 단축키" },
  { "Welcome mappings", "시작 화면 단축키" },
  { "Opens or focuses the schema sidebar.", "스키마 사이드바 열기/이동" },
  { "Opens or focuses the SQL pad.", "SQL 패드 열기/이동" },
  { "Returns to records, or picks a table from records.", "레코드로 돌아가기, 이미 있으면 테이블 고르기" },
  { "Opens the connection picker.", "연결 목록 열기" },
  { "Focuses results, or opens the selected table.", "결과로 이동, 없으면 선택한 테이블 열기" },
  { "Opens query history.", "쿼리 기록 열기" },
  { "Focuses results, or picks a table if none is open.", "결과로 이동, 없으면 테이블 고르기" },
  { "Opens the SQL pad.", "SQL 패드 열기" },
  { "Picks a table.", "테이블 고르기" },
  { "(insert) ", "(입력 모드) " },
  { "(visual) ", "(비주얼) " },
  { "Full manual and commands", "전체 설명서(영문)와 명령어" },
  { "Zoom a normal help/report split", "도움말·리포트 창 확대" },
  { "About dadbod-grip", "dadbod-grip 소개" },
  { "Close this help", "도움말 닫기" },
}

local function replace_plain(line, from, to)
  local s, e = line:find(from, 1, true)
  if not s then return line end
  return line:sub(1, s - 1) .. to .. line:sub(e + 1)
end

local function wrap(line, width)
  if vim.fn.strdisplaywidth(line) <= width then return { line } end
  local prefix, rest = line:match "^(  %S+ +)(.*)$"
  if not prefix then return { line } end
  local out, cur = {}, prefix
  for word in rest:gmatch "%S+" do
    local next_line = cur .. (cur == prefix and "" or " ") .. word
    if vim.fn.strdisplaywidth(next_line) > width and cur ~= prefix then
      out[#out + 1] = cur
      prefix = string.rep(" ", 15)
      cur = prefix .. word
    else
      cur = next_line
    end
  end
  out[#out + 1] = cur
  return out
end

function M.apply()
  vim.opt.runtimepath:prepend(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h"))
  local ok, keymaps = pcall(require, "dadbod-grip.keymaps")
  if not ok or type(keymaps.catalog) ~= "table" or type(keymaps.help_lines) ~= "function" then return end
  for _, record in ipairs(keymaps.catalog) do
    record.description = M.descriptions[record.action] or record.description
    record.category = M.categories[record.category] or record.category
  end
  local bind = keymaps.bind
  keymaps.bind = function(surface, bufnr, action, mode, fn, opts, ...)
    local tab = tonumber(tostring(action):match "^tab_([123])$")
    local desc = tab and M.tabs[surface] and M.tabs[surface][tab] or M.descriptions[action]
    if desc then opts = vim.tbl_extend("force", opts or {}, { desc = "Grip: " .. desc }) end
    return bind(surface, bufnr, action, mode, fn, opts, ...)
  end
  local help_lines = keymaps.help_lines
  keymaps.help_lines = function(surface, width, ...)
    local out = {}
    for _, line in ipairs(help_lines(surface, math.huge, ...)) do
      for _, pair in ipairs(M.help_text) do
        line = replace_plain(line, pair[1], pair[2])
      end
      vim.list_extend(out, wrap(line, width))
    end
    return out
  end
end

return M
