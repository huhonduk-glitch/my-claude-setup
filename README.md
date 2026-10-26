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
| 플러그인 | superpowers | 질문 → 계획 → 테스트 순서로 개발 | [superpowers](https://github.com/huhonduk-glitch/superpowers) |
| 플러그인 | document-skills | 엑셀·워드·PPT·PDF | [anthropic-skills](https://github.com/huhonduk-glitch/anthropic-skills) |
| 플러그인 | ui-ux-pro-max | 화면 스타일·색·글꼴 자료 | [ui-ux-pro-max-skill](https://github.com/huhonduk-glitch/ui-ux-pro-max-skill) |
| 플러그인 | caveman | 답을 짧게 해서 사용량 아끼기 (`/caveman` 칠 때만 켜짐) | [caveman](https://github.com/huhonduk-glitch/caveman) |
| 플러그인 | taste-skill | AI 티 안 나는 디자인 규칙 | [taste-skill](https://github.com/huhonduk-glitch/taste-skill) |

hwpx 스킬용으로 **파이썬 3.12 + lxml + python-hwpx**도 함께 설치합니다.

## 새 스킬을 더하면

1. 원본 저장소를 내 GitHub에 포크
2. `setup.ps1`에 한 줄 추가
