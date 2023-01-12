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

function Insert-Parameter([string] $name, $value, [string] $text){
	$text.Replace(('#$' + $name + '$#'), [System.Net.WebUtility]::HtmlEncode($value.ToString()))
}

$label_root = Get-Section $label "root"
$label = Get-Section $label "label"

$labels = ""
$c = 0
foreach($row in $data){
	$rep = $label -join "`r`n"
	$rep = Insert-Parameter "COUNT" $c $rep
	foreach($prop in $row.PSObject.Properties){
		$rep = Insert-Parameter $prop.Name.ToLower() $prop.Value $rep
	}
	$labels += "<div class='label-container'>`r`n$($rep)`r`n</div>`r`n"
	$c = $c + 1
}

$result.Replace('#$LABELS$#', $labels).Replace('#$ROOT$#', $label_root)
