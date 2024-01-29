# Ruta donde se guardarÃ¡n los backups
#$backupPath = ""

# Crear la carpeta de backups si no existe
#if (-not (Test-Path -Path $backupPath)) {
#    New-Item -Path $backupPath -ItemType Directory
#}

# Obtener todas las zonas de DNS
$zones = Get-DnsServerZone -ComputerName prometeo
$fechaActual = Get-Date

# Recorrer cada zona y hacer backup
foreach ($zone in $zones) {
    $zoneName = $zone.ZoneName
    $backupName = $zoneName + "_" + $fechaActual.ToString("yyyyMMdd_HHmmss") + "_DNS_Zone.back"
    
    Write-Host "Haciendo backup de la zona $backupName"
    
    Export-DnsServerZone -ComputerName prometeo -Name $zoneName -FileName $backupName
}

Write-Host "Backup de todas las zonas completado"
