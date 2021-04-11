function outer_loop([string]$alp, [int]$num) {
    Write-Host $alp
    Write-Host $num

    Write-Host "$alp-$num"
}

$ary_a = @("a", "b", "c")
$ary_1 = @(1, 2, 3)

Write-Host $ary_a
Write-Host $ary_1

foreach ($alp in $ary_a) {
    foreach ($num in $ary_1) {
        outer_loop($alp, $num)
    }
}
