---
name: coding-problem-solver
description: "코딩 인터뷰 문제 풀이를 구조화된 형식으로 정리. 새 문제 풀이, 복습, 면접 준비에 사용. LeetCode, 프로그래머스, HackerRank 등 코딩 문제 링크가 포함된 경우 트리거. \"이 문제 풀어줘\", \"Two Sum 정리해줘\", \"코딩 문제 분석\", \"면접 준비용으로 정리\" 등의 요청 시에도 트리거."
argument-hint: "[문제 URL 또는 이름]"
---

# Coding Problem Solver

$ARGUMENTS가 제공된 경우, 해당 문제를 직접 분석하여 풀이를 시작한다.

코딩 인터뷰 문제를 Staff 레벨(10년차) 기준으로 구조화하여 정리한다.

## 출력 형식

[references/output-template.md](references/output-template.md) 템플릿을 따른다.

## 문제 풀이 프로세스

### Step 1: 문제 이해 (Problem Understanding)
- 입력/출력 형식 명확히 하기: "배열의 크기는 몇인가?", "음수도 포함되는가?"
- 제약조건 정리: 시간 제한, 메모리 제한, 값의 범위
- 엣지케이스 식별: 빈 입력, 단일 원소, 모두 같은 값, 매우 큰 입력
- 면접 관점: "면접에서 이 질문을 받았다면 어떤 명확화 질문을 할 것인가?"

### Step 2: 접근법 설계 (Algorithm Design)
- Brute Force부터 시작: 조건을 무시하고 단순하게
- 최소 2가지 접근법 제시: 시간과 공간 트레이드오프 명시
- 각 접근법의 장단점: "O(n²)이지만 구현이 간단", "O(n log n) 정렬 필요"
- 실용성 고려: 면접 시간 내에 구현 가능한 방법 선택

### Step 3: 코드 작성 (Implementation)
- 가독성 우선: 나중에 최적화하는 것이 쉽다
- 변수명 의미 있게: `left`, `right` (숨겨진 의미), `maxLen` (명확)
- 주석은 "왜"만: "왜 이 조건인가?"는 설명, "이 줄은 카운트"는 필요 없음
- 점진적 구현: 핵심 로직 먼저, 엣지 케이스 차례로

### Step 4: 검증 (Verification)
- 직접 테스트 케이스 도출: 정상 케이스, 엣지 케이스, 큰 입력
- 손으로 트레이스: 작은 예제로 직접 실행해보기
- 반례 찾기: "이 방법이 틀릴 수 있는 경우는?"

### Step 5: 복잡도 분석 (Complexity Analysis)
- 시간복잡도: 루프 깊이, 재귀 호출 분석
- 공간복잡도: 추가 자료구조, 호출 스택
- 최적성 논증: "이게 최선인가? 입력을 전부 봐야 하는가?"

## 핵심 알고리즘 패턴

| 패턴 | 언제 사용 | 대표 문제 | 시간복잡도 |
|------|---------|---------|-----------|
| **Two Pointers** | 정렬된 배열, 부분합, 역순 탐색 | Two Sum (sorted), Container With Most Water | O(n) |
| **Sliding Window** | 연속 부분 배열/문자열 조건 | Longest Substring Without Repeating, Max Consecutive Ones | O(n) |
| **Binary Search** | 정렬된 데이터, 답의 범위 탐색 | Search in Rotated Sorted Array, Median of Two Sorted Arrays | O(log n) |
| **BFS/DFS** | 그래프 탐색, 트리 순회, 연결 요소 | Number of Islands, Course Schedule | O(V+E) |
| **Dynamic Programming** | 최적 부분 구조, 중복 부분 문제 | Coin Change, Longest Common Subsequence | varies |
| **Greedy** | 각 단계 최선 선택이 전체 최선 | Activity Selection, Jump Game | O(n log n) |
| **Stack/Queue** | 괄호 매칭, 단조 스택, 레벨 순회 | Valid Parentheses, Daily Temperatures | O(n) |
| **Hash Map/Set** | 빈도 카운트, 중복 탐지, 매핑 | Two Sum, Group Anagrams | O(n) |
| **Heap/Priority Queue** | Top-K, 중간값, 정렬된 병합 | Merge K Sorted Lists, Find Median from Stream | O(n log k) |
| **Union-Find** | 연결 요소, 사이클 탐지, MST | Redundant Connection, Number of Connected Components | O(α(n)) |

