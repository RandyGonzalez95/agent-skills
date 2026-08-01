#Requires -Version 5.1
<#
Installs every skill under .claude/skills into the user's global Claude Code
skills directory (~/.claude/skills), making them available in every project,
not just this repo.

Usage:
  ./scripts/install.ps1              # install/update all skills
  ./scripts/install.ps1 -Skill notion-skill   # install/update just one
  ./scripts/install.ps1 -WhatIf      # preview without copying
#>
param(
    [string]$Skill,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot ".claude\skills"
$destRoot = Join-Path $HOME ".claude\skills"

if (-not (Test-Path $sourceRoot)) {
    Write-Error "No skills found at $sourceRoot"
    exit 1
}

if (-not (Test-Path $destRoot)) {
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
}

$skillDirs = Get-ChildItem -Path $sourceRoot -Directory
if ($Skill) {
    $skillDirs = $skillDirs | Where-Object { $_.Name -eq $Skill }
    if (-not $skillDirs) {
        Write-Error "No skill named '$Skill' found under $sourceRoot"
        exit 1
    }
}

foreach ($dir in $skillDirs) {
    $dest = Join-Path $destRoot $dir.Name
    $existed = Test-Path $dest

    if ($WhatIf) {
        $verb = if ($existed) { "would update" } else { "would install" }
        Write-Host "$verb $($dir.Name) -> $dest"
        continue
    }

    if ($existed) {
        Remove-Item -Recurse -Force $dest -Confirm:$false
    }
    Copy-Item -Recurse -Path $dir.FullName -Destination $dest

    # Skill tooling (e.g. web-design-skill/tools) may have its own node_modules -
    # each install location bootstraps that independently (npm install), so don't
    # copy it wholesale here.
    Get-ChildItem -Path $dest -Recurse -Directory -Filter node_modules -ErrorAction SilentlyContinue |
        ForEach-Object { Remove-Item -Recurse -Force $_.FullName -Confirm:$false }

    $verb = if ($existed) { "Updated" } else { "Installed" }
    Write-Host "$verb $($dir.Name) -> $dest"
}

Write-Host ""
Write-Host "Done. Skills are installed globally and available in any Claude Code project."
