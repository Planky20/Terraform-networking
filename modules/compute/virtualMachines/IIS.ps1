Import-Module servermanager
Add-WindowsFeature web-server -includeallsubfeature
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "This is the server $($env:computername) !"