#Requires -Version 5.1
<#
Installs repository skills globally for Claude Code, Codex, or both.
Previous copies are backed up outside the skill discovery directory.

Usage:
  ./scripts/install.ps1              # install/update all skills
  ./scripts/install.ps1 -Target Both -RetireSuperseded
  ./scripts/install.ps1 -Skill notion   # install/update just one
  ./scripts/install.ps1 -WhatIf      # preview without copying
#>
param(
    [string]$Skill,
    [ValidateSet('Claude', 'Codex', 'Both')]
    [string]$Target = 'Claude',
    [switch]$RetireSuperseded,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"
if ($RetireSuperseded -and $Skill) { throw 'Retiring old names requires a full installation.' }

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot ".claude\skills"
$destinations = @()
if ($Target -in @('Claude', 'Both')) { $destinations += Join-Path $HOME '.claude\skills' }
if ($Target -in @('Codex', 'Both')) {
    $codexBase = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
    $destinations += Join-Path $codexBase 'skills'
}

if (-not (Test-Path $sourceRoot)) {
    Write-Error "No skills found at $sourceRoot"
    exit 1
}

$skillDirs = @(Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf
})
if ($Skill) {
    $skillDirs = $skillDirs | Where-Object { $_.Name -eq $Skill }
    if (-not $skillDirs) {
        Write-Error "No skill named '$Skill' found under $sourceRoot"
        exit 1
    }
}

function Assert-SafeChild([string]$Path, [string]$Root) {
    $full = [IO.Path]::GetFullPath($Path)
    $prefix = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw "Path escapes installation root: $full" }
    $cursor = $full
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Linked path is not supported: $cursor" }
        }
        $parent = Split-Path -Parent $cursor
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
}

$stamp = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0, 8)
foreach ($destination in $destinations) {
$destRoot = [IO.Path]::GetFullPath($destination)
$backupRoot = Join-Path (Split-Path -Parent $destRoot) "skill-backups\$stamp"
foreach ($dir in $skillDirs) {
    $dest = Join-Path $destRoot $dir.Name
    Assert-SafeChild $dest $destRoot
    Assert-SafeChild $dir.FullName $sourceRoot
    if (Get-ChildItem -LiteralPath $dir.FullName -Recurse -Force | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }) {
        throw "Linked source content is not supported: $($dir.FullName)"
    }
    $existed = Test-Path $dest

    if ($WhatIf) {
        $verb = if ($existed) { "would update" } else { "would install" }
        Write-Host "$verb $($dir.Name) -> $dest"
        continue
    }

    if ($existed) {
        $backup = Join-Path $backupRoot $dir.Name
        Assert-SafeChild $backup $backupRoot
        New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
        Move-Item -LiteralPath $dest -Destination $backup
    }
    New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
    Copy-Item -Recurse -Path $dir.FullName -Destination $dest

    # Skill tooling (e.g. web-design/tools) may have its own node_modules -
    # each install location bootstraps that independently (npm install), so don't
    # copy it wholesale here.
    Get-ChildItem -Path $dest -Recurse -Directory -Filter node_modules -ErrorAction SilentlyContinue |
        ForEach-Object {
            Assert-SafeChild $_.FullName $destRoot
            Remove-Item -LiteralPath $_.FullName -Recurse -Force -Confirm:$false
        }

    $verb = if ($existed) { "Updated" } else { "Installed" }
    Write-Host "$verb $($dir.Name) -> $dest"
}
if ($RetireSuperseded) {
    foreach ($name in Get-Content -LiteralPath (Join-Path $PSScriptRoot 'retired-skills.txt')) {
        if (-not $name -or $name.StartsWith('#')) { continue }
        if ($name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { throw "Invalid retired name: $name" }
        if (Test-Path -LiteralPath (Join-Path $sourceRoot $name)) { throw "Cannot retire current skill: $name" }
        $old = Join-Path $destRoot $name
        Assert-SafeChild $old $destRoot
        if (-not (Test-Path -LiteralPath $old)) { continue }
        $backup = Join-Path $backupRoot $name
        Assert-SafeChild $backup $backupRoot
        if ($WhatIf) { Write-Host "Would retire $name -> $backup"; continue }
        New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
        Move-Item -LiteralPath $old -Destination $backup
        Write-Host "Retired $name -> $backup"
    }
}
if (-not $WhatIf -and (Test-Path -LiteralPath $backupRoot)) { Write-Host "Previous copies: $backupRoot" }
}

Write-Host ""
if ($WhatIf) { Write-Host 'Preview complete; no files changed.' }
else { Write-Host "Done. Skills installed globally for $Target." }
