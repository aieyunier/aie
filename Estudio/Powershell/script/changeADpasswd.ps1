clear
write-host "############################################"
write-host "####    CAMBIO DE PASS EN EL AD        #####"
write-host "############################################"
write-host "...................... by Yunier Valdés 2023"
write-host ""
write-host "Explicacion:"
write-host "Este script leera los pares USUARIO,PASSWORD de un fichero txt  con ruta 
predefinida en el cuertpo de este script, Se conectara al directorio activo y cambiara el 
password para cada usuario"
write-host ""
read-host "Escriba ok"
# Ruta del archivo de texto que contiene los nombres de los usuarios (uno por línea)
$filePath = "C:\Users\yvaldes\Desktop\DATA\Powershell\script\usuariosAD.txt"

# Obtener la contraseña que deseas establecer para los usuarios (puedes cambiarla por la contraseña deseada)
#$securePassword = ConvertTo-SecureString "T3mp0r4l2023++" -AsPlainText -Force

# Leer los nombres de los usuarios desde el archivo
#$userNames = Get-Content $filePath

# Recorrer la lista de nombres de usuarios y cambiar la contraseña
#foreach ($userName in $userNames) {
#    try {
#        Set-ADAccountPassword -Identity $userName -NewPassword $securePassword -Reset
#        Write-Host "Contraseña cambiada para el usuario $userName"
#    } catch {
#        Write-Host "Error al cambiar la contraseña para el usuario $userName"
#    }
#    write-host $userName
#}



# Ruta del archivo de texto que contiene el nombre de usuario y la contraseña (formato: "usuario,contraseña" por línea)
#$filePath = "C:\ruta\archivo.txt"

# Leer las líneas del archivo y cambiar la contraseña de los usuarios
Get-Content $filePath | ForEach-Object {
    $line = $_ -split ","
    $userName = $line[0]
    $newPassword = $line[1] | ConvertTo-SecureString -AsPlainText -Force

    try {
        Set-ADAccountPassword -Identity $userName -NewPassword $newPassword -Reset
        Write-Host "Password cambiado para el usuario $userName"
    } catch {
        Write-Host "Error al cambiar el password para el usuario $userName"
    }
}
