Clear

# Check/Install DHCP feature
If ((Get-WindowsFeature DHCP).Installed -eq $False) {

Write-Host "DHCP is not installed. Installing now."

Install-WindowsFeature DHCP -IncludeManagementTools
# Powershell doesn't add the DHCP Administrators and DHCP Users groups automatically when DHCP is installed
Add-DhcpServerSecurityGroup
Restart-Service DHCPServer
# Delete the flag that says DHCP isn't configured correctly in Server Manager
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState –Value 2

}

# User interface
While($true) {

$opr0 = $null
$operation = $null

Do {

Clear

Write-Host "What operation would you like to perform?"
Write-Host ""
Write-Host "0) New DHCP Scope"
Write-Host "1) View all created scopes"
Write-Host "2) View options & usage statistics per scope"
Write-Host "3) Continue"
Write-Host ""
Write-Host "4) Exit"

Write-Host ""
Write-Host "Your current choice is:" $operation
Write-Host ""
$opr0 = Read-Host -Prompt "Type Number & Enter"

Clear

Switch ($opr0) {

	0 {$operation = "NewScope"}
	1 {$operation = "ViewScopes"}
	2 {$operation = "ViewScopesStatus"}
	3 {$opr0 = "CONT"}
   	4 {Exit}

}

Clear

}Until($opr0 -eq "CONT")

Switch ($operation) {

	NewScope {
	
	$ScopeName = Read-Host -Prompt "Enter the new scope name"
	$StartIP = Read-Host -Prompt "Enter the Starting IP address"
	$EndIP = Read-Host -Prompt "Enter the Ending IP address"
	$Netmask = Read-Host -Prompt "Enter the netmask for the DHCP scope"
	$Gateway = Read-Host -Prompt "Enter the Default Gateway IP address"
	$DNSServer = Read-Host -Prompt "Enter the DNS Server IP address"

	Add-DhcpServerv4Scope `
		-Name $ScopeName `
		-StartRange $StartIP `
		-EndRange $EndIP `
		-SubnetMask $Netmask

    # Will error but not stop script if no DNS server is detected
    Get-DhcpServerv4Scope | Where {$_.Name -eq $ScopeName} | Set-DHCPServerv4OptionValue -DNSServer $DNSServer -Router $Gateway

	Write-Host "Your scope was created successfully"
	Start-Sleep 2

	}

	ViewScopes {

    # Display all scopes
	Get-DhcpServerv4Scope | FT
    Write-Host ""
    Pause
	
	}

	ViewScopesStatus {

    # Display all scopes
	Get-DhcpServerv4Scope | FT
    Write-Host ""

    $ScopeSelect = Read-Host -Prompt "Which Scope would you like to view stats on? (Type ScopeID)"
	
	Get-DhcpServerv4ScopeStatistics -ScopeID $ScopeSelect | FT
    Write-Host ""
    Get-DhcpServerv4OptionValue -ScopeID $ScopeSelect | FT Name,Type,Value,OptionID
    Write-Host ""
    Pause

	}

}
}
