
clear-host
Write-host "#################################################################"
Write-host "##########     Administracion de serevicios          ############"
Write-host "#################################################################"

$service = Read-host "Escriba el nombre o parte del nombre del servicio que desea operar"
$option = Read-host "Qué operación desea hacer (0)Listar (1)-Iniciar (2)-Detener (3)-Deshabilitar (4)-Desintalar"

$matchServices = Get-Service | Where-Object { $_.DisplayName -like "*$service*" } 

switch ($option) {
    0 { 
        Write-Host "Listar servicios que coinciden con $service...." 
        Get-Service | Where-Object { $_.DisplayName -like "*$service*" }
    }
    1 { 
        Write-Host "Iniciar servicios que coinciden con $service...." 
        $matchServices | ForEach-Object {
            $serviceName = $_.Name
            $result = Start-Service -Name $serviceName -Force
            write-host $result
            Write-Host "Operacion Completada para $serviceName"
            }
    }
    2 { 
        read-host ""
        Write-Host "Detener servicios que coinciden con $service...." 
        $matchServices | ForEach-Object {
            $serviceName = $_.Name
            $result = Stop-Service -Name $serviceName -Force
            write-host $result
            Write-Host "Operacion Completada $serviceName"
            }
    }
    3 { 
        Write-Host "Deshabilitar servicios que coinciden con $service...." 
        $matchServices | ForEach-Object {
            $serviceName = $_.Name
            $result = Stop-Service -Name $serviceName -Force
            write-host $result
            Write-Host "Operacion Completada $serviceName"
            }
     }
    4 { 
        Write-Host "Desintalar servicios que coinciden con $service...." 
        $matchServices | ForEach-Object {
            $serviceName = $_.Name
            $result = Stop-Service -Name $serviceName -Force
            sc.exe delete $serviceName
            sc delete $serviceName -force
            write-host $result
            Write-Host "Operacion Completada $serviceName"
            }
     }
    default { Write-Host "No ha seleccionado un a opcin valida" }
}
