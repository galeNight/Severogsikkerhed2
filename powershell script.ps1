#static ip sever
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.128.2" -PrefixLength 24 -DefaultGateway "192.168.128.1"
#Dns IP
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.128.2"
#PC name
Rename-Computer -NewName "DCSever1" -Restart
#domaincontrller
Install-WindowsFeature -Name Rsat-AD-Tools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Restart
$DomainName = "KursusX.com"
$DomainMode = "WinThresHold"
$SafeModePassword = ConvertTo-SecureString -String "Passw0rd" -AsPlainText -Force
Import-Module ADDSDeployment
Install-ADDSForest -DomainName $DomainName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModePassword -Force
#Dhcp
Install-WindowsFeature -Name DHCP -IncludeManagementTools -Restart
$ScopeName = "Myscope"
$StartRange = "192.168.128.13"
$EndRange = "192.168.128.213"
$SubnetMask = "255.255.255.0"
$DefaultGateway ="192.168.128.2"
$DNS = "192.168.128.2"
Add-DhcpServerv4Scope -Name $ScopeName -StartRange $StartRange -EndRange $EndRange -SubnetMask $SubnetMask -DefualtGateway $DefaultGateway -ComputerName LocalHost
Set-DhcpServerv4OptionValue -ScopeId $ScopeName -DnsServer $DNS

