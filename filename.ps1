# Change names of all photos in a folder to earliest aviable date

$FOlder = 'C:\Kuba\local\projekty_local\kody\filename-test'
$types = ('.jpg', '.jpeg', '.heic', '.png')
$CharWhiteList = '[^: \w\/]'
$Shell = New-Object -ComObject shell.application

$raport_folder_name = $FOlder.Replace("\", "_").Replace(":", "")
$curr_date = Get-Date -Format "MM_dd_yyyy_HH_mm_ss_"
$raport_folder = 'C:\Kuba\local\projekty_local\kody\filename-test\raports'
$raport_path = $raport_folder + "\" + "$raport_folder_name$curr_date.txt"
New-Item -Path $raport_folder -Name "$curr_date$raport_folder_name.txt" -ItemType File

$i = 1
Get-ChildItem $FOlder -Recurse | where {$_.extension -in $types} | ForEach-Object{ # -Recurse
    $dir = $Shell.Namespace($_.DirectoryName)
    $strModified = $dir.GetDetailsOf($dir.ParseName($_.Name),3)
    $strCreated = $dir.GetDetailsOf($dir.ParseName($_.Name),4)
    $strTaken = $dir.GetDetailsOf($dir.ParseName($_.Name),12)
    # $strAccessed = $dir.GetDetailsOf($dir.ParseName($_.Name),5)

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
    if ($strTaken) {
        $DateTaken = [datetime]::ParseExact(($strTaken -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
        $list.Add($DateTaken)
        $taken = ""
        if($strCreated){
            if($DateCreated -lt $DateTaken){
                $taken = "_ntc" # nieprawidlowy date taken
            }
        }
    }
    else{
        $taken = "_nt" # brak date taken
    }
    # if ($strAccessed) {
    #     $DateAccessed = [datetime]::ParseExact(($strAccessed -replace $CharWhiteList),"yyyyMMdd HH:mm",$Null)
    #     $list.Add($DateAccessed)
    # }

    $size = $_.Length
    If     ($size -gt 1TB) {$size_format = [string]::Format("{0:0.00}TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {$size_format = [string]::Format("{0:0.00}GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {$size_format = [string]::Format("{0:0.00}MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {$size_format = [string]::Format("{0:0.00}KB", $size / 1KB)}
    ElseIf ($size -gt 0)   {$size_format = [string]::Format("{0:0.00}B", $size)}
    Else                   {$size_format = "brak_rozmiaru"}
    # $size_format = $size_format.replace('.','-')

    $list_sort = $list | Sort-Object
    $list_dupl = Get-ChildItem $_.DirectoryName | where {$_.extension -in $types}
    $earliestDate = $list_sort[0]
    $ext = $_.extension.ToLower()
    $short_name = "{0:yyyy_MM_dd_HH}h{1:mm_}$size_format$taken" -f $earliestDate, $EarliestDate
    $short_name_e = $short_name + $ext

    $short = $true
    foreach ($item in $list_dupl){
        if($item.Name -ne $_.Name){ # Substring(0, 16)
            # Write-Host $item.Name
            $list_dupl_w.Add($item) 
            if($item.Name -eq $short_name_e){
                Write-Host "sub" $item.Name
                $short = $false
            }
        }       
    }

    if($short -eq $false){
        $global:dupl = $true
        while($dupl){
            $dupl = $false
            $long_name = "$short_name{0:_00000}$ext" -f $i++
            foreach ($item in $list_dupl_w){
                if($long_name -eq $item){
                    # Write-Host "dupl"
                    $dupl = $true
                }
            }
        }
    }

    if($short){
        Write-Host $short_name_e
        Rename-Item $_.FullName ($short_name_e)
        $_.FullName + " --> " + $short_name_e | Out-File -FilePath $raport_path -Append -Force
    }else{
        Write-Host $long_name
        Rename-Item $_.FullName ($long_name)
        $_.FullName + " --> " + $long_name | Out-File -FilePath $raport_path -Append -Force
    }
}