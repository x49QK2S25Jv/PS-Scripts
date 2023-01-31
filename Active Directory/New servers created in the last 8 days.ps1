#Variables
$SMTPTo = 'Recipents@domain.com'
$SMTPFrom = 'Sender@domain.com'
$SMTPSubject = "New servers added in the last 8 days"
$SMTPAttachment = 'Location attachment was saved to'
$SMTPBody = "Hi, attached are servers which have been added to the domain in the last 8 days"
$SMTPServer = 'MailServerName'

#AD Servers OU location
$ServSearchBase = "OU Location e.g. OU=Servers,DC=domain,DC=com" 

#HTML formattting for the table in attachment on the email
$Header = @"
<style>
TABLE {border-width: 1px; font-family: Century Gothic; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; font-family: Century Gothic; padding: 3px; border-style: solid; border-color: black; background-color: #b7cee8;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@


$NewServerReport = Get-ADComputer -SearchBase $ServSearchBase -Properties Name,whenCreated -filter * | Where-Object { ((Get-Date) - $_.whenCreated).Days -lt 8}  | Select-Object Name,whenCreated | Sort-Object Name

#Convert the above output into HTML and send as an email with the report as an attachment
$NewServerReport | ConvertTo-Html -Property Name,whenCreated -Head $Header -PreContent "<H1 style='font-family:Century Gothic;'> Servers added to the domain in the past 8 days </H1>" -PostContent "<p Style='font-family:Century Gothic;'>Report created: $(Get-Date) created by $Env:USERNAME<p>" | Out-File NewServers.htm

#Send out above report via email
Send-MailMessage -Attachments $SMTPAttachment -To $SMTPTo -From $SMTPFrom -Subject $SMTPSubject -Body $SMTPBody -SmtpServer $SMTPServer