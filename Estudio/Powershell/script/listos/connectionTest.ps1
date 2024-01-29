clear
write-host "############################################"
write-host "####    PRUEBA DE CONECTIVIDAD TCP     #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""
#$port = 1688
$server = read-host "Escriba el nombre o la direccion ip del servidor.
Ejemplo: google.es"
$port = read-host "Escriba el numero del puerto que desea comprobar
en el servidor remoto. 
Ejemplo 443"
write-host "Probando la conexion a $server por el puerto $port ..."
write-host "*******************************************************"
Test-NetConnection -ComputerName $server -Port $port
write-host "*******************************************************"
