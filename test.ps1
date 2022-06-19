# for (($j = 0), ($j = 0); $j -lt 2; $j++){Write-Output $j}

# Get-ChildItem | Rename-Item -NewName {$_.LastWriteTime.ToString("yyyy-MM-dd hh.mm.ss ddd") + ($_.Extension)}


$str = "123456789012345678901234567890"
$str.Substring(0,20)