# Softrear Inc. 내부 운영 분석

당신은 데이터 분석가다. 화장지 제조 선도 기업 Softrear Inc.의 사내 운영
데이터베이스를 넘겨받았다. 테이블 17개, 활발히 돌아가는 대나무 공급망, 그리고
보안팀이 "관리되는 위협 환경(managed threat landscape)"이라 부르는 무언가를 가진
회사다.

질문은 세 가지다.

1. 제품 품질 문제가 있는가, 있다면 어디서 비롯되는가?
2. 누가 무엇을 알고 있고, 그에 대해 무엇을 했는가?
3. 어떤 결정들이 회사를 여기까지 끌고 왔고, 그 결정은 어떻게 내려졌는가?

이 노트북은 세 질문 모두에 답한다. SQL 블록 안에 커서를 두고 `<C-CR>`을 누르면
실행된다. 결과는 아래 그리드에 나타난다. 노트북 안에서는 `j`/`k`로 이동한다.

예시는 기본 키 기준이다. 키를 바꿨다면 현재 패널에서 `?`를 눌러 확인한다.

```text
+-- Schema --------+-- SQL -------------------+
| / 객체 찾기      | <C-CR> 이 블록 실행      |
| h/l 접기         +-- Results ---------------+
| 2 SQL 열기       | K 상세      gs 검토      |
|                  | u 되돌리기  a 적용       |
+------------------+--------------------------+
                 gz 확대 / 복원
```

숫자 키는 패널에 따라 다르다. 스키마나 결과 패널에서 `2`는 SQL을 열고, SQL
안에서 `2`는 히스토리를 연다. 조사를 마친 뒤 짧은 작업 루프를 연습하려면 이
노트북에서 `Daily practice`를 검색한다.

DuckDB는 505개 롤 전체 조사 데이터를 로드한다. SQLite 대체 모드는 같은 이름의
증거를 35개 롤짜리 축소 픽스처로 유지하므로, 배경 행 개수는 정확히 일치하지 않는다.

---

## 1. 제품 카탈로그 개요

DuckDB 전체 카탈로그에는 SKU가 505개 있고, SQLite는 이름 붙은 예시 35개만
유지한다. 필터링하기 전에 softness_score(부드러움 점수) 순으로 정렬한 넓은 뷰를
뽑아, 양 끝에서 뭔가 드러나는지 본다.

```sql
SELECT sku, ply, softness_score, tensile_strength, discontinued
FROM rolls
ORDER BY softness_score ASC
LIMIT 20
```

점수가 가장 낮은 행은 `ULTRA_BUDGET_XTRM`이다: softness_score = 0.0, ply = 1,
tensile_strength = 2.1, discontinued = false. 부드러움 점수가 0인 제품이
카탈로그에 있고, 출하되고 있다. 아래의 모든 내용은 이 한 행에서 시작된다.

> **그리드:** `gR`을 누르면 softness_score 전체 분포를 스파크라인으로 본다.
> 아무 컬럼에서나 `s`는 오름차순 정렬, `S`는 보조 정렬을 쌓는다 (▲1 ▼2).

---

## 2. 인장강도 이상치

카탈로그를 훑을 때 최대 인장강도 값이 수상해 보였다. 분포의 상단만 떼어내
확인한다.

```sql
SELECT sku, ply, tensile_strength, softness_score
FROM rolls
ORDER BY tensile_strength DESC
LIMIT 10
```

`TITANIUM_TRIPLE_PLY`의 인장강도는 47.0이다. 일반 데님은 40 안팎으로 측정된다.
이 제품은 데님보다 질기다. 소비자 사고 테이블에도 `incident_type = 'clog'`(막힘),
심각도 8, 메모 "Product exceeded specifications. Plumber invoice attached."
(제품이 사양을 초과함. 배관공 청구서 첨부.)로 올라 있다.

---

## 3. 심각도별 소비자 사고

이상치 제품 두 개를 찾았으니 다음 질문은 이것이다: 사고는 얼마나 심각하고,
가장 심각한 사고들에 패턴이 있는가?

