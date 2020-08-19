#### Create administrator users
#### Author: Joe Trapp
#### Date: 8/18/2020

# Create username schema
$User = "?Admin"
$DAUser = "$User-DA"
$EAUser = "$User-EA"
$Path = "OU=City Of Tieton Special Users,DC=cityoftieton,DC=com"

# Create users
New-ADUser -Name $User -Enabled $true -CannotChangePassword $true -Path $Path
New-ADUser -Name $DAUser -Enabled $true -CannotChangePassword $true -Path $Path
New-ADUser -Name $EAUser -Enabled $false -CannotChangePassword $true -Path $Path

# Get groups to add to admin users
$AdministratorGroups = @()
$AdministratorGroups += "Account Operators"
$AdministratorGroups += "Administrators"
$AdministratorGroups += "Backup Operators"
$AdministratorGroups += "DHCP Administrators"
$AdministratorGroups += "DnsAdmins"
$AdministratorGroups += "Domain Users"
$AdministratorGroups += "Group Policy Creator Owners"
$AdministratorGroups += "Print Operators"
$AdministratorGroups += "Read-only Domain Controllers"
$AdministratorGroups += "Remote Desktop Users"

# Add users to groups
ForEach ($Group in $AdministratorGroups) {Add-ADGroupMember -Identity $Group -Members $User}
Add-ADGroupMember -Identity "Domain Admins" -Members $DAUser
Add-ADGroupMember -Identity "Enterprise Admins" -Members $EAUser