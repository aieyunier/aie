###############################################################################
# Accion
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########  	MODIFICACION DE ESTADO DE CUENTA DE USUARIO   #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"
$accion = "modificacion de estado de cuenta"



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

$actionDisable = read-host "Desabilitar_(1)   Habilitar_(2)"
if ($actiondisable -eq 1){
	# Deshabilitar el usuario
	Disable-ADAccount -Identity $usuarioSeleccionado
	Write-Host "Se deshabilito la cuenta del usuario $usuarioSeleccionado"
	$mensaje = "Se deshabilito la cuenta de usuario: "
}
if ($actiondisable -eq 2){
	# Habilitar el usuario
	Enable-ADAccount -Identity $usuarioSeleccionado
	Write-Host "Se habilito la cuenta del usuario $usuarioSeleccionado"
	$mensaje = "Se habilito la cuenta de usuario: "
}



write-host ""

write-host "****************************************************************************************"

#####################################################################################################
# Log de operacion
#####################################################################################################
$mensaje += $usuarioSeleccionado
RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje + $usuarioSeleccionado
#####################################################################################################
}else{write-host "Operacion cancelada"}