###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "##########      REPORTE DE OU VACIA DEL AD           ############"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de OU vacias"
$mensaje = "Se hizo un reporte de todas las OU vacias del Active Directory"
#mostrarResumenUsuariosAD

# Leyendo la base de datos de OU del servidor LDAP
write-host "Obteniendo el listado de OU de directorio..."

# Obtiene todas las OUs en el dominio especificado
$ouList = Get-ADOrganizationalUnit -Filter * -SearchBase "DC=redaie,DC=local"
write-host "Total de OU del directorio:................ " $ouList.Length
write-host "Buscando OU vacias, espere unos segundos.. "
# Crear una lista para almacenar los resultados
$resultados = @()

# Recorre la lista de OUs y verifica si están completamente vacías
foreach ($ou in $ouList) {
    if (IsOUCompletelyEmpty $ou) {
        $resultado = New-Object PSObject -Property @{
            Nombre_OU = $ou.Name
            Ruta_OU   = $ou.DistinguishedName
        }
        $resultados += $resultado
    }
}

write-host "Total de OU vacias:................ " $resultados.Length
write-host "**********************************************************************"
# ordenar el resultado
$resultados = $resultados | Sort-Object -Property Ruta_OU
# Mostrar los resultados en formato de tabla
$resultados | Format-Table -AutoSize Nombre_OU, Ruta_OU 


write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_emptyOUs.txt"
$resultados | Out-File -FilePath ".\reportes\$reportFileName"

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################