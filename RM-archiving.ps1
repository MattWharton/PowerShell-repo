set-alias sz "C:\Program Files\7-Zip\7z.exe"  

$toplevel = Get-ChildItem -Path "D:\Release Management\Test Releases\" -directory
Foreach ($top in $toplevel)
{
$path1 = "D:\Release Management\Test Releases\$top"

$DSpath1 = $path1.remove(0,3) 

$DSdir1 = "\\diskstation2\Backup\Archive\$DSpath1\"

    if(!(Test-Path -Path $DSdir1 )){
    New-Item -ItemType directory -Path $Dsdir1
    Write-Host "New folder created"
    }


$directory = Get-ChildItem -Path $path1 -directory  #| ? {$_.LastWriteTime -lt (Get-Date).AddDays(-1) }

Foreach ($dir in $directory)

    {
    $path2 = "D:\Release Management\Test Releases\$top\$dir"

    $DSpath2 = $path2.remove(0,3) 

    $DSdir2 = "\\diskstation2\Backup\Archive\$DSpath2\"

    if(!(Test-Path -Path $DSdir2 )){
    New-Item -ItemType directory -Path $Dsdir2
    Write-Host "New folder created"
    }

    $subdirectory = Get-ChildItem -Path $path2 -directory  | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-110) }

    Foreach ($sub in $subdirectory)

        {
        $folder = "$($sub.name)" 

        Write-Output '-----------------Next folder------------'
        $folder

        $Source = "$path2\$folder" 
        $Target = "\\diskstation2\Backup\Archive\$DSpath2\$folder.zip"

        
        if(!(Test-Path -Path $DSdir2 )){
        Write-Host "Target unreachable"
            }
        elseif($path1 -eq "D:\Release Management\Test Releases\PME"){
            }
        elseif($path1 -eq "D:\Release Management\Test Releases\DME"){
            }
        elseif($path1 -eq "D:\Release Management\Test Releases\ExcelToSOL"){
            }
        elseif($path1 -eq "D:\Release Management\Test Releases\3rd Party Components"){
            }
        else
            {
        sz a $Target $Source
        Remove-Item -Path $source -Recurse
        Start-Sleep -s 5
            }
        }
    }
}