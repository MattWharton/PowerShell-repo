# Credentials
$credential = Get-Credential
 
# Exchange Online connection settings
$params = @{
       ConfigurationName = 'Microsoft.Exchange' 
       ConnectionUri = 'https://outlook.office365.com/powershell-liveid'
       Credential = $credential
       Authentication = 'Basic' 
       AllowRedirection = $true
}
$exchangeSession = New-PSSession @params

# Connect to Exchange Online
Import-PSSession $exchangeSession -DisableNameChecking

Get-UnifiedGroup | Where-Object {$_.HiddenFromAddressListsEnabled -eq $false}

Get-UnifiedGroup -Identity [Office365group] | Set-UnifiedGroup -HiddenFromAddressListsEnabled $true

Get-UnifiedGroup -Identity [Office365group] | Select-Object -Property HiddenFromAddressListsEnabled

# Disconnect from Exchange Online
Get-PSSession | Remove-PSSession