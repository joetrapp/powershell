#### Create new DHCP server and assign a default scope
#### Created: 7/28/2020

If (!(Get-WindowsFeature DHCP).Installed) {

    Write-Host "DHCP is not installed. Installing now."
    Install-WindowsFeature DHCP -IncludeManagementTools

    # Powershell doesn't add the DHCP Administrators and DHCP Users groups automatically when DHCP is installed
    Add-DhcpServerSecurityGroup
    Restart-Service DHCPServer

    # Delete the flag that says DHCP isn't configured correctly in Server Manager
    Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState –Value 2
    
}

$StartIP = "192.168.1.50"
$EndIP = "192.168.1.254"
$Netmask = "255.255.255.0"
$Gateway = "192.168.1.1"

$ScopeName = Read-Host -Prompt "Enter the new scope name"
$StartIP = Read-Host -Prompt "Enter the Starting IP address. Default is 192.168.1.50"
$EndIP = Read-Host -Prompt "Enter the Ending IP address. Default is 192.168.1.254"
$Netmask = Read-Host -Prompt "Enter the netmask for the DHCP scope. Default is 255.255.255.0"
$Gateway = Read-Host -Prompt "Enter the Default Gateway IP address. Default is 192.168.1.1"
$DNSServer = Read-Host -Prompt "Enter the DNS Server IP address"

	Add-DhcpServerv4Scope -Name $ScopeName -StartRange $StartIP -EndRange $EndIP -SubnetMask $Netmask

    # Will error but not stop script if no DNS server is detected
    Get-DhcpServerv4Scope | Where-Object {$_.Name -eq $ScopeName} | Set-DHCPServerv4OptionValue -DNSServer $DNSServer -Router $Gateway

	Write-Host "Your scope was created successfully"
	Start-Sleep 1