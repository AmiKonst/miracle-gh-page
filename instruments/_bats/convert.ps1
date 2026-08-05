# Ищем все файлы .wav в текущей папке и глубже
$wavFiles = Get-ChildItem -Path "." -Filter "*.wav" -Recurse

foreach ($file in $wavFiles) {
    # Формируем путь для нового файла, меняя расширение на .webm
    $outputFile = [System.IO.Path]::ChangeExtension($file.FullName, ".webm")
    
    Write-Host "Конвертирую: $($file.Name)" -ForegroundColor Cyan
    
    # Запуск FFmpeg для кодирования в Opus без видеодорожки
    ffmpeg -y -i "$($file.FullName)" -vn -c:a libopus -b:a 128k "$outputFile" 2>$null
}

Write-Host "Готово! Все файлы обработаны." -ForegroundColor Green
pause
