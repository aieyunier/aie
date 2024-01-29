############################################################################
# creacion de las credenciales para la ejecusion de script
# el PATH donde se generen estas credenciales, sebe usarse como PATH para 
# importarlas en el script a ejecutar porsetirormente
############################################################################
# Solicitar las credenciales al usuario
$credenciales = Get-Credential
$credenciales | Export-Clixml -Path C:\Export\credenciales3.xml