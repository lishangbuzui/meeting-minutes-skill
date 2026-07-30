param(
    [string]$Directory = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$resolvedDirectory = (Resolve-Path -LiteralPath $Directory).Path
$editionSuffix = [System.Text.RegularExpressions.Regex]::Escape([string][char]0x7248)
$generatedPattern = '_.*' + $editionSuffix + '(?:_v\d+)?$'

$files = @(
    Get-ChildItem -LiteralPath $resolvedDirectory -File -Filter '*.txt' |
        Sort-Object Name |
        ForEach-Object {
            [PSCustomObject]@{
                Name = $_.Name
                FullPath = $_.FullName
                SizeBytes = $_.Length
                LastWriteTime = $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
                LikelyGeneratedMinutes = ($_.BaseName -match $generatedPattern)
            }
        }
)

ConvertTo-Json -InputObject $files -Depth 3
