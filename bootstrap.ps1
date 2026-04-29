<#
.SYNOPSIS
    Bootstrap a fresh Windows machine with this Neovim config.

.DESCRIPTION
    Installs system dependencies via winget, then clones (or links) this repo
    into $env:LOCALAPPDATA\nvim. Run from any directory.

    Usage:
        # If you've already cloned the repo somewhere and want to install from it:
        .\bootstrap.ps1

        # Or pass a remote URL to clone fresh:
        .\bootstrap.ps1 -RepoUrl https://github.com/<you>/nvim-config.git

.PARAMETER RepoUrl
    Optional. Git URL to clone into $env:LOCALAPPDATA\nvim. If omitted and the
    script is being run from inside the repo, it copies the current repo
    contents to the nvim config dir.

.PARAMETER Force
    Overwrite an existing nvim config dir without prompting.
#>

[CmdletBinding()]
param(
    [string]$RepoUrl,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Skip($msg) { Write-Host "    $msg" -ForegroundColor DarkGray }
function Write-Warn($msg) { Write-Host "!!! $msg" -ForegroundColor Yellow }

# 1. Install system dependencies via winget.
Write-Step "Installing system dependencies via winget"

$packages = @(
    @{ Id = "Neovim.Neovim";           Name = "Neovim";   Bin = "nvim"    },
    @{ Id = "Git.Git";                  Name = "Git";      Bin = "git"     },
    @{ Id = "BurntSushi.ripgrep.MSVC";  Name = "ripgrep";  Bin = "rg"      },
    @{ Id = "sharkdp.fd";               Name = "fd";       Bin = "fd"      },
    @{ Id = "JesseDuffield.lazygit";    Name = "lazygit";  Bin = "lazygit" },
    @{ Id = "OpenJS.NodeJS";            Name = "Node.js";  Bin = "node"    }
)

foreach ($pkg in $packages) {
    # Prefer PATH check — covers manual installs / nvm / scoop / chocolatey too.
    if (Get-Command $pkg.Bin -ErrorAction SilentlyContinue) {
        Write-Skip "$($pkg.Name) already on PATH"
        continue
    }

    $installed = winget list --id $pkg.Id --exact --accept-source-agreements 2>$null `
        | Select-String -SimpleMatch $pkg.Id
    if ($installed) {
        Write-Skip "$($pkg.Name) already installed via winget (may need shell restart for PATH)"
    }
    else {
        Write-Step "Installing $($pkg.Name) ($($pkg.Id))"
        winget install --id $pkg.Id --exact --silent --accept-source-agreements --accept-package-agreements
    }
}

# 2. Refresh PATH for the current session so the next steps see new binaries.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + `
    ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# 3. Place the config under $env:LOCALAPPDATA\nvim.
$nvimDir = Join-Path $env:LOCALAPPDATA "nvim"
Write-Step "Target nvim config dir: $nvimDir"

if (Test-Path $nvimDir) {
    if (-not $Force) {
        Write-Warn "$nvimDir already exists. Re-run with -Force to overwrite."
        Write-Warn "Skipping config copy."
    }
    else {
        Write-Step "Removing existing $nvimDir (-Force was supplied)"
        Remove-Item -LiteralPath $nvimDir -Recurse -Force
    }
}

if (-not (Test-Path $nvimDir)) {
    if ($RepoUrl) {
        Write-Step "Cloning $RepoUrl -> $nvimDir"
        git clone $RepoUrl $nvimDir
    }
    else {
        # Use the directory containing this script as the source.
        $repoRoot = Split-Path -Parent $PSCommandPath
        Write-Step "Copying $repoRoot -> $nvimDir"
        New-Item -ItemType Directory -Path $nvimDir | Out-Null
        Copy-Item -Path (Join-Path $repoRoot "*") -Destination $nvimDir -Recurse -Force `
            -Exclude @(".git", ".gitignore")
    }
}

# 4. Final reminders.
Write-Host ""
Write-Step "Done."
Write-Host "Next steps:"
Write-Host "  1. Install a Nerd Font (e.g. JetBrainsMono Nerd Font) from https://www.nerdfonts.com"
Write-Host "     and set it in Windows Terminal / your terminal of choice."
Write-Host "  2. Run: nvim"
Write-Host "     lazy.nvim will install plugins on first launch."
Write-Host "  3. After plugins finish, run :Mason and let LSPs / formatters install."
Write-Host "  4. Run :checkhealth to verify everything is wired correctly."
