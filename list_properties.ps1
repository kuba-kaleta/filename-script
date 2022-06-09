$Folder = (New-Object -ComObject Shell.Application).NameSpace("C:\")
0..400 | ForEach {
If ($DataValue = $Folder.GetDetailsOf($null, $_)) {
Write-Output "$DataValue"
}
}