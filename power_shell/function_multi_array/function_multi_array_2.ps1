function multi_array( [string[]]$ary_a, [int[]]$ary_1) {
    #Write-Host $ary_a
    #Write-Host $ary_1
    foreach ($alp in $ary_a) {
        Write-Host $alp
        foreach ($num in $ary_1) {
            Write-Host "$alp-$num"
        }
    }
}

$ary_a = [string[]]("a", "b", "c")
$ary_1 = [int[]](1, 2, 3)

#Write-Host $ary_a
#Write-Host $ary_1

multi_array($ary_a, $ary_1)
