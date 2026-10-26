# 내 Claude Code 스킬·플러그인 한 번에 설치 (Windows PowerShell)
# 쓰는 법: PowerShell에서
#   irm https://raw.githubusercontent.com/huhonduk-glitch/my-claude-setup/main/setup.ps1 | iex
# 먼저 필요한 것: git, Claude Code(claude 명령), winget

$ErrorActionPreference = 'Continue'
$me = 'huhonduk-glitch'
$skills = Join-Path $HOME '.claude\skills'
New-Item -ItemType Directory -Force $skills | Out-Null

function Step($t) { Write-Host "`n== $t" -ForegroundColor Cyan }

# 1. 스킬 (폴더째 넣는 것)
Step '스킬: prompt-master, hwpxskill, grilling'
foreach ($name in 'prompt-master', 'hwpxskill') {
  $dir = Join-Path $skills $name
  if (Test-Path $dir) { git -C $dir pull --ff-only }
  else { git clone "https://github.com/$me/$name.git" $dir }
}
$grill = Join-Path $skills 'grilling'
if (-not (Test-Path $grill)) {
  $tmp = Join-Path $env:TEMP "mattpocock-skills-$(Get-Random)"
  git clone --depth 1 "https://github.com/$me/mattpocock-skills.git" $tmp
  Copy-Item -Recurse (Join-Path $tmp 'skills\productivity\grilling') $grill
  Remove-Item -Recurse -Force $tmp
}

# 2. 플러그인 (내 GitHub 포크에서)
Step '플러그인: superpowers, document-skills, ui-ux-pro-max, caveman, taste-skill'
$plugins = @(
  @{ repo = 'superpowers';         id = 'superpowers@superpowers-dev' },
  @{ repo = 'anthropic-skills';    id = 'document-skills@anthropic-agent-skills' },
  @{ repo = 'ui-ux-pro-max-skill'; id = 'ui-ux-pro-max@ui-ux-pro-max-skill' },
  @{ repo = 'caveman';             id = 'caveman@caveman' },
  @{ repo = 'taste-skill';         id = 'taste-skill@taste-skill' }
)
foreach ($p in $plugins) {
  claude plugin marketplace add "$me/$($p.repo)"
  claude plugin install $p.id --scope user
}

# Caveman은 /caveman 을 칠 때만 켜지게
$cave = Join-Path $env:APPDATA 'caveman'
New-Item -ItemType Directory -Force $cave | Out-Null
$caveCfg = Join-Path $cave 'config.json'
if (-not (Test-Path $caveCfg)) { '{ "defaultMode": "manual" }' | Set-Content -Encoding ascii $caveCfg }

# 3. hwpx 스킬에 필요한 파이썬
Step '파이썬 3.12 + lxml + python-hwpx'
$py = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312\python.exe'
if (-not (Test-Path $py)) {
  winget install --id Python.Python.3.12 -e --scope user --accept-package-agreements --accept-source-agreements --silent
}
if (Test-Path $py) {
  & $py -m pip install --user --quiet lxml python-hwpx
  # 스킬이 부르는 python3 가 마이크로소프트 스토어로 빠지지 않게
  $py3 = Join-Path (Split-Path $py) 'python3.exe'
  if (-not (Test-Path $py3)) { Copy-Item $py $py3 }
  [Environment]::SetEnvironmentVariable('PYTHONUTF8', '1', 'User')
} else {
  Write-Host '파이썬 설치를 확인하지 못했습니다. 터미널을 새로 열고 다시 실행해 보세요.' -ForegroundColor Yellow
}

Step '끝. 터미널과 Claude Code를 새로 켜세요.'
claude plugin list
