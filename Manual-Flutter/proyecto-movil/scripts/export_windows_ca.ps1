$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$certificateDirectory = Join-Path $projectRoot '.local'
New-Item -ItemType Directory -Force -Path $certificateDirectory | Out-Null
# Public root certificates only. No private keys are exported or trust settings changed.
$trustedCertificates = Get-ChildItem Cert:\CurrentUser\Root,Cert:\LocalMachine\Root | Sort-Object Thumbprint -Unique
$pemBlocks = foreach ($certificate in $trustedCertificates) {
    '-----BEGIN CERTIFICATE-----'
    [Convert]::ToBase64String($certificate.RawData, [Base64FormattingOptions]::InsertLineBreaks)
    '-----END CERTIFICATE-----'
}
$certificateFile = Join-Path $certificateDirectory 'windows-ca.pem'
[IO.File]::WriteAllLines($certificateFile, $pemBlocks, [Text.Encoding]::ASCII)
Write-Output "Exportados $($trustedCertificates.Count) certificados públicos a .local/windows-ca.pem."
