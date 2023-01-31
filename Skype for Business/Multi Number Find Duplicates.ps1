$BlockofNumbers = Get-Content -Path "C:\Users\$env:username\Desktop\Numbers.txt"

function NumbersFileExists {
    Test-Path -Path "C:\users\$env:username\Desktop\Numbers.txt"    
}

Clear-Host
Foreach ($Number in $BlockofNumbers){
    if (NumbersFileExists -eq $false){
        Write-Host "Numbers.txt does not exist on your desktop, please create the file and add in numbers"
        }
    else {
    $Number1 = $Number.Trim("+")
    $Number2 = $Number1.Replace(" ","")
    $Number3 = $Number2 + '*'

    Write-Host -ForegroundColor Green "===== $Number3 ====="
    C:\Users\$env:username\Desktop\FindDDI.Ps1 $Number3
    Write-Host -ForegroundColor Green "===== $Number3 End ====="
    Write-host -ForegroundColor Yellow ""
    }
}