# Pre-commit integrity gate — validates solid-principles-review-report.md
# Shared by: .githooks/pre-commit and Cursor beforeShellExecution (.cursor/hooks.json)

param(
    [switch]$CursorHook
)

$ErrorActionPreference = 'Stop'

$ReportPath = '5-governance/solid-principles-review-report.md'
$MaxAgeSeconds = 60
$FailMessage = 'Validaciones COD / SOLID KO, repita las validaciones'

function Write-CursorAllow {
    Write-Output '{"permission":"allow"}'
    exit 0
}

function Write-CursorDeny {
    param([string]$UserMessage, [string]$AgentMessage)
    $payload = @{
        permission    = 'deny'
        user_message  = $UserMessage
        agent_message = $AgentMessage
    } | ConvertTo-Json -Compress
    Write-Output $payload
    exit 2
}

function Fail-Gate {
    if ($CursorHook) {
        Write-CursorDeny -UserMessage $FailMessage -AgentMessage $FailMessage
    }
    [Console]::Error.WriteLine($FailMessage)
    exit 1
}

if ($CursorHook) {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { Write-CursorAllow }
    try {
        $input = $raw | ConvertFrom-Json
    }
    catch {
        Write-CursorAllow
    }
    $command = [string]$input.command
    if ($command -notmatch '(?i)git\s+commit') { Write-CursorAllow }
}

$repoRoot = Split-Path $PSScriptRoot -Parent
if (-not (Test-Path (Join-Path $repoRoot $ReportPath))) {
    $repoRoot = (Get-Location).Path
}

$fullPath = Join-Path $repoRoot $ReportPath
if (-not (Test-Path $fullPath)) {
    Fail-Gate
}

$raw = Get-Content -Path $fullPath -Raw -Encoding UTF8

if ($raw -notmatch '(?s)## Current audit\s*\r?\n(.*)\z') {
    Fail-Gate
}
$text = $Matches[1]

if ($text -notmatch '(?m)^\*\*Audit completed:\*\*\s*(.+)\s*$') {
    Fail-Gate
}
$auditRaw = $Matches[1].Trim()

if ($text -notmatch '(?m)^\*\*STATUS:\*\*\s*(\S+)\s*$') {
    Fail-Gate
}
$status = $Matches[1].Trim()

if ($status -ne 'PASS') {
    Fail-Gate
}

try {
    $auditTime = [datetime]::ParseExact($auditRaw, 'yyyy-MM-ddTHH:mm:ss', $null)
}
catch {
    Fail-Gate
}

$now = Get-Date
$ageSeconds = ($now - $auditTime).TotalSeconds
if ($ageSeconds -lt 0) { $ageSeconds = -$ageSeconds }

if ($ageSeconds -gt $MaxAgeSeconds) {
    Fail-Gate
}

if ($CursorHook) {
    Write-CursorAllow
}
exit 0
