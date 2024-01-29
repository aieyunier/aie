############################################################################
# creacion de las credenciales para la ejecusion de script
# el PATH donde se generen estas credenciales, sebe usarse como PATH para 
# importarlas en el script a ejecutar porsetirormente
############################################################################
# Solicitar las credenciales al usuario
clear
write-host "############################################"
write-host "####        CREACION DE CREDENCIALES   #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""
write-host "Se solicitaran credenciales para generar un fichero en formato XML
donde la clave del usuario esta encriptada. El fichero XML podra ser utilizado 
en la opcion -Credential de los comando de PowerShell luego de ser importadas 
por el script"
write-host ""
$credenciales = Get-Credential
$credenciales | Export-Clixml -Path credenciales.xml

# Obtiene el path del script que se está ejecutando
$scriptPath = $MyInvocation.MyCommand.Path

# Obtiene solo el directorio del path del script
$scriptDirectory = [System.IO.Path]::GetDirectoryName($scriptPath)

# Imprime el directorio del script
Write-Host "Se guardaron las credenciales en:" $scriptDirectory
