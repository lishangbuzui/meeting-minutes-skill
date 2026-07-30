Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageRoot = $PSScriptRoot
$source = Join-Path $packageRoot 'meeting-minutes'
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
    throw "Invalid package: meeting-minutes\SKILL.md was not found."
}

if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    $codexRoot = Join-Path $env:USERPROFILE '.codex'
} else {
    $codexRoot = [System.IO.Path]::GetFullPath($env:CODEX_HOME)
}

$skillsRoot = Join-Path $codexRoot 'skills'
$backupRoot = Join-Path $codexRoot 'skill-backups'
$target = Join-Path $skillsRoot 'meeting-minutes'
$staging = Join-Path $skillsRoot ('.meeting-minutes-install-' + [Guid]::NewGuid().ToString('N'))
$backup = $null
$newTargetInstalled = $false

New-Item -ItemType Directory -Path $skillsRoot -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $staging -Recurse -Force

try {
    if (Test-Path -LiteralPath $target) {
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backup = Join-Path $backupRoot ("meeting-minutes-$stamp")
        $backupSequence = 2
        while (Test-Path -LiteralPath $backup) {
            $backup = Join-Path $backupRoot ("meeting-minutes-$stamp-$backupSequence")
            $backupSequence++
        }
        Move-Item -LiteralPath $target -Destination $backup
    }

    Move-Item -LiteralPath $staging -Destination $target
    $newTargetInstalled = $true

    if (-not (Test-Path -LiteralPath (Join-Path $target 'agents\openai.yaml'))) {
        throw 'Installed skill is missing agents\openai.yaml.'
    }

    Write-Host ''
    Write-Host 'Meeting Minutes skill v1.0.0 installed successfully.' -ForegroundColor Green
    Write-Host "Installed at: $target"
    if ($null -ne $backup) {
        Write-Host "Previous version backup: $backup"
    }
    Write-Host 'Restart Codex Desktop or start a new task before first use.'
}
catch {
    if ($newTargetInstalled -and (Test-Path -LiteralPath $target)) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    if ((-not [string]::IsNullOrWhiteSpace($backup)) -and (Test-Path -LiteralPath $backup)) {
        Move-Item -LiteralPath $backup -Destination $target
    }
    throw
}
finally {
    if (Test-Path -LiteralPath $staging) {
        Remove-Item -LiteralPath $staging -Recurse -Force
    }
}