```sql
SELECT id, incident_type, severity, roll_sku, incident_date, notes
FROM consumer_incidents
ORDER BY severity DESC
LIMIT 30
```

`severity = 10`인 행은 예외 없이 전부 `incident_type = 'airplane'`이다. 상위 두
행의 메모:

- "Seat 34B. Meal service had just ended. This review cannot be submitted to the airline."
  (좌석 34B. 기내식 서비스가 막 끝난 참이었다. 이 리뷰는 항공사에 제출할 수 없다.)
- "JFK to Heathrow. Economy class. We do not manufacture under-seat storage. The quilting did not help."
  (JFK발 히드로행. 이코노미석. 당사는 좌석 밑 수납공간을 만들지 않는다. 퀼팅은 도움이 되지 않았다.)

비행기 화장실은 이 제품군의 구조적 실패 모드다.

> **그리드:** `gS`는 심각도 통계(평균, 최소, 최대, null 수)를 보여준다. 셀에서
> `f`를 누르면 그리드가 즉시 그 사고 유형으로 필터링된다.
>
> **셀 편집기:** `incident_date` 셀로 이동해 `i`로 값을 열고, `<Esc>`로 INSERT
> 모드를 빠져나온다. 날짜 미리보기는 편집기를 연 시점 기준으로 계산한 달력 날짜와
> 상대 시간을 보여준다. 좌석 34B. 기내식 서비스가 막 끝난 참이었다.

---

## 4. 비행기 상관관계

보고하기 전에 패턴을 정량적으로 확인한다.

```sql
SELECT incident_type, COUNT(*) AS count, ROUND(AVG(severity), 2) AS avg_severity
FROM consumer_incidents
GROUP BY incident_type
ORDER BY avg_severity DESC
```

평균 심각도는 `airplane`이 1위다. 동률도 아니다: 다음 사고 유형과의 격차가
2.5점이 넘는다. 노이즈가 아니다.

---

## 5. 비행기 외 고심각도 사고

비행기 상관관계는 이미 알려진 실패 모드다. 그렇다면 지상에서는 무슨 일이
벌어지고 있는가? 비행기와 무관한 고심각도 사고만 걸러낸다.

```sql
SELECT roll_sku, severity, incident_type, notes
FROM consumer_incidents
WHERE incident_type != 'airplane'
  AND severity > 7
ORDER BY severity DESC
```

최상위 결과는 심각도 9의 `ULTRA_BUDGET_XTRM`이다. 메모: "Open floor plan.
No music. The third floor is now the second floor people."
(오픈형 사무실. 음악 없음. 이제 3층이 2층 사람들이 됐다.)

softness_score = 0.0인 제품이 데이터셋에서 비행기 외 가장 심각한 사고를 일으키고
있다.

---

## 6. 공급망: 쿼리 하나로 네 단계 추적

외래 키 체인은 소비자 사고에서 시작해 공급망 전체를 관통한다. 테이블을 하나씩
따라가는 대신, 이 JOIN은 네 단계를 한 번에 가로질러 제품 하나의 전체 경로를
드러낸다.

```sql
SELECT
  ci.roll_sku,
  ci.severity,
  ci.notes                          AS incident_note,
  pb.quality_score,
  pb.recall,
  f.name                            AS facility_name,
  f.vibe_score,
  bc.alias                          AS supplier_alias,
  bc.territory,
  bc.our_relationship               AS supplier_relationship
FROM consumer_incidents ci
JOIN rolls r             ON r.sku = ci.roll_sku
JOIN production_batches pb ON pb.id = r.batch_id
JOIN facilities f        ON f.id = pb.facility_id
JOIN bamboo_cartel_members bc ON bc.id = f.bamboo_supplier_id
WHERE ci.roll_sku = 'ULTRA_BUDGET_XTRM'
ORDER BY ci.severity DESC
```

