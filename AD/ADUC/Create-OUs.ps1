#### Create basic set of OU's
#### Created: 7/28/2020

$Company = "Company Name"
$Path = "DC=DC1,DC=COM"

New-ADOrgnaizationalUnit -Name "$Company Users" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrgnaizationalUnit -Name "$Company Groups" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrgnaizationalUnit -Name "$Company Computers" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrgnaizationalUnit -Name "$Company Special Users" -Path $Path -ProtectedFromAccidentalDeletion $True