###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########  REPORTE DE USUARIOS DESHABILITADOS              #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de usuario"
$mensaje = "Se hizo un reporte de los usuarios deshabilitados en el Active Directory"


# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
write-host "Total de usuarios :................ " $allUsers.Length
write-host "**********************************************************************"
write-host "la operacion puede tardar unos segundos, por favor espere ..."

# obteniendo los usuarios deshabilitados
$allUsers= get-aduser -Credential $credenciales -filter {Enabled -eq $false}  -properties $adUserProperties
write-host "Total de usuarios bloqueados: " $allUsers.Length


$tablaUsuarios = @()

foreach ($user in $allUsers) {	# se optiene la prima cadena de usuario (DN completo del usuario)
	# Agregar los datos del usuario a la lista
	$tablaUsuarios += New-Object PSObject -Property @{
		'Mail' = $user.mail
		'Enabled' = $user.Enabled
		'LastLogonDate' = $user.LastLogonDate
		'Name' = $user.Name
		#'ExpiresOn' = $expireson
		#'PasswordLastSet' = $user.PasswordLastSet
		#'DaysToExpire' = $daystoexpire
			
	}
    
}
# ordenar la tabla con el listado de usuarios por la propiedad "PasswordLastSet"
$tablaUsuarios = $tablaUsuarios | Sort-Object -Property Name
# Mostrar la lista en formato de tabla
$tablaUsuarios | Format-Table -AutoSize Enabled, LastLogonDate, Name, Mail
write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_disabledUsers.txt"
$tablaUsuarios | Out-File -FilePath ".\reportes\$reportFileName "

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################
