# PowerShell script to install required software and dependencies / created by nish ♡⸜(˶˃ ᵕ ˂˶)⸝♡

# Run as Administrator
if (-not [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') {
    Start-Process powershell.exe -ArgumentList "-File", "$PSCommandPath" -Verb RunAs
    exit
}

# Function to check and install package managers
function Install-PackageManagers {
    Write-Host "Checking for package managers..."
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "INSTALLING CHOCOLATEY..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "WINGET NOT FOUND, SKIPPING..."
    }
    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "INSTALLING SCOOP..."
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }
}

# Install Package Managers
Install-PackageManagers

# List of software to install
$softwareList = @("Google Chrome", "Docker Desktop", "Node.js LTS", "VS Code", "IDM", "Python 3.10-3.13", "Discord", "ChatGPT", "Git", "GitHub CLI", "VLC")

foreach ($software in $softwareList) {
    Write-Host "INSTALLING: $software"
    winget install --exact --silent --accept-package-agreements --accept-source-agreements $software | Out-Null
}

# Install Visual C++ Redistributables
$vcUrls = @("https://aka.ms/vs/17/release/vc_redist.x86.exe", "https://aka.ms/vs/17/release/vc_redist.x64.exe")
$downloadPath = "$env:TEMP\RuntimeInstallers"
New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null

foreach ($url in $vcUrls) {
    $fileName = "$downloadPath\" + [System.IO.Path]::GetFileName($url)
    if (!(Test-Path $fileName)) {
        Write-Host "DOWNLOADING: $fileName"
        Invoke-WebRequest -Uri $url -OutFile $fileName -ErrorAction SilentlyContinue
    } else {
        Write-Host "SKIPPING: $fileName already exists"
    }
    if (Test-Path $fileName) {
        Write-Host "INSTALLING: $fileName"
        Start-Process -FilePath $fileName -ArgumentList "/quiet /norestart" -NoNewWindow -Wait
    }
}

# Install DirectX Web Installer in Background
$dxWebInstaller = "$downloadPath\dxwebsetup.exe"
$dxWebUrl = "https://download.microsoft.com/download/1/1a/1a17f7b8-3b3a-4b0b-9a6a-8a0e0a2bab3d/dxwebsetup.exe"

if (!(Test-Path $dxWebInstaller)) {
    Write-Host "DOWNLOADING: DirectX Web Installer"
    Invoke-WebRequest -Uri $dxWebUrl -OutFile $dxWebInstaller -ErrorAction SilentlyContinue
} else {
    Write-Host "SKIPPING: DirectX Web Installer already exists"
}

if (Test-Path $dxWebInstaller) {
    Write-Host "INSTALLING: DirectX Web Installer"
    Start-Process -FilePath $dxWebInstaller -ArgumentList "/Q" -NoNewWindow -Wait
} else {
    Write-Host "FAILED TO DOWNLOAD DirectX Web Installer, SKIPPING INSTALLATION"
}

# Install .NET Framework and .NET Core Runtimes
$dotnetVersions = @("4.8", "3.1", "5", "6", "7", "8", "9")
foreach ($version in $dotnetVersions) {
    $netUrl = "https://download.visualstudio.microsoft.com/download/pr/dotnet-runtime-$version.exe"
    $netFile = "$downloadPath\dotnet_$version.exe"
    if (!(Test-Path $netFile)) {
        Write-Host "DOWNLOADING: .NET $version"
        Invoke-WebRequest -Uri $netUrl -OutFile $netFile -ErrorAction SilentlyContinue
    } else {
        Write-Host "SKIPPING: .NET $version already exists"
    }
    if (Test-Path $netFile) {
        Write-Host "INSTALLING: .NET $version"
        Start-Process -FilePath $netFile -ArgumentList "/quiet /norestart" -NoNewWindow -Wait
    }
}

# Install NuGet if missing
if (!(Get-Command nuget -ErrorAction SilentlyContinue)) {
    Write-Host "INSTALLING: NuGet"
    Install-PackageProvider -Name NuGet -Force
} else {
    Write-Host "SKIPPING: NuGet already installed"
}

Write-Host "ALL INSTALLATIONS COMPLETED!"
