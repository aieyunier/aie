
Clear-Host
Write-host "#################################################################"
Write-host "########## NOTIFICACION E-MAIL MEDIANTE SENDGRID   ###########"
Write-host "#################################################################"
write-host "........................................... by Yunier Valdés 2023"
write-host ""

Import-Module -Name PSSendGrid

write-host "Se enviara un correo de pruebas usando apikey....
******************************************
from:   sapproaie@aie.es
to:     yunier.valdes@aie.es
******************************************
"
$Parameters = @{
    FromAddress     = "sap@aie.es"
    ToAddress       = "yunier.valdes@aie.es"
    Subject         = "otra prueba"
    Body            = "This is a plain text email"
    Token           = "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"
    FromName        = "Yunier aie"
    ToName          = "Yunier"
}
Send-PSSendGridMail @Parameters

#sedgrid yunier
#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
#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
#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
#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

#sap:
#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


#new sendgrid aie:
#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