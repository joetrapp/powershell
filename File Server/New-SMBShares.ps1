#### Create new SMB file shares on a file server
#### Created: 7/28/2020

If (!((Get-WindowsFeature File-Services).Installed)) {Install-WindowsFeature -Name "File-Services" -IncludeManagementTools}

New-SmbShare -Name "My Documents" -Path "c:\Shares\My Documents" -FullAccess "CityOfTieton\Domain Users" -FolderEnumerationMode "AccessBased"