$computers = Get-ADComputer -SearchBase 'OU=servers,DC=domain,DC=local' -Filter * | Select-Object -ExpandProperty DNSHostName
foreach ($computer in $computers) {
$option = New-CimSessionOption -Protocol Wsman
$session = New-CimSession -SessionOption $option -ComputerName $Computer

Get-CimInstance -ComputerName $Computer -Query "SELECT * FROM Win32_Service WHERE StartName LIKE 'DOMAIN\\accountname'"
$session | Remove-CimSession
} #foreach