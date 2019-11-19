# Function to create report email
function SendNotification{
 $Msg = New-Object Net.Mail.MailMessage
 $Smtp = New-Object Net.Mail.SmtpClient($ExchangeServer)
 $Msg.From = $FromAddress
 $Msg.To.Add($ToAddress)
 $Msg.Subject = "Announcement: Important information about your Cegedim mailbox."
 $Msg.Body = $EmailBody
 $Msg.IsBodyHTML = $true
 $Smtp.Send($Msg)
}
 
# Define local Exchange server info for message relay. Ensure that any servers running this script have permission to relay.
$ExchangeServer = "mail.actisure.net"
$FromAddress = "Matt Wharton <noreply@actisure.co.uk>"
 
# Import user list and information from .CSV file
$Users = Import-Csv C:\scripts\CGDMUserList.csv
 
# Send notification to each user in the list
Foreach ($User in $Users) {
 $ToAddress = $User.Email
 $Name = $User.FirstName
 $NewEmail = $User.NewEmail
 $Usrnm = $User.Username
 $EmailBody = @"
 <html>
 <head>
 </head>
 <body>
 <p>Dear $Name,</p>
 
 <p>This email contains your login details for your new Cegedim mailbox.</p>
 
 <p>You will receive instructions regarding how to set up your new mailbox in a separate email.</p>
 
 <p><strong>Cegedim email address:</strong> $NewEmail<br />
 <strong>Username:</strong> $Usrnm<br />
 <strong>Password:</strong> Cegedim!</p>
 
 <p>If you require any assistance please contact itsupport@activus.co.uk</p>
 
 <p>Regards,</p>
 
 <p>Matthew Wharton</p>
 </body>
 </html>
"@
 Write-Host "Sending notification to $Name ($ToAddress)" -ForegroundColor Yellow
 SendNotification
}