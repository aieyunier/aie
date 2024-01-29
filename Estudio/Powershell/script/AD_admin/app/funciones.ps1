function SeleccionarUsuarioAD {
    param (
        $credenciales
    )
        
    do {
        $validacion1 = "OK"
        
        $usuario = Read-Host "Ingrese el nombre del usuario"
        
        if ([string]::IsNullOrWhiteSpace($usuario)) {
            Write-Host "Debe escribir el nombre o parte del nombre del usuario."
            $validacion1 = "fail"
        }
        else {
            $usuariosEncontrados1 = Get-ADUser -Filter "SamAccountName -like '*$usuario*'" | Select-Object SamAccountName
            if ($usuariosEncontrados1.Count -eq 0) {
                Write-Host "No se encontraron usuarios coincidentes."
                $validacion1 = "fail"
            }
        }
    } while ($validacion1 -eq "fail")

    Write-Host "Usuarios Coincidentes: $($usuariosEncontrados1.Count)"
    $indice = 1
    $usuariosEncontrados1 | ForEach-Object {
        Write-Host "$indice. $($_.SamAccountName)"
        $indice++
    }

    do {
        $validacion2 = "ok"
        $usuarioSeleccionado = ""
        Write-Host "Seleccione un usuario de la lista:"
        #Write-Host "Cancelar operacion (0)"
        $seleccion = Read-Host "Introduzca la opcion"
    
        $usuarioSeleccionado = $usuariosEncontrados1[$seleccion - 1].SamAccountName
        Write-Host "usuario seleccionado: $usuarioSeleccionado"
        #if ($seleccion -match '^\d+$' -and $seleccion -ge 0 -and $seleccion -le $fin) {
        #    $validacion2 = "OK"
        #}
        
    } while ($usuarioSeleccionado -eq $null -or [string]::IsNullOrWhiteSpace($usuarioSeleccionado))
    
    return $usuarioSeleccionado
}


function mostrarResumenUsuariosAD {
    param (
        $credenciales,
        $adUserProperties
    )
    
# leyendo la base de datos de usuarios del servidor LDAP
write-host "Obteniendo informacion de usuarios del directorio, por favor espere..."

# total de usuarios del AD
$allUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties
# obteniendo los usuarios con claves que nunca expiran
$neverExpireUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties | Where-Object { $_.PasswordNeverExpires -eq $false }
# obteniendo los usuarios habilitados, qproximos a expirar
$nextExpireUsers = get-aduser -Credential $credenciales -filter * -properties $adUserProperties | Where-Object {$_.Enabled -eq "True"} | Where-Object { $_.PasswordNeverExpires -eq $false } | Where-Object { $_.passwordexpired -eq $false }
# obteniendo los usuarios deshabilitados
$disabledUsers= get-aduser -Credential $credenciales -filter {Enabled -eq $false}  -properties $adUserProperties
# obteniendo los usuarios bloqueados
$lockedUsers= get-aduser -Credential $credenciales -filter * -properties $adUserProperties | Where-Object { $_.LockedOut -eq $True }


write-host ""
Write-host "#################################################################"
write-host "Total de usuarios en Active Directory:................. " $allUsers.Length
write-host "Usuarios con claves que nunca expiran:................. " $neverExpireUsers.Length
#write-host "Usuarios con claves que expiran proximamente:.......... " $nextExpireUsers.Length
write-host "Usuarios deshabilitados:............................... " $disabledUsers.Length
write-host "Usuarios bloqueados:................................... " $lockedUsers.Length
Write-host "#################################################################"
write-host ""
    
}

function seleccionarUsuarioAD2 {
    param (
        $credenciales
    )
        
    # Solicitar el usuario sobre el que se realizara la accion
    do{
        $validacion1 = "OK"
        # Solicitar el nombre de usuario para cambiar la contraseña
        $usuario = Read-Host "Ingrese el nombre del usuario"
        # Verificar si no se introdujo un valor nulo
        if ($usuario -eq "") {
            Write-Host "Debe escribir el nombre o parte del nombre del usuario."
            $validacion1 = "fail"
        }else{
            # Buscar usuarios que coincidan con el nombre introducido
            $usuariosEncontrados = Get-ADUser -Filter "SamAccountName -like '*$usuario*'" | Select-Object SamAccountName
            if($usuariosEncontrados.Count -eq 0){
                write-host "No se encontraron usuarios coincidentes"
                $validacion1 = "fail"
            }
        }
    }while ($validacion1 -eq "fail")

    ## Mostrar los usuarios coincidentes y crear indice para su seleccion
    write-host "Usuarios Coincidentes: " $usuariosEncontrados.Count
    $indice = 1
    $usuariosEncontrados | ForEach-Object {
        Write-Host "$indice. $($_.SamAccountName)"
        $indice++
    }

    # solicitar y validar la seleccion de indice
    do{
        $validacion2 = "fail"
        write-host "Seleccione un usuario de la lista:"
        write-host "Cancelar operacion (0)"
        $seleccion = Read-Host "Introduzca la opcion"
        if ($seleccion -ge 1 -and $seleccion -le $usuariosEncontrados.Count) {
            $validacion2 = "OK"
        }       
    }while ($validacion2 -eq "fail" -and $seleccion -ne "0")
        if ($seleccion -ne "0") {
            # en este punto, se ha seleccionado la accion y el usuario, y se procede a realizar operacion
            # Obtener el nombre de usuario seleccionado
            $usuarioSeleccionado = $usuariosEncontrados[$seleccion - 1].SamAccountName
            return $usuarioSeleccionado
    }
}

