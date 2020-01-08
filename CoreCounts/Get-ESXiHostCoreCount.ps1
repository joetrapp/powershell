#### Get physical core count for ESXi hosts
#### Connect-ViServer first

Get-VMHost | Measure-Object NumCPU -Sum