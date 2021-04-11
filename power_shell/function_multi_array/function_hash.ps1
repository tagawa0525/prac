function multi_array_by_hash($hash_table) {
    foreach ($alp in $hash_table["alps"]) {
        foreach ($num in $hash_table["nums"]) {
            Write-Host "$alp-$num"
        }
    }
}

$hash_table = @{
    "alps" = @("a", "b", "c")
    "nums" = @(1, 2, 3)
}

multi_array_by_hash($hash_table)
