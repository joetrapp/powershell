#### Setup DNS server - Create basic zone with DNS forwarders
#### Created: 7/28/2020

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
    Add-DNSServerPrimaryZone -Name $ZoneName -DynamicUpdate "NonsecureAndSecure"

    # Create REV lookup zone
    Add-DNSServerPrimaryZone -NetworkID "$NetID/$Netmask" -ReplicationScope "Domain"

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

    Write-Host "DNS is already installed on this server"
    Start-Sleep 1

}