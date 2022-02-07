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
    
try {
    $webrequest = Invoke-WebRequest -uri $UrlKortstokk
   
}
catch {
    Write-Error "Denne Url har ikke noen kortstokk" -ErrorAction Stop
}
$kortstokk =  $webrequest.Content | ConvertFrom-Json
Write-Output "Kortstokk: $(kortstokkstringfunc -kortstokk $kortstokk)"
Write-Output "Poengsum: $(kortstokksumfunc -kortstokk $kortstokk)"