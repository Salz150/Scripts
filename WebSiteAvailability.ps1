# Import Testing function (also defines prerequisites).C:\Users\LeandroT\Dropbox\Documents\Powershell\Ultimate\Test-ReportSite.ps1
##############################################################################
##
## Website Availability Monitoring
## Created by Sravan Kumar S 
## Date : 19 Apr 2013
## Version : 1.0
## Email: sravankumar.s@outlook.com  
##############################################################################
CLS
## The URI list to test
#$URLListFile = "C:\Users\LeandroT\Documents\Powershell\WebTest\Weblink_Test.csv" 
#$URLListFile =  "C:\Users\ltorres\Dropbox\Documents\Powershell\Ultimate\Weblink_TestShort.csv"
$URLListFile =  "C:\Users\LeandroT\Dropbox\Documents\Powershell\Ultimate\Weblink_Test.csv"
$URLList = Import-CSV $URLListFile -Header ARNumber,CustomerName,Descrip,URL,ReportNet_URL,Admin_Server,Weblogic_Domain,Application_Server,SQL_Server,ReportNet_Server,Port_Number,Version_Number,UTA_DatabaseName -ErrorAction SilentlyContinue
$Result = @()

$wc = New-Object System.Net.WebClient

Foreach ($item in $URLList) {
  $ARNumber           = $item.ARNumber  
  $CustomerName       = $item.CustomerName  
  $Descrip            = $item.Descrip  
  $URL                = $item.URL  
  $ReportNet_URL      = $item.ReportNet_URL  
  $Admin_Server       = $item.Admin_Server  
  $Weblogic_Domain    = $item.Weblogic_Domain  
  $Application_Server = $item.Application_Server  
  $SQL_Server         = $item.SQL_Server  
  $ReportNet_Server   = $item.ReportNet_Server  
  $Port_Number        = $item.Port_Number  
  $Version_Number     = $item.Version_Number  
  $UTA_DatabaseName   = $item.UTA_DatabaseName
  try 
  {    
    $request = $null     
    ## Request the URI, and measure how long the response took.    
    $time = (Measure-Command { $request = Invoke-WebRequest -Uri $URL }).TotalMilliseconds
  }   
  catch  
  {    
  <# If the request generated an exception (i.e.: 500 server    
          error or 404 not found), we can pull the status code from the    
          Exception.Response property #>    
  $request = $_.Exception.Response   
  $time = -1 
  }  
  ###############################################################################
  Write-Host $URL  [string] 
  $content = $wc.DownloadString($URL)    
  # Preparing a custom object, prefill with "under construction" values  
  $restmp = [PSCustomObject] @{    
  TimeTime              = Get-Date    Uri               = $URL    ResponseLength    = $request.RawContentLength    TimeTaken         = $time    ARNumber          = $ARNumber    CustomerName      = $CustomerName    Descrip           = $Descrip    URL               = $URL    ReportNet_URL     = $ReportNet_URL    Admin_Server      = $Admin_Server     Weblogic_Domain   = $Weblogic_Domain    Application_Server= $Application_Server    SQL_Server        = $SQL_Server    ReportNet_Server  = $ReportNet_Server    Port_Number       = $Port_Number    Version_Number    = $Version_Number    UTA_DatabaseName  = $UTA_DatabaseName
    StatusCode        = [int] -201    StatusDescription = "Website Under Construction"  }
  if($content -notmatch "Under Construction") {    $restmp.StatusCode        = [int] $request.StatusCode    $restmp.StatusDescription = $request.StatusDescription  }  $Result += $restmp
  if ($request.StatusCode -eq 200)  {    $ReportTest = Test-ReportSite $URL "workbrain" "Pwd"  }
  Write-Host $ReportTest
  if($ReportTest -eq -200 ){        $result += [PSCustomObject] @{      Time              = Get-Date      Uri               = $URL      ResponseLength    = $request.RawContentLength      TimeTaken         = $time      ARNumber          = $ARNumber      CustomerName      = $CustomerName      Descrip           = $Descrip      URL               = $URL      ReportNet_URL     = $ReportNet_URL      Admin_Server      = $Admin_Server       Weblogic_Domain   = $Weblogic_Domain      Application_Server= $Application_Server      SQL_Server        = $SQL_Server      ReportNet_Server  = $ReportNet_Server      Port_Number       = $Port_Number      Version_Number    = $Version_Number      UTA_DatabaseName  = $UTA_DatabaseName
      StatusCode        = [int] -201      StatusDescription = "Testing Report Page Failed. Please try again Manually to confirm Error";    }  }}
