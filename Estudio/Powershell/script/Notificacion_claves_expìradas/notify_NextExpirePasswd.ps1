#################################################################
# Notificacion de cuentas a punto de expirar del AD
# yunier.valdes@aie.es  2023
#################################################################
#limpieza de la consola
clear

#importar modulos necesarios
#en el caso de que no existan en el sistema, se pueden isntalla mediante el cmando:
# Install-Module -Name PSSendGrid
# Install-Module -Name ActiveDirectory
# de no estar disponibles para la instalacion automatica, se puede hacer manualmente descargandolos desde la pagina:
# https://www.powershellgallery.com/packages/ActiveDirectory.Toolbox/0.2002.2
# cambiando la extension del fifhero ".nupkg" a ".zip" renombrando el modulo segun se hara la importacion y
# copiandolo para la carpeta de modulos de powershell:
Import-Module -Name PSSendGrid
Import-Module ActiveDirectory
########################################################################################################################
# parametrizacion del script
# solo esta seccion se podra modifira, el resto no debe tocarse
########################################################################################################################
# Definiendo parametros para la ejecusion 
$credencialesPath = "C:\Export\credenciales.xml"  # en este fichero se encuentran las credenciales para la conexion al AD
#$sendmail = "False" 
$sendmail = "Enabled"
$MailFrom = "area.sistemas@aie.es"
$MailSubject = "Cuenta a punto de expirar"
$MailBody = "Estimado usuario,

Le informamos de que su clave esta a punto de expirar. Por favor, acceda a su cuenta y cambie su clave lo antes posible para evitar problemas de acceso.

Gracias por su colaboracion.

Atentamente,

SISTEMAS

"
#$date = Get-Date -format yyyyMMdd
#$CSVFile = $date+"_pwd_expires_days.csv"
$TestDestEmail = 'yunier.valdes@aie.es'
#$TestModeEnabled = $true
$NotificationDay = 10
$maxPasswordAge = "60.00:00:00"  # tiempo de vida de una cuenta de usuario (60 dias)
$SendGridKey = "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"  #ApiKey de SendGrid para la autenticacion
#################################################################################################################################



#################################################################################################################################
# Cuerpo del Script
# a partir de este ponto no debe tocarse el codig, los cambios deben realizarse en la seccion de parametrrizacion
#################################################################################################################################
# importando las credenciales para la autenticacion
$credenciales = Import-Clixml -Path $credencialesPath

# leyendo la base de datos de usuarios del servidor LDAP
$users = get-aduser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false }
#$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy -Credential $credenciales).MaxPasswordAge

###ciclo principal del Script, donde se recorren todos los usuarios y se chequea la fecha de expiracion de la clave
## en caso de que este proximo a expirar, se notifica via correo mediante SengGrid
foreach ($user in $users) {	# se optiene la prima cadena de usuario (DN completo del usuario)
	$Name = (Get-ADUser $user | foreach { $_.Name})		 # Se extrae el nombre de usuario de la cadena   		
	$emailaddress = $user.mail	# se obtiene el correo del usuario que se esta procesando
	$passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })	
	$PasswordPol = (Get-AduserResultantPasswordPolicy $user) 
	## a la fecha del ultimo cambio de clave se le suma el tiempo definido para la expircion de clave (parametro $maxPasswordAge)
	$expireson = $passwordsetdate + $maxPasswordAge

	$today = (get-date) #se obtiene la fecha actual
	$daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days # se obtiene la cantidad de dias que faltan para que expire la clave	                

	## se chequea si los dias que faltan para que expiere la clave, a superado el unbral definido  (parametro $NotificationDay)
	if ($daystoexpire -le $NotificationDay ) {	
					## mensajes que se veran solo por consola en la ejecusion manual del script			
					write-host "Usuario del dierectorio proximo a expirar:"
					write-host $emailaddress	
					write-host "Ultimo cambio de Password efectuado:"
					write-host $passwordSetDate		
					write-host "Fecha de expiracion del password:"
					write-host $expireson
					write-host "Dias que faltan para la expiracion:"
					write-host $daystoexpire
					write-host "notificando al usuario"

		if (($sendmail -eq "Enabled")) {	## solo se hara notificacion por correo si se habilita en los parametros iniciales
			## conformacion del correo para el envio por SendGrid
			#$emailaddress = $TestDestEmail ##enviar el correo a la direccion de pruebas
			$MailBodyText = $MailBody
			$MailSubjectText = $MailSubject
			$MailBody += "PD: Restan $daystoexpire dias" ## se agrega el numero de dias al texto del cuerpo del mensaje
			$MailSubject += " ( $daystoexpire dias.)" ## se agrega el numero de dias en el cuerpo del asunto del mensaje
			$Parameters = @{
				FromAddress     = $MailFrom
				ToAddress       = $emailaddress
				Subject         = $MailSubject
				Body            = $MailBody
				Token           = $SendGridKey 
				FromName        = $MailFronm
				ToName          = $emailaddress
			}
			$MailBody = $MailBodyText
			$MailSubject = $MailSubjectText 
			#envio del correo por Sendgrid
			Send-PSSendGridMail @Parameters
				Start-Sleep -s 1
		} ## cierre del IF de envio de correo
	} ##cierre del IF de notificacion 

}# cierre del ciclo principal Foreach
#################################################################################################################################

