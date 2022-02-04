[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $UrlKortstokk
)

Clear-Host
$ErrorActionPreference = "Stop"

function kortstokkstringfunc {[OutputType([string])]
param ([object[]]$kortstokk)

$kortstokksjekk = ""

foreach ($kort in $kortstokk) {
    $kortstokksjekk = $kortstokksjekk + $kort.suit[0] + $kort.value + ","
  
}
$kortstokksjekk = $kortstokksjekk.Substring(0,$kortstokksjekk.Length-1)

return $kortstokksjekk
}

try {
    $webrequest = Invoke-WebRequest -uri $UrlKortstokk
    $kortstokk =  $webrequest.Content | ConvertFrom-Json
    Write-Output "Kortstokk: $(kortstokkstringfunc -kortstokk $kortstokk)"
}
catch {
    Write-Output "Denne Url har ikke noen kortstokk"
}
