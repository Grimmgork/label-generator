param (
    [string]$templatePath = $(throw "-templatePath is required."), 
    [string]$dataPath = $(throw "-dataPath is required.")
)

Add-Type -AssemblyName System.Web

$data = Import-Csv $dataPath
$result = Get-Content .\index.html
$label = Get-Content $templatePath

if((-not $data) -or (-not $result) -or (-not $label)){
	throw "file missing!"
}

function Get-Section([string[]]$rows, [string]$name){
	$start = $rows.IndexOf("#$($name)")
	$start += 1
	foreach ($line in $rows[$start..($rows.Length-1)]){
		$line = $line.Trim()
		if (($line -like '#*')){
			break
		}
		$line
	}
}

$label_root = Get-Section $label "root"
$label = Get-Section $label "label"

$labels = ""
$c = 0
foreach($row in $data){
	$rep = $label -join "`r`n"
	$rep = $rep.Replace('#$COUNT$#', $c.ToString())
	
	foreach($prop in $row.PSObject.Properties){
		$rep = $rep.Replace(('#$' + $prop.Name + '$#'), [System.Net.WebUtility]::HtmlEncode($prop.Value.ToString()))
	}
	$labels += "<div class='label-container'>`r`n$($rep)`r`n</div>`r`n"
	$c = $c + 1
}

$result.Replace('#$LABELS$#', $labels).Replace('#$ROOT$#', $label_root)