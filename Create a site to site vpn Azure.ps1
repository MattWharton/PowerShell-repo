<#Creating a site-to-site VPN connection between Microsoft Azure 
and the local on-premises infrastructure.

Firstly we need to define the parameters we will be using in the script.
#>

$SubscriptionId          = '********-****-****-****-************'
$ResourceGroup           = 'demo-rg'
$Location                = 'uksouth' 

$VnetName                = 'VNet'
$AddressSpace            = '10.100.0.0/16' 
$AZSubnet                = '10.100.0.0/24' 
$GatewaySubnet           = '10.100.255.0/27'

$LocalNetworkGatewayName = 'local'
$LocalGatewayIP          = 'local-IP'  # Example: 8.8.4.4
$LocalSubnet             = 'local-subnet' # Example: 192.168.0.0/24

$GatewayName             = 'VNetA2GW'
$PublicIPName            = 'VNetA2GWPIP'
$GatewayIPConfig         = 'gwipconfig' 
$VPNType                 = 'RouteBased' 
$GatewayType             = 'Vpn'
$ConnectionName          = 'VNettoLocal'

#Connect to Azure
Connect-AzureRmAccount

#Set the context to the subscription Id where Site to site VPN will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Define the subnet variables.
$subnet1 = New-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix $GatewaySubnet
$subnet2 = New-AzureRmVirtualNetworkSubnetConfig -Name 'Frontend1' -AddressPrefix $AZSubnet

#Create the VNet.
New-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup `
-Location $Location -AddressPrefix $AddressSpace -Subnet $subnet1, $subnet2

#Create the local network gateway
New-AzureRmLocalNetworkGateway -Name $LocalNetworkGatewayName -ResourceGroupName $ResourceGroup `
-Location $Location -GatewayIpAddress $LocalGatewayIP -AddressPrefix $LocalSubnet

#Request a Public IP address
$gwpip= New-AzureRmPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroup -Location $Location -AllocationMethod Dynamic

#Create the gateway IP addressing configuration
$vnet = Get-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GatewayIPConfig -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id

#Create the VPN gateway
New-AzureRmVirtualNetworkGateway -Name $GatewayName -ResourceGroupName $ResourceGroup `
-Location $Location -IpConfigurations $gwipconfig -GatewayType $GatewayType  `
-VpnType $VPNType -GatewaySku Basic

#Set the gateway variables.
$gateway1 = Get-AzureRmVirtualNetworkGateway -Name $GatewayName -ResourceGroupName $ResourceGroup
$local = Get-AzureRmLocalNetworkGateway -Name $LocalNetworkGatewayName -ResourceGroupName $ResourceGroup

#Create the connection.
New-AzureRmVirtualNetworkGatewayConnection -Name $ConnectionName -ResourceGroupName $ResourceGroup `
-Location $Location -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'Generate a secure string to use as key' # Example of 64 chrs: Cp67AG7wyTgCT35rz3SM6jDx57G56ryl345k4GL1cu67wqJi361M4lAKsEzIhWl7

#Browse to the Azure portal and download the configuration file for your local network gateway device.

#Verify the VPN connection
Get-AzureRmVirtualNetworkGatewayConnection -Name $ConnectionName -ResourceGroupName $ResourceGroup

<# Output should be similar to below

"connectionStatus": "Connected",
"ingressBytesTransferred": 33509044,
"egressBytesTransferred": 4142431

#>
