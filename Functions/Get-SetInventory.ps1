function Get-SetInventory {
    <#
        .SYNOPSIS
            Retrieves the part inventory for a specific set
        .DESCRIPTION
            Retrieves the part inventory for a specific LEGO set from Rebrickable.com

            NOTE: You must sign up for an account and then generate an APIKey on Rebrickable.com
            before using this function.
        .PARAMETER ApiKey
            An APIKey generated for your account at https://rebrickable.com/users/<your username>/settings/#api
        .PARAMETER SetNumber
            The number of a LEGO set to retrieve. Usually in the format of "####-#".
        .EXAMPLE
            PS> Get-SetInventory -ApiKey 12345 -SetNumber 1000-1


        .LINK
            https://rebrickable.com/api/v3/swagger/#!/lego/lego_sets_parts_list
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true)]
        [string]$ApiKey,

        [parameter(Mandatory = $true)]
        [string]$SetNumber
    )

    Begin {
        # Setting a default page size for now
        $PageSize = 1000

        [uri]$uri = "$RebrickableRoot/sets/$SetNumber/parts/?page_size=$PageSize"
        Write-Verbose "URI: $uri"

        $authHeader = @{ Authorization = "key $ApiKey" }
    }
    
    Process {
        $result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $authHeader
        $result.results | Write-Output
    }
}
