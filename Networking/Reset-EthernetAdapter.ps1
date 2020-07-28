#### Reset static IP computer to DHCP
#### Created: YVC-era

$intid = Get-NetIPInterface -addressfamily IPv4 -InterfaceAlias ethernet | Select-Object -ExpandProperty interfaceindex
route delete 0.0.0.0
Set-NetIPInterface -interfaceindex $intid -dhcp enabled
ipconfig /renew