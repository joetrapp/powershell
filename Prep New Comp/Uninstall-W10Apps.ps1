if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
#Elevate permissions

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