
Clear-Host
Set-ExecutionPolicy Bypass
$computers = get-content "C:\tmp\list.txt"
foreach($computer in $computers)
{
Write-Host -ForegroundColor DarkYellow 'Starting Process on VM: ' $computer

Invoke-Command -ComputerName $computer -ScriptBlock{
 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco upgrade jre8 -y}
}