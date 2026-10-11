# Sync labels: delete all in target, then recreate from source
$source = "67762961/.github"

$targets = @(
    "67762961/Csv_reader",
    "67762961/Paper_sweeper",
    "67762961/Mirror_export",
    "67762961/Driver_Tester",
    "67762961/Wave_controller"
)

$dryRun = $true

Write-Host ""
Write-Host "Source: $source" -ForegroundColor Yellow
Write-Host "Dry-Run: $dryRun" -ForegroundColor Yellow
Write-Host ""

Write-Host "[1/2] Fetching source labels ..." -ForegroundColor Cyan
$sourceLabels = gh api "repos/$source/labels?per_page=100" --paginate | ConvertFrom-Json

if (-not $sourceLabels) {
    Write-Host "  Failed to fetch source labels, aborting" -ForegroundColor Red
    exit 1
}

Write-Host "  Total $($sourceLabels.Count) labels:" -ForegroundColor Green
$sourceLabels | ForEach-Object { Write-Host "    - $($_.name)" -ForegroundColor Gray }
Write-Host ""

foreach ($repo in $targets) {
    Write-Host "========== $repo ==========" -ForegroundColor Magenta

    $targetLabels = gh api "repos/$repo/labels?per_page=100" --paginate | ConvertFrom-Json
    if ($null -eq $targetLabels) { $targetLabels = @() }

    Write-Host "  Existing: $($targetLabels.Count)" -ForegroundColor Gray

    # Step 1: delete ALL existing labels
    foreach ($t in $targetLabels) {
        Write-Host "    [delete] $($t.name)" -ForegroundColor Red
        if (-not $dryRun) {
            gh label delete "$($t.name)" --repo $repo --yes 2>$null | Out-Null
        }
    }

    # Step 2: create all source labels
    foreach ($label in $sourceLabels) {
        $name = $label.name
        $color = $label.color
        $desc = $label.description
        if ($null -eq $desc) { $desc = "" }

        Write-Host "    [create] $name" -ForegroundColor Green
        if (-not $dryRun) {
            gh label create "$name" --color "$color" --description "$desc" --repo $repo 2>$null | Out-Null
        }
    }

    Write-Host "  Done: $repo" -ForegroundColor Green
    Write-Host ""
}

Write-Host "All done." -ForegroundColor Cyan
if ($dryRun) {
    Write-Host "DRY RUN - no changes made." -ForegroundColor Yellow
    Write-Host "Set dryRun = false to apply." -ForegroundColor Yellow
}