체인: `ULTRA_BUDGET_XTRM`은 Shanghai Liaison Office(상하이 연락사무소,
vibe_score = 3.2)의 배치 5(quality_score = 4.1, recall = true)에서 생산됐고,
`our_relationship = 'embargo'` 상태인 `Bamboo Don`이 공급했다.

근본 원인은 외래 키 네 단계 아래에 있다. 아직도 출하되는 이 제품은 리콜됐었고,
평점 낮은 시설에서 생산됐으며, 현재 금수 조치 중인 공급업체에서 조달됐다.

> **그리드:** 이 결과는 폭이 넓다. 아무 행에서나 `K`를 누르면 세로 키-값 뷰로 본다.
> `V`로 두 행을 비주얼 선택한 뒤 `K`를 누르면 두 행을 한 플로트에 쌓아 보여준다.
> `gQ`는 쿼리 플랜을 열어 데이터베이스가 조인을 어떻게 실행하는지 보여준다.
> FK 컬럼에서 `gf`를 누르면 참조 대상 테이블로 따라가고, 참조되는 행에서 `gm`을
> 누르면 그 행을 가리키는 행들을 연다. `gE`는 현재 페이지 또는 조건에 맞는 모든
> 행을 내보낸다.

---

## 7. 검토되지 않은 위협 댓글

정보부는 `conspiracy_adjacent`(음모론 인접) 컬럼이 있는 `youtube_comments`
테이블을 관리한다. NULL은 아직 검토되지 않은 댓글이라는 뜻이다. 미검토 댓글을
감성 점수가 가장 나쁜 순으로 뽑는다.

```sql
SELECT channel_name, comment_text, sentiment_score
FROM youtube_comments
WHERE conspiracy_adjacent IS NULL
ORDER BY sentiment_score ASC
LIMIT 20
```

미검토 댓글 샘플:

- "Look into the Shanghai supplier before you buy this brand."
  (이 브랜드 사기 전에 상하이 공급업체부터 알아봐라.)
- "Has anyone else noticed the sheets are thinner than they used to be?"
  (휴지가 예전보다 얇아진 거 나만 느낌?)
- "Why is this product 15% smaller than it was in 2018?"
  (이 제품은 왜 2018년보다 15% 작아졌나?)

DuckDB 전체 픽스처에는 미검토 대기열에 댓글이 193개 있고, 축소된 SQLite 대체
모드는 대표 행 두 개만 유지한다. 위협 환경은 위협 평가팀이 처리하는 속도보다
빠르게 커지고 있다.

---

## 8. Reddit 위협 환경

YouTube 대기열은 내부용이다. Reddit 쪽은 공개되어 있고, 규모와 위협 수준으로
추적할 수 있다.

```sql
SELECT
  subreddit,
  COUNT(*)                        AS thread_count,
  SUM(upvotes)                    AS total_upvotes,
  ROUND(AVG(threat_level), 1)     AS avg_threat_level,
  MAX(upvotes)                    AS top_post_upvotes
FROM reddit_threads
WHERE mentions_softrear = true
GROUP BY subreddit
ORDER BY total_upvotes DESC
```

총 추천수는 `r/brandconspiracies`가 1위다. 평균 위협 수준은 `r/softreartruth`가
가장 높다. 겹치는 지점: r/brandconspiracies의 5번 글은 "I work in supply chain
and I'm not allowed to say what I know about Softrear."(공급망에서 일하는데
Softrear에 대해 아는 걸 말하면 안 된다.)라고 적혀 있다. 추천 67,420개.

---

## 9. BambooKnows의 흔적

한 YouTube 댓글 작성자가 "formula"(제조법)라는 단어를 썼다. 그 작성자는
`suspicious_persons`에 프로필이 있고, 진행 중인 내부 조사 대상이다.

```sql
SELECT
  yc.comment_text,
  yc.sentiment_score,
  sp.alias,
  sp.knows_too_much,
  ii.status,
  ii.finding
FROM youtube_comments yc
JOIN suspicious_persons sp  ON sp.id = yc.commenter_id
JOIN internal_investigations ii ON ii.id = sp.investigation_id
WHERE sp.knows_too_much = true
```

