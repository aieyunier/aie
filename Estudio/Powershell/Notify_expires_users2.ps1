Import-Module ActiveDirectory

$logging = "Enable" 
$sendmail = "Disable"
$date = Get-Date -format yyyyMMdd
$CSVFile = $date+"_pwd_expires_days.csv"

$TestDestEmail = 'yunier.valde@aie.es'
$TestModeEnabled = $true

#----------------------------------------------------------------------------------------------------

function SendMail(
	[string] $SMTPServer='192.168.1.', 
	[string] $From = 'XXXXXXXXXXXXXXX',
	[string] $To = '',
	[string] $DaysToExpire,
	$ExpireDate) {		
	
	$encoding  = New-Object System.Text.utf8encoding	
	$str_date=$ExpireDate.ToString("dd/MM/yyyy")		
	$Subject = "Aviso: Expiración contraseña en pocos días"
	$Body = "<p>Hola '$Name', tu contraseña expirará dentro de '$DaysToExpire' día(s) el día '$str_date', te sugerimos que la cambies antes de que llegue el día señalado para evitar problemas.</p>"	
	$Body+='<p>Si a pesar de todo sigues teniendo problemas contacta con informática</p>'	
			
	if ( $TestModeEnabled -eq $true ) {	
		$To = $TestDestEmail
	}
		
	Send-MailMessage -smtpServer $SMTPServer -From $From -To $To -subject $Subject -body $Body -Encoding $encoding -BodyAsHtml -Priority high 
} #FIN SendMail

#----------------------------------------------------------------------------------------------------

function AccountExpiresNextDays([int] $MaxDaysToExpire = 10) {	
	$users = get-aduser -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false }
	
	$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

	foreach ($user in $users) {	
		$Name = (Get-ADUser $user | foreach { $_.Name})		    		
		$emailaddress = $user.mail		
		$passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })	
		$PasswordPol = (Get-AduserResultantPasswordPolicy $user)	

		if (($PasswordPol) -ne $null) {
			$maxPasswordAge = ($PasswordPol).MaxPasswordAge		
		}		
  
		$expireson = $passwordsetdate + $maxPasswordAge	
		$today = (get-date)
		$daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days	                
		$messageDays = $daystoexpire
						
		if (($daystoexpire -ge "0") -and ($daystoexpire -lt $MaxDaysToExpire)) {				
			if (($sendmail -eq "Enabled")) {				
				SendMail 'XXXXXXXXXXXXXX' 'XXXXXXXXXXXXX' $emailaddress $messageDays $expireson				
				Start-Sleep -s 1
			}			
			
			# If Logging is Enabled Log Details
			if (($logging) -eq "Enabled") {
				Add-Content $CSVFile "$date,$Name,$daystoExpire,$expireson"  			 
			} 			
		} 	
	}# End User Processing
	
} #FIN AccountExpiresNextDays

#----------------------------------------------------------------------------------------------------

AccountExpiresNextDays 15