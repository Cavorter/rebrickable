$functionName = $MyInvocation.MyCommand.Name.Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"
Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\StdTests.ps1

Describe "$functionName" {
    $goodApiKey = "NotAnApiKey0123456"
    $goodSetNumber = "1000-1"
    $goodPageSize = 1000
    $goodUri = ( [uri]("$RebrickableRoot/sets/$goodSetNumber/parts/?page_size=$goodPageSize") ).AbsoluteUri

    $goodResult = Get-Content $PSScriptRoot\..\TestContent\TestInventory.json | ConvertFrom-Json

    $goodParams = @{ ApiKey = $goodApiKey ; SetNumber = $goodSetNumber }

    Mock -CommandName Invoke-RestMethod -MockWith { return @{ count = $goodResult.Count; next = ''; previous = ''; results = $goodResult } }

    Test-StandardParams

    Context "Happy Path" {
        $testResult = Test-Function @goodParams

        It "calls the remote api" {
            Assert-MockCalled -Scope Context -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter { $uri -eq $goodUri -and $Headers.Authorization -eq "key $goodApiKey" }
        }

        It "returns the expected result" {
            $testResult.Count | Should -Be $goodResult.Count
            $testIndex = Get-Random -Minimum 0 -Maximum ( $goodResult.Count - 1 )
            $testResult[$testIndex].id | Should -Be $goodResult[$testIndex].id
        }
    }
}
