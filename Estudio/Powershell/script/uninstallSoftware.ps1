

#desinstalar un software en version 4.1 de powershell
# Get-WmiObject -Class Win32_Product | Select-Object Name, Version


# Desinstalacion de SGS desde powershel

$credenciales = Import-Clixml -Path $credencialesPath

$programName = "sgs"

$program = Get-WmiObject -Credential $credenciales -Class Win32_Product | Where-Object { $_.Name -eq $programName }
if ($program) {
    $program.Uninstall()
} else {
    Write-Host "El programa $programName no fue encontrado, o ya fue desinstalado previamente"
}