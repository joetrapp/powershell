Clear

Write-Host "Do all disks pass S.M.A.R.T.?"
Start-Sleep 2
Write-Host ""

# Check if all disks pass SMART test 
cmd.exe /c  "wmic diskdrive get status,size,model,mediatype"
Start-Sleep 5

Write-Host "Are any drives are predicted to fail?"
Write-Host ""

# Check if any disks are predicted to fail
Get-WmiObject -Namespace root\wmi -class MSStorageDriver_FailurePredictStatus | ft PredictFailure , Active , PSComputerName , InstanceName
Pause
