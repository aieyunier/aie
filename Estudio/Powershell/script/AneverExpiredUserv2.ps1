#limpieza de la consola
Clear-Host

#importar modulos necesarios
Import-Module ActiveDirectory

########################################################################################################################
# parametrizacion del script
# solo esta seccion se podra modificar, el resto no debe tocarse
########################################################################################################################
# Definiendo parametros para la ejecusion 
$credencialesPath = "C:\Export\credenciales.xml"  # en este fichero se encuentran las credenciales para la conexion al AD
$excludedUsersPath = "C:\Export\excludedUsers.txt"

#################################################################################################################################

#################################################################################################################################
# Cuerpo del Script
# a partir de este punto no debe tocarse el codigo, los cambios deben realizarse en la seccion de parametrizacion
#################################################################################################################################

# importando las credenciales para la autenticacion
$credenciales = Import-Clixml -Path $credencialesPath

# leyendo la base de datos de usuarios del servidor LDAP
Write-Host "Obteniendo el listado de usuarios del directorio..."
$users = Get-ADUser -Server -Credential $credenciales -Filter * -Properties Name, PasswordNeverExpires, mail, PasswordLastSet, PasswordExpired

Write-Host "Total de usuarios obtenidos del directorio: " $users.Length

# obteniendo los usuarios con claves que nunca expiran
$usersToFix = Get-ADUser -Credential $credenciales -Filter * -Properties Name, PasswordNeverExpires, mail, PasswordExpired, PasswordLastSet | Where-Object { $_.PasswordNeverExpires -eq $false }
Write-Host "Total de usuarios con claves que nunca expiran: " $usersToFix.Length

Write-Host "Lista de usuarios con claves que nunca expiran:"
foreach ($user in $usersToFix) {
    Write-Host $user.Name
}

# listando los usuarios excluidos (segun la seccion de parametrizacion del script)
# leyendo los usuarios que se van a excluir del proceso de reparacion
$usersExclude = Get-Content -Path $excludedUsersPath

Write-Host "Listando los usuarios excluidos para el proceso de reparacion:"
foreach ($nombre in $usersExclude) {
    Write-Host $nombre
}

# quitando los usuarios excluidos de la lista a procesar y procediendo a la reparacion
Write-Host "Determinando la lista de usuarios a reparar segun los criterios de exclusion:"
foreach ($user in $usersToFix) {
    $Name = (Get-ADUser $user | ForEach-Object { $_.Name })
    if ($usersExclude -notcontains $Name) {
        Write-Host "Reparando al usuario:" $Name
        # Descomenta las siguientes líneas para realizar la reparación
        #Set-ADUser -Identity $user -PasswordNeverExpires $true
        #Set-ADUser -Identity $user -AccountExpirationDate (Get-Date).AddDays(5)
    } else {
        Write-Host "Usuario excluido...............:" $Name
    }
}

Write-Host "Operacion finalizada"
#################################################################################################################################
