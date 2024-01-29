
Import-Module -Name PSSendGrid

$Parameters = @{
    FromAddress     = "sapproaie@aie.es"
    ToAddress       = "yunier.valdes@aie.es"
    Subject         = "SendGrid Plain Example"
    Body            = "This is a plain text email"
    Token           = "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"
    FromName        = "Barbara"
    ToName          = "Barbara"
}
Send-PSSendGridMail @Parameters