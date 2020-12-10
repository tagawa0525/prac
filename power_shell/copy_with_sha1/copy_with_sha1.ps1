
Set-Location (Split-Path $MyInvocation.MyCommand.Path -Parent)

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue"

class FileWithSha1 {
    [string] $path
    [string] $sha1

    [FileWithSha1] $src

    FileWithSha1($path, $sha1) {
        $this.path = $path
        $this.sha1 = $sha1

        #$this.path_org = $path + ".org"
        #$this.path_new = $path + ".new"
    }

    [string] dir_name( ) { return Split-Path -Parent $this.path }
    [string] file_name() { return [System.IO.Path]::GetFilename($this.path) }

    [boolean] validate_path() {
        if (!(Test-Path $this.path -PathType Leaf)) {
            Write-Debug $this.path
            return $False
        }

        [string] $chck_sha1 = (Get-FileHash -Path $this.path -Algorithm SHA1).Hash.ToLower()
        if ($chck_sha1 -ne $this.sha1) {
            Write-Debug $this.path
            Write-Debug $this.sha1
            Write-Debug $chck_sha1
            return $False
        }

        return $True
    }
}

class SrcDstList {
    [FileWithSha1[]] $news = @()
    [FileWithSha1[]] $orgs = @()

    static install() {
        $dir_org = Get-Item("org")
        if (Test-Path $dir_org -PathType Container) {
            Remove-Item -Path $dir_org -Recurse
        }
        Expand-Archive -Path org.zip -DestinationPath ./
    }

    replace() {
        $this.validate_news()
        $this.validate_orgs()
        $dsts = $this.make_dsts()

        foreach($dst in $dsts) {
            $path = $dst.path
            if($dst.validate_path()){
                Write-Host  "Already Replaced :: ${path}"
            } else {
                Write-Host  "Replace          :: ${path}"
                Copy-Item $dst.src.path $dst.path
            }

        }
    }

    validate_news() {
        foreach ($new in $this.news) {
            if (!($new.validate_path())) {
                Write-Debug "New file has been changed!"
                exit
            }
        }
    }

    validate_orgs() {
        $org_dir = $this.orgs[0].dir_name()
        foreach ($org in $this.orgs) {
            if ($org.dir_name() -ne $org_dir) {
                Write-Debug "Org file has different dir_name!"
                Write-Debug $org_dir
                Write-Debug $org.dir_name()
                exit
            }
        }
    }

    [FileWithSha1[]] make_dsts() {
        [FileWithSha1[]] $dsts = @()
        foreach ($new in $this.news) {
            $org_dir = $this.orgs[0].dir_name()
            $fname = $new.file_name()
            $path = (Join-Path $org_dir $fname)
            $dst = New-Object FileWithSha1($path, $new.sha1)
            $dst.src = $new
            $dsts += $dst
        }
        return $dsts
    }
}

function install_and_copy() {
    [SrcDstList]::install()

    [SrcDstList] $aaa = New-Object SrcDstList
    $aaa.orgs += New-Object FileWithSha1('org/aaa/aaa.txt', '30a70817adf4a33f770a9fabd6ef399ff54b1b84')

    $aaa.news += New-Object FileWithSha1('new/aaa/aaa.txt', 'bfa76de888175d9f90413d692e7710f09a33b059')
    $aaa.news += New-Object FileWithSha1('new/aaa/aa1.txt', 'ccd6d7c34ab101d24478c9667049b07eb002fbed')
    $aaa.news += New-Object FileWithSha1('new/aaa/aa2.txt', '3a0dab1796415fcfaa2999d61f303228a8937b22')

    [SrcDstList] $bbb = New-Object SrcDstList
    $bbb.orgs += New-Object FileWithSha1('org/bbb/bbb.txt', 'ceeaa0615948f47bac426d4f359387e85c433e1b')
    $bbb.news += New-Object FileWithSha1('new/bbb/bbb.txt', '2b2bc7c471109e749c1cb19a5f47ac2d8b16f0a3')

    $aaa.replace()
    $bbb.replace()

    $aaa.replace()
    $bbb.replace()
}

install_and_copy
