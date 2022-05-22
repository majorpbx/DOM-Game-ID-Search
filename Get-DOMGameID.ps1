Function Get-DOMGameId {
Param(
[Parameter(Mandatory=$true, ValueFromPipeline=$false)]
[int]$System = '24', # Nintendo 64
[Parameter(Mandatory=$true, ValueFromPipeline=$false)]
[ValidateSet('1','2','3','4','5','6','7','8','9')]
[int]$SearchType = '3', # Serials
[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
[String]$Serial
)

<#
where = '1'    # archive name
where = '2'    # hash-data
where = '3'    # serials
where = '4'    # numbering
where = '5'    # scene dirname
where = '6'    # UNKNOWN
where = '7'    # LOG
where = '8'    # file name
where = '9'    # title
#>

$DOM_Response = Invoke-WebRequest -Uri "https://datomatic.no-intro.org/index.php?page=search&s=$($System)" `
-Method "POST" `
-Headers @{
"authority"="datomatic.no-intro.org"
  "method"="POST"
  "path"="/index.php?page=search&s=$($System)"
  "scheme"="https"
  "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "accept-encoding"="gzip, deflate, br"
  "accept-language"="en-US,en;q=0.9,ja;q=0.8"
  "cache-control"="max-age=0"
  "origin"="https://datomatic.no-intro.org"
  "referer"="https://datomatic.no-intro.org/index.php?page=search&s=$($System)"
  "sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"101`", `"Google Chrome`";v=`"101`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "sec-fetch-dest"="document"
  "sec-fetch-mode"="navigate"
  "sec-fetch-site"="same-origin"
  "sec-fetch-user"="?1"
  "upgrade-insecure-requests"="1"
} `
-ContentType "application/x-www-form-urlencoded" `
-Body "system_selection=$($System)&text=$($Serial)&where=$($SearchType)&sort=Dump+Status&order=Ascending"

$Content  = $DOM_Response.ParsedHtml.IHTMLDocument3_getElementsByTagName("TABLE") | Where-Object { $_.classname -eq "info-table" }

Switch -Regex ($Content.outerHTML) {
"n=(\d+)`"\>" { $Script:GameId = "$($Matches[1])" }
}

}
