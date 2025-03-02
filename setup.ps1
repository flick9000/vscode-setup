# Installs the latest VS Code
Write-Output "Installing VS Code..."
winget install --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
Write-Host -ForegroundColor Green "Installing VS Code..."


Write-Output "Configuring VS Code..."

# Define GitHub repository and VS Code paths
$repoUrl = "https://raw.githubusercontent.com/flick9000/vscode-setup/main"
$vsCodeUserPath = "$env:APPDATA\Code\User"

# Download and copy settings.json
Invoke-WebRequest -Uri "$repoUrl/settings.json" -OutFile "$vsCodeUserPath\settings.json"
Write-Host -ForegroundColor Green "✔ Copied settings.json to VS Code."

# Download and copy keybindings.json
Invoke-WebRequest -Uri "$repoUrl/keybindings.json" -OutFile "$vsCodeUserPath\keybindings.json"
Write-Host -ForegroundColor Green "✔ Copied keybindings.json to VS Code."

# Download and install extensions
$extensionsJson = "$env:TEMP\extensions.json"
Invoke-WebRequest -Uri "$repoUrl/extensions.json" -OutFile $extensionsJson
$extensions = (Get-Content $extensionsJson | ConvertFrom-Json).extensions
$extensions | ForEach-Object { 
    code --install-extension $_
    Write-Output "✔ Installed $_"
}
Remove-Item $extensionsJson

Write-Host -ForegroundColor Green "VS Code setup complete."
