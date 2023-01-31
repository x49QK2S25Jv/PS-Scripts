#Create text file on the desktop and add all room email addresses
$AllRooms = Get-Content -Path "C:\Users\$env:username\Desktop\Rooms.txt"
$user = Read-Host "Please enter an email address to grant access too"

#gets a list of email addresses from above and granted full permission without auto mapping the mailbox
foreach ($Room in $AllRooms){
Add-MailboxPermission -Identity $Room -User $user -AccessRights FullAccess -InheritanceType All -AutoMapping $false
}

#List mailboxes a user has access to
Get-Mailbox -Resultsize Unlimited | Get-MailboxPermission -User User@domain.com