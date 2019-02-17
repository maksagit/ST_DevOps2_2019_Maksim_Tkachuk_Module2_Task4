### 1. Вывести список всех классов WMI на локальном компьютере.

Get-WmiObject –list
# gwmi -list
# gwmi –namespace "root\cimv2" –list                    # root\cimv2 пространство имен по умолчанию