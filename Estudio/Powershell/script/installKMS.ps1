Install-WindowsFeature -Name VolumeActivation -IncludeManagementTools
Set-NetFirewallRule -Name SPPSVC-In-TCP -Profile Domain,Private -Enabled True
vmw.exe


#instalar mediante PowerShell
Install-WindowsFeature -Name VolumeActivation -IncludeManagementTools

#permitir conexiones en el FW (accesible por los puerto tcp:1688)
Set-NetFirewallRule -Name SPPSVC-In-TCP -Profile Domain,Private -Enabled True

# Para instalar la clave kms
lsmgr.vbs /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
# Para publicar la entrada en el DNS desde el servidor KMS:
slmgr /sdns
# Para chequear que el servidor KMS esta activado:
slmgr.vbs /dlv
# 