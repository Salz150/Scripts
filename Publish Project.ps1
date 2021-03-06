﻿# ======================================================================================
# Author:		Chris Salisbury
# Create date:  2016-07-26
# Description:	Script template to publish a project.
# ======================================================================================

Write-Host "Backing up encrypted connection strings..."
Write-Host ""
Write-Host ""

# Backup the encrypted connection string.
Invoke-Expression "Robocopy.exe \\encrypted_connection_Strings \\Backup_location /MIR"

Write-Host ""
Write-Host ""

Write-Host "Deleting project directories except for the App_Data folder."
Write-Host ""
Write-Host ""

# Delete everything in project root folder except for App_Data.
Remove-Item "\\project\*.*"

$BinFolder = "\\project\bin"
If ((Test-Path $BinFolder) -eq $True)
{
    Remove-Item $BinFolder -Recurse
    Write-Host "   Directory ""$($BinFolder)"" deleted."
}
else
{
    Write-Host "   Directory ""$($BinFolder)"" does not exist."
}

$ContentFolder = "\\project\Content"
If ((Test-Path $ContentFolder) -eq $True)
{
   Remove-Item $ContentFolder -Recurse
   Write-Host "   Directory ""$($ContentFolder)"" deleted."
}
else
{
   Write-Host "   Directory ""$($ContentFolder)"" does not exist."
}

$FontsFolder = "\\project\fonts"
If ((Test-Path $FontsFolder) -eq $True)
{
    Remove-Item $FontsFolder -Recurse
    Write-Host "   Directory ""$($FontsFolder)"" deleted."
}
else
{
    Write-Host "   Directory ""$($FontsFolder)"" does not exist."
}

$ModelsFolder = "\\project\Models"
If ((Test-Path $ModelsFolder) -eq $True)
{
    Remove-Item $ModelsFolder -Recurse
    Write-Host "   Directory ""$($ModelsFolder)"" deleted."
}
else
{
    Write-Host "   Directory ""$($ModelsFolder)"" does not exist."
}

$ScriptsFolder = "\\project\Scripts"
If ((Test-Path $ScriptsFolder) -eq $True)
{
    Remove-Item $ScriptsFolder -Recurse
    Write-Host "   Directory ""$($ScriptsFolder)"" deleted."
}
else
{
    Write-Host "   Directory ""$($ScriptsFolder)"" does not exist."
}

$ViewsFolder = "\\project\Views"
If ((Test-Path $ViewsFolder) -eq $True)
{
    Remove-Item $ViewsFolder -Recurse
    Write-Host "   Directory ""$($ViewsFolder)"" deleted."
}
else
{
    Write-Host "   Directory ""$($ViewsFolder)"" does not exist."
}

Write-Host ""
Write-Host ""

Write-Host "Publishing project to DEV enviroment."

Write-Host ""
Write-Host ""

# Publish PDMC to DEV.
$msbuild = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
Invoke-Expression "$($msbuild) 'C:\Users\Me\Documents\Visual Studio 2015\Projects\project\project\project.csproj' /p:DeployOnBuild=true /p:PublishProfile=Dev /p:VisualStudioVersion=12.0 /v:m"

Add-Content "C:\Users\me\Documents\Project Publishes to DEV.txt" "Published Project to DEV - $(Get-Date -format F)"

