Clear-Host
$ErrorActionPreference = "Stop"
$webrequest = Invoke-WebRequest -uri http://nav-deckofcards.herokuapp.com/shuffle
$kortstokk =  $webrequest.Content | ConvertFrom-Json

function kortstokkstringfunc {[OutputType([string])]
param ([object[]]$kortstokk)

$kortstokksjekk = ""

foreach ($kort in $kortstokk) {
    $kortstokksjekk = $kortstokksjekk + $kort.suit[0] + $kort.value + ","
  
}
$kortstokksjekk = $kortstokksjekk.Substring(0,$kortstokksjekk.Length-1)

return $kortstokksjekk
}
 Write-Output "Kortstokk: $(kortstokkstringfunc -kortstokk $kortstokk)"
 