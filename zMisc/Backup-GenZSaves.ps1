#### Script to backup GenZ saves. Game will sometimes wipe saves

Write-Host "Backing up GenZ saves"

Copy-Item -Recurse -Path "C:\Users\Joe\Documents\Avalanche Studios\GenerationZero\Saves\" -Destination  "D:\Games\GenZSaves\$(Get-Date -uformat %Y-%m-%d_%H.%M)"