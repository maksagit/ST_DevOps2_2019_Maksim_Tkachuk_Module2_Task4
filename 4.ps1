### 4. Вывести информацию об операционной системе, не менее 10 полей.

$ArrayOperatingSystem = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object PSComputerName, BuildNumber, Status,`
Caption, NumberOfUsers, OSArchitecture, OSLanguage, SystemDrive , TotalVirtualMemorySize, FreeVirtualMemory
Write-Output($ArrayOperatingSystem)