작성자는 YouTube 팔로워 72,400명의 `BambooKnows`, `knows_too_much = true`.
조사 상태: `they_got_us`(들켰다). 결론: `they have the recipe`(그들이 레시피를
가졌다).

`they_got_us`는 이 스키마에서 유효한 상태 값이다. 결론은 네 단어다. 기록에 다른
메모는 없다.

> **AI:** 그리드에서 `A`를 누르고 후속 질문을 자연어로 적는다:
> "knows_too_much가 true이고 조사가 진행 중인 youtube 댓글을 모두 보여줘."
> AI는 현재 스키마를 알고 있으므로 JOIN을 대신 작성해 준다.

---

## 9.5 위협 출처가 활동 중인지 확인

조사 결과는 `they_got_us`였다. 표준 다음 단계: 각 출처가 아직 온라인인지
검증한다.

`suspicious_persons` 테이블을 연다. 2번 행 BambooKnows로 이동한다.
`profile_url` 셀을 `i`로 열고, `<Esc>`로 NORMAL 모드에 들어간 뒤 `gx`를 누른다.

브라우저가 bamboo toilet paper truth(대나무 휴지의 진실) YouTube 검색을 연다.
이 채널은 최근에도 업로드했다. 상태 필드 `they_got_us`는 정확한 것으로 확인됐다.

5번 행 GalileoOfToiletPaper에도 똑같이 해본다. 위협 평가팀이 `profile_url`
필드에 메모를 남겨 두었다: 링크는 열린다. 릭 애슬리 영상이다. 구독자 47,000명은
아직도 보고 있다.

이제 이건 조사관의 문제다.

---

## 10. 우리를 눈치챈 사람들

조사는 BambooKnows에 닿았다. `people_on_to_us` 테이블에는 몇 명이 더 있고,
회사는 그들이 무엇을 아는지에 대해 무엇을 알고 있는가?

```sql
SELECT name, evidence_strength, what_they_know, our_response
FROM people_on_to_us
WHERE what_they_know LIKE '%formula%'
ORDER BY evidence_strength DESC
```

네 행이 일치한다. `our_response` 값:

```
legal_letter
acquired
coupon_sent
ignored
```

한 명은 인수(acquired)됐다. 스키마 CHECK 제약 조건의 `acquired` 응답 코드는
가정이 아니었다.

---

## 11. Greg 문제

품질 인증은 최후의 방어선이어야 한다. 인증 기록 전체를 뽑아, Greg가 직접 제품을
써봤는지 여부로 정렬한다.

```sql
SELECT
  roll_sku,
  score,
  certified_by,
  has_greg_tried_the_product,
  notes
FROM quality_certifications
WHERE roll_sku = 'ULTRA_BUDGET_XTRM'
ORDER BY has_greg_tried_the_product ASC, score ASC
```

Greg는 `ULTRA_BUDGET_XTRM`을 다섯 번 인증했다. 매번
`has_greg_tried_the_product = 0`, `score = 8`이었다.

`has_greg_tried_the_product = 1`인 유일한 행은 `score = 2`,
`certified_by = "Greg"`, 메모 "Greg was traveling. Filled in by Greg's
assistant. Not Greg."(Greg 출장 중. Greg의 비서가 대신 작성. Greg 아님.)이다.

이 데이터베이스에서 제품을 실제로 써본 사람은 Greg의 비서뿐이다. Greg는 써보지도
않고 다섯 번 인증했다.

---

## 12. 그들이 스스로에게 한 말

마지막 층은 내부 문서다: 명시적으로 무엇을 말했는지, 공개적으로 무엇을
인정했는지, 그리고 공개하지 않은 채 무엇을 정책으로 확정했는지.

```sql
SELECT directive, publicly_acknowledged, issued_by
FROM leadership_directives
ORDER BY publicly_acknowledged ASC
```

