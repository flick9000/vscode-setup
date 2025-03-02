# Installs the latest VS Code
winget install --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements

Write-Host -ForegroundColor Green "✔ VS Code Installed."

# Define GitHub repository and VS Code paths
$repoUrl = "https://raw.githubusercontent.com/flick9000/vscode-setup/main"
$vsCodeUserPath = "$env:APPDATA\Code\User"

# Ensure the VS Code settings directory exists
if (!(Test-Path $vsCodeUserPath)) {
    New-Item -ItemType Directory -Path $vsCodeUserPath -Force
   Write-Host -ForegroundColor Green "✔ Created VS Code settings directory."
}

# Download and copy settings.json
Invoke-WebRequest -Uri "$repoUrl/settings.json" -OutFile "$vsCodeUserPath\settings.json"
Write-Host -ForegroundColor Green "✔ Copied settings.json to VS Code."

# Download and copy keybindings.json
Invoke-WebRequest -Uri "$repoUrl/keybindings.json" -OutFile "$vsCodeUserPath\keybindings.json"
Write-Host -ForegroundColor Green "✔ Copied keybindings.json to VS Code."

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host -ForegroundColor Green "✔ Environment variables refreshed."

# Download and install extensions
$extensionsJson = "$env:TEMP\extensions.json"
Invoke-WebRequest -Uri "$repoUrl/extensions.json" -OutFile $extensionsJson
$extensions = (Get-Content $extensionsJson | ConvertFrom-Json).extensions
$extensions | ForEach-Object { 
    code --install-extension $_
    Write-Host -ForegroundColor Cyan "✔ Installed $_"
}
Remove-Item $extensionsJson

Write-Host -ForegroundColor Green "✔ VS Code setup complete."
