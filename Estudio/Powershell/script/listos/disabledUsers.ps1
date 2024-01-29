#################################################################
# Reporte de usuarios bloqueados
# yunier.valdes@aie.es  2023
#################################################################
#limpieza de la consola
clear-host
Write-host "#################################################################"
Write-host "########## REPORTE DE USUARIOS DESHABILITADOS DEL AD ############"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"

#importar modulos necesarios
#en el caso de que no existan en el sistema, se pueden isntalla mediante el cmando:
# Install-Module -Name ActiveDirectory
# de no estar disponibles para la instalacion automatica, se puede hacer manualmente descargandolos desde la pagina:
# https://www.powershellgallery.com/packages/ActiveDirectory.Toolbox/0.2002.2
# cambiando la extension del fifhero ".nupkg" a ".zip" renombrando el modulo segun se hara la importacion y
# copiandolo para la carpeta de modulos de powershell:
#Import-Module -Name PSSendGrid
Import-Module ActiveDirectory
#################################################################


########################################################################################################################
# parametrizacion del script
# solo esta seccion se podra modifira, el resto no debe tocarse
########################################################################################################################
# Definiendo parametros para la ejecusion 
write-host "Se importaran las credenciales para la consulta al AD...."
$credencialesPath= "C:\Export\credenciales.xml"  # en este fichero se encuentran las credenciales para la conexion al AD
$csvPath = "C:\Export\disabledUser.csv"
#################################################################################################################################



#################################################################################################################################
# Cuerpo del Script
# a partir de este punto no debe tocarse el codig, los cambios deben realizarse en la seccion de parametrrizacion
#################################################################################################################################

# importando las credenciales para la autenticacion
$credenciales = Import-Clixml -Path $credencialesPath


# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$user = get-aduser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet, PasswordExpired, LastLogonDate, Enabled
write-host "Total de usuarios :................ " $user.Length
# obteniendo los usuarios con   uw se encuentran deshabilitados
$disabledUser= get-aduser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet, PasswordExpired, LastLogonDate, Enabled | Where-Object { $_.Enabled -eq $false }
write-host "Usuarios deshabilitados:................. " $disabledUser.Length
write-host "#################################################################"
write-host "Lista de usuarios con deshabilitados:"
write-host "Nomre_Usuario ____________ Ultima_Sesion"


foreach ($user in $disabledUser) {	
	$Name = (Get-ADUser $user | ForEach-Object { $_.Name})	
	write-host $user.Name `t $user.LastLogonDate
	write-host $user.Name ____________ $user.LastLogonDate
}		

$disabledUser | Export-Csv -Path $csvPath -NoTypeInformation -Delimiter ";"
Write-Host "operacion finalizada"
#################################################################################################################################


