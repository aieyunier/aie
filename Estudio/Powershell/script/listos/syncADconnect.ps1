# Definir las credenciales para la conexión remota
#$cred = Get-Credential

# Nombre del servidor al que te conectarás
$nombreServidor = "madrid"

# Crear la sesión remota
$session = New-PSSession -ComputerName $nombreServidor #-Credential $cred

# Comando que deseas ejecutar
$comando = "start-adsyncsynccycle -policytype delta"

# Ejecutar el comando en la sesión remota y capturar la salida
$resultado = Invoke-Command -Session $session -ScriptBlock {
    param($command)
    Invoke-Expression $command
} -ArgumentList $comando

# Mostrar el resultado en la consola local
Write-Host "Resultado del comando remoto: $resultado"

# Cerrar la sesión remota
Remove-PSSession $session

# Pausa al final del script
Read-Host -Prompt "Presiona Enter para salir"
