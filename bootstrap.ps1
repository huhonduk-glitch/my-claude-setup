# 내 저장소의 .claude/settings.json (SessionStart 훅)이 부른다.
# 이 컴퓨터에 내 스킬·플러그인이 아직 없으면 setup.ps1을 새 창에서 돌린다. 한 번 끝나면 다시 돌지 않는다.
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$me = 'huhonduk-glitch'
$claude = Join-Path $HOME '.claude'
if (Test-Path (Join-Path $claude '.my-claude-setup-done')) { exit 0 }

$running = Join-Path $claude '.my-claude-setup-running'
if ((Test-Path $running) -and ((Get-Item $running).LastWriteTime -gt (Get-Date).AddHours(-2))) {
  Write-Output '내 스킬·플러그인 설치 창이 이미 돌고 있습니다. 끝나면 Claude Code를 새로 켜세요.'
  exit 0
}

# 다른 사람이 내 공개 저장소를 받았을 때는 설치하지 않는다 (GitHub 로그인이 나일 때만)
$login = $null
if (Get-Command gh -ErrorAction SilentlyContinue) { $login = gh api user -q .login 2>$null }
if ($login -ne $me) {
  Write-Output "이 컴퓨터에는 $me 의 스킬·플러그인이 아직 없습니다. 본인 컴퓨터라면 터미널에서 winget install GitHub.cli → gh auth login 을 한 뒤 Claude Code를 다시 여세요. 그러면 자동으로 설치됩니다."
  exit 0
}

New-Item -ItemType Directory -Force $claude | Out-Null
Get-Date -Format s | Set-Content -Encoding ascii $running
Start-Process powershell -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-NoExit', '-Command',
  "irm https://raw.githubusercontent.com/$me/my-claude-setup/main/setup.ps1 | iex"
Write-Output '새 컴퓨터라서 내 스킬·플러그인 설치 창을 열었습니다. 그 창에서 설치가 끝나면 Claude Code를 새로 켜세요.'
