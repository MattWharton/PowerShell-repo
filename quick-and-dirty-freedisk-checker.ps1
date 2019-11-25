$computers = Get-ADComputer -SearchBase 'OU=Desktops,OU=Client Machines,DC=Activus,DC=local' -Filter * | Select-Object -ExpandProperty DNSHostName

$credential = Get-Credential

Invoke-Command -ComputerName $Computers -Credential $credential -ScriptBlock {
Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object @{label='FreeSpace(GB)';expression={$_.FreeSpace / 1GB -as [int]}}
}