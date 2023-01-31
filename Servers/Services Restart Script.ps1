#Restart services every how many seconds
$SecondsInBetweenRestarts = "1800"
$ServicesToRestart = Get-Content -Path C:\Users\$Env:USERNAME\desktop\Services.txt
$LogFileDate = Get-date -UFormat %d/%m/%Y

#Email function variables
$EmailTo = "User@domain.com"
$EmailFrom = "$env:computername@domain.com"
$EmailSubject = "Failed to restart services on $env:computername"
$EmailBody =  "Failed to restart services on $Env:computername, please login and check out the services"
$EmailSmtpServer = "EmailServer"

function LogDate {
        Get-Date -Format "HH:mm:ss dd/MM/yyyy"
}

function OnErrorSendEmail {
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailSmtpServer
}

function LogFileDirectoryExists{
    $TestPath = Test-Path -Path C:\Scripts
    if($TestPath -eq $false){
        New-Item -Path "c:\" -Name "Scripts"
    }
}

#Confirm Directory exists
LogFileDirectoryExists

Start-Transcript -Path "C:\Scripts\$LogFileDate"

foreach ($Service in $ServicesToRestart){
    while ($true){
        LogDate
        Write-Host "Restarting service '$Service' at $(LogDate)" -ForegroundColor Green
        Restart-Service $Service -ErrorAction OnErrorSendEmail
        LogDate
        Write-Host "Finished restarting service '$Service' at $Date" -ForegroundColor Cyan `n
        Write-host -ForegroundColor Red "Sleeping for 20 seconds" `n
        Start-Sleep -Seconds 20
    }
}
Stop-Transcript