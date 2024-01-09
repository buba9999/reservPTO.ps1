$sourceFolder = "z:\PTO"
$destinationFolder = "F:\PTO"


# ���������, ���������� �� ����� �������� ������
if (!(Test-Path $sourceFolder)) {
    Write-Host "����� �������� ������ �� �������."
    exit
}

# ���������, ���������� �� ����� ����������. ���� ���, ������� ��
if (!(Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Force -Path $destinationFolder | Out-Null
}

# ������� ��� ������������ ����������� ������ � ����� � �������������� robocopy
function Copy-ItemsRecursively($source, $destination) {
    $robocopyOptions = "/E /PURGE /R:1 /W:1 /NP /NFL /NDL /NJH /NJS /NS /NC /LOG+:robocopy.log /XF ~*"

    $robocopyCommand = "robocopy `"$source`" `"$destination`" $robocopyOptions"
    Write-Host "������ robocopy: $robocopyCommand"
    Invoke-Expression $robocopyCommand
}

# �������� ����� � ����� �� ����� �������� ������ � ����� ���������� � �������������� robocopy
Write-Host "������ ����������� ������ � �����..."
try {
    Copy-ItemsRecursively $sourceFolder $destinationFolder
} catch {
    $errorMessage = $_.Exception.Message
    if ($errorMessage -match "Access to the path") {
        Write-Host "������ ������� � �����: $errorMessage"
    } else {
        throw
    }
}
Write-Host "����������� ������ � ����� ���������."