#To Do, change from making a new folder for each date to copying the bookmarks to the onedrive folder and rename the file

#Complete below for error action during testing to send email to me
function ErrorOnBackup {
Send-MailMessage -To user@domain.com -From $Env:username@domain.com -Subject "Error backing up bookmarks" -SmtpServer "EmailServer" -Body "Error backing up bookmarks on $Env:COMPUTERNAME"
}

#Variables
$TodaysDateFolder = Get-date -Format dd-MM-yyyy
$OneDriveBrowserBackupPath = "C:\Users\$Env:username\OneDrive"

#OneDrive folder testing
$OneDriveBackupFolderTest = Test-Path -Path "$OneDriveBrowserBackupPath\Bookmark Backup"
$OneDriveBackupTodaysFolderTest = Test-Path -Path "$OneDriveBrowserBackupPath\BookMark Backup\$TodaysDateFolder"

#Browser Folder Testing
$ChromeBackupFolderTest = Test-Path -Path "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder\Chrome"
$EdgeBackupFolderTest = Test-Path -Path "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder\Edge"

#Confirm parent backup folder exists
if ($OneDriveBackupFolderTest -eq $False){
    New-Item -Name 'Bookmark Backup' -ItemType Directory -Path "$OneDriveBrowserBackupPath"
}

#Confirm todays backup folder exists
if ($OneDriveBackupTodaysFolderTest -eq $False){
    New-Item -Name $TodaysDateFolder -ItemType Directory -Path "$OneDriveBrowserBackupPath\Bookmark Backup"
}

#Confirm todays Chrome folder exists
if ($ChromeBackupFolderTest -eq $False){
    New-Item -Name Chrome -ItemType Directory -Path "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder"
}

#Confirm todays Edge folder exists
if ($EdgeBackupFolderTest -eq $False){
    New-Item -Name Edge -ItemType Directory -Path "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder"
}

#Copy bookmarks for each browser into the backup location
Copy-Item "C:\Users\$Env:username\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Destination "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder\Chrome" -ErrorAction $ErrorOnBackup
Copy-Item "C:\Users\$Env:username\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" -Destination "$OneDriveBrowserBackupPath\Bookmark Backup\$TodaysDateFolder\Edge" -ErrorAction $ErrorOnBackup

#Delete older folders max of 20 days retention
Get-ChildItem -Path "$OneDriveBrowserBackupPath\Bookmark Backup" | where {$_.LastWriteTime -le $(get-date).Adddays(-20)} | Remove-Item -force