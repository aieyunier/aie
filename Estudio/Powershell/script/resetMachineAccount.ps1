# Reemplaza estos valores con la información adecuada
$nombreComputadora = "NombreDeLaComputadora"
$nombreUsuarioAdmin = "UsuarioAdministrador"
$nuevaContraseña = ConvertTo-SecureString -String "NuevaContraseña" -AsPlainText -Force

# Restablecer la cuenta de la computadora en el dominio
Reset-ComputerMachinePassword -Credential (Get-Credential -UserName $nombreUsuarioAdmin) -Server $nombreComputadora -NewPassword $nuevaContraseña
