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