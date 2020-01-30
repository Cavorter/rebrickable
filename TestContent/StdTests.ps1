function Test-StandardParams {
    Param()

    Context "Standard Parameter Tests" {
        $functionObject = Get-Command -Name Test-Function
        
        foreach ( $param in $goodParams.Keys ) {
            It "has a parameter named $param that is mandatory" {
                $functionObject.Parameters."$param".Attributes.Mandatory | Should -Be $true
            }
        }
    }
}