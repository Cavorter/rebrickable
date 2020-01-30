function Get-Set {
    <#
        .SYNOPSIS
            Retrieves data for a specific Set from Rebrickable.com
        .DESCRIPTION
            Retrieves detailed information about a specific set from Rebrickable.com

            NOTE: You must sign up for an account and then generate an APIKey on Rebrickable.com
            before using this function.
        .PARAMETER ApiKey
            An APIKey generated for your account at https://rebrickable.com/users/<your username>/settings/#api
        .PARAMETER SetNumber
            The number of a LEGO set to retrieve. Usually in the format of "####-#".
        .EXAMPLE
            PS> Get-Set -ApiKey 1234 -SetNumber 1000-1

            set_num             : 1000-1
            name                : Mosaic Set
            year                : 1985
            theme_id            : 516
            num_parts           : 190
            set_img_url         : https://cdn.rebrickable.com/media/sets/1000-1.jpg
            set_url             : https://rebrickable.com/sets/1000-1/mosaic-set/
            last_modified_dt    : 12/20/2019 9:21:21 AM
        .LINK
            https://rebrickable.com/api/v3/swagger/#!/lego/lego_sets_list
    #>
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [string]$ApiKey,

        [parameter(Mandatory = $true)]
        [string]$SetNumber
    )

    Begin {
        [uri]$uri = "$RebrickableRoot/sets/$SetNumber/"
        Write-Verbose "URI: $uri"
        $authHeader = @{ Authorization = "key $ApiKey" }
    }

    Process {
        $result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $authHeader
        $result | Write-Output
    }
}
