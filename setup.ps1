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

# 시스메이커 스킬 4개 (비공개 저장소라 gh 로그인이 필요)
$sm = Join-Path $env:TEMP "sysmaker-materials-$(Get-Random)"
if (Get-Command gh -ErrorAction SilentlyContinue) { gh repo clone "$me/sysmaker-materials" $sm -- --depth 1 }
if (Test-Path (Join-Path $sm 'sysmaker-shorts-starter')) {
  $map = @{
    'guideline-check'     = 'sysmaker-guideline-check\지침점검\.claude\skills\guideline-check'
    'find-topics-lite'    = 'sysmaker-shorts-starter\.claude\skills\find-topics-lite'
    'shorts-script'       = 'sysmaker-shorts-starter\.claude\skills\shorts-script'
    'first-short-by-hand' = 'sysmaker-shorts-starter\.claude\skills\first-short-by-hand'
  }
  foreach ($k in $map.Keys) {
    $dst = Join-Path $skills $k
    if (-not (Test-Path $dst)) { Copy-Item -Recurse (Join-Path $sm $map[$k]) $dst }
  }
  Remove-Item -Recurse -Force $sm
} else {
  Write-Host '시스메이커 스킬은 건너뜀: gh auth login 후 다시 실행하세요.' -ForegroundColor Yellow
}

# 스마트대디 영상 편집 스킬 (비공개 저장소). git 폴더째 받아서 '내 규칙'을 올리고 받을 수 있게
Step '스킬: smartdaddy-video-edit'
$vid = Join-Path $skills 'smartdaddy-video-edit'
if (Test-Path (Join-Path $vid '.git')) { git -C $vid pull --ff-only }
elseif (Get-Command gh -ErrorAction SilentlyContinue) { gh repo clone "$me/smartdaddy-video-edit" $vid }
else { Write-Host '영상 편집 스킬은 건너뜀: gh auth login 후 다시 실행하세요.' -ForegroundColor Yellow }

# REA (reverse-engineer-anything 스킬 + rea MCP 서버)
Step 'REA: reverse-engineer-anything'
if (Get-Command npx -ErrorAction SilentlyContinue) { npx -y rea-agents@6.7.0 setup --client claude_code --yes }
else { Write-Host 'Node.js가 없어 REA를 건너뜀: winget install OpenJS.NodeJS.LTS 후 다시 실행하세요.' -ForegroundColor Yellow }

# 2. 플러그인 (내 GitHub 포크에서)
Step '플러그인: superpowers, document-skills, ui-ux-pro-max, caveman, taste-skill'
$plugins = @(
  @{ repo = 'superpowers';         id = 'superpowers@superpowers-dev' },
  @{ repo = 'anthropic-skills';    id = 'document-skills@anthropic-agent-skills' },
  @{ repo = 'ui-ux-pro-max-skill'; id = 'ui-ux-pro-max@ui-ux-pro-max-skill' },
  @{ repo = 'caveman';             id = 'caveman@caveman' },
  @{ repo = 'taste-skill';         id = 'taste-skill@taste-skill' },
  @{ repo = 'claude-hud';          id = 'claude-hud@claude-hud' },
  @{ repo = 'youtube-agent-skill'; id = 'youtube-agent@youtube-agent-skill' }
)
foreach ($p in $plugins) {
  claude plugin marketplace add "$me/$($p.repo)"
  claude plugin install $p.id --scope user
}

# 공식 장터 플러그인
Step '공식 플러그인: frontend-design, context7, playwright'
claude plugin marketplace add anthropics/claude-plugins-official
foreach ($id in 'frontend-design', 'context7', 'playwright') {
  claude plugin install "$id@claude-plugins-official" --scope user
}

# claude-hud 상태줄 켜기 (/claude-hud:setup 과 같은 일)
Step 'claude-hud 상태줄'
$hud = Get-ChildItem (Join-Path $HOME '.claude\plugins\cache\claude-hud\claude-hud') -Directory -ErrorAction SilentlyContinue |
  Sort-Object Name | Select-Object -Last 1
if ($hud -and (Get-Command node -ErrorAction SilentlyContinue)) {
  $sh = if (Get-Command bash -ErrorAction SilentlyContinue) { 'gitbash' } else { 'powershell' }
  node (Join-Path $hud.FullName 'scripts\setup.mjs') install --shell $sh
} else {
  Write-Host 'Node.js가 없어 상태줄을 못 켰습니다. winget install OpenJS.NodeJS.LTS 후 Claude Code에서 /claude-hud:setup' -ForegroundColor Yellow
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
  # 영상 편집 스킬용 패키지(받아쓰기·영상) + 모션 카드용 크로미움
  $vidReq = Join-Path $vid 'scripts\requirements.txt'
  if (Test-Path $vidReq) {
    & $py -m pip install --user --quiet -r $vidReq
    & $py -m playwright install chromium
  }
} else {
  Write-Host '파이썬 설치를 확인하지 못했습니다. 터미널을 새로 열고 다시 실행해 보세요.' -ForegroundColor Yellow
}

# 영상 편집 스킬용 ffmpeg
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  Step 'ffmpeg'
  winget install --id Gyan.FFmpeg -e --silent --accept-package-agreements --accept-source-agreements
}

# 설치 끝 표시: 저장소를 열 때 자동 설치(bootstrap.ps1)가 다시 돌지 않게
$done = Join-Path $HOME '.claude\.my-claude-setup-done'
Get-Date -Format s | Set-Content -Encoding ascii $done
Remove-Item -Force (Join-Path $HOME '.claude\.my-claude-setup-running') -ErrorAction SilentlyContinue

Step '끝. 터미널과 Claude Code를 새로 켜세요.'
claude plugin list
