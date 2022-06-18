# for (($j = 0), ($j = 0); $j -lt 2; $j++){Write-Output $j}

# Get-ChildItem | Rename-Item -NewName {$_.LastWriteTime.ToString("yyyy-MM-dd hh.mm.ss ddd") + ($_.Extension)}


$string1 = "a"
$string1 = $string1.Replace(".", "p")
$string1