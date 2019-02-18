### 1. Вывести список всех классов WMI на локальном компьютере.

Get-WmiObject –list
# gwmi -list
# gwmi –namespace "root\cimv2" –list                    # root\cimv2 пространство имен по умолчанию

### 2. Получить список всех пространств имён классов WMI. 

Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name
# Get-CimInstance -Namespace Root -ClassName __Namespace            # аналог команды

### 3. Получить список классов работы с принтером.

Get-WmiObject -List "*Printer*"

### 4. Вывести информацию об операционной системе, не менее 10 полей.

$ArrayOperatingSystem = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object PSComputerName, BuildNumber, Status,`
Caption, NumberOfUsers, OSArchitecture, OSLanguage, SystemDrive , TotalVirtualMemorySize, FreeVirtualMemory
Write-Output($ArrayOperatingSystem)

### 5. Получить информацию о BIOS.

Get-WmiObject -Class "Win32_BIOS"

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

### 7. Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.
[CmdletBinding(PositionalBinding=$false)]
Param 
(
    [parameter (Mandatory = $true, HelpMessage = "Enter IP of Computer", Position = 0)]
    [string]$IpOfComputerPing,

    [parameter (Position = 1)]
    [int]$Times = 3
)

$SumTimePing = 0
for ([int]$i = 0; $i -lt $Times; $i++)
{
    $Ping = Get-WmiObject -Query "select * from win32_pingstatus where Address='$IpOfComputerPing'"       # ping IP
    Write-Output ("Response from " + $Ping.PSComputerName + " to $IpOfComputerPing : " + "bytes=" + $Ping.BufferSize`
    + " time=" + $Ping.ResponseTime + " ms TTL=" + $Ping.TimeToLive)
    $SumTimePing += $Ping.ResponseTime
}
Write-Output("Total time of response to $IpOfComputerPing = $SumTimePing ms")

### 8. Создать файл-сценарий вывода списка установленных программных продуктов
### в виде таблицы с полями Имя и Версия.

Get-WmiObject -Class "Win32_Product" | Select-Object Name, Version | Format-Table -AutoSize

### 9. Выводить сообщение при каждом запуске приложения MS Word.

try {
    if ((Get-EventSubscriber -SourceIdentifier "MSWordRun"))     # If MSWordRun event exist, then event delete and register new.
    {
        Unregister-Event -SourceIdentifier "MSWordRun"
        # The event when MS WORD will start. 
        Register-WmiEvent -Query "Select * From __instancecreationevent within 5 where targetinstance isa 'Win32_Process' and targetinstance.name='WINWORD.EXE'" `
        -sourceIdentifier "MSWordRun" -Action { Write-Host "Microsoft Word has been started." }
        Write-Output ("MSWordRun event existed")
    }
}
catch{
    # The event when MS WORD will start.
    Register-WmiEvent -Query "Select * From __instancecreationevent within 5 where targetinstance isa 'Win32_Process' and targetinstance.name='WINWORD.EXE'" `
    -sourceIdentifier "MSWordRun" -Action { Write-Host "Microsoft Word has been started." }
    Write-Output ("MSWordRun event no existed")
}

# Unregister-Event -SourceIdentifier "MSWordRun"                # Delete "MSWordRun" event