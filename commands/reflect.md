---
name: reflect
description: "세션 회고 및 자기 개선. @reflector 에이전트를 호출하여 분석 실행"
allowed-tools: Bash, Read, Edit, Grep, Glob, AskUserQuestion
disable-model-invocation: true
---

# Session Reflection

이번 세션을 회고하고 시스템을 개선해줘.

## 실행 방법

`@reflector` 에이전트를 호출하여 세션 분석을 위임한다.

에이전트가 분석 결과를 반환하면, 사용자에게 제안을 제시하고 승인을 요청한다.
승인된 항목만 실제 파일에 반영한다.
