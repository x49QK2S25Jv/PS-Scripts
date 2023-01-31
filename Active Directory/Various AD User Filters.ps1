#Filters meant to be run selectivly to get bit of info about a user or group

#Clear the screen
Clear-Host

#Set the user for the commands below
$username = "AD UserName Here"

#Get basic user details
Get-ADUser -Identity $username

#Get basic user details (with job title)
Get-ADUser -Identity $username -Properties * | Select-Object Name,Title

#Get all user details
Get-ADUser -Identity $username -Properties *

#Get users details for password and locked status
Get-aduser -Identity $username -Properties * | Select-Object Name,LastLogonDate,LockedOut,PasswordExpired,BadLogonCount,badPwdCount,LastBadPasswordAttempt,PasswordLastSet,PasswordNeverExpires

#Convert a word to upper case
$Word = "lowercaseword"
$UpperWord = "$word".ToUpper()
Write-Host "$UpperWord"
"$UpperWord" | Clip

#Get one users ad group membership
Clear-Host
"`n"
Write-Host "$username Group Membership" -ForegroundColor Green -NoNewline
Get-ADPrincipalGroupMembership -Identity $username | Select-Object SamAccountName | Sort-Object SamAccountName | Format-Table -HideTableHeaders

#Get one users ad groups exported to file on desktop
$OutfilePath = "C:\Users\$Env:USERNAME\Desktop"
Clear-Host
"`n"
"$username AD Membership" | Out-String | Out-File -LiteralPath $OutfilePath\$username.txt -Append
Write-host "$username" | Out-File -FilePath $OutfilePath\$username.txt -Append
$ADUsersGroups = Get-ADPrincipalGroupMembership -Identity $username | Select-Object SamAccountName | Sort-Object SamAccountName | Format-Table -HideTableHeaders | Out-File -FilePath $OutfilePath\$username.txt -Append


(Get-ADUser -Properties * -Filter {Title -like "Director"} )

get-aduser -Properties * -Filter * {Title -like "Research"}


#Folders
#Filter for folders with Specific Name
Get-ChildItem -Directory -path c:\temp -Recurse | Where-Object {$_.Name -eq "Google"} | Remove-Item -Confirm:$true


#Active Directory
#Get All AD user Properties
Get-ADUser -Identity $username -Properties *

#Filter AD user for disabled users and export to csv
Get-ADUser  -Properties Name,Enabled -Filter {Enabled -eq "False"} | Select-Object Name,Enabled | Sort-Object Name | Export-Csv -Path "C:\Users\$Env:Username\Desktop\DisabledUsers.csv"

#Get Aduser name and password never expires and export to csv
Get-ADUser  -Properties Name,PasswordNeverExpires -Filter {PasswordNeverExpires -eq "True"} | Select-Object Name,PasswordNeverExpires | Sort-Object Name | Export-Csv -Path "C:\Users\$Env:Username\Desktop\PasswordNeverExpires.csv"



