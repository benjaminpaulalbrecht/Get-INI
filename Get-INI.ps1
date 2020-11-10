# ref: https://devblogs.microsoft.com/scripting/use-powershell-to-work-with-any-ini-file/ (comment section: Casten Giese)

$ErrorActionPreference = "continue" 

$signature = @'

[DllImport("kernel32.dll")] 
public static extern uint GetPrivateProfileString( 
    string lpAppName,
    string lpKeyName,
    string lpDefault,
    StringBuilder lpReturnedString,
    uint nSize,
    string lpFileName);
'@


$getini = Add-Type -MemberDefinition $signature -Name getini -Namespace GetPrivateProfileString -Using System.Text -PassThru 

function Get-INI ($filename, $category, $key) {

    $length = 1024 
    $result = New-Object System.Text.StringBuilder $length
    $null = $getini::GetPrivateProfileString($category, $key, "", $result, $length, $filename) 
    return ($result.ToString() -split " ;")[0].Trim() 
    
}

#example usage:
$value = get-ini "C:\users\balbrecht\OneDrive - Energy Transfer\Q0FN\test.ini"  "Assets" "Legacy" 
$value