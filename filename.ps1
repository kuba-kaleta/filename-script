# Write-Host "Congratulations! Your first script executed successfully"

$FOlder = 'C:\Users\kubam\Desktop\New'
$CharWhiteList = '[^: \w\/]'
$Shell = New-Object -ComObject shell.application
$i = 1
Get-ChildItem $FOlder *.jpg -Recurse  | ForEach-Object{
    $dir = $Shell.Namespace($_.DirectoryName)
    $DateTaken = [datetime]::ParseExact(($dir.GetDetailsOf($dir.ParseName($_.Name),12) -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
    Rename-Item $_.FullName ('{0:yyyy_MM_dd}_Nr{1:0000}.jpg' -f $DateTaken, $i++)
}