########
# poner en el fichero de funciones y eliminar al final 
######
$contenidoFunciones = Get-Content -Path .\app\funciones2.ps1 -Raw
Invoke-Expression -Command $contenidoFunciones 
###############################################################################
# Visor de eventos
###############################################################################
clear-host
Write-host "#################################################################"
Write-host "########      	 VISOR DE EVENTOS DEL AD		          #######"
Write-host "#################################################################"
write-host "............................................by Yunier Valdes 2023"


write-host "Seleccione la opcion para el filtrado del registro de eventos"
write-host "(1) Eventos de inicio de sesion exitosos"
write-host "(2) Eventos de inicio de sesion fallidos"
write-host "(3) Eventos de bloqueo de cuentas"
write-host "(4) Eventos de reseteo de claves"
write-host "(5) Eventos de intento de validacion de cuenta"
write-host " "
write-host "(0) Cancelar y Reresar"
write-host " "
$operacion = read-host "Operacion"

if($operacion -ne 0){ #si la opcion seleccionada no es la de regresar
	if ($operacion -ge 1 -and $operacion -le 5){ ## si se selecciona una opcion de la lista
		switch ($operacion) {
			1 { 
				write-host "
				(1) Ultimos eventos registrados en los AD
				(2) Ultimos eventos de un usuario determinado
				"
				$select=Read-host "Seleccione"
				if ($select -eq 1){ eventViewer -eventID 4624}else {
					$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
					eventViewer -eventID 4624 -user $usuarioSeleccionado
				}
				$accion = "Visor de eventos"
				$mensaje = "revision de logs de inicio de sesion de u suario $usuarioSeleccionado "
			}
			
			2 {  
				write-host "
				(1) Ultimos eventos registrados en los AD
				(2) Ultimos eventos de un usuario determinado
				"
				$select=Read-host "Seleccione"
				if ($select -eq 1){ eventViewer -eventID 4625}else {
					$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
					eventViewer -eventID 4625 -user $usuarioSeleccionado
				}
				$accion = "Visor de eventos"
				$mensaje = "revision de logs de inicio de sesion de u suario $usuarioSeleccionado "

			}
			3 {  
				write-host "
				(1) Ultimos eventos registrados en los AD
				(2) Ultimos eventos de un usuario determinado
				"
				$select=Read-host "Seleccione"
				if ($select -eq 1){ eventViewer -eventID 4740}else {
					$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
					eventViewer -eventID 4740 -user $usuarioSeleccionado
				}
				$accion = "Visor de eventos"
				$mensaje = "revision de logs de inicio de sesion de u suario $usuarioSeleccionado "

			}
			4 { 
				write-host "
				(1) Ultimos eventos registrados en los AD
				(2) Ultimos eventos de un usuario determinado
				"
				$select=Read-host "Seleccione"
				if ($select -eq 1){ eventViewer -eventID 4724}else {
					$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
					eventViewer -eventID 4724 -user $usuarioSeleccionado
				}
				$accion = "Visor de eventos"
				$mensaje = "revision de logs de inicio de sesion de u suario $usuarioSeleccionado "
			}
			5 {  
				write-host "
				(1) Ultimos eventos registrados en los AD
				(2) Ultimos eventos de un usuario determinado
				"
				$select=Read-host "Seleccione"
				if ($select -eq 1){ eventViewer -eventID 4776}else {
					$usuarioSeleccionado = seleccionarUsuarioAD -credenciales $credenciales
					eventViewer -eventID 4776 -user $usuarioSeleccionado
				}
				$accion = "Visor de eventos"
				$mensaje = "revision de logs de inicio de sesion de u suario $usuarioSeleccionado "
			}
			6 {  

			}
			7 {  
				
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

