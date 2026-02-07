---
name: product-planning
description: "인터뷰 기반 제품/프로젝트 기획 및 설계 스킬. Impact Mapping, User Story Mapping, C4 Model, ADR 순서로 기획 문서 생성. 트리거: 기획해줘, 설계해줘, 프로젝트 시작, PRD 만들어줘, 요구사항 정리, 아키텍처 설계"
argument-hint: "[프로젝트명]"
---

# Product Planning Skill

$ARGUMENTS가 제공된 경우, 해당 프로젝트명으로 기획 프로세스를 시작한다.

인터뷰 기반으로 제품/프로젝트를 근본적으로 기획하고 설계하는 스킬.

## 핵심 철학

```
"기능(What)은 목표(Why)에서 도출되어야 한다"
"모든 결정에는 근거가 있어야 한다"
```

## 프로세스 개요

```
┌─────────────────────────────────────────────────────────────────┐
│                    Planning Process                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Impact Mapping (인터뷰)                                │
│  └── Goal → Actors → Impacts → Deliverables                     │
│      "왜 만드는가?" → "뭘 만들까?"                               │
│                                                                 │
│  Step 2: User Story Mapping                                     │
│  └── 사용자 여정 → 스토리 → 우선순위                            │
│      "사용자가 어떻게 쓰는가?"                                   │
│                                                                 │
│  Step 3: C4 Model                                               │
│  └── Context → Container → Component                            │
│      "어떻게 구성되는가?"                                        │
│                                                                 │
│  Step 4: ADR                                                    │
│  └── 주요 결정 근거 기록                                        │
│      "왜 이렇게 결정했는가?"                                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 인터뷰 진행 방법

### 원칙

1. **한 번에 2-3개 질문만** - 사용자 피로 방지
2. **답변 기반 후속 질문** - 동적으로 조정
3. **최대 30개 질문** - 전체 인터뷰
4. **중간 정리** - 각 단계 완료 시 요약

### Step 1: Impact Mapping 인터뷰

Goal → Actors → Impacts → Deliverables 순서로 질문.

상세 질문 목록: [references/impact-mapping-questions.md](references/impact-mapping-questions.md)

```
Phase 1: Goal (Why)
- "이 프로젝트의 궁극적인 목표가 뭐야?"
- "6개월 후 '성공했다'고 느끼려면 뭐가 달성되어야 해?"
- "명시적으로 '이건 목표가 아니다'라고 할 것은?"

Phase 2: Actors (Who)
- "이 시스템의 사용자는 누구야?"
- "각 사용자가 얻고자 하는 가치는?"

Phase 3: Impacts (How)
- "이 시스템이 성공하면 사용자의 행동이 어떻게 바뀔까?"
- "현재 Pain Point는 뭐야?"

Phase 4: Deliverables (What)
- "그 변화를 위해 뭘 만들어야 해?"
- "MVP에 반드시 포함되어야 할 것은?"
```

### Step 2: User Story Mapping

Impact Mapping 결과를 사용자 여정으로 배치.

상세 가이드: [references/user-story-mapping-guide.md](references/user-story-mapping-guide.md)

```
1. Backbone 정의 (큰 활동 단계)
2. 각 활동별 User Story 도출
3. 우선순위별 수평 슬라이스 (MVP / Phase 2 / Phase 3)
4. MVP Validation Scenario 정의
```

### Step 3: C4 Model

아키텍처를 계층적으로 설계.

상세 가이드: [references/c4-model-guide.md](references/c4-model-guide.md)

```
C1: System Context - 외부 연결
C2: Container - 주요 기술 단위
C3: Component - 내부 구성요소
```

### Step 4: ADR

주요 결정 근거 기록.

상세 가이드: [references/adr-guide.md](references/adr-guide.md)

```
각 결정에 대해:
- Context: 왜 이 결정이 필요했는가?
- Options: 어떤 선택지가 있었는가?
- Decision: 무엇을 선택했는가?
- Rationale: 왜 이것을 선택했는가?
- Consequences: 이 결정의 결과는?
```

## 산출물

프로세스 완료 시 생성되는 문서:

```
docs/
├── 01_IMPACT_MAPPING.md
├── 02_USER_STORY_MAPPING.md
├── 03_C4_MODEL.md
└── 04_ADR.md
```

## 사용 예시

```
User: "새 프로젝트 기획해줘"

Claude: [이 스킬 활성화]
        "좋아, 근본적인 기획부터 시작하자.
        
        먼저 Goal에 대해 물어볼게.
        
        Q1. 이 프로젝트의 궁극적인 목표가 뭐야?
        Q2. 6개월 후 '성공했다'고 느끼려면?"
```

## 팁

- 사용자가 "잘 모르겠어"라고 하면 예시 제시
- 답변이 애매하면 구체화 질문
- 기술적 세부사항은 나중에 (Goal 먼저)
- 각 단계 완료 시 확인 받고 진행
