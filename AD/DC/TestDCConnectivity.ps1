Clear

Param(
    $IP = (Read-Host "Enter Destination IP Address")
)
if ($IP -eq “”) {
   	$IP = "127.0.0.1"
   	Write-Host $IP
# Ports 389 & 445 are ADDS ports
Test-NetConnection $IP -Port 389
Test-NetConnection $IP -Port 445
} else {
	Write-Host $IP
Test-NetConnection $IP -Port 389
Test-NetConnection $IP -Port 445
}
