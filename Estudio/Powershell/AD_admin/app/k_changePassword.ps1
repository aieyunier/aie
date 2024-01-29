###############################################################################
# Accion
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########  	CAMBIO DE CLAVE DE USUARIO                    #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "Cambio de clave"
$mensaje = "Se Cambio la clave del usuario: "


# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo el listado de usuarios de directorio..."
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
write-host "Total de usuarios :................ " $allUsers.Length
write-host "**********************************************************************"
write-host ""
write-host ""

# validar que se no se intruduce un valor nulo en el nombre de usuario
do{
	$validacion = "OK"
	# Solicitar el nombre de usuario para cambiar la contraseña
	$usuario = Read-Host "Ingrese el nombre del usuario"
	# Verificar si no se introdujo un valor nulo
	if ($usuario -eq "") {
    	Write-Host "Debe escribir el nombre o parte del nombre del usuario."
		$validacion = "fail"
	} else{
		# Buscar usuarios que coincidan con el nombre introducido
		$usuariosEncontrados = Get-ADUser -Filter "SamAccountName -like '*$Usuario*'" | Select-Object SamAccountName
		if($usuariosEncontrados.Count -eq 0){
			write-host "No se encontraron usuarios coincidentes"
			$validacion = "fail"
		}
	}
}while ($validacion -eq "fail")

write-host "Usuarios Coincidentes: " $usuariosEncontrados.Count
# Mostrar los usuarios encontrados y permitir al usuario seleccionar uno
$indice = 1
$usuariosEncontrados | ForEach-Object {
	Write-Host "$indice. $($_.SamAccountName)"
	$indice++
}

# validar que el usuario selecciona un indice correcto
do{
	$validacion = "fail"
	write-host "Seleccione un usuario de la lista:"
	write-host "Cancelar operacion (0)"
	$seleccion = Read-Host "Introduzca la opcion"
	if ($seleccion -ge 1 -and $seleccion -le $usuariosEncontrados.Count) {
		$validacion = "OK"
	}       
}while ($validacion -eq "fail" -and $seleccion -ne "0")

if ($seleccion -ne "0") {
# Obtener el nombre de usuario seleccionado
$usuarioSeleccionado = $usuariosEncontrados[$seleccion - 1].SamAccountName

# Obtener las políticas de seguridad de contraseña
$passwordPolicies = Get-ADDefaultDomainPasswordPolicy

# Obtener la complejidad de contraseña mínima requerida
$minPasswordLength = $passwordPolicies.MinPasswordLength
$minPasswordComplexCharacters = $passwordPolicies.MinPasswordComplexCharacters

# Solicitar y validar la nueva contraseña
do {
    $nuevaClave = Read-Host "Ingrese la nueva clave" -AsSecureString
    $nuevaClaveString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($nuevaClave))
    
    $complexityCheck = $nuevaClaveString -cmatch "^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{$minPasswordLength,}$"
    
    if (!$complexityCheck) {
        Write-Host "La clave no cumple con las directivas de complejidad definidas."
        Write-Host "Debe contener al menos $minPasswordLength caracteres"
		Write-Host "Debe contener mayusculas y minusculas"
		Write-Host "Debe contener numeros"
		Write-Host "Debe contener caracteres especiales (*/+-#)"
		write-host ""
    }
} while (!$complexityCheck)

# Cambiar la contraseña
Set-ADAccountPassword -Identity $usuarioSeleccionado -NewPassword $nuevaClave -Reset

# Desbloquear la cuenta si está bloqueada
Unlock-ADAccount -Identity $usuarioSeleccionado

Write-Host "Se cambio la clave del usuario $usuarioSeleccionado"
write-host ""

write-host "****************************************************************************************"

#####################################################################################################
# Log de operacion
#####################################################################################################
$mensaje += $usuarioSeleccionado
RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje + $usuarioSeleccionado
#####################################################################################################
}else{write-host "Operacion cancelada"}