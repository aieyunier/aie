###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########  REPORTE DE USUARIOS BLOQUEADOS                  #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de usuario"
$mensaje = "Se hizo un reporte de los usuarios bloqueados en el Active Directory"


# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
write-host "Total de usuarios :................ " $allUsers.Length
write-host "**********************************************************************"
write-host "la operacion puede tardar unos segundos, por favor espere ..."

# obteniendo los usuarios bloqueados
$allUsers= get-aduser -Credential $credenciales -filter * -properties $adUserProperties | Where-Object { $_.LockedOut -eq $True }
write-host "Total de usuarios bloqueados: " $allUsers.Length


$tablaUsuarios = @()

foreach ($user in $allUsers) {	# se optiene la prima cadena de usuario (DN completo del usuario)
	# Agregar los datos del usuario a la lista
	$tablaUsuarios += New-Object PSObject -Property @{
		
		'Mail' = $user.mail
		'LastLogonDate' = $user.LastLogonDate
		#'ExpiresOn' = $expireson
		'PasswordLastSet' = $user.PasswordLastSet	
		'LockedOut' = $user.LockedOut
		'Name' = $user.Name
		#'DaysToExpire' = $daystoexpire
			
	}
    
}
# ordenar la tabla con el listado de usuarios por la propiedad "PasswordLastSet"
$tablaUsuarios = $tablaUsuarios | Sort-Object -Property LastLogonDate
# Mostrar la lista en formato de tabla
$tablaUsuarios | Format-Table -AutoSize LockedOut, Name, Mail, LastLogonDate, PasswordLastSet 
write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_lockedUsers.txt"
$tablaUsuarios | Out-File -FilePath ".\reportes\$reportFileName "

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################
