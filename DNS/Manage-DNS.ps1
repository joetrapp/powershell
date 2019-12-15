Clear

#Checks if DNS is installed or not
If ((Get-WindowsFeature DNS).Installed -eq $False) {
Write-Host "DNS is not installed. Installing now. Run this script again"

#Install DNS and mgmt tools
Install-WindowsFeature DNS -IncludeManagementTools

}

#Checks if there are no forwarders on the DNS server
If ((Get-DnsServerForwarder).IPaddress -eq $null) {

	$dnsfwdopr = Read-Host "You don't have a DNS Forwarder. Your DNS server will not be able to resolve hosts it's not authoritative to. Do you want to set a DNS forwarder? (Y/N)"

	If ($dnsfwdopr -match "[yY]")  {

		Do {
			$dnsfwd = ""
			$dnsfwd = Read-Host "Type IP of a DNS forwarder. To continue, leave blank and hit Enter"
			Add-DnsServerForwarder $dnsfwd
			Write-Host "The DNS forwarder you added is $dnsfwd"
			Write-Host ""
		}Until ($dnsfwd -eq "") #Loop to add forwarders till $dnsfwd is blank

	}

}

#User interface
While($true) {

$opr0 = $null
$operation = $null
Clear

Write-Host "What operation would you like to perform?"
Write-Host ""
Write-Host "1) New Zone"
Write-Host "2) New A Record"
Write-Host "3) View A Records"
Write-Host "4) View Zone Info"
Write-Host "5) Setup Addressing for this host"
Write-Host ""
Write-Host "0) Exit"

Write-Host ""
Write-Host "Your current choice is:" $operation
Write-Host ""
$opr0 = Read-Host "Type Number & Enter"

Clear

#Run operation based on menu selection
Switch ($opr0) {

	1 {$operation = "NewZone"}
	2 {$operation = "NewARecord"}
	3 {$operation = "ViewARecords"}
	4 {$operation = "ViewZoneInfo"}
	5 {$operation = "SetupAddressing"}
   	0 {Exit}

}

Clear


Switch ($operation) {

    NewZone {

	Write-Host "Creating new zone"
	Write-Host ""

	$ZoneName = Read-Host "Enter the Zone name"
	$NetID = Read-Host "Enter the Network ID of the Reverse lookup Zone in Dot notation (xxx.xxx.xxx.xxx)"
	$Netmask = Read-Host "Enter the netmask of the Reverse lookup Zone in bits (12, 18, 24)"

    	#Create FWD lookup zone
	Add-DNSServerPrimaryZone `
		-Name $ZoneName `
		-DynamicUpdate "None" `
		-ZoneFile "$ZoneName.dns"
    
	#Create REV lookup zone
	Add-DNSServerPrimaryZone `
        	-NetworkID "$NetID/$Netmask" `
		-ZoneFile "$NetID.in-addr.arpa.dns"

	#Display created zone
	Write-Host ""

	Get-DNSServerZone | Where {$_.ZoneName -eq $ZoneName}
	Get-DNSServerZone | Where {$_.ZoneName -like $NetID}

	Write-Host "This was the created Zone"
	Write-Host ""
	Pause

        }

    ViewZoneInfo {

	Write-Host "Viewing Zone Info"

	#Get all manually created zones
	Get-DNSServerZone | Where {$_.IsAutoCreated -ne "True"}
	Write-Host ""
	Pause

        }

    NewARecord{

	Write-Host "Creating a new A record"
	Write-Host ""

	#Get all manually created zones, and NO Reverse Lookup Zones
	Get-DNSServerZone | Where {$_.IsAutoCreated -ne "True" -AND ($_.IsReverseLookupZone -ne "True")}
	Write-Host ""

	$ZoneName = Read-Host "Which Zone would you like to create a new A record in? (Type ZoneName)"
	$IP = Read-Host “What is the computer's IPv4 address”
	$NewHost = Read-Host “What is the host's name”

	#Display created A record
	Add-DnsServerResourceRecordA -ZoneName $ZoneName -Name $newhost -IPv4Address $IP -CreatePtr -AgeRecord
    	Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $newhost

    	Write-Host ""
    	Write-Host "This was the created A record"
    	Write-Host ""
    	Pause

        }

    ViewARecords {

	Write-Host "Viewing A records"
	Write-Host ""

	#Get all manually created zones, and NO Reverse Lookup Zones
	Clear
	Get-DNSServerZone | Where {$_.IsAutoCreated -ne "True" -AND ($_.IsReverseLookupZone -ne "True")}
	Write-Host ""

    	$ZoneSelect = Read-Host "Which Zone would you like to get A records from? (Type ZoneName)"

    	Get-DnsServerResourceRecord -ZoneName $ZoneSelect -RRType "A"
    	Write-Host ""
    	Pause
        }

    SetupAddressing {
		
	Write-Host "Setting up static IP and other addressing now"
	Write-Host ""

	#Get variables
	$ipadd = Read-Host "Enter IPv4 address"
	$subnet = Read-Host "Enter Subnet mask in bits (E.X. 24 = 255.255.255.0, 16 = 255.255.0.0)"
	$gateway  = Read-Host "Enter Default Gateway address"
	$selfdns = Read-Host "Use self as DNS? (Y/N)"

	#Erase current network addressing/Turn off DHCP (IPv4/"Ethernet" adapter only)
	Remove-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet"
	Remove-NetRoute -AddressFamily IPv4 -InterfaceAlias "Ethernet"
	Set-NetIPInterface -DHCP Disabled

	# Set IP address
	New-NetIPAddress `
		-InterfaceAlias "Ethernet" `
		-IPAddress $ipadd `
		-PrefixLength $subnet `
		-AddressFamily IPv4

	#Set Gateway
	New-NetRoute `
		-InterfaceAlias "Ethernet" `
		-DestinationPrefix "0.0.0.0/0" `
		-NextHop $gateway

	#Set DNS server to itself
	If ($selfdns -match "[yY]") {Set-DNSClientServerAddress -InterfaceAlias "Ethernet" -ServerAddress "127.0.0.1"}

	}

}
}