function SeleccionarOU {
    param (
        [string]$searchBase = "DC=redaie,DC=local"
    )

    $ous = Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $searchBase
    Write-Host "Unidades Organizativas Disponibles:"

    for ($i = 0; $i -lt $ous.Count; $i++) {
        Write-Host "$i. $($ous[$i].Name)"
    }
    $ouIndex = Read-Host "Selecciona el indice de la Unidad Organizativa o X para terminar"
    if ($ouIndex -eq "x") {
        return $null
    }

    $selectedOU = $ous[$ouIndex]

    $subOU = SeleccionarOU -searchBase $selectedOU.DistinguishedName
    if ($subOU -ne $null) {
        return $subOU
    }

    return $selectedOU.DistinguishedName
}
function RegistrarLog {
    param (
        [string]$usuario,
        [string]$accion,
        [string]$mensaje
    )

    # Obtiene la fecha y hora actual
    $fechaActual = Get-Date

    # Obtiene el año, el mes, el día y la hora de la fecha actual
    $year = $fechaActual.Year
    $month = $fechaActual.Month.ToString("D2") # Asegura que el mes tenga dos dígitos
    $day = $fechaActual.Day.ToString("D2")     # Asegura que el día tenga dos dígitos
    $hour = $fechaActual.Hour.ToString("D2")   # Asegura que la hora tenga dos dígitos
    $minute = $fechaActual.Minute.ToString("D2") # Asegura que el minuto tenga dos dígitos
    $second = $fechaActual.Second.ToString("D2") # Asegura que el segundo tenga dos dígitos

    # Crea el nombre del archivo con el formato AñoMesDia.log
    $nombreArchivo = "$year$month$day.log"

    # Crea la línea de registro con la información proporcionada y la fecha y hora actual
    $lineaRegistro = "$fechaActual - Usuario: $usuario - Accion: $accion - Mensaje: $mensaje"

    # Agrega la línea de registro al archivo de texto
    Add-Content -Path log\$nombreArchivo -Value $lineaRegistro

    # Muestra un mensaje con la línea de registro creada
    Write-Host "Registro guardado en el archivo '$nombreArchivo':"
    Write-Host $lineaRegistro
}

function cambiarClaveUsuario {
    param (
        [string]$usuario
    )
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
}

function intDatosNewUser {
    Write-Host "Se solicitaran a continuacion los datos del nuevo usuario"
    Write-Host "****************************************************"
    Write-Host "Ejemplo:"
    Write-Host "****************************************************"
    Write-Host "Nombre(s) del usuario: Daniel Alejandro"
    Write-Host "1er Apellido: Perez"
    Write-Host "2do Apellido: Diaz"
    Write-Host "Cuenta de usuario: dperez"
    Write-Host "Direccion de correo electronico: daniel.perez@aie.es"
    Write-Host "Clave del usuario: Cl4v3usu4r10+"
    Write-Host "****************************************************"

    $nombreNewUser = Read-Host "Nombre(s) del Usuario"
    $apellido1NewUser = Read-Host "1er Apellido"
    $apellido2NewUser = Read-Host "2do Apellido"

    $defaultCuenta = $nombreNewUser[0] + $apellido1NewUser
    do {
        $cuentaNewUser = Read-Host "Cuenta de usuario ($defaultCuenta)"
        if ([string]::IsNullOrEmpty($cuentaNewUser)) {
            $cuentaNewUser = $defaultCuenta
        }
        $valid = [regex]::IsMatch($cuentaNewUser, '^[a-zA-Z][a-zA-Z0-9_]+$')
        if (-not $valid) {
            Write-Host "El formato de la cuenta de usuario no es valido para Active Directory. Intentalo nuevamente."
        }
    } while (-not $valid)

    do {
        $correoNewUser = Read-Host "Direccion de correo electronico"
        $valid = [regex]::IsMatch($correoNewUser, '^\S+@\S+\.\S+$')
        if (-not $valid) {
            Write-Host "El formato del correo electronico no es valido. Intentalo nuevamente."
        }
    } while (-not $valid)

    $defaultClave = "Cl4v3usu4r10+"
    do {
        $claveNewUser = Read-Host "Clave del usuario (10 caracteres, mayusculas, minusculas y caracteres especial)" -AsSecureString
        if ([string]::IsNullOrEmpty($claveNewUser)) {
            $claveNewUser = $defaultClave
        }
        $valid = $claveNewUser.Length -gt 9 -and $claveNewUser -cmatch "[A-Z]" -and $claveNewUser -cmatch "[a-z]" -and $claveNewUser -cmatch "[\W_]"
        if (-not $valid) {
            Write-Host "La clave no cumple con los requisitos. Intentalo nuevamente."
        }
    } while (-not $valid)
    
    $newUser = New-Object PSObject -Property @{
        Nombre = $nombreNewUser
        Apellido1 = $apellido1NewUser
        Apellido2 = $apellido2NewUser
        Cuenta = $cuentaNewUser
        Correo = $correoNewUser
        Clave = $claveNewUser
    }

    return $newUser
}

