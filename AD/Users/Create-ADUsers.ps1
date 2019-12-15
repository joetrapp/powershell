param(
[Parameter(Mandatory =$true)]
$csvfile
)
Clear

# Import CSV template file
$userlist = Import-CSV -Path ".\newusers.csv"
$password = "abcd1234$"

# Take fields from CSV and populate in AD
ForEach ($User in $userlist) {
	$Prop = @{}
	$Prop.Name = $User.UserName
    $Prop.GivenName = $User.FirstName
    $Prop.SurName = $User.LastName
    $Prop.DisplayName = $User.FirstName.trim() + " " + $User.LastName.trim()
    $Prop.UserPrincipalName = $User.UPN
	$Prop.AccountPassword = $(ConvertTo-SecureString -AsPlainText $password -Force)
	$Prop.ChangePasswordAtLogon = $true

	New-ADUser @Prop -Enabled:$true
    Write-Host "New user: $($Prop.DisplayName)"

}
Pause
