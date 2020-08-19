#### Spin up a server from scratch
#### Author: Joe Trapp
#### Created: 8/18/2020

$CSV = Import-Csv -Path ".\newserver.csv" -Delimiter "," -ErrorAction Stop

ForEach ($Item in $CSV) {

    If ($Item.Type -eq "FileShare") {

        If ($FilePrintServer -ne $true) {

            If (!((Get-WindowsFeature File-Services).Installed)) {
                
                # Install the file/print server
                $FilePrintServer = $true
                Install-WindowsFeature -Name "File-Services" -IncludeManagementTools
            
            }
        }

        New-SmbShare -Name $Item.ShareName -Path $Item.SharePath -FullAccess "$Domain\Domain Users" -FolderEnumerationMode "AccessBased"

    }

}