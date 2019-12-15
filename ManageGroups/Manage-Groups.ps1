#### Joe Trapp
#### BASIT 341
#### Group Mgmt
#### Date: 11/13/2018
#### Updated: 11/13/2018
Clear

While($true) {

$opr0 = $null
$operation = $null

Do {

Clear

Write-Host "What operation would you like to perform?"
Write-Host ""
Write-Host "0) Add users to a group"
Write-Host "1) Remove users from a group"
Write-Host "2) Create new group"
Write-Host "3) List all groups"
Write-Host "4) List users in a group (users that belong to a group)"
Write-Host "5) Continue"
Write-Host ""
Write-Host "6) Exit"

Write-Host ""
Write-Host "Your current choice is:" $operation
Write-Host ""
$opr0 = Read-Host "Type Number & Enter"

Clear

Switch ($opr0) {

	0 {$operation = "AddUsers"}
	1 {$operation = "RemoveUsers"}
	2 {$operation = "CreateNewGroup"}
	3 {$operation = "ListAllGroups"}
	4 {$operation = "ListGroupMembers"}
	5 {$opr0 = "Continue"}
   	6 {Exit}

}

Clear

}Until($opr0 -eq "Continue")

Switch ($operation) {


	AddUsers {
    
    Write-Host "Adding Users to a group" -ForegroundColor Green -BackgroundColor Black

    Get-ADUser -Filter * | FT Name,GivenName,SurName,DistinguishedName,Enabled
    $user = Read-Host "Which user would you like to manipulate? (Type 'Name')"
    Get-ADGroup -Filter * | FW Name
	$group = Read-Host "Which group would you like to add $user to?"

    Add-ADGroupMember -Identity $group -Members $user

    Write-Host "$User is now a member of: $group" -BackgroundColor Black
    Write-Host ""
    Write-Host "Members in $group" -BackgroundColor Black
    Get-ADGroupMember $group | FT Name,DistinguishedName
    Write-Host ""
    Pause
	
	} #End add members

	RemoveUsers {

    Write-Host "Removing Users from a group" -ForegroundColor Yellow -BackgroundColor Black

    Get-ADUser -Filter * | FT Name,GivenName,SurName,DistinguishedName,Enabled
    $user = Read-Host "Which user would you like to manipulate? (Type 'Name')"
    Get-ADUser $user -Properties MemberOf | FT MemberOf
	$group = Read-Host "Which group would you like to remove $user from?"

    Remove-ADGroupMember -Identity $group -Members $user

    Write-Host "$User has been removed from: $group" -BackgroundColor Black
    Write-Host ""
    Write-Host "Members in $group" -BackgroundColor Black
    Get-ADGroupMember $group | FT Name,DistinguishedName
    Write-Host ""
    Pause
	
	} #End remove members

	CreateNewGroup {

	$GroupName = Read-Host  "What is the name of the group?"
	$Scope = Read-Host "What is the scope of the group? (DomainLocal, Global, Universal. Type `"Help`" if you don't understand what Group Scope is)"

	If ($Scope -eq "Help") {

		Write-Host "Group Scope Help" -ForeGroundColor  -BackgroundColor Black
		Write-Host ""
		Write-Host "Scope matters. Best practice dictates that you assign users like this:"
		Write-Host "`$Users are members of `$GlobalGroups." -ForeGroundColor Yellow 
        Write-Host "`$GlobalGroups are members of $DomainLocalGroups" -ForeGroundColor Yellow
		Write-Host "`$DomainLocalGroups are assigned (NTFS) permissions" -ForeGroundColor Red -BackgroundColor Black
        Write-Host ""

		$scope = Read-Host "With your new understanding of group scope, what is the scope of the group? (DomainLocal, Global, Universal)"

		}
	
	New-ADGroup `
		-Name $GroupName `
		-GroupScope $Scope

	} #End Create New Group

	ListAllGroups {

	Get-ADGroup -Filter * | FW Name
	Pause
	
	} #End list all groups

	ListGroupMembers {

    Get-ADGroup -Filter * | FW Name
    $group = Read-Host "Which group would you like to display members from?"
	Get-ADGroupMember $group | FT Name,DistinguishedName
	Pause
	
	} #End list group members

} #EndSwitch
} #EndWhile