function eventViewer {
    param (
        $domainController1 = "prometeo",
        $domainController2 = "europa",
        $user="",
        $eventID=4624,
        $maxEvent= 50
    )
    if ([string]::IsNullOrWhiteSpace($user)) {
        $xpathFilter = "*[System[EventID=$eventID]]"
    } else {$xpathFilter = "*[System[EventID=$eventID]] and *[EventData[Data[@Name='TargetUserName']='$user']]"}

    $eventLog = Get-WinEvent -ComputerName $domainController1 -LogName Security -MaxEvents $maxEvent -FilterXPath $xpathFilter 
    write-host $eventLog.Length
    if ($eventLog.Length -gt 0){
        foreach ($event in $eventLog) {
            $xml = [xml]$event.ToXml()
            $userName = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'TargetUserName'} | Select-Object -ExpandProperty '#text'
            #$computerName = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'WorkstationName'} | Select-Object -ExpandProperty '#text'
            $computerIP = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'IpAddress'} | Select-Object -ExpandProperty '#text'
            $errorCode = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'Status_Code'} | Select-Object -ExpandProperty '#text'

            Write-Host "Controlador de dominio: $domainController1"
            Write-Host "Evento ID: $($event.Id)"
            Write-Host "Registro: $($event.LogName)"
            Write-Host "Hora de evento: $($event.TimeCreated)"
            Write-Host "Usuario: $userName"
            #Write-Host "Computadora: $computerName"
            Write-Host "Direccion IP: $computerIP"
            #Write-Host "Cdigo de estado: $errorCode"
            Write-Host "------------------------"
        }
    }else{write-host "No hay eventos con ID $eventID para el usuario $user"}   
    
    $eventLog = Get-WinEvent -ComputerName $domainController2 -LogName Security -MaxEvents $maxEvent -FilterXPath $xpathFilter 
    if ($eventLog.Length -gt 0){
        foreach ($event in $eventLog) {
            $xml = [xml]$event.ToXml()
            $userName = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'TargetUserName'} | Select-Object -ExpandProperty '#text'
            #$computerName = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'WorkstationName'} | Select-Object -ExpandProperty '#text'
            $computerIP = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'IpAddress'} | Select-Object -ExpandProperty '#text'
            $errorCode = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'Status_Code'} | Select-Object -ExpandProperty '#text'

            Write-Host "Controlador de dominio: $domainController2"
            Write-Host "Evento ID: $($event.Id)"
            Write-Host "Registro: $($event.LogName)"
            Write-Host "Hora de evento: $($event.TimeCreated)"
            Write-Host "Usuario: $userName"
            #Write-Host "Computadora: $computerName"
            Write-Host "Direccion IP: $computerIP"
            #Write-Host "Cdigo de estado: $errorCode"
            Write-Host "------------------------"
        }
    }else{write-host "No hay eventos con ID $eventID para el usuario $user"}   
}

# Función recursiva para verificar si una OU está completamente vacía
function IsOUCompletelyEmpty($ou) {
    $objetosEnOU = Get-ADObject -SearchBase $ou.DistinguishedName -SearchScope OneLevel -Filter *
    if ($objetosEnOU.Count -eq 0) {
        return $true
    }
    
    foreach ($subOU in $objetosEnOU) {
        if ($subOU.ObjectClass -eq "organizationalUnit" -and (IsOUCompletelyEmpty $subOU)) {
            return $true
        }
    }
    
    return $false
}