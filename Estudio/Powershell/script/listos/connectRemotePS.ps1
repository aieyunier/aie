clear
write-host "############################################"
write-host "####   CONEXION CON POWERSHELL REMOTO  #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""
write-host "PUEDE QUE SEA NECESARIO HABILITAR EL ACCESO EN
EL SERVIDOR REMOTO: Enable-PSRemoting -Force
"
# Habilitar en el equipò remoto 
#Enable-PSRemoting -Force

# permitir en FW del equipo remoto
#Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress "IP-del-Equipo-Local" -Enabled True
$remoteServer = read-host "Escriba el nombre o la direccion IP del servidor remoto"
# conectar desde el cliente
Enter-PSSession -ComputerName $remoteServer -Credential ""
