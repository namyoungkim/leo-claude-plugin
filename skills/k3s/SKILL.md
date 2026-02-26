---
name: k3s
description: "k3s 지식 베이스 검색. 축적된 카드에서 Principle/Pattern/Fact를 찾아 답변. 트리거: /k3s"
disable-model-invocation: true
argument-hint: "[질문]"
---

# k3s Knowledge Base

k3s 지식 베이스에서 축적된 카드를 검색하여 답변하는 스킬.

## $ARGUMENTS가 있는 경우

`k3s-master` 에이전트를 Task 서브에이전트로 호출하여 답변을 생성한다.

**반드시 아래 형식으로 Task 도구를 호출할 것:**

```
Task(
  subagent_type="leo-claude-plugin:k3s-master",
  description="k3s KB 검색",
  model="opus",
  prompt="다음 질문에 대해 k3s 지식 베이스를 검색하여 답변해줘: $ARGUMENTS"
)
```

현재 작업 컨텍스트(열린 파일, 진행 중인 작업 등)가 있다면 prompt에 추가하여 더 정확한 답변을 유도한다.

서브에이전트가 반환한 답변을 그대로 사용자에게 전달한다. 답변을 재가공하지 않는다.

## $ARGUMENTS가 없는 경우

Bash로 `kb coverage k3s` 를 실행하여 현재 카드 현황을 보여주고, 질문을 요청한다.

```
예시 출력:

k3s 지식 베이스 현황:
- 전체 N장 (Principle: N, Pattern: N, Fact: N)
- 커버리지: N% (N/N 소스 완료)

질문 예시:
- /k3s "HA 클러스터 구성 방법은?"
- /k3s "에어갭 설치 패턴"
- /k3s "Flannel 백엔드 옵션"
```
