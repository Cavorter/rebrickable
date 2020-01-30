$functionName = $MyInvocation.MyCommand.Name.Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"
Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\StdTests.ps1

Describe "Get-Set" {
    $goodApiKey = "NotAnApiKey0123456"
    $goodSetNumber = "1000-1"
    $goodUri = ( [uri]$uri = "$RebrickableRoot/sets/$goodSetNumber/" ).AbsoluteUri

    $goodResult = @{
        "set_num"          = $goodSetNumber
        "name"             = "Manual Points"
        "year"             = 1978
        "theme_id"         = 999
        "num_parts"        = 566
        "set_img_url"      = "https://cdn.rebrickable.com/media/sets/$goodSetNumber.jpg"
        "set_url"          = "https://rebrickable.com/sets/$goodSetNumber/manual-points/"
        "last_modified_dt" = ( Get-Date )
    }

    $goodParams = @{ ApiKey = $goodApiKey ; SetNumber = $goodSetNumber }

    Mock -CommandName Invoke-RestMethod -MockWith { return $goodResult }

    Test-StandardParams

    Context "Happy Path" {
        $testResult = Test-Function @goodParams

        It "calls the remote api" {
            Assert-MockCalled -Scope Context -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter { $uri -eq $goodUri -and $Headers.Authorization -eq "key $goodApiKey" }
        }

        It "returns the expected result" {
            $testResult -eq $goodResult | Should -Be $true
        }
    }

    Context "Multiple Sets" {
        $SetList = @( "1111-1" , "2222-2" )

        It "processes all sets via pipeline" {
            $SetList | Test-Function -ApiKey $goodApiKey
            Assert-MockCalled -Scope It -CommandName Invoke-RestMethod -Times $SetList.Count -Exactly
        }

        It "processes all sets via parameter" {
            Test-Function -ApiKey $goodApiKey -SetNumber $SetList
            Assert-MockCalled -Scope It -CommandName Invoke-RestMethod -Times $SetList.Count -Exactly
        }
    }
}
