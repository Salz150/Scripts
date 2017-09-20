$url = "http://regexstorm.net/tester"

$ie = New-Object -ComObject InternetExplorer.Application

$ie.Navigate2($url)

$ie.Visible = $true

# Giving IE time to load
while($ie.ReadyState -ne 4){
    Start-Sleep -m 100
}

Start-Sleep -m 100

$jsSetBackColor = @"
`$(".body_container").css("background-color","black");
"@

$jsSetBackColor

$ie.document.parentWindow.execScript($jsSetBackColor,"javascript")
