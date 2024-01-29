###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "##########      REPORTE DE USUARIOS  DEL AD          ############"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de usuario"
$mensaje = "Se hizo un reporte de todos los usuarios del Active Directory"
#mostrarResumenUsuariosAD

# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
write-host "Total de usuarios :................ " $allUsers.Length
write-host "**********************************************************************"
write-host "la operacion puede tardar unos segundos, por favor espere ..."
# Crear una lista para almacenar los resultados en formato de tabla
$tablaUsuarios = @()

foreach ($user in $allUsers) {
    #$Name = (Get-ADUser $user | ForEach-Object { $_.Name })

    # Agregar los datos del usuario a la lista
    $tablaUsuarios += New-Object PSObject -Property @{
        'LastLogonDate' = $user.LastLogonDate
        'PasswordLastSet' = $user.PasswordLastSet
        'Name' = $user.Name
        'Mail' = $user.mail
    }
}

# ordenar la tabla con el listado de usuarios por la propiedad "LastLogonDate"
$tablaUsuarios = $tablaUsuarios | Sort-Object -Property LastLogonDate
# Mostrar la lista en formato de tabla
$tablaUsuarios | Format-Table -AutoSize PasswordLastSet, LastLogonDate, Name, Mail
write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_allUsers.txt"
$tablaUsuarios | Out-File -FilePath ".\reportes\$reportFileName"

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################