## 복잡도 분석 가이드

### 시간복잡도 산출 방법
- 단일 루프: `for i in range(n)` → O(n)
- 중첩 루프: `for i in range(n) for j in range(n)` → O(n²)
- 재귀: 호출 깊이 × 호출당 작업량 (예: 이진 검색 깊이 log n)
- 분할정복: 마스터 정리 (예: merge sort T(n) = 2T(n/2) + O(n) → O(n log n))

### 공간복잡도 산출 방법
- 추가 배열: 크기에 비례 (예: 정렬용 배열 O(n))
- 재귀 호출 스택: 깊이만큼 (예: DFS 최악 O(n), 균형 트리 O(log n))
- 해시맵/셋: 저장 원소 수만큼 (예: 중복 제거 O(unique elements))

### 판단 기준: "이게 최적인가?"
- 입력을 한 번이라도 다 봐야 한다면: 최소 O(n)
- 비교 기반 정렬: 이론적 하한 O(n log n)
- "더 빠를 수 없을까?"가 아니라 "입력 특성상 이만큼은 필요한가?" 생각하기

## 면접 커뮤니케이션

### Think Aloud (생각 과정을 소리내어 말하기)
- "제가 이해한 문제는..." 로 시작: 요구사항 확인
- "먼저 브루트포스 방법은..." 으로 간단함부터
- "더 최적화하면..." 으로 개선 경로 제시

### 트레이드오프 명시
- "이 방법은 시간이 O(n)이지만 공간이 O(n) 더 필요합니다"
- "정렬이 필요해서 O(n log n)이 되지만, 이후 조회는 O(1)입니다"

### 의사코드 사용
- 코드 작성 전 의사코드로 접근법 합의: "리뷰어(면접관)가 동의하는지 확인"
- 구현 세부사항은 나중: 먼저 논리 구조 명확히

### 막혔을 때의 전략
- 작은 예제로 돌아가기: 손으로 푼 후 패턴 찾기
- 패턴 힌트 요청: "이 부분이 Two Pointers 패턴일까요?"
- 다른 접근법 시도: "A 방법이 막히면 B 방법을 생각해볼까요?"

## 흔한 실수 패턴

### Off-by-One Errors
- 인덱스 경계: `i < n` vs `i <= n`
- range 함수: `range(n)`은 0부터 n-1까지
- 루프 끝 포함 여부: "마지막 원소를 포함하는가?"

### Integer Overflow
- 큰 수 곱셈: `a * b`가 범위 초과 가능
- 누적합: 중간 계산값이 최종값보다 커질 수 있음
- 해결: long/BigInt 사용, 모듈로 연산 활용

### Null/빈 입력 처리
- 빈 배열/문자열: 크기 0인 경우 처리 필요
- Null 노드: 트리/그래프에서 null 체크
- 단일 원소: 엣지 케이스도 확인

### 정렬 가정하지 않기
- "입력이 정렬되어 있다고 가정하지 마라" ← 매우 흔한 실수
- 정렬이 필요하면 명시적으로: `Array.sort()` 호출 후 O(n log n) 카운트

### 중복 처리
- 같은 원소를 두 번 사용하는 문제: Set vs List 선택 신중히
- "각 원소를 최대 몇 번 쓸 수 있는가?" 확인

## 작성 지침

### 예시 섹션
- 12세가 이해할 수 있는 수준으로 작성
- 일상생활 비유 사용 (사탕 가게, 도서관, 줄 서기 등)
- 무식한 방법 → 똑똑한 방법 순서로 대비
- 왜 빠른지/좋은지 직관적으로 설명

### 시니어 평가 요소
10년차 Staff 레벨 면접에서 평가하는 핵심 역량:
- 요구사항 명확화 질문 능력
- 복수 접근법 제시 + 트레이드오프 분석
- 점진적 최적화 과정 시연
- 엣지 케이스 및 에러 핸들링 고려
- 테스트 케이스 직접 도출
- 확장성/스케일 관점 (대용량, 스트리밍 등)

### 면접 설명 가이드
- 30초 요약: 엘리베이터 피치 수준
- 예상 질문: 면접관이 물어볼 법한 후속 질문과 답변

### 실수 포인트
- 해당 문제에서 흔히 하는 실수
- 오프바이원, 엣지 케이스, 순서 등

### 복습 메모
- 사용자가 풀 때마다 추가할 수 있는 공간
- 처음 정리 시 비워둠
