#################################################################
# Fix usuarios con claves que nunca expiran
# yunier.valdes@aie.es  2023
#################################################################
#limpieza de la consola
Clear-Host
Write-host "#################################################################"
Write-host "######## REPORTE DE USUARIOS CON CLAVES QUE NO EXPIRAN ##########"
Write-host "#################################################################"
write-host "........................................... by Yunier Valdés 2023"
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
$credencialesPath= "C:\Export\credenciales.xml"  # en este fichero se encuentran las credenciales para la conexion al AD
$excludedUsersPath= "C:\Export\excludedUsers.txt"

#################################################################################################################################



#################################################################################################################################
# Cuerpo del Script
# a partir de este ponto no debe tocarse el codig, los cambios deben realizarse en la seccion de parametrrizacion
#################################################################################################################################

# importando las credenciales para la autenticacion
$credenciales = Import-Clixml -Path $credencialesPath


# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
write-host "************************************************************"
$user = Get-ADUser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordLastSet, PasswordExpired, PasswordExpired
write-host "Total de usuarios obtenidos del directorio: " $user.Length


# obteniendo los usuarios con claves que nunca expiran
$usersToFix= get-aduser -Credential $credenciales -filter * -properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet | Where-Object { $_.PasswordNeverExpires -eq $false }
write-host "Total de usuarios a con claves que nunca expiran: " $usersToFix.Length
#[void][System.Console]::ReadKey($true) ## establecer una pausa (presionar tecla para continuar)
#write-host "Lista de usuarios con claves que nunca expiran:"
write-host "************************************************************"
write-host ""
#foreach ($user in $usersToFix) {	
#	$Name = (Get-ADUser $user | foreach { $_.Name})		    		
#	write-host $user.Name
#}

#[void][System.Console]::ReadKey($true) ## establecer una pausa (presionar tecla para continuar)

# listando los usuarios excluidos (segun la seccion de parametrizacion del script)
# leyendo los usuarios que se van a excluir del proceso de reparacion
$usersExclude = Get-Content -Path $excludedUsersPath -Encoding UTF8


#Write-Host "Listando los usuarios excluidos para el proceso de reparacion: "
#foreach ($nombre in $usersExclude) {
#    Write-Host $nombre
#}

#[void][System.Console]::ReadKey($true) ## establecer una pausa (presionar tecla para continuar)

# quitando los usuarios excluidos de la lista a procesar y procediendo a la reparacion
$repair = read-host "Si quiere que se haga el proceso de reparacion de los usuarios
escriba REAPAIR  en mayusculas. Si solo quiere listar los usuarios con claves que nunca 
expiran, presione A y Enter"
Write-Host "Determinando la lista de usuarios a reparar segun los criterios de exclusion:"
foreach ($user in $usersToFix) {
    $Name = (Get-ADUser $user | ForEach-Object { $_.Name })
    if ($usersExclude -notcontains $Name) {
        Write-Host "Reparando al usuario:" $Name
        if ($repair -eq "REPAIR"){
        # Descomenta las siguientes líneas para realizar la reparación
        Set-ADUser -Identity $user -PasswordNeverExpires $true
        Set-ADUser -Identity $user -AccountExpirationDate (Get-Date).AddDays(5)
        }
    } else {
        Write-Host "Usuario excluido...............:" $Name
    }
}											

Write-Host "operacion finalizada"
#################################################################################################################################


