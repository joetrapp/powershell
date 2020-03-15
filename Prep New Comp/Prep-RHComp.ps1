#### Prep RH comps
#### Date created: 2/17/2020

net accounts /maxpwage:90
net accounts /minpwage:2
net accounts /minpwlen:10

# Export cfg
secedit.exe /export /cfg C:\secconfig.cfg

# Import cfg
secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY