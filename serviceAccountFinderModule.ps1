function Get-ServiceAccountReport {

<#
    .SYNOPSIS
        This function retrieve service accounts logged in a pool of computer passed as argument
    .DESCRIPTION
        This function retrieve service accounts logged in a pool of computer passed as argument
    .PARAMETER 
        -dn : specify a string with the scope of the search (specify an OU or a specific computer)
        -all : get every computers in the domain (not recommanded)
        - input_csv : take as input a csv list of computer names to look up
    .EXAMPLE

    .Contributors
        benoit estrade
        clement LAVOILLOTTE


    #>

    [CmdletBinding()]
    PARAM (
        [parameter(Mandatory = $false, ParameterSetName = "dn")]
        [String]$dn,
        [parameter(Mandatory = $false, ParameterSetName = "All")]
        [Switch]$All,
        [parameter(Mandatory = $false, ParameterSetName = "input_csv")]
        [String]$input_csv
    )


    BEGIN {

        $path_to_file =  "$(pwd)\output.csv"
        $domain = Get-ADDomain | Select-Object name 

        TRY {
            if (-not (Get-Module -Name ActiveDirectory)) { Import-Module -Name ActiveDirectory -ErrorAction Stop -ErrorVariable ErrorBeginIpmoAD }
        }
        CATCH {
            Write-Warning -Message "[BEGIN] Something wrong happened"
            IF ($ErrorBeginIpmoAD) { Write-Warning -Message "[BEGIN] Error while Importing the module Active Directory" }
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    PROCESS {
        
        Write-Host "Searching for services ..."

        TRY {
            if ($psBoundParameters['dn']) {
                get-adcomputer -filter * -SearchBase $dn| % {
                    $c = $_
                    $service = Get-WmiObject "win32_service" -Filter "startname LIKE '%@%' OR startname LIKE '$domain.name\\%'" -ComputerName $c.Name
                    $service | % { New-Object psobject -Property @{
                    Computer = $c.name
                    Service = $_.Name
                    Display_Name = $_.Displayname
                    User = $_.StartName
                } } 
        
                } | out-gridview -title "Service Accounts in your domain" -PassThru| Export-Csv $path_to_file -encoding UTF8 -NoTypeInformation
            
            }
            if ($psBoundParameters['input_csv']) {
                Import-Csv input.csv | % {
                    $c = $_
                    $service = Get-WmiObject "win32_service" -Filter "startname LIKE '%@%' OR startname LIKE '$domain.name%'" -ComputerName $c.name
                    $service | % { New-Object psobject -Property @{
                    Computer = $c.name
                    Service = $_.Name
                    Display_Name = $_.Displayname
                    User = $_.StartName
                } }
                } | Export-Csv $path_to_file -encoding UTF8 -NoTypeInformation
            }
            Write-Host "Services found are written in $(pwd)\output.csv file"
            }
        CATCH {
            Write-Warning -Message "[PROCESS] Something wrong happened"
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
    

