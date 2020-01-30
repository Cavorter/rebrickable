function Test-StandardParams {
    Param()

    Context "Standard Parameter Tests" {
        $functionObject = Get-Command -Name Test-Function
        
        foreach ( $param in $goodParams.Keys ) {
            It "has a parameter named $param that is mandatory" {
                $functionObject.Parameters."$param".Attributes.Mandatory | Should -Be $true
            }

            if ( $param -eq "SetNumber" ) {
                It "has a SetNumber parameter that is the correct type" {
                    $functionObject.Parameters.SetNumber.ParameterType.Name | Should -Be 'String[]'
                }

                It "has a SetNumber parameter that accepts pipeline input" {
                    $functionObject.Parameters.SetNumber.Attributes.ValueFromPipeLine | Should -Be $true
                }
            }
        }
    }
}