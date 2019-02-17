### 8. Создать файл-сценарий вывода списка установленных программных продуктов
### в виде таблицы с полями Имя и Версия.

Get-WmiObject -Class "Win32_Product" | Select-Object Name, Version | Format-Table -AutoSize