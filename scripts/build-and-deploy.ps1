# PowerShell Script to Build and Deploy CoiModAgent

# Define variables
$sourceDir = "."  # Current directory
$buildOutputDir = "$PWD\bin\Debug\netcoreapp3.1"  # Adjust according to your project output
$deployPath = "$env:APPDATA\Captain of Industry\Mods\CoiModAgent\CoiModAgent.dll"

# Build the project
try {
    Write-Host "Building the project..."
    dotnet build /p:LangVersion=10.0
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed!"
    }
} catch {
    Write-Host "Error during build: $_"
    exit 1
}

# Deploy the DLL
try {
    # Ensure output directory exists
    if (-Not (Test-Path -Path $buildOutputDir)) {
        throw "Build output directory does not exist: $buildOutputDir"
    }
    
    # Copy DLL to deployment path
    Copy-Item "$buildOutputDir\CoiModAgent.dll" -Destination $deployPath -Force
    Write-Host "Deployment successful! DLL deployed to $deployPath"
} catch {
    Write-Host "Error during deployment: $_"
    exit 1
}