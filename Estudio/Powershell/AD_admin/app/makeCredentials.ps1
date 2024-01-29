############################################################################
# Solicitud y validacion de credenciales del AD
############################################################################
# Solicitar las credenciales al usuario
write-host ""
read-host "Se solicitaran credenciales para la conexion al AD (y)"
write-host ""

do{
#obtener credenciales del usuario
$credenciales = Get-Credential

# Extrae el nombre de usuario del objeto de credenciales
$nombreUsuario = $credenciales.UserName

# Si hay conectividad con el controlador de dominio, intenta autenticar el usuario en Active Directory
try {
    $usuario = Get-ADUser -Credential $credenciales -Identity $nombreUsuario -ErrorAction Stop
    $mensaje = "$nombreUsuario se ha autenticado satisfactoriamente"
    $conect = "ok"
}
catch {
    $mensaje = "Error al autenticar el usuario $nombreUsuario. Verifique usuario y clave."
    $conect = "no_ok"
    read-host "Presine ENTER para intentarlo de nuevo"
}
write-host $mensaje
# Guardar log de la operacion
RegistrarLog -usuario $nombreUsuario -accion "Inicio de sesion" -mensaje $mensaje
}while ($conect -eq "no_ok")
