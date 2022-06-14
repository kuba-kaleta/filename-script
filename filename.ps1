# Change names of all photos in a folder to earliest aviable date

$FOlder = 'C:\Users\kubam\Desktop\New'
$CharWhiteList = '[^: \w\/]'
$Shell = New-Object -ComObject shell.application

$i = 1
Get-ChildItem $FOlder *.jpg -Recurse | ForEach-Object{
    $dir = $Shell.Namespace($_.DirectoryName)
    $strModified = $dir.GetDetailsOf($dir.ParseName($_.Name),3)
    $strCreated = $dir.GetDetailsOf($dir.ParseName($_.Name),4)
    $strAccessed = $dir.GetDetailsOf($dir.ParseName($_.Name),5)
    $strTaken = $dir.GetDetailsOf($dir.ParseName($_.Name),12)

    $list = New-Object Collections.Generic.List[datetime]
    $list_dupl_w  = New-Object Collections.Generic.List[String]

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
    $list_dupl = Get-ChildItem $_.DirectoryName *.jpg
    $earliestDate = $list_sort[0]
    $short_name = '{0:yyyy_MM_dd_HH}h{1:mm}.jpg' -f $earliestDate, $EarliestDate

    Write-Host " "
    Write-Host $_.Name $short_name

    foreach ($item in $list_dupl){
        if($item.Name -ne $_.Name){ # Substring(0, 16)
            Write-Host $item.Name
            $list_dupl_w.Add($item)
        }
        else{
            Write-Host "Odrzucony" $item.Name
        }
    }

    $short = $true
    foreach ($item in $list_dupl_w){
        if($item.Length -ge 16){
            if($item.Substring(0, 16) -eq $short_name.Substring(0, 16)){
                Write-Host "false" $item
                $short = $false
            }
        }        
    }

    if($short -eq $false){
        $global:dupl = $true
        while($dupl){
            $dupl = $false
            $long_name = '{0:yyyy_MM_dd_HH}h{1:mm}_{2:00000}.jpg' -f $EarliestDate, $EarliestDate, $i++
            foreach ($item in $list_dupl_w){
                if($long_name -eq $item){
                    Write-Host "dupl"
                    $dupl = $true
                }
            }
        }
    }

    if($short){
        Write-Host $short_name "      short"
        Rename-Item $_.FullName ($short_name)
    }else{
        Write-Host $long_name "long"
        Rename-Item $_.FullName ($long_name)
    }
}