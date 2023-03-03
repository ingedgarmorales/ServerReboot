﻿# Look for the last event with EventID 1074 in the System log.
$EventInfo = Get-WinEvent -FilterHashtable @{logname='System'; id=1074} -MaxEvents 1
$EventInfo | ForEach-Object {
$rv = New-Object PSObject | Select-Object Date, User, Action, Process, Reason, ReasonCode, Comment
$rv.Date = $_.TimeCreated
$rv.User = $_.Properties[6].Value
$rv.Process = $_.Properties[0].Value
$rv.Action = $_.Properties[4].Value
$rv.Reason = $_.Properties[2].Value
$rv.ReasonCode = $_.Properties[3].Value
$rv.Comment = $_.Properties[5].Value
$rv
}
 
 
# Set your email settings
$From = "<INSERT EMAIL ADDRESS HERE>"
$To = "<INSERT EMAIL ADDRESS HERE>"
#$Cc = ""
$Subject = $env:COMPUTERNAME + " has Rebooted"
#My Email body contains custom properties that will differ from your system.
$Body = "$env:COMPUTERNAME has rebooted at $($rv.Date) by $($rv.User) `r`nReason: $($rv.Reason) ($($rv.ReasonCode)) `r`nComment:$($rv.Comment) "
$SMTPServer = "<INSERT SMTP SERVER HERE>"
$SMTPPort = "25" # smtp port, usually 465 with SSL or 587 with TLS

# Send the email with  SMTP Credentials
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("<username>", "<password>"); 
$SMTPMessage = New-Object System.Net.Mail.MailMessage($From,$To,$Subject,$Body)
$SMTPClient.Send($SMTPMessage)
 
# Send the email without SMTP Credentials
# Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer
