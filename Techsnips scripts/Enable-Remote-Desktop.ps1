Invoke-Command -ComputerName server01 -ScriptBlock {
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' 
-Name fDenyTSConnections -Value 0}

Invoke-Command -ComputerName server01 -ScriptBlock {
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'}