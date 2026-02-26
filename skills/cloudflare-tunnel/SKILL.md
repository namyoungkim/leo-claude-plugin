---
name: cloudflare-tunnel
description: "Cloudflare Tunnel 지식 베이스 검색. 축적된 카드에서 Principle/Pattern/Fact를 찾아 답변. 트리거: /cloudflare-tunnel"
disable-model-invocation: true
argument-hint: "[질문]"
---

# Cloudflare Tunnel Knowledge Base

Cloudflare Tunnel 지식 베이스에서 축적된 카드를 검색하여 답변하는 스킬.

## $ARGUMENTS가 있는 경우

`cloudflare-tunnel-master` 에이전트를 Task 서브에이전트로 호출하여 답변을 생성한다.

**반드시 아래 형식으로 Task 도구를 호출할 것:**

```
Task(
  subagent_type="leo-claude-plugin:cloudflare-tunnel-master",
  description="Cloudflare Tunnel KB 검색",
  model="opus",
  prompt="다음 질문에 대해 Cloudflare Tunnel 지식 베이스를 검색하여 답변해줘: $ARGUMENTS"
)
```

현재 작업 컨텍스트(열린 파일, 진행 중인 작업 등)가 있다면 prompt에 추가하여 더 정확한 답변을 유도한다.

서브에이전트가 반환한 답변을 그대로 사용자에게 전달한다. 답변을 재가공하지 않는다.

## $ARGUMENTS가 없는 경우

Bash로 `kb coverage cloudflare-tunnel` 를 실행하여 현재 카드 현황을 보여주고, 질문을 요청한다.

```
예시 출력:

Cloudflare Tunnel 지식 베이스 현황:
- 전체 N장 (Principle: N, Pattern: N, Fact: N)
- 커버리지: N% (N/N 소스 완료)

질문 예시:
- /cloudflare-tunnel "터널 생성 및 설정 방법은?"
- /cloudflare-tunnel "프라이빗 네트워크 라우팅 구성"
- /cloudflare-tunnel "cloudflared 모니터링 및 로그 확인"
```
