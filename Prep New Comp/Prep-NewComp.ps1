## Specific to Rod's house for now

# Elevate permissions
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Create new local user
$user = read-host "New username (RH user):"
$firstname = read-host "New user's actual first name:"
New-LocalUser -firstname $firstname -username $user

# Rename computer
$newcompname = read-host "New Computer Name (RHL0*): "
Rename-Computer -newname $newcompname
Write-Host "New computer name is" $newcompname

# Update PS Help
Update-Help -Force

# Enforce password rules (WinPro only)
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 0", "PasswordComplexity = 1") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

net accounts /MAXPWAGE:365
net accounts /MINPWLEN:10

# Get rid of bloatware

$bloatlist = @("Dell Inc.")

foreach ($application in $bloatlist) {

$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Vendor -match $application}

$app.Uninstall()

}

# Uninstall Windows Apps

Get-AppxPackage *3dbuilder* | Remove-AppxPackage;
Get-AppxPackage *keeper* | Remove-AppxPackage;
Get-AppxPackage *March of* | Remove-AppxPackage;
﻿Get-AppxPackage *Candy* | Remove-AppxPackage;
Get-AppxPackage *windowsalarms* | Remove-AppxPackage;
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage;
Get-AppxPackage *windowscamera* | Remove-AppxPackage;
Get-AppxPackage *officehub* | Remove-AppxPackage;
Get-AppxPackage *skypeapp* | Remove-AppxPackage;
Get-AppxPackage *getstarted* | Remove-AppxPackage;
Get-AppxPackage *zunemusic* | Remove-AppxPackage;
Get-AppxPackage *windowsmaps* | Remove-AppxPackage;
Get-AppxPackage *solitairecollection* | Remove-AppxPackage;
Get-AppxPackage *bingfinance* | Remove-AppxPackage;
Get-AppxPackage *zunevideo* | Remove-AppxPackage;
Get-AppxPackage *bingnews* | Remove-AppxPackage;
Get-AppxPackage *onenote* | Remove-AppxPackage;
Get-AppxPackage *people* | Remove-AppxPackage;
Get-AppxPackage *windowsphone* | Remove-AppxPackage;
Get-AppxPackage *bingsports* | Remove-AppxPackage;
Get-AppxPackage *soundrecorder* | Remove-AppxPackage;
Get-AppxPackage *bingweather* | Remove-AppxPackage;
Get-AppxPackage *Sway* | Remove-AppxPackage
Get-AppxPackage *Revolt* | Remove-AppxPackage;
Get-AppxPackage *Netflix* | Remove-AppxPackage;
Get-AppxPackage *Plex* | Remove-AppxPackage;
Get-AppxPackage *BingNews* | Remove-AppxPackage;
Get-AppxPackage *xbox* | Remove-AppxPackage;
Get-AppxPackage *McAfee* | Remove-AppxPackage;
Get-AppxPackage *Zune* | Remove-AppxPackage;
Get-AppxPackage *SmartByte* | Remove-AppxPackage;
Get-AppxPackage *Dell* | Remove-AppxPackage;
Get-AppxPackage *CandyCrushSaga* | Remove-AppxPackage;
Get-AppxPackage *DropboxOEM* | Remove-AppxPackage;
Get-AppxPackage *LinkedInforWindows* | Remove-AppxPackage;
Get-AppxPackage *Microsoft.People* | Remove-AppxPackage;
Get-AppxPackage *Messaging* | Remove-AppxPackage;
Get-AppxPackage *WindowsMaps* | Remove-AppxPackage;
Get-AppxPackage *OneConnect* | Remove-AppxPackage;
Get-AppxPackage *Bing* | Remove-AppxPackage;
Get-AppxPackage *GetHelp* | Remove-AppxPackage;
Get-AppxPackage *FeedbackHub* | Remove-AppxPackage;
Get-AppxPackage *CookingFever* | Remove-AppxPackage;
Get-AppxPackage *HPJumpStart* | Remove-AppxPackage;
Get-AppxPackage *WildTangent* | Remove-AppxPackage;
Get-AppxPackage *Priceline* | Remove-AppxPackage;
Get-AppxPackage *RandomSalad* | Remove-AppxPackage;

# Disable Windows services that are safe

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SharedAccess"                             # Internet Connection Sharing (ICS)
    "TrkWks"                                   # Distributed Link Tracking Client
    "WbioSrvc"                                 # Windows Biometric Service
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service

    # Services which cannot be disabled
    # "WdNisSvc"
)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}
