$computers = Get-ADComputer -filter * -SearchBase "OU=Servers,DC=Contoso,DC=com" | ForEach-Object {$_.Name}

Foreach ($computers in $computers){

    if (Test-Connection -Computername $computers -BufferSize 8 -Count 1 -Quiet) {
        invoke-command -ComputerName $computers {wuauclt.exe /detectnow}
        invoke-command -ComputerName $computers {wuauclt.exe /reportnow}
        write-host -foregroundcolor "Green" "WSUS is now checking in for computer: " $computers
    }

    else{
        Write-host -foregroundcolor "Red" $computers is offline
    }   
}