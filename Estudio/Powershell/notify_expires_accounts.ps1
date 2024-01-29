# Configuración de variables
$dominio = "redaie" 
$correoRemitente = "active_directory@aie.es"  
$smtpServidor = "smtp.example.com" 
$correoDestinatario = "yunier.valdes@aie.es"

# Obtener fecha actual
$fechaActual = Get-Date

# Obtener fecha límite (10 días en el futuro)
$fechaLimite = $fechaActual.AddDays(10)

# Obtener usuarios del dominio
$usuarios = Get-ADUser -Filter * -Properties PasswordLastSet, EmailAddress -SearchBase "OU=Usuarios,DC=$dominio,DC=com"

# Verificar fecha de expiración de contraseña de cada usuario
foreach ($usuario in $usuarios) {
    $fechaExpiracion = $usuario.PasswordLastSet.AddDays((Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.TotalDays)
    if ($fechaExpiracion -lt $fechaLimite) {
        $diasRestantes = ($fechaExpiracion - $fechaActual).Days
        $asunto = "Notificación de caducidad de contraseña"
        $cuerpo = "La contraseña del usuario $($usuario.SamAccountName) caducará en $diasRestantes días."
        
        # Enviar notificación por correo electrónico
        Send-MailMessage -From $correoRemitente -To $correoDestinatario -Subject $asunto -Body $cuerpo -SmtpServer $smtpServidor
    }
}
