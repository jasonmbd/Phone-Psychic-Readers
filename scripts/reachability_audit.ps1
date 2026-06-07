# Audit internal-link reachability from the homepage over built *.html files.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$host_ = "phonepsychicreaders.com"

$files = Get-ChildItem -Path $root -Filter *.html -File
function Slug-Of([string]$name) {
    $b = [System.IO.Path]::GetFileNameWithoutExtension($name)
    return $b
}

$allSlugs = @{}
foreach ($f in $files) { $allSlugs[(Slug-Of $f.Name)] = $true }

function Normalize([string]$href) {
    $h = $href.Trim()
    $h = ($h -split '#',2)[0]
    $h = ($h -split '\?',2)[0]
    if ([string]::IsNullOrWhiteSpace($h)) { return $null }
    if ($h -match '^(tel:|mailto:|javascript:|data:)') { return $null }
    $h = [regex]::Replace($h, '^https?://(www\.)?' + [regex]::Escape($host_), '', 'IgnoreCase')
    if ($h -match '^https?://') { return $null }   # external
    $h = $h.Trim('/')
    if ($h -eq '') { return 'index' }
    if ($h.ToLower().EndsWith('.html')) { $h = $h.Substring(0, $h.Length-5) }
    return $h
}

$hrefRe = [regex]'(?i)href\s*=\s*["'']([^"'']+)["'']'
$graph = @{}
foreach ($f in $files) {
    $s = Slug-Of $f.Name
    $html = Get-Content -Raw -LiteralPath $f.FullName -ErrorAction SilentlyContinue
    $targets = New-Object System.Collections.Generic.HashSet[string]
    if ($html) {
        foreach ($m in $hrefRe.Matches($html)) {
            $t = Normalize $m.Groups[1].Value
            if ($t -and $allSlugs.ContainsKey($t)) { [void]$targets.Add($t) }
        }
    }
    $graph[$s] = $targets
}

# BFS from index
$seen = New-Object System.Collections.Generic.HashSet[string]
[void]$seen.Add('index')
$q = New-Object System.Collections.Queue
$q.Enqueue('index')
while ($q.Count -gt 0) {
    $cur = $q.Dequeue()
    if ($graph.ContainsKey($cur)) {
        foreach ($n in $graph[$cur]) {
            if (-not $seen.Contains($n)) { [void]$seen.Add($n); $q.Enqueue($n) }
        }
    }
}

$pages = @($allSlugs.Keys | Where-Object { $_ -ne '404' })
$unreachable = @($pages | Where-Object { -not $seen.Contains($_) } | Sort-Object)
$reachableCount = ($pages | Where-Object { $seen.Contains($_) }).Count

Write-Output ("Total pages (excl. 404): {0}" -f $pages.Count)
Write-Output ("Reachable from homepage: {0}" -f $reachableCount)
Write-Output ("UNREACHABLE: {0}" -f $unreachable.Count)

function Get-Bucket([string]$s) {
    if ($s -match '-tarot-card-meanings?$') { return 'tarot-card' }
    if ($s -match '-phone-psychic$') { return 'city-landing' }
    foreach ($c in 'burbank','glendale','north-hollywood','toluca-lake','universal-city','sun-valley') {
        if ($s.StartsWith($c + '-')) { return "silo:$c" }
    }
    return 'other'
}
Write-Output "`n-- unreachable by category --"
$unreachable | ForEach-Object { Get-Bucket $_ } | Group-Object | Sort-Object Count -Descending |
    ForEach-Object { Write-Output ("{0,4}  {1}" -f $_.Count, $_.Name) }

Write-Output "`n-- sample unreachable (first 50) --"
$unreachable | Select-Object -First 50 | ForEach-Object { Write-Output ("   " + $_) }
