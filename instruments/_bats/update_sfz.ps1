# Ищем все .sfz файлы в текущей папке и во всех подпапках
$sfzFiles = Get-ChildItem -Path "." -Filter "*.sfz" -Recurse

foreach ($file in $sfzFiles) {
    Write-Host "Пересобираю пути в карте: $($file.Name)" -ForegroundColor Cyan
    
    # Читаем содержимое файла
    $content = Get-Content -Path $file.FullName -Raw
    
    # Регулярное выражение ищет 'sample=', затем любой старый путь/папки, 
    # имя файла с пробелами и расширение .wav или .WAV.
    # Меняет всё это на 'sample=samples/имя_файла.webm'
    $pattern = 'sample=(?:[^=\n\r]*/)?([^=\n\r]+?)\.[wW][aA][vV]\b'
    $updatedContent = $content -replace $pattern, 'sample=samples/$1.webm'
    
    # Сохраняем файл обратно в UTF-8 без BOM
    [System.IO.File]::WriteAllText($file.FullName, $updatedContent, [System.Text.Encoding]::UTF8)
}

Write-Host "Готово! Все пути изменены на 'samples/{имя_файла}.webm'." -ForegroundColor Green
pause
