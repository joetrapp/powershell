#### Install ADDS and create a new forest then promote the server to a DC
#### Created: Powershell scripting 101 @ YVC
Clear-Host

# Check for ADDS Status
$ADStatus = (Get-WindowsFeature ad-domain-services).Installed

# Install ADDS/Mgmt tools if AD-Domain-Services is not installed
If ($ADStatus -eq $False) {

	Write-Host "ADDS is being installed. This may cause the system to reboot. Run this script again after restart to promote server to DC and install DNS" -BackgroundColor Black -ForegroundColor Green
	Start-Sleep -s 1
	Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Restart

} Else {

	# Checks if DNS is installed or not
If ((Get-WindowsFeature DNS).Installed -eq $False) {

    # Install DNS role
    Install-WindowsFeature DNS -IncludeManagementTools

    # Set defaults for NetID/Netmask
    $NetID = "192.168.1.0"
    $Netmask = "24"

    # Get info to build domain
    $ZoneName = Read-Host "Enter the Zone name"
    $NetID = Read-Host "Enter the Network ID of the Reverse lookup Zone in Dot notation (Default is 192.168.1.0)"
    $Netmask = Read-Host "Enter the netmask of the Reverse lookup Zone in bits (Default is 24)"

    # Create FWD lookup zone
    Add-DNSServerPrimaryZone -Name $ZoneName -DynamicUpdate "NonsecureAndSecure" -ZoneFile "$ZoneName.dns"

    # Create REV lookup zone
    Add-DNSServerPrimaryZone -NetworkID "$NetID/$Netmask" -ZoneFile "$NetID.in-addr.arpa.dns" -ReplicationScope "Domain"

    # Add basic Google & Cloudflare DNS servers
    Add-DnsServerForwarder -IPAddress "8.8.8.8" -Passthru
    Add-DnsServerForwarder -IPAddress "1.1.1.1" -Passthru

    # Display created zone
    Write-Host ""
    Get-DNSServerZone | Where-Object {$_.ZoneName -eq $ZoneName}
    Get-DNSServerZone | Where-Object {$_.ZoneName -like $NetID}
    Write-Host "This was the created Zone"
    Start-Sleep 3

} ELSE {

    Write-Host "DNS is already installed on this server, Moving to DC install"
    Start-Sleep 1

}

	# Create new forest/Promote to DC/install DNS if neccessary
	Write-Host "WARNING: DC name will be $ENV:computername. Are you sure you want this to be the DC's name? You cannot change it once it has been promoted and must demote it to rename it."
	Pause
	$DomainName = Read-Host "Enter New Forest Domain Name"
	Write-Host "This server is being promoted. This will cause the system to reboot. You are almost finished" -BackgroundColor Black -ForegroundColor Green
	Start-Sleep -s 1
	Install-ADDSForest -DomainName "$DomainName" -InstallDns:$False -Force:$true

}