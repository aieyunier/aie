###############################################################################
# Panel de control de usuarios
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########       PANEL DE ADMINISTRACION DE USUARIOS        #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"

$show = mostrarResumenUsuariosAD -credenciales $credenciales -adUserProperties $adUserProperties

write-host "Seleccione la operacion que desea relizar sobre cuenta de usuario"
write-host "(1) Cambiar clave de usuario		(2) Desbloquear cuenta de usuario"
write-host "(3) Habilitar cuenta de usuario		(4) Desabilitar cuenta de usuario"
write-host "(5) Crear cuenta de usuario		(6) Eliminar cuenta de usuario"
write-host "(7) Ver estado de cuenta de usuario"
write-host " "
write-host "(0) Cancelar y Reresar"
write-host " "
$operacion = read-host "Operacion"

if($operacion -ne 0){ #si la opcion seleccionada no es la de regresar
	if ($operacion -ge 1 -and $operacion -le 7){ ## si se selecciona una opcion de la lista
		switch ($operacion) {
			1 {  
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "cambio de clave"
				$mensaje = "Se cambio la clave del usuario: "
				cambiarClaveUsuario -Credential $credenciales -usuario $usuarioSeleccionado
			}
			2 {  
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "desbloqueo de cuenta"
				$mensaje = "Se desbloqueo la cuenta de usuario: "
				# Desbloquear la cuenta
				Unlock-ADAccount -Credential $credenciales -Identity $usuarioSeleccionado
			}
			3 {  
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "habilitacion de cuenta"
				$mensaje = "Se habilito la cuenta de usuario: "
				# Habilitar el usuario
				Enable-ADAccount -Credential $credenciales -Identity $usuarioSeleccionado
			}
			4 { 
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "deshabilitacion de cuenta"
				$mensaje = "Se deshabilito la cuenta de usuario: "
				# Deshabilitar el usuario
				Disable-ADAccount -Credential $credenciales -Identity $usuarioSeleccionado
			}
			5 {  
				$newUser = intDatosNewUser
				$ouPath = SeleccionarOU
				# Definir los detalles del nuevo usuario
				$nombreNuevoUsuario = $newUser.Nombre
				$contrasena = ConvertTo-SecureString $newUser.Clave -AsPlainText -Force
				$nombreCompleto = $newUser.Nombre + " " + $newUser.Apellido1 + " " + $newUser.Apellido2
				$apellidos = $newUser.Apellido1 + " " + $newUser.Apellido2
				$nombreUsuarioSam = $newUser.Cuenta  # Nombre de inicio de sesión (debe ser único)
				$mail = $newUser.Correo 
				# Crear el nuevo usuario en la OU especificada
				New-ADUser -Name $nombreCompleto -DisplayName $nombreCompleto -EmailAddress $mail -Surname $apellidos -AccountPassword $contrasena -Enabled $true -GivenName $nombreNuevoUsuario -SamAccountName $nombreUsuarioSam -UserPrincipalName "$nombreUsuarioSam@dominio.com" -Path $ouPath
				$accion = "Creacion de cuenta"
				$mensaje = "Se creo la cuenta de usuario: "
				$usuarioSeleccionado = $nombreUsuarioSam

			}
			6 {  
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "eliminacion de cuenta"
				$mensaje = "Se elimino la cuenta de usuario: "
				Remove-ADUser -Credential $credenciales -Identity $usuarioSeleccionado 

			}
			7 {  
				$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
				$accion = "revision de cuenta"
				$mensaje = "Se reviso el estdo de la cuenta de usuario: "
				Get-ADUser -Credential $credenciales -Filter "SamAccountName -eq '$usuarioSeleccionado'" -properties $adUserProperties				
			}
			Default {}
			
		} 
		write-host "****************************************************************************************"
		#####################################################################################################
		# Log de operacion
		#####################################################################################################
		$mensaje += $usuarioSeleccionado
		RegistrarLog -usuario $nombreUsuario -accion $accion -mensaje $mensaje
		#####################################################################################################
	}else {write-host "Opcion Invalida"}	
}