`publicly_acknowledged = false`인 지침 세 개:

- "Do not use the word 'disintegrate' in customer communications."
  (고객 커뮤니케이션에서 '분해된다'라는 단어를 쓰지 말 것.)
- "ULTRA_BUDGET_XTRM incidents are 'enhanced feedback opportunities'."
  (ULTRA_BUDGET_XTRM 사고는 '강화된 피드백 기회'다.)
- "Severity 10 = airplane correlation is internal classification only."
  (심각도 10 = 비행기 상관관계는 내부 분류 전용.)

`publicly_acknowledged = true`인 지침 하나:

- "Greg is authorized to self-certify all SKUs. This is intentional."
  (Greg는 모든 SKU를 자체 인증할 권한이 있다. 의도된 것이다.)

대중에게는 Greg 이야기를 했다. 커뮤니케이션 전략은 명확하다: 내부에서는 문제에
이름을 붙이고, 외부에서는 그 이름이 나오지 않도록 정책을 만든다.

---

## 13. 크로스 데이터베이스: 공급업체 정보

내부 조사는 Bamboo Don에 대한 금수 조치에서 끝난다. 유출된 공급업체 물류
데이터베이스가 그 관계의 반대편에서 무슨 일이 있었는지 보여준다. DuckDB와 SQLite가
둘 다 설치되어 있으면 `:GripStart`가 Neovim 데이터 디렉터리 아래에 일회용 공급업체
데이터베이스를 만들어 `supplier`로 attach한다. 스키마 사이드바에 그 세 테이블
`shipments`, `ingredient_tests`, `pricing`이 보인다. 데모가 축소 SQLite 대체
모드로 돌고 있다면 14–16절은 건너뛴다.

---

## 14. 신고 내용 vs 실제 내용

Bamboo Don의 모든 선적은 신고된 내용물이 기록된 채 도착했다. 시설이 실제로 받은
것과 비교해 본다.

<!-- Requires: duckdb+sqlite3 -->
```sql
SELECT
  s.ship_date,
  s.declared_contents,
  s.actual_contents,
  pb.quality_score,
  pb.recall
FROM supplier.shipments s
JOIN production_batches pb
  ON pb.facility_id = (
    SELECT id FROM facilities WHERE name LIKE '%Shanghai%'
  )
WHERE s.supplier_alias = 'Bamboo Don'
ORDER BY s.ship_date
```

모든 선적은 `Grade A Bamboo Fiber`(A등급 대나무 섬유)로 신고됐다. 리콜된 생산
배치에 대응하는 모든 행에서 `actual_contents` 컬럼은 `Grade C Mixed Pulp`(C등급
혼합 펄프)다. 리콜된 배치는 모두 알면서 잘못 표기한 입고 자재로 거슬러 올라간다.

---

## 15. 불합격한 원료 검사

라벨 바꿔치기는 공급업체 쪽에 문서 흔적을 남겼다. 원료 검사 기록에 무엇이
발견됐는지 나온다.

<!-- Requires: duckdb+sqlite3 -->
```sql
SELECT batch_ref, bamboo_grade, contaminant_level, passed, tester_notes
FROM supplier.ingredient_tests
WHERE passed = 0
ORDER BY contaminant_level DESC
```

불합격 검사 세 건. 가장 높은 오염도는 10점 만점에 8.7이다. 그 행의 검사자 메모:
"Sample relabeled before customs. Original grade: C."(세관 통과 전 샘플 라벨
교체. 원래 등급: C.)

오염도 8.7은 어떤 식품 인접 안전 기준도 통과하지 못한다. 라벨 교체는 세관 검사
전에 이루어졌다.

---

## 16. 가격 약정

라벨 교체를 낳은 경제적 동기는 가격 테이블에 있다.

<!-- Requires: duckdb+sqlite3 -->
```sql
SELECT supplier_alias, territory, price_per_ton, discount_pct, loyalty_tier
FROM supplier.pricing
ORDER BY discount_pct DESC
```

