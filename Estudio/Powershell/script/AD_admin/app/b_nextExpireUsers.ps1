###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########  REPORTE DE USUARIOS CON CLAVE PROXIMO A EXPIRAR #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de usuario"
$mensaje = "Se hizo un reporte de los usuarios con claves proximo a expirar en el Active Directory"

# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
write-host "Total de usuarios :................ " $allUsers.Length
write-host "**********************************************************************"
write-host "la operacion puede tardar unos segundos, por favor espere ..."

# obteniendo los usuarios habilitados, que aun no han expirado el passwords
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties | Where-Object {$_.Enabled -eq "True"} | Where-Object { $_.PasswordNeverExpires -eq $false } | Where-Object { $_.passwordexpired -eq $false }

$tablaUsuarios = @()

foreach ($user in $allUsers) {	# se optiene la prima cadena de usuario (DN completo del usuario)

	$expireson = $user.PasswordLastSet + $maxPasswordAge

	$today = (get-date) #se obtiene la fecha actual
	$daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days # se obtiene la cantidad de dias que faltan para que expire la clave	                

	## se chequea si los dias que faltan para que expiere la clave, a superado el unbral definido  (parametro $NotificationDay)
	if ($daystoexpire -le $NotificationDay ) {	
		# Agregar los datos del usuario a la lista
		$tablaUsuarios += New-Object PSObject -Property @{
			'Name' = $user.Name
			'Mail' = $user.mail
			'LastLogonDate' = $user.LastLogonDate
			'ExpiresOn' = $expireson
			'PasswordLastSet' = $user.PasswordLastSet	
			'DaysToExpire' = $daystoexpire
			
		}

    }
}

write-host "Total de usuarios con claves proximo a expirar: " $tablaUsuarios.Length

# ordenar la tabla con el listado de usuarios por la propiedad "DaysToExpire"
$tablaUsuarios = $tablaUsuarios | Sort-Object -Property DaysToExpire
# Mostrar la lista en formato de tabla
$tablaUsuarios | Format-Table -AutoSize Name, ExpiresOn, DaysToExpire, LastLogonDate, PasswordLastSet, Mail
write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_nextEpireUsers.txt"
$tablaUsuarios | Out-File -FilePath ".\reportes\$reportFileName"

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################



