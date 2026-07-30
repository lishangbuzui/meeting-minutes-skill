param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string[]]$Edition
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$source = Get-Item -LiteralPath $SourcePath
if ($source.Extension -ine '.txt') {
    throw 'SourcePath must point to a .txt file.'
}

$invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
$results = foreach ($label in $Edition) {
    $safeLabelChars = foreach ($character in $label.ToCharArray()) {
        if ($invalidChars -contains $character) { '_' } else { $character }
    }

    $safeLabel = (-join $safeLabelChars).Trim().TrimEnd('.')
    if ([string]::IsNullOrWhiteSpace($safeLabel)) {
        throw 'Edition must contain at least one valid file-name character.'
    }

    $baseName = '{0}_{1}' -f $source.BaseName, $safeLabel
    $candidate = Join-Path $source.DirectoryName ($baseName + '.txt')
    $version = 2
    while (Test-Path -LiteralPath $candidate) {
        $candidate = Join-Path $source.DirectoryName ('{0}_v{1}.txt' -f $baseName, $version)
        $version++
    }

    [PSCustomObject]@{
        Edition = $label
        Path = $candidate
    }
}

ConvertTo-Json -InputObject @($results) -Depth 3
