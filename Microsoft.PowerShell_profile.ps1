function Get-CustomTree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$IncludeFiles = $false,

        [string[]]$Exclude = @(),

        [switch]$ShowSize
    )

    $chars = @{
        interior = "├─"
        last     = "└─"
        hline    = "─"
        vline    = "│"
        space    = " "
    }

    function Get-Size {
        param (
            [string]$ItemPath,
            [switch]$IsDirectory
        )

        if ($IsDirectory) {
            # Write-Host "DEBUG: Calculating size for directory: ${ItemPath}" -ForegroundColor Cyan
            $files = Get-ChildItem -Path $ItemPath -Recurse -File -ErrorAction SilentlyContinue
            if (-not $files) {
                # Write-Host "DEBUG: No files found in directory: ${ItemPath}" -ForegroundColor Red
                return 0
            }
            $dirSize = ($files | Measure-Object -Property Length -Sum).Sum
            # Write-Host "DEBUG: Total size for directory ${ItemPath}: $dirSize bytes" -ForegroundColor Cyan
            return $dirSize
        } else {
            # Write-Host "DEBUG: Calculating size for file: ${ItemPath}" -ForegroundColor Cyan
            try {
                $fileSize = (Get-Item -Path $ItemPath -ErrorAction SilentlyContinue).Length
                # Write-Host "DEBUG: File size: $fileSize bytes" -ForegroundColor Cyan
                return $fileSize
            } catch {
                # Write-Host "DEBUG: Failed to get size for file: ${ItemPath}" -ForegroundColor Red
                return 0
            }
        }
    }

    function Format-Size {
        param (
            [int64]$Bytes
        )
        if ($null -eq $Bytes) {
            return "0 B"
        }
        switch ($Bytes) {
            { $_ -ge 1GB } { "{0:N2} GB" -f ($Bytes / 1GB); break }
            { $_ -ge 1MB } { "{0:N2} MB" -f ($Bytes / 1MB); break }
            { $_ -ge 1KB } { "{0:N2} KB" -f ($Bytes / 1KB); break }
            default        { "$Bytes B"; break }
        }
    }

    function Get-Tree {
        param (
            [string]$CurrentPath,
            [string]$Prefix = "",
            [switch]$IsLast,

            [switch]$ShowSize,
            [switch]$IncludeFiles,
            [string[]]$Exclude
        )

        # Write-Host "DEBUG: Entering Get-Tree for path: $CurrentPath" -ForegroundColor Yellow
        if ($ShowSize) {
            # Write-Host "DEBUG: The -ShowSize switch is active" -ForegroundColor Green
        } else {
            # Write-Host "DEBUG: The -ShowSize switch is NOT active" -ForegroundColor Red
        }

        $items = Get-ChildItem -Path $CurrentPath -Force |
            Where-Object {
                -not ($Exclude -contains $_.Name)
            }

        $directories = $items | Where-Object { $_.PSIsContainer }
        $files = @()
        if ($IncludeFiles) {
            $files = $items | Where-Object { -not $_.PSIsContainer }
        }

        $allItems = @()
        if ($directories) {
            $allItems += $directories
        }
        if ($files) {
            $allItems += $files
        }

        for ($i = 0; $i -lt $allItems.Count; $i++) {
            $item = $allItems[$i]
            $isLastItem = ($i -eq $allItems.Count - 1)

            $treeChar = if ($isLastItem) { $chars.last } else { $chars.interior }

            [string]$size = ""

            if ($ShowSize) {
                # Write-Host "DEBUG: Processing item: $($item.FullName)" -ForegroundColor Cyan
                $sizeBytes = if ($item.PSIsContainer) {
                    Get-Size -ItemPath $item.FullName -IsDirectory:$true
                } else {
                    Get-Size -ItemPath $item.FullName -IsDirectory:$false
                }
                if ($sizeBytes -ne $null) {
                    $size = Format-Size -Bytes $sizeBytes
                } else {
                    # Write-Host "DEBUG: Size calculation returned null for $($item.FullName)" -ForegroundColor Red
                }
                # Write-Host "DEBUG: Formatted size for item $($item.FullName): $size" -ForegroundColor Cyan
            }

            $line = if ($ShowSize) {
                "{0,-10} {1}{2}" -f $size, $Prefix, "$treeChar $($item.Name)"
            } else {
                "$Prefix$treeChar $($item.Name)"
            }

            # Debug: Display constructed line
            # Write-Host "DEBUG: Constructed line: $line" -ForegroundColor Green

            # Display line with appropriate colors
            if ($item.PSIsContainer) {
                Write-Host $line -ForegroundColor Yellow
            } else {
                Write-Host $line -ForegroundColor Green
            }

            $nextPrefix = $Prefix
            if ($isLastItem) {
                $nextPrefix += $chars.space + "  "
            } else {
                $nextPrefix += $chars.vline + "  "
            }

            if ($item.PSIsContainer) {
                Get-Tree -CurrentPath $item.FullName `
                         -Prefix $nextPrefix `
                         -IsLast:$isLastItem `
                         -ShowSize:$ShowSize `
                         -IncludeFiles:$IncludeFiles `
                         -Exclude $Exclude
            }
        }
    }

    if (-not (Test-Path -Path $Path)) {
        Write-Error "The path '$Path' does not exist."
        return
    }

    $Path = $Path.TrimEnd('\')

    Write-Output "Directory: $Path"
    Get-Tree -CurrentPath $Path -Prefix "" -ShowSize:$ShowSize -IncludeFiles:$IncludeFiles -Exclude $Exclude
}
