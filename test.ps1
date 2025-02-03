# PowerShell script to install required software and dependencies

# Function to check and install package managers
function Install-PackageManagers {
    Write-Host "Checking for package managers..."
    
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "Winget is missing. Please install it manually."
    }
    
    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Scoop..."
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }
}

# Function to install software using Winget
function Install-Software {
    param (
        [string]$software
    )
    Write-Host "Installing $software..."
    winget install --exact --silent --accept-package-agreements --accept-source-agreements $software
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install $software, skipping..."
    }
}

# Install Package Managers
Install-PackageManagers

# List of software to install
$softwareList = @(
    "Google Chrome", "Docker Desktop", "Node.js LTS", "Visual Studio Code", "Internet Download Manager",
    "Python 3.10", "Python 3.11", "Python 3.12", "Python 3.13", "Discord", "ChatGPT Windows",
    "Git", "GitHub CLI", "VLC Media Player"
)

foreach ($software in $softwareList) {
    Install-Software -software $software
}

# Download and install Visual C++ Redistributables
$vcUrls = @(
    "https://aka.ms/vs/17/release/vc_redist.x86.exe",
    "https://aka.ms/vs/17/release/vc_redist.x64.exe",
    "https://aka.ms/vs/15/release/vc_redist.x86.exe",
    "https://aka.ms/vs/15/release/vc_redist.x64.exe",
    "https://aka.ms/vs/13/release/vc_redist.x86.exe",
    "https://aka.ms/vs/13/release/vc_redist.x64.exe",
    "https://aka.ms/vs/12/release/vc_redist.x86.exe",
    "https://aka.ms/vs/12/release/vc_redist.x64.exe",
    "https://aka.ms/vs/10/release/vcredist_x86.exe",
    "https://aka.ms/vs/10/release/vcredist_x64.exe"
)

$downloadPath = "$env:TEMP\RuntimeInstallers"
if (!(Test-Path $downloadPath)) {
    New-Item -ItemType Directory -Path $downloadPath | Out-Null
}

foreach ($url in $vcUrls) {
    $fileName = $downloadPath + "\" + [System.IO.Path]::GetFileName($url)
    if (!(Test-Path $fileName)) {
        Write-Host "Downloading $url"
        Invoke-WebRequest -Uri $url -OutFile $fileName
    }
    Write-Host "Installing $fileName"
    Start-Process -FilePath $fileName -ArgumentList "/quiet /norestart" -Wait
}

# Install DirectX
$dxFile = "$downloadPath\directx.exe"
if (!(Test-Path $dxFile)) {
    Write-Host "Downloading DirectX..."
    Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/5/6/156fbd63-028e-4ec1-bddf-e66df1dc780f/directx_Jun2010_redist.exe" -OutFile $dxFile
}
Write-Host "Installing DirectX..."
Start-Process -FilePath $dxFile -ArgumentList "/Q /T:$downloadPath\DXSETUP /C" -Wait
Start-Process -FilePath "$downloadPath\DXSETUP\DXSETUP.exe" -ArgumentList "/silent" -Wait

# Install .NET Framework
$netFrameworks = @(
    @{url = "https://go.microsoft.com/fwlink/?linkid=2088631"; name = ".NET 4.8"},
    @{url = "https://go.microsoft.com/fwlink/?linkid=2088517"; name = ".NET 4.7.2"},
    @{url = "https://go.microsoft.com/fwlink/?linkid=2088521"; name = ".NET 4.6.2"},
    @{url = "https://go.microsoft.com/fwlink/?linkid=2088622"; name = ".NET 3.5"}
)

foreach ($net in $netFrameworks) {
    $netFile = "$downloadPath\dotnet_$($net.name).exe"
    if (!(Test-Path $netFile)) {
        Write-Host "Downloading $($net.name)"
        Invoke-WebRequest -Uri $net.url -OutFile $netFile
    }
    Write-Host "Installing $($net.name)"
    Start-Process -FilePath $netFile -ArgumentList "/quiet /norestart" -Wait
}

Write-Host "All installations completed!"
Pause
