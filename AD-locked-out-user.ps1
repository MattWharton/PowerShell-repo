$pdce = (Get-ADDomain).PDCEmulator
$filter = @{'LogName' = 'Security';'Id' = 4740}
$events = Get-WinEvent -ComputerName $pdce -FilterHashTable $filter
$events | Select-Object @{'Name' ='UserName'; Expression={$_.Properties[0].value}}, @{'Name' ='ComputerName';Expression={$_.Properties[1].value}}, TimeCreated