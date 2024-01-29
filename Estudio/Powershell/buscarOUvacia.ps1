# Importar el módulo de Active Directory
Import-Module ActiveDirectory

# Obtiene todas las OUs en el dominio especificado
$ouList = Get-ADOrganizationalUnit -Filter * -SearchBase "DC=redaie,DC=local"

# Recorre la lista de OUs y verifica si están vacías
foreach ($ou in $ouList) {
    $objetosEnOU = Get-ADObject -SearchBase $ou.DistinguishedName -SearchScope OneLevel -Filter *
    if ($objetosEnOU.Count -eq 0) {
        Write-Host "OU sin objetos: $($ou.Name)"
    }
}



# Recorre la lista de OUs y verifica si están vacías
foreach ($ou in $ouList) {
    $objetosEnOU = Get-ADObject -SearchBase $ou.DistinguishedName -SearchScope OneLevel -Filter *
    if ($objetosEnOU.Count -eq 0) {
        $resultado = New-Object PSObject -Property @{
            'Nombre_OU' = $ou.Name
            'Ruta_OU'   = $ou.DistinguishedName
        }
        $resultados += $resultado
    }
}

# Mostrar los resultados en formato de tabla
$resultados | Format-Table -AutoSize Nombre_OU, Ruta_OU