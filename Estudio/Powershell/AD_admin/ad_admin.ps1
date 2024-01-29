clear-host
#################################################################################
# cargando ficheros de configuracion y modulos necesarios
#################################################################################
#importar modulos
Import-Module ActiveDirectory

# Obtiene el contenido del archivo Funciones.ps1
$contenidoFunciones = Get-Content -Path .\app\funciones.ps1 -Raw
Invoke-Expression -Command $contenidoFunciones 
# Obtiene el la lista de atributos que se usan en las consultas de usuarios del AD
$acontenidoadUserProprerties = Get-Content -Path .\config\adUserProperties.ps1 -Raw
Invoke-Expression -Command $acontenidoadUserProprerties
# Obtiene valores de variables globales y parametros que se usaran para las operaciones
$contenidoVariables = Get-Content -Path .\config\variables.ps1 -Raw
Invoke-Expression -Command $contenidoVariables 

#################################################################################
# Inicio del programa principal
#################################################################################
# solicitar la credenciales para la conexion al AD y almacenarlas de manera encriptada en la variable $solicitarCredenciales
# para usarlas en cada operacion con el AD
$solicitarCredenciales = Get-Content -Path .\app\makeCredentials.ps1 -Raw
Invoke-Expression -Command $solicitarCredenciales

#$credencialesPath= "C:\Users\yvaldes\Desktop\DATA\Powershell\script\listos"
#$credenciales = Import-Clixml -Path $credencialesPath

#Inicio
do {
    Clear-Host
    # escribir el texto de cabecera
    Invoke-Expression -Command config\TextoCabecera.ps1


#################################################################################
# Reportes y acciones
#################################################################################

    write-host "
    REPORTES
    (a) - Reporte de todos los usuarios del directorio
    (b) - Reporte de usuarios con clave proximo a expirar
    (c) - Reporte de usuarios con claves que nunca expiran
    (d) - Reporte de usuarios bloqueados
    (e) - Reporte de usuarios deshabilitados
    (f) - Listado de computadoras en Active Directory
    (g) - Listado de OU vacias en Active Directory
    
    ACCIONES
    (p) - Administracion de Usuarios (PANEL DE CONTROL)

    REGISTRO DE EVENTOS
    (r) - Reporte de eventos del controlador de dominio
    "
    #    
    #(k) - Cambiar clave de usuario
    #(l) - Desbloquear cuenta de usuario
    #(m) - Deshabilitar usuario
    #(n) - Eliminar usuario

    $action = read-host "Seleccione la operacion que desea realizar"

    # seleccion del script que se va a ejecutar (cada script realiza una accion o reporte)
    switch -exact ($action) {
        a {
            $script = "a_allusers.ps1"
        }
        b {
            $script = "b_nextExpireUsers.ps1"
        }
        c {
            $script = "c_neverExpireUsers.ps1"
        }
        d {
            $script = "d_lockedUsers.ps1"
        }
        e {    
            $script = "e_disabledUsers.ps1"
        }
        f {    
            $script = "f_allcomputers.ps1"
        }
        g {    
            $script = "g_emptyOU.ps1"
        }
        k {    
            #$script = "k_changePassword.ps1"
        }
        l {    
            #$script = "l_unlockUser.ps1"
        }
        m {    
            #$script = "m_disableUser.ps1"
        }
        p {    
            $script = "p_controlPanel.ps1"
        }
        r {    
            $script = "r_eventViewer.ps1"
        }
        default {
            # Acciones si ningún valor coincide
            Write-host "La accion seleccionada fue la $action"
            #$script = "noImplementado.ps1"
        }
        
    } ## cierre del case de reportes y acciones


    Write-host "La accion seleccionada fue la $action"
    #Se ejecuta el script seleccionado en la estuctura "switch" anterior
    $actionToRun = Get-Content -Path .\app\$script -Raw
    Invoke-Expression -Command $actionToRun

    # Si se escribe "stop" se detiene el ciclo, de lo contrari se procede a una nueva iteracion
    $cicloPrincipal = read-host "Presione ENTER para continuar?"
}  while ($cicloPrincipal -ne "stop")




#################################################################################
# final del script
#################################################################################
Invoke-Expression -Command config\TextoPie.ps1