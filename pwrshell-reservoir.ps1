# omit execution policy
PowerShell.exe -ExecutionPolicy Bypass -File .\test.ps1

# parameter
Param (
  $Path
)
Write-Host $Path
