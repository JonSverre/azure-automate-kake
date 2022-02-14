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
        
        if ($kort.value -eq "A") {
            $kortstokksum = $kortstokksum + 11
                      
        }
        elseif ($kort.value -eq "K") {
            $kortstokksum = $kortstokksum + 10
           
        }
        elseif ($kort.value -eq "Q") {
            $kortstokksum = $kortstokksum + 10
           
        }
        elseif ($kort.value -eq "J") {
            $kortstokksum = $kortstokksum + 10
            
        }
        else {
            $kortstokksum = $kortstokksum + $kort.value  
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
     Write-Output "magnus | $magnus | $kortStokkMagnus"    
     Write-Output "meg    | $meg | $kortStokkMeg"
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



$meg = (kortstokkstringfunc -kortstokk $kortstokk[0..1])
#Write-Output "meg:$meg"

$kortstokksum = $(kortstokksumfunc -kortstokk $kortstokk)
$kortstokk = $kortstokk[2..$kortstokk.Count]
$megkortsum =$($kortstokksum) - $(kortstokksumfunc -kortstokk $kortstokk)
#Write-Output "meg:$megkortsum"

$magnus = (kortstokkstringfunc -kortstokk $kortstokk[0..1])
#Write-Output "Magnus:$magnus"

$kortstokksum = $(kortstokksumfunc -kortstokk $kortstokk)
$kortstokk = $kortstokk[2..$kortstokk.Count]
$magnuskortsum =$($kortstokksum) - $(kortstokksumfunc -kortstokk $kortstokk)
#Write-Output "magnus:$magnuskortsum"

#Write-Output $blackjack
if ($megkortsum -eq $blackjack -and $magnuskortsum -eq $blackjack) {
  
    kortskrivvinnerfunc -vinner "Draw" -kortStokkMagnus $magnuskortsum -kortStokkMeg $megkortsum
    exit
 }
 elseif ($megkortsum -eq $blackjack -and $magnuskortsum -ne $blackjack) {
  
   kortskrivvinnerfunc -vinner "meg" -kortStokkMagnus $magnuskortsum -kortStokkMeg $megkortsum
   exit
}
elseif ($magnuskortsum -eq $blackjack -and $megkortsum -ne $blackjack) {
  
   kortskrivvinnerfunc -vinner "magnus" -kortStokkMagnus $magnuskortsum -kortStokkMeg $megkortsum
   exit
}