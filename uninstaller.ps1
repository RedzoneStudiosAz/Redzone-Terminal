<#
.SYNOPSIS
    Redzone Terminal V2.0 Uninstaller
.DESCRIPTION
    Removes Redzone PowerShell profiles, language/theme/ghost configs, and safely resets 
    Windows Terminal color schemes across all profiles without invalid scheme errors.
#>

$ErrorActionPreference = "SilentlyContinue"

Write-Host "`n🔴 REDZONE TERMINAL V2.0 - UNINSTALLER" -ForegroundColor Red
Write-Host "────────────────────────────────────────────────────────" -ForegroundColor DarkGray

# 1. Remove PowerShell 7 & Windows PowerShell Profiles
$profilePaths = @(
    "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
    "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
)

foreach ($pPath in $profilePaths) {
    if (Test-Path $pPath) {
        Remove-Item $pPath -Force
        Write-Host "[+] Removed profile: $pPath" -ForegroundColor Green
    }
}

# 2. Remove Language, Theme & Ghost Configuration
$configFiles = @(
    "$env:USERPROFILE\.redzone_lang",
    "$env:USERPROFILE\.redzone_theme",
    "$env:USERPROFILE\.redzone_ghost"
)

foreach ($cFile in $configFiles) {
    if (Test-Path $cFile) {
        Remove-Item $cFile -Force
        Write-Host "[+] Removed config: $cFile" -ForegroundColor Green
    }
}

# 3. Clean Windows Terminal Theme & Profile Overrides Safely
$wtPaths = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)

$propsToRemove = @("colorScheme", "useAcrylic", "opacity", "cursorShape", "cursorColor", "background", "tabColor")

foreach ($wtPath in $wtPaths) {
    if (Test-Path $wtPath) {
        try {
            Copy-Item $wtPath "$wtPath.bak" -Force
            $json = Get-Content $wtPath -Raw | ConvertFrom-Json

            # Remove Redzone color scheme from schemes list
            if ($json.schemes) {
                $json.schemes = @($json.schemes | Where-Object { $_.name -notmatch "Redzone" })
            }

            # Clean global defaults
            if ($json.profiles -and $json.profiles.defaults) {
                foreach ($prop in $propsToRemove) {
                    if ($json.profiles.defaults.PSObject.Properties[$prop]) {
                        $json.profiles.defaults.PSObject.Properties.Remove($prop)
                    }
                }
            }

            # Clean individual profiles so Windows Terminal doesn't complain about missing scheme
            if ($json.profiles -and $json.profiles.list) {
                foreach ($prof in $json.profiles.list) {
                    if ($prof.colorScheme -match "Redzone") {
                        $prof.PSObject.Properties.Remove("colorScheme")
                    }
                    foreach ($prop in @("useAcrylic", "opacity", "cursorShape", "cursorColor", "background", "tabColor")) {
                        if ($prof.PSObject.Properties[$prop]) {
                            $prof.PSObject.Properties.Remove($prop)
                        }
                    }
                }
            }

            $json | ConvertTo-Json -Depth 10 | Set-Content $wtPath -Encoding UTF8
            Write-Host "[+] Windows Terminal theme reset (Backup: settings.json.bak)." -ForegroundColor Green
        }
        catch {
            Write-Host "[!] Could not automatically clean Windows Terminal settings.json." -ForegroundColor Yellow
        }
    }
}

Write-Host "────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "✔ Redzone Terminal V2.0 has been completely uninstalled." -ForegroundColor Cyan
Write-Host "Please restart your terminal for changes to take full effect.`n" -ForegroundColor Gray
