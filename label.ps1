Add-Type -AssemblyName System.Web

$data = Import-Csv -Path .\example\names.csv

$result = Get-Content .\index.html

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

$label = Get-Content .\example\label.html
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