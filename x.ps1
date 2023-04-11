#
# pwsh -file x.ps1 -path ./aws-report.csv
#
param($path = './aws-report.csv')

## pass 1 parameters
$record_type = 'header'
$line = 0
$level1 = 0
$level2 = -1

## pass 2 parameters
$header_object = [pscustomobject][ordered]@{
    filename = $path
}
$labela = ''
$labelb = ''
$labelc = ''
$labeld = ''
$labele = ''
$labelf = ''
$labelg = ''
$labelh = ''
$detailname = ''
$parts = @()
$lparts = @()
##


import-csv $path -header 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' |
foreach-object {
    $line = $line + 1
    if (-not $_.a -and -not $_.b -and -not $_.c -and -not $_.d) {
        $record_type = 'detail'
        $level1 = $level1 + 1
        if ($level1 -eq 1) {
            $level2 = -3
        } else  {
            $level2 = -2
        }
    }
    $level2 = $level2 + 1
    $_ | 
    add-member -NotePropertyName 'line' -NotePropertyValue $line -PassThru |
    add-member -NotePropertyName 'record_type' -NotePropertyValue $record_type -PassThru |
    add-member -NotePropertyName 'level1' -NotePropertyValue $level1 -PassThru |
    add-member -NotePropertyName 'level2' -NotePropertyValue $level2 -PassThru 
} |
select-object -property line, record_type, level1, level2, a, b, c, d, e, f, g, h, i, j, k, l, m, n, p, q, r, s, t, u, v, w, x, y, z |
foreach-object {
    $item = $_
    switch ($item.record_type) {
        'header' {
            $propertyname = ''
            $propertyvalue = ''
            if ($item.level2 -eq 0) {
                $propertyname = 'report_name'
                $propertyvalue = $item.a
            } else {
                $propertyname = $item.a -replace ' ', '_'
                $propertyvalue = $item.b
            }
            $header_object | add-member -notepropertyname $propertyname -NotePropertyValue $propertyvalue
        }
        'detail' {
            switch ($item.level2) {
                -2 {

                }
                -1 {
                    if ($item.level1 -eq 1) {
                        $labela = $item.a -replace ' ', '_'
                        $labelb = $item.b -replace ' ', '_'
                        $labelc = $item.c -replace ' ', '_'
                        $labeld = $item.d -replace ' ', '_'
                        $labele = $item.e -replace ' ', '_'
                        $labelf = $item.f -replace ' ', '_'
                        $labelg = $item.g -replace ' ', '_'
                        $labelh = $item.h -replace ' ', '_'
                    }
                }
                0 {
                    $detailname = $item.a
                    $parts = $detailname -split '>'
                    $len = $parts.length - 1
                    $lparts = $parts[$len] -split ' - '
                    $parts[$len] = $lparts[0]
                    while ($parts.length -lt 10) {
                        $parts += ''
                    }
                }
                default {
                    if ($item.level2 -gt 0) {
                        $header_object |
                        convertto-json |
                        convertfrom-json |
                        add-member -NotePropertyName 'detail_name' -NotePropertyValue $detailname -PassThru |
                        add-member -NotePropertyName 'detail_line' -NotePropertyValue $level2 -PassThru |
                        add-member -NotePropertyName 'servers' -NotePropertyValue $lparts[1] -PassThru |
                        add-member -NotePropertyName 'part0' -NotePropertyValue $parts[0] -PassThru |
                        add-member -NotePropertyName 'part1' -NotePropertyValue $parts[1] -PassThru |
                        add-member -NotePropertyName 'part2' -NotePropertyValue $parts[2] -PassThru |
                        add-member -NotePropertyName 'part3' -NotePropertyValue $parts[3] -PassThru |
                        add-member -NotePropertyName 'part4' -NotePropertyValue $parts[4] -PassThru |
                        add-member -NotePropertyName 'part5' -NotePropertyValue $parts[5] -PassThru |
                        add-member -NotePropertyName 'part6' -NotePropertyValue $parts[6] -PassThru |
                        add-member -NotePropertyName 'part7' -NotePropertyValue $parts[7] -PassThru |
                        add-member -NotePropertyName 'part8' -NotePropertyValue $parts[8] -PassThru |
                        add-member -NotePropertyName 'part9' -NotePropertyValue $parts[9] -PassThru |
                        add-member -NotePropertyName $labela -NotePropertyValue $item.a -PassThru |
                        add-member -NotePropertyName $labelb -NotePropertyValue $item.b -PassThru |
                        add-member -NotePropertyName $labelc -NotePropertyValue $item.c -PassThru |
                        add-member -NotePropertyName $labeld -NotePropertyValue $item.d -PassThru |
                        add-member -NotePropertyName $labele -NotePropertyValue $item.e -PassThru |
                        add-member -NotePropertyName $labelf -NotePropertyValue $item.f -PassThru |
                        add-member -NotePropertyName $labelg -NotePropertyValue $item.g -PassThru |
                        add-member -NotePropertyName $labelh -NotePropertyValue $item.h -PassThru
                    }
                }
            }

        }
    }
} |
export-csv "./flat_files$($path)-flat.csv" -verbose