#Prepare email body in HTML formatif($result){  $Outputreport = "<HTML><TITLE>Website UTA Availability Report</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2> Website UTA Availability Report </H2></font><Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>URL</B></TD><TD><B>StatusCode</B></TD><TD><B>StatusDescription</B></TD><TD><B>ResponseLength</B></TD><TD><B>TimeTaken</B></TD><TD><B>ARNumber</B></TD><TD><B>CustomerName</B></TD><TD><B>Descrip</B></TD><TD><B>URL</B></TD><TD><B>ReportNet_URL</B></TD><TD><B>Admin_Server</B></TD><TD><B>Weblogic_Domain</B></TD><TD><B>Application_Server</B></TD><TD><B>SQL_Server</B></TD><TD><B>ReportNet_Server</B></TD><TD><B>Port_Number</B></TD><TD><B>Version_Number</B></TD><TD><B>UTA_DatabaseName</B></TD></TR>"  Foreach ($Entry in $Result)  {    if($Entry.StatusCode -ne "200")    {      $Outputreport += "<TR bgcolor=red>"        if ($Entry.StatusCode -eq "-201") { $Outputreport += "<TR bgcolor=orange>"        }      if ($Entry.StatusCode -eq "-200") { $Outputreport += "<TR bgcolor=PaleVioletRed>" }    }    else    {        $Outputreport += "<TR>"    }
<#    if($Entry.StatusCode -eq "-201") { $Outputreport += "<TR bgcolor=Orange>" }    if($Entry.StatusCode -ne "200" -and $Entry.StatusCode -ne "-201")    {        $Outputreport += "<TR bgcolor=red>"    }    else    {        $Outputreport += "<TR>"    }#>    $Outputreport += "<TD>$($Entry.uri)</TD><TD align=center>$($Entry.StatusCode)</TD><TD align=center>$($Entry.StatusDescription)</TD><TD align=center>$($Entry.ResponseLength)</TD><TD align=center>$($Entry.timetaken)</TD><TD align=center>$($Entry.ARNumber)</TD><TD align=center>$($Entry.CustomerName)</TD><TD align=center>$($Entry.Descrip)</TD><TD align=center>$($Entry.URL)</TD><TD align=center>$($Entry.ReportNet_URL)</TD><TD align=center>$($Entry.Admin_Server)</TD><TD align=center>$($Entry.Weblogic_Domain)</TD><TD align=center>$($Entry.Application_Server)</TD><TD align=center>$($Entry.SQL_Server)</TD><TD align=center>$($Entry.ReportNet_Server)</TD><TD align=center>$($Entry.Port_Number)</TD><TD align=center>$($Entry.Version_Number)</TD><TD align=center>$($Entry.UTA_DatabaseName)</TD></TR>"  }  $Outputreport += "</Table></BODY></HTML>"}
$Outputreport | out-file C:\Users\LeandroT\Dropbox\Documents\Powershell\Ultimate\Test.htmlInvoke-Expression C:\Users\LeandroT\Dropbox\Documents\Powershell\Ultimate\Test.html  if (!(Get-Variable ie -Scope global -ea SilentlyContinue) -or !$ie.Document){  $global:ie = New-Object -comobject InternetExplorer.Application}$ie.visible = $true$ie.silent  = $true
$global:ReportPart = "/interface/folderTree.jsp?rootId=216&expandLevel=1&clearUIPath=true&uiPathLabel=Reports"
function Test-ReportSite ([String] $url, [String] $login, [String] $password){  $ie.Navigate2($url)  while ($ie.busy)                               { Start-Sleep -m 100 }  while ($ie.Document.readyState -ne 'Complete') { Start-Sleep -m 100 }     $ie.Document.getElementsByTagName("input")  | ? { $_.Id   -eq 'loginField'    } | % { $_.value = $login    }  $ie.Document.getElementsByTagName("input")  | ? { $_.Id   -eq 'passwordField' } | % { $_.value = $password }  $ie.Document.getElementsByTagName("button") | ? { $_.Type -eq 'button'        } | % { $_.Click() }  while ($ie.Document.readyState -ne 'Complete') { Start-Sleep -m 100 }    $ie.Navigate2($url + $ReportPart)  while ($ie.Document.readyState -ne 'Complete') { Start-Sleep -m 100 }
  $link = $ie.Document.getElementsByTagName("a") | ? { $_.InnerText -like '*Overtime Report' }  |  select  -First 1 -expandProperty href  if(!$link) {             $link = $ie.Document.getElementsByTagName("a") | ? { $_.InnerText -like '*Count' }  |  select  -First 1 -expandProperty href             }  $ie.Navigate2($link)  while ($ie.Document.readyState -ne 'Complete') { Start-Sleep -m 100 }     $ie.Document.getElementsByTagName("button") | ? { $_.innerText -eq 'Go' } | % { $_.Click() }  Start-Sleep 5
<#  Error message evaluation ignored ATM     $ie.Document.getElementsByTagName("span") | ft -a classname, tagname, innerText #Gets you error#>
  $RunByTest = $ie.Document.body.tagname -eq 'FRAMESET' -and $ie.Document.body.id -eq 'reportViewerFrame'
  if($RunByTest) {      $TestValue = 200            }  else {               $TestValue = -200  }  Write-Host "$URL`: $TestValue"   return $TestValue}
