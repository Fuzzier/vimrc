function IterateSubFolders()
{
    param
    (
        # A single path, or an array of paths
        $Paths,
        # Return $True to visit subdirectories recursively
        $Callback
    )
    $toVisit = @()
    foreach ($path in $Paths)
    {
        # Skip junction (symbolic link of directory)
        $item = Get-Item -Path $path -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
        {
            # Convert `$item` to a `DirectoryInfo` object and retrieves it
            $reparsePointType = [System.IO.DirectoryInfo]$item | Get-Item
            if ($reparsePointType.LinkType -eq "Junction")
            {
                continue
            }
        }
        $children = Get-ChildItem -Path $path -Directory -Force
        foreach ($child in $children)
        {
            $fullpath = $child.FullName
            # Return $True to visit subdirectories recursively
            $retval = & $Callback -Path $fullpath
            if ($retval[-1])
            {
                $toVisit = $toVisit + $fullpath
            }
        }
    }
    $toVisit
}

function IterateSubFoldersRecursively()
{
    param
    (
        # A single path, or an array of paths
        $Paths,
        # Return $True to visit subdirectories recursively
        $Callback
    )
    $toVisit = $Paths
    do
    {
        $toVisit = IterateSubFolders -Paths $toVisit -Callback $Callback
    }
    while ($toVisit)
}

function GitGc()
{
    param
    (
        [string] $Path
    )
    Write-Host '========================================'
    Write-Host $Path
    Write-Host '========================================'
    Set-Location -Path $Path
    git gc
    git prune
}

function TryGitRepo()
{
    param
    (
        [string] $Path
    )
    $isGitRepo = (Test-Path -Path (Join-Path -Path $Path -ChildPath 'HEAD')) -and
                 (Test-Path -Path (Join-Path -Path $Path -ChildPath 'refs')) -and
                 (Test-Path -Path (Join-Path -Path $Path -ChildPath 'objects'))
    if ($isGitRepo)
    {
        $objectsPath = Join-Path -Path $Path -ChildPath 'objects'
        # Get all subdirectories whose name has two characters, other than 'info' and 'pack'
        $subfolders = Get-ChildItem -Path $objectsPath -Directory -Name '??'
        if ($subfolders)
        {
            $retval = GitGc -Path $Path
            return $true
        }
    }
    return $false
}

function TryGitWorktree()
{
    param
    (
        [string] $Path
    )
    $repo = Join-Path -Path $Path -ChildPath '.git'
    $isGitWorktree = Test-Path -Path $repo -PathType Container
    if ($isGitWorktree)
    {
        return (TryGitRepo -Path $repo)
    }
    return $false
}

$callback = {
    param
    (
        [string] $Path
    )
    $name = Split-Path -Path $Path -Leaf
    if ($name -match 'qt.-build')
    {
        return $false
    }
    if ($name -match '^\.(?!git$)')
    {
        return $false
    }
    if ($name -cmatch '^(Misc|Swig|Lua|out|Asan|Debug|Release|RelWithDebInfo|OpRelease|OpDebug)$')
    {
        return $false
    }
    if ($name -cmatch '^(qt.|icu|llvm-project|vim|neovim)$')
    {
        TryGitWorktree -Path $Path
        return $false
    }
    TryGitRepo -Path $Path
    return $true
}
# Get all subdirectories under current directory
IterateSubFoldersRecursively -Paths $PWD -Callback $callback
Write-Host 'Done. Press any key to continue...' -NoNewline
$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
