Get-VM | Where-Object -Property PowerState -eq "PoweredOff" | Select-Object -Property Name,@{Label="PoweredOffTime"; Expression={
    $_ | Get-ViEvent -Types  Info | Where-Object -Property FullFormattedMessage -Match "shutdown|powered off" |
    Sort-Object -Property CreatedTime  | Select-Object -Last 1 -ExpandProperty CreatedTime
    }} | Sort-Object -Property PoweredOff