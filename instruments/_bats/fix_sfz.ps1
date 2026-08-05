$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Step 1: Renaming .webm files on disk ===" -ForegroundColor Cyan
Get-ChildItem -Path ".\*" -Filter "*.webm" -Recurse | Where-Object { $_.Name -like "*#*" } | ForEach-Object {
    $oldName = $_.FullName
    $newName = $_.Name -replace '#', 's'
    Write-Host "Renaming file: $($_.Name) -> $newName" -ForegroundColor Yellow
    Rename-Item -Path $oldName -NewName $newName -Force
}

Write-Host "`n=== Step 2: Processing .sfz files ===" -ForegroundColor Cyan
Get-ChildItem -Path ".\*" -Filter "*.sfz" -Recurse | ForEach-Object {
    $sfzFile = $_.FullName
    Write-Host "Processing SFZ: $($_.Name)" -ForegroundColor Green
    
    $content = Get-Content -Path $sfzFile -Encoding UTF8
    $newContent = @()

    foreach ($line in $content) {
        if ($line -match 'sample=(?!"?)(.+)$') {
            $rawPath = $Matches[1].Trim()
            $fixedPath = $rawPath -replace '#', 's'
            $newLine = $line -replace 'sample=(?!"?)(.+)$', "sample=`"$fixedPath`""
            $newContent += $newLine
        } else {
            if ($line -match 'sample="(.+?)"') {
                $fixedLine = $line -replace '#', 's'
                $newContent += $fixedLine
            } else {
                $newContent += $line
            }
        }
    }

    [System.IO.File]::WriteAllLines($sfzFile, $newContent, (New-Object System.Text.UTF8Encoding($false)))
}

Write-Host "`nDone! All tasks completed successfully." -ForegroundColor Green
