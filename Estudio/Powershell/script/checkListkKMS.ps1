clear
write-host "############################################"
write-host "#### PRUEBA DE CONECTIVIDAD KMS_server #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""
$port = 1688
# Ruta del archivo de texto que contiene los nombres de los servidores KMS (uno por línea)
$filePath = "C:\Users\yvaldes\Desktop\DATA\Powershell\script\Lista_KMS_original_testeados.txt"

# Leer los nombres de los servidores KMS desde el archivo
$serverNames = Get-Content $filePath

# Realizar la prueba de conectividad a los servidores KMS en el puerto 1688
foreach ($serverName in $serverNames) {
    $result = Test-NetConnection -ComputerName $serverName -Port 1688

    if ($result.TcpTestSucceeded) {
        Write-Host "$serverName _____ DISPONIBLE ___P: 1688"
    } else {
        Write-Host "$serverName _____ NO CONECTA ___P: 1688"
    }
}
