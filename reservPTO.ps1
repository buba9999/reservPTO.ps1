$sourceFolder = "z:\PTO"
$destinationFolder = "F:\PTO"


# Проверяем, существует ли папка исходных файлов
if (!(Test-Path $sourceFolder)) {
    Write-Host "Папка исходных файлов не найдена."
    exit
}

# Проверяем, существует ли папка назначения. Если нет, создаем ее
if (!(Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Force -Path $destinationFolder | Out-Null
}

# Функция для рекурсивного копирования файлов и папок с использованием robocopy
function Copy-ItemsRecursively($source, $destination) {
    $robocopyOptions = "/E /PURGE /R:1 /W:1 /NP /NFL /NDL /NJH /NJS /NS /NC /LOG+:robocopy.log /XF ~*"

    $robocopyCommand = "robocopy `"$source`" `"$destination`" $robocopyOptions"
    Write-Host "Запуск robocopy: $robocopyCommand"
    Invoke-Expression $robocopyCommand
}

# Копируем файлы и папки из папки исходных файлов в папку назначения с использованием robocopy
Write-Host "Начало копирования файлов и папок..."
try {
    Copy-ItemsRecursively $sourceFolder $destinationFolder
} catch {
    $errorMessage = $_.Exception.Message
    if ($errorMessage -match "Access to the path") {
        Write-Host "Ошибка доступа к файлу: $errorMessage"
    } else {
        throw
    }
}
Write-Host "Копирование файлов и папок завершено."