상하이 지역은 `loyalty_tier = 'founding_partner'`(창립 파트너) 조건으로 톤당
40% 덜 낸다. 다른 지역은 모두 정가를 낸다. 할인이 동기를 만들었고, 라벨 교체가
마진을 지켰다. 다 봤으면 detach한다:

```vim
:GripDetach supplier
```

---

## 17. 파이프로 새 단서 스테이징하기

조사에서 단서가 하나 더 나왔다. 편집 가능한 테이블을 열고, 아직 데이터베이스에
쓰지 않은 채로 가져온다:

```vim
:Grip people_on_to_us
:GripImport !printf 'id,name,platform,evidence_strength,what_they_know,our_response,investigation_id\n1001,Import Auditor,Forum,6,Knows the import path,ignored,\n1002,Pipe Witness,Chat,7,Saw the staged batch,coupon_sent,\n'
```

미리보기에서 `y`로 답한다. 두 행이 스테이징 표시와 함께 나타나지만
데이터베이스는 그대로다. `gs`로 두 `INSERT` 문을 확인한 다음, `u`를 한 번 누르면
가져온 배치 전체가 제거된다. 커밋 경로를 시험하려면 가져오기를 다시 실행하고
`a`를 누른다. 평소의 트랜잭션 확인 절차는 그대로 적용된다. 다음에 `:GripStart`를
실행하면 일회용 데이터베이스가 복원된다.

---

## Daily practice (일상 연습)

### 스키마를 전부 열지 않고 리포트 찾기

`gb`로 사이드바에 포커스를 두고 `H`로 접는다. `/`를 누르고 `incident_summary`를
입력한 뒤 Enter. 검색은 닫힌 그룹 안의 일치하는 객체도 드러낸다. 뷰에서 Enter를
누르면 열린다. `gb`로 사이드바로 돌아가 `F`로 검색을 지우면 이전 접힘 상태가
복원된다. `gw`로 그리드로 돌아간다. 이 요약은 실제 집계 뷰이므로 편집하지 말고
탐색과 내보내기만 한다.

SQL로 리포트를 실행할 수도 있다:

```sql
SELECT incident_type, incident_count, max_severity, open_count
FROM incident_summary
ORDER BY max_severity DESC, incident_count DESC
```

그리드에서 `max_severity`로 이동해 `s`로 정렬한다. `K`로 행을 세로로 살펴보고
`q`로 닫는다. `gX`로 파일로 내보내는데, 현재 페이지만 내보낼지 조건에 맞는 모든
행을 내보낼지 고른다. 좁은 패널에서는 단축키 힌트가 두 줄로 표시되고, 나머지
동작은 `?`로 볼 수 있다.

### 되돌릴 수 있는 편집 한 번 해보기

`:Grip consumer_incidents`로 원본 테이블을 연다. `<C-f>`를 누르고 `id = 1`을
입력해 확인한다. `severity`로 이동해 `i`를 누르고 `10`을 `9`로 바꾼 뒤 Enter로
셀을 스테이징한다. 데이터베이스에는 여전히 `10`이 들어 있다.

```text
셀 편집 -> 스테이징 -> gs: UPDATE 확인
                       | q: 미리보기 닫기
                       +-> u: 편집 되돌리기
                       `-> a: 쓰기 확정
