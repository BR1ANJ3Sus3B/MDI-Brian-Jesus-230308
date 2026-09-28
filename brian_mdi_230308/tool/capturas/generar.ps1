<#
.SYNOPSIS
  Genera las capturas PNG de la aplicacion en docs/imagenes/.

.DESCRIPTION
  Descarga (solo si faltan) los .ttf de Space Grotesk que usa google_fonts y
  despues ejecuta el harness de golden tests que renderiza la pantalla real del
  contador en cada estado.

  Los archivos .ttf de .fuentes/ estan en .gitignore: no forman parte del
  proyecto publicado, solo de la generacion de la documentacion.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$raiz = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSCommandPath))
$dirFuentes = Join-Path $raiz 'tool\capturas\.fuentes'
$dirSalida = Join-Path $raiz 'docs\imagenes'

$fuentes = [ordered]@{
  'SpaceGrotesk-Regular.ttf' = '7821207a715952786271398700a0ffaf2dcad829090ab5bca09b9cab112fa8eb'
  'SpaceGrotesk-Bold.ttf'    = '22eb3cc87edf0bd73cd7b79336429dd0035eaf2c9a9fe83c6c7e11b825116926'
  'SpaceGrotesk-Light.ttf'   = 'fd8943c197bcfbb835a8d002ef16d2b5bde4fb928ec8ab97f2ce7366c7a14339'
}

New-Item -ItemType Directory -Path $dirFuentes -Force | Out-Null
New-Item -ItemType Directory -Path $dirSalida -Force | Out-Null

foreach ($nombre in $fuentes.Keys) {
  $destino = Join-Path $dirFuentes $nombre
  $esperado = $fuentes[$nombre]

  if (Test-Path -LiteralPath $destino) {
    $hash = (Get-FileHash -LiteralPath $destino -Algorithm SHA256).Hash.ToLower()
    if ($hash -eq $esperado) {
      Write-Host "fuente al dia: $nombre"
      continue
    }
  }

  $url = "https://fonts.gstatic.com/s/a/$esperado.ttf"
  Write-Host "descargando $nombre ..."
  Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing -TimeoutSec 60

  $hash = (Get-FileHash -LiteralPath $destino -Algorithm SHA256).Hash.ToLower()
  if ($hash -ne $esperado) {
    throw "El hash de $nombre no coincide: se esperaba $esperado y se obtuvo $hash."
  }
}

Write-Host ''
Write-Host 'Renderizando la pantalla del contador ...'
Push-Location $raiz
try {
  flutter test tool/capturas/generar_capturas_test.dart --update-goldens
  if ($LASTEXITCODE -ne 0) { throw "flutter test termino con codigo $LASTEXITCODE." }
}
finally {
  Pop-Location
}

Write-Host ''
Write-Host "Capturas generadas en docs\imagenes\ :"
Get-ChildItem -LiteralPath $dirSalida -Filter 'app-estado-*.png' |
  ForEach-Object { Write-Host "  $($_.Name)  ($([math]::Round($_.Length / 1kb)) KB)" }
