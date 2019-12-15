Clear

# Check for ADDS Status
$ADStatus = (Get-WindowsFeature ad-domain-services).Installed

If ($ADStatus -eq $False) {

# Install ADDS and mgmt tools
	
	Clear
	Write-Host "ADDS is being installed. This may cause the system to reboot. Run this script again" -BackgroundColor Black -ForegroundColor Green
	Start-Sleep -s 3

	Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Restart

} Else {

# Create new forest/Promote to DC

$DomainName = Read-Host "Enter New Forest Domain Name"

Clear

Write-Host "This server is being promoted. This will cause the system to reboot. You are almost finished" -BackgroundColor Black -ForegroundColor Green
Start-Sleep -s 3

Install-ADDSForest -DomainName "$DomainName" -InstallDns:$True -Force:$true

}
