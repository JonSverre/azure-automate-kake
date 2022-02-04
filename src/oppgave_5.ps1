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

function kortstokksumfunc {[OutputType([String])]
    param ([object[]]$kortstokk)
    
    [int]$kortstokksum = ""
    [int]$kortverdi = ""

    foreach ($kort in $kortstokk) {
        
        if ($kort.value -eq "A") {
            [int]$kortverdi = "11"
                      
        }
        elseif ($kort.value -eq "K") {
            [int]$kortverdi = "10"
           
        }
        elseif ($kort.value -eq "Q") {
            [int]$kortverdi = "10"
           
        }
        elseif ($kort.value -eq "J") {
            [int]$kortverdi = "10"
            
        }
        else {
            [int]$kortverdi = $kort.value   
        }
         
        [int]$kortstokksum = [int]$kortstokksum + [int]$kortverdi    
        
          
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