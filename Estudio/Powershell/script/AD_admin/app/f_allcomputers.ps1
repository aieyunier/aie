###############################################################################
# Reporte
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "##########      REPORTE DE COMPUTADORAS DEL AD      ############"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Reporte de computadoras"
$mensaje = "Se hizo un reporte de todas las computadoras del Active Directory"
#mostrarResumenUsuariosAD

# Leyendo la base de datos de computadoras del servidor LDAP
write-host "Obteniendo el listado de computadoras de directorio..."
$allComputers = Get-ADComputer -Credential $credenciales -Filter * -Properties *
write-host "Total de computadoras:................ " $allComputers.Length
write-host "**********************************************************************"
Write-host "Por que atributo quiere ordenar el listado de PC:
(1) Nombre de PC
(2) sistema operativo
(3) Ultimo inicio de sesion"
$orden = read-host "Seleccione"
if ($orden -eq 1){$atributoOrdenar = "Name"}
if ($orden -eq 2){$atributoOrdenar = "OperatingSystem"}
if ($orden -eq 3){$atributoOrdenar = "lastLogonDate"}
write-host "La operación puede tardar unos segundos, por favor espere ..."

# Crear una lista para almacenar los resultados en formato de tabla
$tablaComputadoras = @()

foreach ($computer in $allComputers) {
    # Agregar los datos de la computadora a la lista
    $tablaComputadoras += New-Object PSObject -Property @{
        'Name' = $computer.Name
        'OperatingSystem' = $computer.OperatingSystem
        'OperatingSystemVersion' = $computer.OperatingSystemVersion
        'LastLogonDate' = $computer.LastLogonDate
    }
}

# Formatear y mostrar la tabla en la consola
# Ordenar la tabla por LastLogonDate en orden descendente (más reciente primero)
$tablaComputadoras = $tablaComputadoras | Sort-Object -Property $atributoOrdenar -Descending

$tablaComputadoras | Format-Table -AutoSize Name, lastLogonDate, OperatingSystem

# Opcional: Exportar la tabla a un archivo
#$tablaComputadoras | Format-Table -AutoSize | Out-File -FilePath "C:\ruta\reporte_computadoras.txt"

write-host "****************************************************************************************"
# Exportar el resultado a un archivo de texto
$fechaActual = Get-Date
$reportFileName = $fechaActual.ToString("yyyyMMdd_HHmmss") + "_reporte_allComputers.txt"
$tablaComputadoras | Out-File -FilePath ".\reportes\$reportFileName"

#####################################################################################################
# Log de operacion
#####################################################################################################

RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
#####################################################################################################