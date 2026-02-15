# 플러그인 경로 확인

다음 명령어를 실행하여 이 플러그인의 설치 경로를 확인한다:

```bash
find ~/.claude -path "*/leo-claude-plugin/.claude-plugin/plugin.json" 2>/dev/null \
  | while IFS= read -r f; do
      d="$(dirname "$(dirname "$f")")";
      [ ! -f "$d/.orphaned_at" ] && echo "$d" && break;
    done
```

- 결과가 없으면 플러그인 미설치 상태. 사용자에게 설치 안내.
- `.orphaned_at` 파일이 있는 디렉토리는 이전 버전이므로 무시한다.

위 결과를 이 문서에서 `PLUGIN_ROOT`로 참조한다.
