# Change names of all photos in a folder to earliest aviable date

$FOlder = 'C:\Kuba\local\zdjecia_local\timeline\2021\2021'
$CharWhiteList = '[^: \w\/]'
$Shell = New-Object -ComObject shell.application
# for (($j = 0), ($j = 0); $j -lt 2; $j++){
    $i = 1
    Get-ChildItem $FOlder *.jp* -Recurse  | ForEach-Object{
        $dir = $Shell.Namespace($_.DirectoryName)
        $strModified = $dir.GetDetailsOf($dir.ParseName($_.Name),3)
        $strCreated = $dir.GetDetailsOf($dir.ParseName($_.Name),4)
        $strAccessed = $dir.GetDetailsOf($dir.ParseName($_.Name),5)
        $strTaken = $dir.GetDetailsOf($dir.ParseName($_.Name),12)

        $list = New-Object Collections.Generic.List[datetime]

        if ($strModified) {
            $DateModified = [datetime]::ParseExact(($strModified -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
            $list.Add($DateModified)
        }
        if ($strCreated) {
            $DateCreated = [datetime]::ParseExact(($strCreated -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
            $list.Add($DateCreated)
        }
        if ($strAccessed) {
            $DateAccessed = [datetime]::ParseExact(($strAccessed -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
            $list.Add($DateAccessed)
        }
        if ($strTaken) {
            $DateTaken = [datetime]::ParseExact(($strTaken -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
            $list.Add($DateTaken)
        }

        $list_sort = $list | Sort-Object

        $EarliestDate = $list_sort[0]
        Rename-Item $_.FullName ('{0:yyyy_MM_dd}_{1:0000}.jpg' -f $EarliestDate, $i++)
    }
# }