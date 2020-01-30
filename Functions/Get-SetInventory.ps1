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
            The identifier for one or more LEGO sets to retrieve. Usually in the format of "####-#".
        .EXAMPLE
            PS> Get-SetInventory -ApiKey 12345 -SetNumber 1000-1
        .EXAMPLE
            PS> Get-SetInventory -ApiKey 12345 -SetNumber 1111-1,2222-2
        .LINK
            https://rebrickable.com/api/v3/swagger/#!/lego/lego_sets_parts_list
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true)]
        [string]$ApiKey,

        [parameter(Mandatory = $true, ValueFromPipeLine = $true)]
        [string[]]$SetNumber
    )

    Begin {
        # Setting a default page size for now
        $PageSize = 1000
        $uriTemplate = '{0}/sets/{1}/parts/?page_size={2}'
        $authHeader = @{ Authorization = "key $ApiKey" }
    }
    
    Process {
        foreach ( $entry in $SetNumber ) {
            [uri]$uri = $uriTemplate -f $RebrickableRoot,$entry,$PageSize
            Write-Verbose "URI: $uri"
            $result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $authHeader
            $result.results | Write-Output
        }
    }
}
