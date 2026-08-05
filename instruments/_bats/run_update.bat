@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ===================================================
echo [1/2] Поиск файлов .sfz и обновление путей...
echo ===================================================

:: Запуск PowerShell напрямую из батника для обработки текста
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$files = Get-ChildItem -Path '.' -Filter '*.sfz' -Recurse;" ^
    "if ($files.Count -eq 0) { Write-Host 'Файлы .sfz в этой папке не найдены!' -ForegroundColor Yellow; exit };" ^
    "foreach ($f in $files) {" ^
    "    Write-Host 'Обработка файла: ' -NoNewline; Write-Host $f.Name -ForegroundColor Cyan;" ^
    "    $txt = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8);" ^
    "    $pattern = 'sample=(?:[^=\n\r]*/)?([^=\n\r]+?)\.[wW][aA][vV]\b';" ^
    "    $updated = $txt -replace $pattern, 'sample=samples/$1.webm';" ^
    "    [System.IO.File]::WriteAllText($f.FullName, $updated, [System.Text.Encoding]::UTF8);" ^
    "}"

echo.
echo ===================================================
echo [2/2] Процесс завершен!
echo ===================================================
echo Если выше возникли ошибки, они отобразятся здесь.
echo.
pause
