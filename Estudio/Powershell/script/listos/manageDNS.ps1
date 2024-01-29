############################################################################
#  Consultas sobre el servidor DNS
#  Yunier Valdes 2023
# 
############################################################################
chcp 65001
clear
write-host "############################################"
write-host "####           CONSULTAS DNS           #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""

$serverDNS = read-host "Escriba el nombre o la direccion IP del servidor DNS"
Write-host "Listad de zonas disponibles en el servidor seleccionado"
write-host "**************************************************************"
$result = Get-DnsServerZone -ComputerName $serverDNS
Get-DnsServerZone -ComputerName $serverDNS
write-host "**************************************************************"
write-host "Total de zonas en el servidor..." $result.Length
write-host ""
$zoneDNS = read-host "Escriba la zona sobre la cual se hara la consulta"



clear
write-host "
Entrada "A" (Address): Registra una direccion IPv4 asociada a un nombre de host.
Entrada "AAAA" (IPv6 Address): Registra una direccion IPv6 asociada a un nombre de host.
Entrada "CNAME" (Canonical Name): Registra un alias (nombre canonico) que redirige a otro nombre de host.
Entrada "MX" (Mail Exchange): Registra el servidor de correo responsable de recibir correos electronicos para un dominio.
Entrada "PTR" (Pointer): Registra una direccion IP que se mapea a un nombre de host (usado para resolucion inversa).
Entrada "NS" (Name Server): Registra el nombre del servidor DNS autoritativo para una zona.
Entrada "SOA" (Start of Authority): Registra informacion sobre la autoridad de una zona.
Entrada "TXT" (Text): Registra informacion de texto, generalmente utilizada para propositos de verificacion o autenticacion.
Entrada "SRV" (Service): Registra informacion sobre servicios especificos ofrecidos por un host.
Entrada "SPF" (Sender Policy Framework): Registra informacion sobre politicas de envio de correos electronicos.
Entrada "CAA" (Certification Authority Authorization): Registra informacion para controlar que certificados SSL pueden emitirse para un dominio
"
write-host ""
$entryType = read-host "Escriba el tipo de entrada desea listar (A, SRV, AAAA, CNAME, MX, PTR, NS, SOA, TXT, SPF, CAA)"

write-host "listando las entradas....."
write-host "***********************************************************"
# Obtiene todas las entradas de tipo A del servidor DNS europa
$result = Get-DnsServerResourceRecord -ZoneName $zoneDNS -RRType $entryType -ComputerName $serverDNS
Get-DnsServerResourceRecord -ZoneName $zoneDNS -RRType $entryType -ComputerName $serverDNS
write-host "Usuarios deshabilitados:................. " $disabledUser.Length
write-host ""
write-host "***********************************************************"
write-host "Total de entradas del tipo seleccionado en el servidor.." $result.Length


#############################################################################
#eliminar una entrada en el servidor dns
#Remove-DnsServerResourceRecord -ZoneName "redaie.local" -Name "hostx" -RRType A -ComputerName "europa"
#otiene todos los registros SRV de europa
Get-DnsServerResourceRecord -ZoneName "redaie.local" -RRType "srv" -ComputerName "europa"
#todos los servidores KMS de europa
#Get-DnsServerResourceRecord -ZoneName "redaie.local" -RRType "srv" -ComputerName "europa" | Where-Object {$_.HostName -eq "_VLMCS._tcp"}
# Obtiene todas las zonas en el servidor DNS "europa"
#Get-DnsServerZone -ComputerName europa

# Obtiene todas las entradas de tipo A del servidor DNS europa
#Get-DnsServerResourceRecord -ZoneName "redaie.local" -RRType "A" -ComputerName europa

# Obtiene todas las entradas de tipo A del servidor DNS remoto
#Get-DnsServerResourceRecord -ZoneName "aie" -RRType "A" -ComputerName "opera"

