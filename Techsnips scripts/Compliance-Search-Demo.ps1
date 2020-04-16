# Create a credential object
$Credential = Get-Credential

# Configure a remote session to the Exchange Compliance and Security
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $Credential -Authentication Basic -AllowRedirection 

# Connect session and import commands
Import-PSSession $Session -AllowClobber -DisableNameChecking 

# Create a search query specifying a name, where to look and the search parameters.
New-ComplianceSearch -Name 'PhishingMail' -ExchangeLocation 'All' -ContentMatchQuery 'whaler(c:c)(sent>2018-05-14)(from=seria@mdtube.ru)'

<# 
The ContentMatchQuery is tricky.

The (c:c) notation separates the search keywords from the search conditions.

Search conditions use the standard Boolean operators
(subject='website')
(-subject='network')
#>

Start-ComplianceSearch -Identity 'PhishingMail'

Get-ComplianceSearch -Identity 'PhishingMail'
Get-ComplianceSearch -Identity 'PhishingMail' | Format-List -Property Items

# Preview the results
New-ComplianceSearchAction -SearchName 'PhishingMail' -Preview

Get-ComplianceSearchAction -Identity 'PhishingMail_Preview' | Format-List -Property Results

# Purge the emails
New-ComplianceSearchAction -SearchName 'PhishingMail' -Purge -PurgeType SoftDelete

Get-ComplianceSearchAction -Identity 'PhishingMail_Purge'

Get-ComplianceSearchAction -Identity 'PhishingMail_Purge' | Format-List -Property Results

# Close the session
Get-PSSession | Remove-PSSession