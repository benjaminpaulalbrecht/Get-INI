function Get-INIContent ($filePath)
{
    $ini = @{} 
    switch -regex -file $filePath
    {
      
        # Section Header
        "^\[(.+)\]" 
        { 
            $section = $matches[1] 
            $ini[$section] = @{}
            $CommentCount = 0
        }
        
        # Comment  
        "^(;.*)$" 
        { 
            $value = $matches[1]
            $CommentCount = $CommentCount + 1 
            $name = "Comment" + $CommentCount 
            $ini[$section][$name] = $value
        } 
        # Key 
        "(.+?)\s*=\s*(.*)" 
        { 
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value 
        }
    }    
    return $ini 
}





$iniContent = Get-INIContent ".\test.ini" 
$iniContent.Values
