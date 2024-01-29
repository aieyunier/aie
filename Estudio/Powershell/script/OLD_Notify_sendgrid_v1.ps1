clear-host
$credenciales = Import-Clixml -Path C:\Export\credenciales.xml
Import-Module ActiveDirectory

$logging = "Enable" 
$sendmail = "Enabled"
$date = Get-Date -format yyyyMMdd
$CSVFile = $date+"_pwd_expires_days.csv"
$TestDestEmail = 'yunier.valde@aie.es'
$TestModeEnabled = $true
$NotificationDay = 3
$maxPasswordAge = "60.00:00:00"
#write-host $date
$users = get-aduser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false }
#$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy -Credential $credenciales).MaxPasswordAge

foreach ($user in $users) {	
	$Name = (Get-ADUser $user | foreach { $_.Name})		    		
	$emailaddress = $user.mail	
	write-host "Usuario del dierectorio:"
	write-host $emailaddress	
	$passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })	
	write-host "Ultimo cambio de Password"
	write-host $passwordSetDate
	$PasswordPol = (Get-AduserResultantPasswordPolicy $user)

	#if (($PasswordPol) -ne $null) {
	#	$maxPasswordAge = ($PasswordPol).MaxPasswordAge		
	#}	
	$expireson = $passwordsetdate + $maxPasswordAge
	#$expireson = $passwordsetdate
	write-host "Fecha de expiracion del password:"
	write-host $expireson

	$today = (get-date)
	$daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days	                
	$messageDays = $daystoexpire
	write-host "Dias que faltan para la expiracion:"
	write-host $daystoexpire

	if ($daystoexpire -le "2") {				
		if (($sendmail -eq "Enabled")) {				
			#SendMail 'XXXXX' 'XXXXX' $emailaddress $messageDays $expireson				
			write-host "notificar al usuario"
				Start-Sleep -s 1
		}
	}

}





# Filtrar eventos con ID 5000 en el registro de eventos de IIS-IPRestrictionModule
$events = Get-WinEvent -LogName "Microsoft-IIS-IPRestriction/Operational" -FilterXPath "*[System[(EventID=5000)]]"

# Mostrar los eventos encontrados
$events | ForEach-Object {
    $eventTime = $_.TimeCreated
    $eventMessage = $_.Message
    Write-Host "Evento ID 5000 registrado en: $eventTime"
    Write-Host "Mensaje del evento: $eventMessage"
    Write-Host "------------------------------------------------------------"
}
