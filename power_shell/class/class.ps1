
$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue"

class EachData {
    [String] $Header
    [String[]] $Contents
    EachData ($Header) {
        $this.Header = $Header
    }

    [String] $a
    [String] $b
    [String] $c
    [String] $d
    [EachData]set_key($a, $b, $c, $d) {
        $this.a = $a
        $this.b = $b
        $this.c = $c
        $this.d = $d
        return $this
    }

    [String] to_data_file_string() {
        $result = @()
        $result += $this.Header
        foreach ($line in $this.Contents) {
            $result += $line
        }
        # 改行文字が\nではない!
        return ($result -join "`n")
    }

    [String] $path
    [String] write_data_file() {
        $file_name = "out/" + (@($this.a, $this.b, $this.c, $this.d) -join ("_") ) + ".txt"
        $this.path = New-Item $file_name -type File -Force
        $out = (New-Object System.IO.StreamWriter($this.path, $False))
        $out.WriteLine($this.to_data_file_string())
        $out.close()
        return $this.path
    }
}

class DataFile {
    [String] $path
    DataFile($path) {
        $this.path = $path
    }

    [EachData[]] $included
    [DataFile] parse() {
        Write-Debug $this.path
        $tag_a, $tag_b = (Get-Item $this.path).BaseName.Split("_")
        Write-Debug "(tag_a, tab_b) = ($tag_a, $tag_b)"

        $each_data = New-Object EachData("")
        $inp = New-Object System.IO.StreamReader($this.path)
        $first = $True
        while ($Null -ne ($line = $inp.ReadLine())) {
            $a, $b, $c, $d, $num = $line.Split()
            if (($a -eq $tag_a) -and ($b -eq $tag_b)) {
                if ($first) {
                    $first = $False
                }
                else {
                    $this.included += $each_data
                }
                $each_data = New-Object EachData($line)
                $each_data.set_key($a, $b, $c, $d)
                Write-Debug "(a, b, c, d, num) : ($a, $b, $c, $d, $num)"
            }
            else {
                $each_data.Contents += $line
            }
        }
        $this.included += $each_data
        $inp.close()

        return $this
    }

    [String[]] split() {
        [String []] $paths = @()
        foreach ($ed in $this.included) {
            $paths += $ed.write_data_file()
        }
        return $paths
    }
}

function run () {
    [DataFile[]] $data_files = @()
    foreach ($path in Get-ChildItem("inp/*.txt")) {
        $df = (New-Object DataFile($path)).parse()
        $data_files += $df
    }

    foreach ($df in $data_files) {
        $paths = $df.split()
        Write-Host ($paths -join ("`n"))
    }
}

Set-Location (Split-Path $MyInvocation.MyCommand.Path -Parent)
run
