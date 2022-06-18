# Change names of all photos in a folder to earliest aviable date

$FOlder = 'C:\Users\kubam\Desktop\New'
$types = ('.jpg', '.jpeg', '.heic')
$CharWhiteList = '[^: \w\/]'
$Shell = New-Object -ComObject shell.application

$i = 1
Get-ChildItem $FOlder -Recurse | where {$_.extension -in $types} | ForEach-Object{ # -Recurse
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

    $size = $_.Length
    If     ($size -gt 1TB) {$size_format = [string]::Format("{0:0.00}TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {$size_format = [string]::Format("{0:0.00}GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {$size_format = [string]::Format("{0:0.00}MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {$size_format = [string]::Format("{0:0.00}KB", $size / 1KB)}
    ElseIf ($size -gt 0)   {$size_format = [string]::Format("{0:0.00}B", $size)}
    Else                   {$size_format = ""}
    # $size_format = $size_format.replace('.','-')

    $list_sort = $list | Sort-Object
    $list_dupl = Get-ChildItem $_.DirectoryName | where {$_.extension -in $types}
    $earliestDate = $list_sort[0]
    $ext = $_.extension
    $short_name = "{0:yyyy_MM_dd_HH}h{1:mm_}$size_format$ext" -f $earliestDate, $EarliestDate

    # $comm = $dir.GetDetailsOf($dir.ParseName($_.Name), 24)
    # if($comm.Length -ge 1001){
    #     $comm = $comm.Substring(0, 999)
    # }
    # $dir.SetDetailsOf($dir.ParseName($_.Name), 24, "$comm ... $_.Name")
    # Write-Host $_.Name $short_name

    foreach ($item in $list_dupl){
        if($item.Name -ne $_.Name){ # Substring(0, 16)
            # Write-Host $item.Name
            $list_dupl_w.Add($item)
        }
        else{
            # Write-Host "Odrzucony" $item.Name
        }
    }

    $short = $true
    foreach ($item in $list_dupl_w){
        if($item.Length -ge 16){
            if($item.Substring(0, 20) -eq $short_name.Substring(0, 20)){
                # Write-Host "false" $item
                $short = $false
            }
        }        
    }

    if($short -eq $false){
        $global:dupl = $true
        while($dupl){
            $dupl = $false
            $long_name = "{0:yyyy_MM_dd_HH}h{1:mm}_$size_format{2:_00000}$ext" -f $EarliestDate, $EarliestDate, $i++
            foreach ($item in $list_dupl_w){
                if($long_name -eq $item){
                    # Write-Host "dupl"
                    $dupl = $true
                }
            }
        }
    }

    if($short){
        Write-Host $short_name
        Rename-Item $_.FullName ($short_name)
    }else{
        Write-Host $long_name
        Rename-Item $_.FullName ($long_name)
    }
}