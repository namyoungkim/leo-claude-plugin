---
name: github-init
description: "GitHub repo 초기 설정 — repo 생성, labels, milestones, issues 일괄 등록. 트리거: /github-init"
disable-model-invocation: true
argument-hint: "[visibility: private|public]"
---

# /github-init — GitHub 리포지토리 초기 설정

프로젝트 디렉토리에서 GitHub repo를 생성하고, labels/milestones/issues를 일괄 설정한다.

## 전제 조건

- `gh auth status`로 GitHub CLI 인증 확인
- 현재 디렉토리가 git repo (`git rev-parse --is-inside-work-tree`)
- `docs/ROADMAP.md`에 Layer/Step 구조가 있을 것
- `docs/PROGRESS.md`에 Step 테이블이 있을 것

전제 조건이 충족되지 않으면 어떤 것이 부족한지 알려주고 멈춘다.

## 실행 단계

### 1. 사전 확인

```bash
gh auth status
git remote -v
```

- remote `origin`이 이미 있으면: "이미 remote가 설정되어 있습니다" 알리고, 2단계(Labels)부터 시작할지 사용자에게 확인
- remote가 없으면: 2단계로 진행

### 2. Repo 생성

```bash
gh repo create <owner>/<repo-name> --${visibility:-private} --source=. --remote=origin
git push -u origin main
```

- `<owner>`는 `gh api user --jq '.login'`으로 자동 감지
- `<repo-name>`은 현재 디렉토리명 사용
- visibility는 `$ARGUMENTS`에서 가져오며, 기본값은 `private`

### 3. Labels 생성

`labels.json`을 참조하여 labels를 생성한다. 이미 존재하는 label은 건너뛴다.

### 4. Milestones 생성

`docs/ROADMAP.md`를 Read로 읽어서 Layer/섹션 구조를 파악한다.

각 Layer/섹션을 Milestone으로 생성:
- title: 섹션 제목 (예: "Layer 1 — 서버 기반")
- description: 해당 섹션의 Step 요약

### 5. Issues 생성

`docs/PROGRESS.md`를 Read로 읽어서 Step 테이블을 파싱한다.

각 Step을 Issue로 생성:
- title: `Step {id}: {설명}`
- body: 완료 조건 (ROADMAP.md에서 추출 가능하면 포함)
- labels: Layer에 해당하는 label + 관련 label (PROGRESS.md 비고 참조)
- milestone: 해당 Layer의 Milestone

### 6. PROGRESS.md 업데이트

생성된 Issue 번호를 PROGRESS.md의 Issue 컬럼에 반영한다.

- Issue 컬럼이 없으면 컬럼을 추가한다
- 이미 Issue 번호가 있는 행은 건너뛴다

### 7. 결과 리포트

```
┌─ GitHub Init ──────────────────────
│ Repo     https://github.com/{owner}/{repo}  {visibility}
│ Labels   {created}/{total}
│ Milestones  {created}/{total}
│ Issues   {created}/{total}
│ PROGRESS.md  {updated rows}/{total rows}
└────────────────────────────────────
```

## 규칙

- 이미 존재하는 리소스(label, milestone, issue)는 중복 생성하지 않는다
- Issue 제목 중복 검사: 같은 title의 open issue가 있으면 건너뛴다
- 에러 발생 시 해당 항목을 건너뛰고 계속 진행한다 (전체 중단하지 않음)
- 모든 `gh` 명령 실행 전 사용자에게 실행 계획을 보여주고 승인받는다
