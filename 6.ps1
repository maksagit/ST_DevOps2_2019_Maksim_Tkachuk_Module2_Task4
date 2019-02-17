### 6. Вывести свободное место на локальных дисках. На каждом и сумму.

$ArrayLogicalDisks = Get-WmiObject -Class "Win32_LogicalDisk" | Select-Object DeviceID, FreeSpace, VolumeName
[float]$SumDiskFreeSpace = 0
foreach ($LogicalDisk in $ArrayLogicalDisks){
    # Суммирование свободного места локальных дисков
    $SumDiskFreeSpace += ($LogicalDisk.FreeSpace / 1Gb)
    # Буква логического диска
    [string]$LetterDisk = $LogicalDisk.DeviceID                                                          
    # Вывод и кругление до трех цифр после точки свободного места логического диска
    Write-Output ("Disk $LetterDisk FreeSpace = {0:n3} Gb" -f ($LogicalDisk.FreeSpace / 1Gb))    
}
Write-Output ("Total FreeSpace = {0:n3} Gb" -f $SumDiskFreeSpace)