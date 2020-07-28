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

	# Create new forest/Promote to DC/install DNS if neccessary
	Write-Host "WARNING: DC name will be $ENV:computername. Are you sure you want this to be the DC's name? You cannot change it once it has been promoted and must demote it to rename it."
	Pause
	$DomainName = Read-Host "Enter New Forest Domain Name"
	Write-Host "This server is being promoted. This will cause the system to reboot. You are almost finished" -BackgroundColor Black -ForegroundColor Green
	Start-Sleep -s 1
	Install-ADDSForest -DomainName "$DomainName" -InstallDns:$True -Force:$true

}