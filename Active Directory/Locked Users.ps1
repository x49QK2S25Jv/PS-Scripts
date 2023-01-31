Clear-Host
Write-Host "Searching for locked accounts, please check for a powershell popup" -ForegroundColor Green

#Searches all AD accounts, returns accounts which are locked only, put those results into a grid view for the operator to select
$LockeduserAccount = Search-ADAccount -LockedOut | Select-Object Name,SamAccountName,Lockedout | Sort-Object Name | Out-GridView -OutputMode Single -Title "Please select account to unlock" | Select-Object -ExpandProperty SamAccountName

if ($LockeduserAccount -eq $null){
    Write-Host "Invalid or null account exiting script" -ForegroundColor Red
    Break
} Elseif ($LockeduserAccount -ne $null){
    Write-Host "suspected valid account, continuing script" -ForegroundColor Green
}

Start-Sleep -Seconds 1

#Shows the user account from the user steps above
Get-ADUser -Identity $LockeduserAccount -Properties * | Select-object Name,Lockedout,AccountLockoutTime

Write-Host "Attempting to unlock " -NoNewline -ForegroundColor Green
Write-Host "$Lockeduseraccount" -ForegroundColor Red

#Unlocks the account in the selected variable $LockeduserAccount
Unlock-ADAccount -Identity "$LockeduserAccount"
Write-Host "$Lockeduseraccount should be unlocked"

Start-Sleep -Seconds 1

#Gets a list of all the domain controllers in the forest and sorts by name
$DomainControllers = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name | Sort-Object Name

#Temp Sleep
Start-Sleep -Seconds 1

Write-Host "Showing $Lockeduseraccount status against each DC" -ForegroundColor Yellow

#Tests each DC and confirms if an account is still locked on one of them
ForEach ($DC in $DomainControllers) {
    $CheckLockedAccountStatusOnEachDC = Get-ADUser -Identity $LockeduserAccount -Properties Name,Lockedout -Server $DC | Select-Object -ExpandProperty Lockedout
    if ($CheckLockedAccountStatusOnEachDC -match "True") {
        Write-host "$LockeduserAccount" -ForegroundColor Red -NoNewline
        Write-host " is still " -NoNewline
        Write-host "locked" -NoNewline -ForegroundColor Red
        Write-host " on " -NoNewline
        Write-host "$DC" -ForegroundColor Magenta
        Write-Host "Attempting to unlock $Lockeduseraccount on $DC" -ForegroundColor DarkYellow
        Unlock-ADAccount -Identity "$LockeduserAccount" -Server $DC
        Write-Host "Account should be unlocked, checking"
        Start-Sleep -Seconds 1
        $AccountlockedOnOneDCStatus = Get-ADUser -Identity $LockeduserAccount -Properties Name,Lockedout -Server $DC | Select-Object -ExpandProperty Lockedout
        if ($AccountlockedOnOneDCStatus -match "False") {
            Write-host "$LockeduserAccount" -ForegroundColor Red -NoNewline
            Write-host " is now " -NoNewline
            Write-host "unlocked" -NoNewline -ForegroundColor Green
            Write-host " on " -NoNewline
            Write-host "$DC" -ForegroundColor Magenta
        }
            else    {
                Write-Host "Can't unlock $LockeduserAccount please try manually on $DC" -ForegroundColor Red
                }
           } elseif ($CheckLockedAccountStatusOnEachDC -match "False") {
        Write-host "$LockeduserAccount" -ForegroundColor Red -NoNewline
        Write-host " is " -NoNewline
        Write-host "unlocked" -NoNewline -ForegroundColor Green
        Write-host " on " -NoNewline
        Write-host "$DC" -ForegroundColor Magenta
    } 
    else {
                Write-Host "Mr Stark, I don't feel so good - $DC" -ForegroundColor Cyan
            }
}
Read-host "Press any key to to exit..."
Exit