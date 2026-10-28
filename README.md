# 내 Claude Code 스킬·플러그인 설치

새 컴퓨터에서 PowerShell을 열고 아래 한 줄을 붙여넣으면 전부 설치됩니다.

```powershell
irm https://raw.githubusercontent.com/huhonduk-glitch/my-claude-setup/main/setup.ps1 | iex
```

먼저 있어야 하는 것: **git**, **Claude Code**(`claude` 명령), **winget**(윈도우 10·11에 기본으로 있음).
끝나면 터미널과 Claude Code를 새로 켭니다.

## 설치되는 것

| 종류 | 이름 | 하는 일 | 내 포크 |
|---|---|---|---|
| 스킬 | prompt-master | AI 도구별 프롬프트 만들기 | [prompt-master](https://github.com/huhonduk-glitch/prompt-master) |
| 스킬 | hwpx | 한글(HWPX) 문서 만들기·읽기·고치기 | [hwpxskill](https://github.com/huhonduk-glitch/hwpxskill) |
| 스킬 | grilling | 계획을 질문으로 꼼꼼히 따지기 | [mattpocock-skills](https://github.com/huhonduk-glitch/mattpocock-skills) |
| 스킬 | guideline-check · find-topics-lite · shorts-script · first-short-by-hand | 지침 점검 · 쇼츠 소재·대본·첫 편 (시스메이커) | 비공개 저장소 — `gh auth login` 해 둬야 받음 |
| 스킬 | smartdaddy-video-edit | 녹화본 → 컷·자막·효과음·모션 카드 넣은 CapCut 초안 (스마트대디) | 비공개 저장소 smartdaddy-video-edit — `gh auth login` 필요 |
| 스킬 | reverse-engineer-anything | 프로그램·앱 뜯어보기 (REA MCP 서버 포함) | npm `rea-agents` |
| 플러그인 | superpowers | 질문 → 계획 → 테스트 순서로 개발 | [superpowers](https://github.com/huhonduk-glitch/superpowers) |
| 플러그인 | document-skills | 엑셀·워드·PPT·PDF | [anthropic-skills](https://github.com/huhonduk-glitch/anthropic-skills) |
| 플러그인 | ui-ux-pro-max | 화면 스타일·색·글꼴 자료 | [ui-ux-pro-max-skill](https://github.com/huhonduk-glitch/ui-ux-pro-max-skill) |
| 플러그인 | caveman | 답을 짧게 해서 사용량 아끼기 (`/caveman` 칠 때만 켜짐) | [caveman](https://github.com/huhonduk-glitch/caveman) |
| 플러그인 | taste-skill | AI 티 안 나는 디자인 규칙 | [taste-skill](https://github.com/huhonduk-glitch/taste-skill) |
| 플러그인 | claude-hud | 아래 상태줄에 사용량·진행 상황 | [claude-hud](https://github.com/huhonduk-glitch/claude-hud) |
| 플러그인 | youtube-agent | 유튜브 대본(`/yt-script`)·제목·쇼츠 등 11개 | [youtube-agent-skill](https://github.com/huhonduk-glitch/youtube-agent-skill) |
| 플러그인 | frontend-design | 개성 있는 화면 디자인 | 공식 장터 |
| 플러그인 | context7 | 최신 공식 문서 찾아오기 (라이브러리 이름을 context7 서버로 보냄) | 공식 장터 |
| 플러그인 | playwright | 진짜 브라우저를 열어 눌러 보며 확인 | 공식 장터 |

hwpx 스킬용으로 **파이썬 3.12 + lxml + python-hwpx**, 영상 편집 스킬용으로 **faster-whisper 등 패키지·크로미움·ffmpeg**도 함께 설치합니다.

## 저장소를 열면 자동 설치

내 저장소에는 `.claude/settings.json`에 SessionStart 훅이 들어 있습니다. 새 컴퓨터에서 내 저장소를 받아 Claude Code로 열면, 이 컴퓨터에 아직 설치가 안 됐을 때 `bootstrap.ps1`이 `setup.ps1`을 새 창에서 돌립니다.

- 한 번 끝나면 `~/.claude/.my-claude-setup-done` 파일이 생겨 다시 돌지 않습니다. 다시 설치하려면 이 파일을 지우세요.
- GitHub 로그인(`gh auth login`)이 `huhonduk-glitch`일 때만 설치합니다. 다른 사람이 공개 저장소를 받아도 설치되지 않습니다.
- 새 컴퓨터에서 먼저 할 일: git, Claude Code 설치 → `winget install GitHub.cli` → `gh auth login`.

## 영상 편집 스킬의 '내 규칙' 맞추기

`~/.claude/skills/smartdaddy-video-edit`는 git 폴더입니다. "오늘 고친 거 스킬에 저장해 줘" 다음에 "영상 편집 스킬 깃에 올려 줘"라고 하면 다른 컴퓨터에서도 같은 규칙을 씁니다. 다른 컴퓨터는 `setup.ps1`을 다시 돌리거나 그 폴더에서 `git pull`.

## 새 스킬을 더하면

1. 원본 저장소를 내 GitHub에 포크
2. `setup.ps1`에 한 줄 추가
