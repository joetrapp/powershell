$intid = get-netipinterface -addressfamily IPv4 -InterfaceAlias ethernet | select-object -ExpandProperty interfaceindex
route delete 0.0.0.0
set-netipinterface -interfaceindex $intid -dhcp enabled
ipconfig /renew