```

`gs`를 눌러 보고, `q`로 미리보기를 닫은 다음, 먼저 `u`를 눌러 본다. 커밋 경로는
같은 편집을 반복하고 `gs`로 SQL을 확인한 뒤 `q`로 닫고, `a`를 눌러 확정한다.
`r`로 새로고침한다. `:GripStart`를 다시 실행하면 데모 원본 데이터가 복원된다.
같은 스테이징 경계가 17절의 가져온 배치에도 적용된다.

### SQL과 결과를 가까이 두기

그리드에서 `2`를 누르면 이 SQL 패드로 돌아온다. `gz`로 확대하고 `gz`를 다시
누르면 분할이 복원된다. SQL에서 `2`는 히스토리를 열어 이전 쿼리를 고르게 해준다.
메인 패널에서는 `gh`로도 히스토리를 연다. `gw`로 그리드로 돌아가 유용한 결과를
`gL`로 고정하고, `gJ`로 보존된 결과 사이를 전환한다.

재사용할 쿼리를 저장하려면 `:GripQuery`로 SQL을 열고 패드 내용을 그 SQL 하나로
바꾼 뒤 `<C-s>`를 누르고 이름을 붙인다. 저장 동작은 패드 전체를 저장하므로, 쿼리
하나만 남기려다 조사 노트북 전체를 저장하지 않도록 주의한다. `gq`는 저장된 쿼리를
불러온다. 이름 붙인 쿼리와 히스토리는 유지되지만, 저장하지 않은 패드와 현재 결과
레이아웃은 Neovim 종료 후 자동으로 복원되지 않는다.

### DuckDB의 reporting 스키마 탐색

이 부분은 DuckDB가 필요하다. SQLite에서는 위의 공용 요약이 평평한 객체 목록에
들어 있다. DuckDB 사이드바에서 `l`로 `reporting`을 펼친 뒤 Views 아래의
`reporting.monthly_incidents`를 연다. 스키마를 다시 접으려면 `gb`를 누르고
`reporting` 위로 이동해 `h`를 누른다. supplier attach 여부에 따라 원래 테이블은
`main` 또는 `softrear` 그룹에 나타난다.

```text
reporting
  Views (1)
    monthly_incidents
```

<!-- Requires: duckdb -->
```sql
SELECT month, incident_count, highest_priority
FROM reporting.monthly_incidents
ORDER BY month
```

이 리포트는 저장된 스칼라 매크로를 사용한다. SQL에서 호출해 본다:

<!-- Requires: duckdb -->
```sql
SELECT reporting.severity_label(4) AS low_priority,
       reporting.severity_label(8) AS high_priority
```

DuckDB 매크로는 호출 가능한 SQL 표현식이다. Dadbod Grip은 이를 사이드바에
PostgreSQL식 Functions로 나열하지 않는다. 실제 파티션 트리, 함수 소스, 부모 대
자식 쿼리를 연습하려면 일회용 로컬 데이터베이스에서 선택 사항인
[PostgreSQL lab](https://github.com/joryeugene/dadbod-grip.nvim/blob/main/demo/README.md#postgresql-schema-lab)을
이용한다.

---

## 발견한 것

처음의 세 질문에 이제 답이 있다.

**제품 품질 문제:** `ULTRA_BUDGET_XTRM`은 softness_score = 0.0이고, 심각도 9
사고를 냈으며, 생산 배치가 리콜됐다. 문제는 실재하고 문서로 남아 있다.

**원인:** 공급망은 상하이 연락사무소를 거쳐 현재 금수 조치 중인 공급업체
Bamboo Don으로 이어진다. Bamboo Don은 C등급 혼합 펄프를 A등급 섬유로 신고해
보냈고, 세관 통과 전에 라벨을 바꿨다. 40% 창립 파트너 할인이 금전적 동기를
만들었다.

**누가 아는가:** BambooKnows가 레시피를 갖고 있다(조사 상태: `they_got_us`).
제조법을 안다고 기록된 사람이 넷이고, 그중 한 명은 인수됐다.

**어떤 결정이 이렇게 만들었나:** 지침 세 개는 끝내 공개적으로 인정되지 않았다.
공개된 단 하나는 Greg의 자체 인증 권한이었다. Greg는 제품을 한 번도 써본 적이
없다. 데이터는 처음부터 여기 있었다.

---

## 더 알아보기

모든 결과 세트는 라이브 그리드다. 어느 화면에서든 `?`를 누르면 그 패널에 설정된
키를 볼 수 있다. 쿼리 패드에서 `gn`을 누르면 다른 SQL 또는 Markdown 노트북을 연다.

전체 기능 레퍼런스: https://jorypestorious.com/dadbod-grip-web/
