$Global:RebrickableRoot = "https://rebrickable.com/api/v3/lego"

$fileList = Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -Exclude *.Tests.*
foreach ( $file in $fileList ) {
    . $file.FullName
}