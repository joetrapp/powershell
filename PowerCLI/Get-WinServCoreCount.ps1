$WinServ = Get-VM | Get-VMGuest | Where-Object {$_.OsFullName -like "*Windows Server"} | Select-Object VMName ; Get-VM -Name $WinServ.VMName | Measure-Object NumCPU -Sum