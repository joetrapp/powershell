#### Create basic set of OU's
#### Created: 7/28/2020

$Company = "Company Name"
$Path = "DC=DC1,DC=COM"

New-ADOrganizationalUnit -Name "$Company Users" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name "$Company Groups" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name "$Company Computers" -Path $Path -ProtectedFromAccidentalDeletion $True
New-ADOrganizationalUnit -Name "$Company Special Users" -Path $Path -ProtectedFromAccidentalDeletion $True