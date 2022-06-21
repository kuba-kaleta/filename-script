# for (($j = 0), ($j = 0); $j -lt 2; $j++){Write-Output $j}

# Get-ChildItem | Rename-Item -NewName {$_.LastWriteTime.ToString("yyyy-MM-dd hh.mm.ss ddd") + ($_.Extension)}

# $comm = $dir.GetDetailsOf($dir.ParseName($_.Name), 24)
# if($comm.Length -ge 1001){
#     $comm = $comm.Substring(0, 999)
# }
# $dir.SetDetailsOf($dir.ParseName($_.Name), 24, "$comm ... $_.Name")
# Write-Host $_.Name $short_name

#$short_length = $short_name.Length
# if($item.Name.Length -ge $short_length){
#     if($item.Name.Substring(0, $short_length - $ext.Length) -eq $short_name.Substring(0, $short_length - $ext.Length)){
#         Write-Host "sub" $item.Name.Substring(0, $short_length - $ext.Length) $ext.Length
#         $short = $false
#     }
# }


$str = "123456789012345678901234567890"
$str.Substring(0, 20)