[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $UrlKortstokk
)

Clear-Host
$ErrorActionPreference = "Stop"

function kortstokkstringfunc {[OutputType([String])]
param ([object[]]$kortstokk)

$kortstokksjekk = ""

foreach ($kort in $kortstokk) {
    $kortstokksjekk = $kortstokksjekk + "$($kort.suit[0])" + "$($kort.value)" + ","
  
}
$kortstokksjekk = "$($kortstokksjekk.Substring(0,$kortstokksjekk.Length-1))"

return $kortstokksjekk
}

function kortstokksumfunc {[OutputType([Int])]
    param ([object[]]$kortstokk)
    
    $kortstokksum = 0

    foreach ($kort in $kortstokk) {
        
        $kortstokksum += switch ($kort.value){
            { $_ -cin @('J', 'K', 'Q' ) } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
      
    }
   return $kortstokksum
}
    
 function kortskrivvinnerfunc {
     param (
         [string]
         $vinner,
         [object[]]
         $kortstokkMagnus,
         [object[]]
         $kortstokkMeg
     )
     Write-Output "Vinner: $vinner"
     Write-Output "magnus | $(kortstokksumfunc -kortstokk $kortStokkMagnus) | $(kortstokkstringfunc -kortstokk $kortStokkMagnus)"    
     Write-Output "meg    | $(kortstokksumfunc -kortstokk $kortStokkMeg) | $(kortstokkstringfunc -kortstokk $kortStokkMeg)"
    }


 try {
    $webrequest = Invoke-WebRequest -uri $UrlKortstokk
   
    }
catch {
    Write-Error "Denne Url har ikke noen kortstokk" -ErrorAction Stop
}


$kortstokk = ""
$blackjack = 21
$kortstokk = $webrequest.Content | ConvertFrom-Json
Write-Output "Kortstokk: $(kortstokkstringfunc -kortstokk $kortstokk)"
Write-Output "Poengsum: $(kortstokksumfunc -kortstokk $kortstokk)"
$kortStokkMeg = $kortstokk[0..1]

#Write-Output "kortstokk meg: $(kortstokkstringfunc -kortstokk $kortstokkmeg)"
$kortstokk = $kortstokk[2..$kortstokk.Count]
$kortStokkMagnus = $kortstokk[0..1]
#Write-Output "kortstokk magnus: $(kortstokkstringfunc -kortstokk $kortstokkmagnus)"
$kortstokk = $kortstokk[2..$kortstokk.Count]
#Write-Output "kortstokk igjen: $(kortstokkstringfunc -kortstokk $kortstokk)"


 do {
       #kortstokksumfunc -kortstokk $kortStokkMeg   
        $kortStokkMeg += $kortstokk[0]
        $kortstokk = $kortstokk[1..$kortstokk.Count]
        #if ((kortstokksumfunc -kortstokk $kortStokkMeg) -le 21) {Exit}
        #Write-Output $kortstokk
       Write-Output $(kortstokksumfunc -kortstokk $kortStokkMeg)
} while (((kortstokksumfunc -kortstokk $kortStokkMeg) -lt 17 -and (kortstokksumfunc -kortstokk $kortStokkMeg)-le 21))


while ((kortstokksumfunc -kortstokk $kortStokkMagnus) -lt (kortstokksumfunc -kortstokk $kortStokkMeg) -and (kortstokksumfunc -kortstokk $kortStokkMagnus)-le 21 ){
    $kortStokkMagnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
    #Write-Output $kortstokk
    #Write-Output $(kortstokksumfunc -kortstokk $kortStokkMagnus)

}


if ((kortstokksumfunc -kortstokk $kortStokkMagnus) -le 21 -and (kortstokksumfunc -kortstokk $kortStokkMagnus) -lt (kortstokksumfunc -kortstokk $kortStokkMeg) ){

    kortskrivvinnerfunc -vinner "Magnus" -kortStokkMagnus $kortStokkMagnus -kortStokkMeg $kortStokkMeg
    exit
}
Else {
     kortskrivvinnerfunc -vinner "Meg" -kortStokkMagnus $kortStokkMagnus -kortStokkMeg $kortStokkMeg
 exit
}
