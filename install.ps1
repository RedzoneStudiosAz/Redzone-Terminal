Write-Host "Installing Redzone Terminal V2.0..." -ForegroundColor Red

# 1. Check and install PowerShell 7 & Windows Terminal
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing PowerShell 7..." -ForegroundColor Yellow
    winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements
}
if (-not (Get-Command wt -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Windows Terminal..." -ForegroundColor Yellow
    winget install --id Microsoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements
    Start-Process "wt.exe"; Start-Sleep -Seconds 2; Stop-Process -Name "WindowsTerminal" -Force -ErrorAction SilentlyContinue
}

# 2. Set Windows Terminal as Default Console
New-Item -Path "HKCU:\Console\%%Startup" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Console\%%Startup" -Name "DelegationConsole" -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}"
Set-ItemProperty -Path "HKCU:\Console\%%Startup" -Name "DelegationTerminal" -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}"

# 3. Apply Redzone Color Scheme & Transparency to Windows Terminal
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $settingsPath) {
    $json = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $redzoneScheme = [PSCustomObject]@{
        name = "Redzone Theme"
        background = "#0D0505"
        foreground = "#F2E6E6"
        cursorColor = "#FF1E1E"
        selectionBackground = "#590D0D"
        black = "#1A0A0A"
        red = "#FF1E1E"
        green = "#2ECC71"
        yellow = "#F1C40F"
        blue = "#3498DB"
        purple = "#9B59B6"
        cyan = "#1ABC9C"
        white = "#ECF0F1"
        brightBlack = "#5C2B2B"
        brightRed = "#FF4D4D"
        brightGreen = "#58D68D"
        brightYellow = "#F4D03F"
        brightBlue = "#5DADE2"
        brightPurple = "#AF7AC5"
        brightCyan = "#48C9B0"
        brightWhite = "#FFFFFF"
    }
    if (-not $json.schemes) {
        $json | Add-Member -NotePropertyName "schemes" -NotePropertyValue @() -Force
    }
    $json.schemes = @($json.schemes | Where-Object { $_.name -ne "Redzone Theme" }) + $redzoneScheme
    
    $ps7Profile = $json.profiles.list | Where-Object { $_.source -eq "Windows.Terminal.PowershellCore" -or $_.commandline -like "*pwsh.exe*" } | Select-Object -First 1
    if ($ps7Profile) {
        $json.defaultProfile = $ps7Profile.guid
        $ps7Profile | Add-Member -NotePropertyName "name" -NotePropertyValue "Redzone Terminal" -Force
        $ps7Profile | Add-Member -NotePropertyName "colorScheme" -NotePropertyValue "Redzone Theme" -Force
        $ps7Profile | Add-Member -NotePropertyName "useAcrylic" -NotePropertyValue $true -Force
        $ps7Profile | Add-Member -NotePropertyName "opacity" -NotePropertyValue 88 -Force
        $ps7Profile | Add-Member -NotePropertyName "tabColor" -NotePropertyValue "#CC0000" -Force
        $ps7Profile | Add-Member -NotePropertyName "cursorShape" -NotePropertyValue "filledBox" -Force
    }
    $json | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding UTF8
}

# 4. Write 10-Language Redzone System Dashboard V2.0 Profile (Default: English)
$ps7ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$profileDir = Split-Path $ps7ProfilePath
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

$fullMultiLangScript = @'
$langFile = "$env:USERPROFILE\.redzone_lang"
if (-not (Test-Path $langFile)) { Set-Content -Path $langFile -Value "en" -Encoding UTF8 }
$global:RedzoneLang = (Get-Content $langFile -Raw).Trim()

$themeFile = "$env:USERPROFILE\.redzone_theme"
if (-not (Test-Path $themeFile)) { Set-Content -Path $themeFile -Value "RedzoneClassic" -Encoding UTF8 }
$global:RedzoneTheme = (Get-Content $themeFile -Raw).Trim()

$ghostFile = "$env:USERPROFILE\.redzone_ghost"
if (-not (Test-Path $ghostFile)) { Set-Content -Path $ghostFile -Value "0" -Encoding UTF8 }
$global:RedzoneGhost = ((Get-Content $ghostFile -Raw).Trim() -eq "1")

$global:RedzoneThemes = @{
    "RedzoneClassic" = @{
        Primary = "Red"; Secondary = "DarkRed"; Text = "White"
        BgHex = "#0D0505"; FgHex = "#F2E6E6"; CursorHex = "#FF1E1E"; SelHex = "#590D0D"; TabHex = "#CC0000"
    }
    "Cyberpunk" = @{
        Primary = "Magenta"; Secondary = "Cyan"; Text = "White"
        BgHex = "#0B0616"; FgHex = "#F0E6FF"; CursorHex = "#FF007F"; SelHex = "#3B1254"; TabHex = "#FF007F"
    }
    "Matrix" = @{
        Primary = "Green"; Secondary = "DarkGreen"; Text = "Green"
        BgHex = "#020D04"; FgHex = "#00FF41"; CursorHex = "#00FF41"; SelHex = "#0A3614"; TabHex = "#008F11"
    }
    "Minimal" = @{
        Primary = "White"; Secondary = "DarkGray"; Text = "Gray"
        BgHex = "#121212"; FgHex = "#E0E0E0"; CursorHex = "#FFFFFF"; SelHex = "#333333"; TabHex = "#444444"
    }
}

$global:RedzoneTranslations = @{
    "en" = @{
        Name="English"; Sub="S Y S T E M   C O N T R O L   V 2.0";
        User="User       : "; OS="OS         : "; CPU="Processor  : "; GPU="Graphics   : ";
        RAM="Memory RAM : "; Disk="Disk (C:)  : "; Up="Uptime     : "; IP="Local IP   : ";
        Days="d"; Hours="h"; Mins="m"; Off="Offline";
        Avail="Available languages:"; Active="[ACTIVE]"; Usage="Usage: lang az  (or lang tr, lang ru, etc.)";
        Err="Error: '{0}' is not supported. Type 'lang' to see list."
    }
    "az" = @{
        Name="Azərbaycan"; Sub="S İ S T E M   N Ə Z A R Ə T İ   V 2.0";
        User="İstifadəçi : "; OS="Sistem     : "; CPU="Prosessor  : "; GPU="Qrafika    : ";
        RAM="Yaddaş RAM : "; Disk="Disk (C:)  : "; Up="İşləmə vaxt: "; IP="Lokal IP   : ";
        Days="g"; Hours="s"; Mins="d"; Off="Şəbəkə yoxdur";
        Avail="Mövcud dillər:"; Active="[AKTİV]"; Usage="İstifadə: lang en  (və ya lang tr, lang ru və s.)";
        Err="Xəta: '{0}' dəstəklənmir. Siyahı üçün 'lang' yazın."
    }
    "tr" = @{
        Name="Türkçe"; Sub="S İ S T E M   K O N T R O L   V 2.0";
        User="Kullanıcı  : "; OS="Sistem     : "; CPU="İşlemci    : "; GPU="Grafik     : ";
        RAM="Bellek RAM : "; Disk="Disk (C:)  : "; Up="Çalışma    : "; IP="Yerel IP   : ";
        Days="g"; Hours="s"; Mins="dk"; Off="Çevrimdışı";
        Avail="Mevcut diller:"; Active="[AKTİF]"; Usage="Kullanım: lang en  (veya lang az, lang ru vb.)";
        Err="Hata: '{0}' desteklenmiyor. Liste için 'lang' yazın."
    }
    "ru" = @{
        Name="Русский"; Sub="К О Н Т Р О Л Ь   С И С Т Е М Ы   V 2.0";
        User="Юзер       : "; OS="Система    : "; CPU="Процессор  : "; GPU="Графика    : ";
        RAM="Память RAM : "; Disk="Диск (C:)  : "; Up="Аптайм     : "; IP="Локал IP   : ";
        Days="д"; Hours="ч"; Mins="м"; Off="Офлайн";
        Avail="Доступные языки:"; Active="[АКТИВЕН]"; Usage="Использование: lang en  (или lang az, lang tr и т.д.)";
        Err="Ошибка: '{0}' не поддерживается. Введите 'lang' для списка."
    }
    "de" = @{
        Name="Deutsch"; Sub="S Y S T E M K O N T R O L L E   V 2.0";
        User="Benutzer   : "; OS="System     : "; CPU="Prozessor  : "; GPU="Grafik     : ";
        RAM="Speicher   : "; Disk="Festplatte : "; Up="Laufzeit   : "; IP="Lokale IP  : ";
        Days="T"; Hours="Std"; Mins="Min"; Off="Offline";
        Avail="Verfügbare Sprachen:"; Active="[AKTIV]"; Usage="Verwendung: lang en  (oder lang az, lang tr usw.)";
        Err="Fehler: '{0}' wird nicht unterstützt. Geben Sie 'lang' ein."
    }
    "fr" = @{
        Name="Français"; Sub="C O N T R Ô L E   S Y S T È M E   V 2.0";
        User="Utilisateur: "; OS="Système    : "; CPU="Processeur : "; GPU="Graphiques : ";
        RAM="Mémoire    : "; Disk="Disque (C:): "; Up="Disponibil.: "; IP="IP Locale  : ";
        Days="j"; Hours="h"; Mins="m"; Off="Hors ligne";
        Avail="Langues disponibles :"; Active="[ACTIF]"; Usage="Utilisation : lang en  (ou lang az, lang tr, etc.)";
        Err="Erreur : '{0}' non pris en charge. Tapez 'lang'."
    }
    "es" = @{
        Name="Español"; Sub="C O N T R O L   D E L   S I S T E M A   V 2.0";
        User="Usuario    : "; OS="Sistema    : "; CPU="Procesador : "; GPU="Gráficos   : ";
        RAM="Memoria RAM: "; Disk="Disco (C:) : "; Up="Actividad  : "; IP="IP Local   : ";
        Days="d"; Hours="h"; Mins="m"; Off="Desconectado";
        Avail="Idiomas disponibles:"; Active="[ACTIVO]"; Usage="Uso: lang en  (o lang az, lang tr, etc.)";
        Err="Error: '{0}' no soportado. Escribe 'lang' para ver la lista."
    }
    "ar" = @{
        Name="العربية"; Sub="التحكم في النظام  V 2.0";
        User="المستخدم   : "; OS="النظام     : "; CPU="المعالج    : "; GPU="الرسوميات  : ";
        RAM="الذاكرة    : "; Disk="القرص (C:) : "; Up="وقت التشغيل: "; IP="IP المحلي  : ";
        Days="ي"; Hours="س"; Mins="د"; Off="غير متصل";
        Avail="اللغات المتاحة:"; Active="[نشط]"; Usage="الاستخدام: lang en  (أو lang az، lang tr، إلخ)";
        Err="خطأ: '{0}' غير مدعوم. اكتب 'lang' لعرض القائمة."
    }
    "zh" = @{
        Name="中文"; Sub="系统控制中心  V 2.0";
        User="用户       : "; OS="系统       : "; CPU="处理器     : "; GPU="显卡       : ";
        RAM="内存 RAM   : "; Disk="磁盘 (C:)  : "; Up="运行时间   : "; IP="本地 IP    : ";
        Days="天"; Hours="时"; Mins="分"; Off="离线";
        Avail="可用语言:"; Active="[当前]"; Usage="用法: lang en  (或 lang az, lang tr 等)";
        Err="错误: 不支持 '{0}'。输入 'lang' 查看列表。"
    }
    "ja" = @{
        Name="日本語"; Sub="システムコントロール  V 2.0";
        User="ユーザー   : "; OS="OS         : "; CPU="CPU        : "; GPU="GPU        : ";
        RAM="メモリ     : "; Disk="ディスク   : "; Up="稼働時間   : "; IP="ローカルIP : ";
        Days="日"; Hours="時間"; Mins="分"; Off="オフライン";
        Avail="利用可能な言語:"; Active="[有効]"; Usage="使用法: lang en  (または lang az, lang tr など)";
        Err="エラー: '{0}' はサポートされていません。'lang' で一覧を表示します。"
    }
}

function Sync-WindowsTerminalTheme {
    param([hashtable]$Palette)
    $wtPaths = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
    )
    foreach ($wtPath in $wtPaths) {
        if (Test-Path $wtPath) {
            try {
                $json = Get-Content $wtPath -Raw | ConvertFrom-Json
                if ($json.schemes) {
                    $scheme = $json.schemes | Where-Object { $_.name -eq "Redzone Theme" } | Select-Object -First 1
                    if ($scheme) {
                        $scheme.background = $Palette.BgHex
                        $scheme.foreground = $Palette.FgHex
                        $scheme.cursorColor = $Palette.CursorHex
                        $scheme.selectionBackground = $Palette.SelHex
                    }
                }
                if ($json.profiles -and $json.profiles.list) {
                    $ps7Prof = $json.profiles.list | Where-Object { $_.name -eq "Redzone Terminal" -or $_.colorScheme -eq "Redzone Theme" } | Select-Object -First 1
                    if ($ps7Prof) {
                        $ps7Prof | Add-Member -NotePropertyName "tabColor" -NotePropertyValue $Palette.TabHex -Force
                    }
                }
                $json | ConvertTo-Json -Depth 100 | Set-Content $wtPath -Encoding UTF8
            } catch {}
        }
    }
}

function Set-RedzoneLanguage {
    param([string]$Code)
    $t = $global:RedzoneTranslations[$global:RedzoneLang]
    if (-not $t) { $t = $global:RedzoneTranslations["en"] }

    if (-not $Code) {
        Write-Host "`n$($t.Avail)" -ForegroundColor Red
        $global:RedzoneTranslations.GetEnumerator() | Sort-Object Name | ForEach-Object {
            $active = if ($_.Key -eq $global:RedzoneLang) { " $($t.Active)" } else { "" }
            Write-Host "  $($_.Key) -> $($_.Value.Name)$active" -ForegroundColor White
        }
        Write-Host "`n$($t.Usage)`n" -ForegroundColor Gray
        return
    }
    $Code = $Code.ToLower()
    if ($global:RedzoneTranslations.ContainsKey($Code)) {
        $global:RedzoneLang = $Code
        Set-Content -Path "$env:USERPROFILE\.redzone_lang" -Value $Code -Encoding UTF8
        Show-RedzoneDashboard
    } else {
        Write-Host ($t.Err -f $Code) -ForegroundColor Red
    }
}

function Set-RedzoneTheme {
    param(
        [Parameter(Position = 0)]
        [string]$ThemeName,
        [switch]$Stop
    )
    $pal = $global:RedzoneThemes[$global:RedzoneTheme]
    if (-not $pal) { $pal = $global:RedzoneThemes["RedzoneClassic"] }

    if ($Stop) {
        $global:RedzoneTheme = "RedzoneClassic"
        Set-Content -Path "$env:USERPROFILE\.redzone_theme" -Value "RedzoneClassic" -Encoding UTF8
        Sync-WindowsTerminalTheme -Palette $global:RedzoneThemes["RedzoneClassic"]
        Show-RedzoneDashboard
        return
    }

    if (-not $ThemeName) {
        Write-Host "`nAvailable themes:" -ForegroundColor $pal.Primary
        $global:RedzoneThemes.Keys | Sort-Object | ForEach-Object {
            $active = if ($_ -eq $global:RedzoneTheme) { " [ACTIVE]" } else { "" }
            Write-Host "  $_$active" -ForegroundColor White
        }
        Write-Host "`nUsage: rz-theme Cyberpunk  |  Reset: rz-theme -stop`n" -ForegroundColor Gray
        return
    }

    $matched = $global:RedzoneThemes.Keys | Where-Object { $_ -ieq $ThemeName } | Select-Object -First 1
    if ($matched) {
        $global:RedzoneTheme = $matched
        Set-Content -Path "$env:USERPROFILE\.redzone_theme" -Value $matched -Encoding UTF8
        Sync-WindowsTerminalTheme -Palette $global:RedzoneThemes[$matched]
        Show-RedzoneDashboard
    } else {
        Write-Host "Error: Theme '$ThemeName' not found. Type 'rz-theme' to see list." -ForegroundColor Red
    }
}

function Set-RedzoneGhost {
    param(
        [switch]$Stop
    )
    if ($Stop) {
        $global:RedzoneGhost = $false
        Set-Content -Path "$env:USERPROFILE\.redzone_ghost" -Value "0" -Encoding UTF8
    } else {
        $global:RedzoneGhost = $true
        Set-Content -Path "$env:USERPROFILE\.redzone_ghost" -Value "1" -Encoding UTF8
    }
    Show-RedzoneDashboard
}

function Invoke-RedzoneClean {
    param(
        [switch]$History,
        [switch]$Docker
    )
    Write-Host "`n[*] Cleaning Windows temporary files (%TEMP%)..." -ForegroundColor Cyan
    $deleted = 0
    if (Test-Path $env:TEMP) {
        Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
                $deleted++
            } catch {}
        }
    }
    Write-Host "[+] Temp cleaned ($deleted items removed)." -ForegroundColor Green

    if ($History) {
        $histPath = (Get-PSReadLineOption).HistorySavePath
        if ($histPath -and (Test-Path $histPath)) {
            Clear-Content -Path $histPath -ErrorAction SilentlyContinue
            [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
            Write-Host "[+] PowerShell history cleared." -ForegroundColor Green
        }
    }

    if ($Docker) {
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            Write-Host "[*] Pruning unused Docker cache..." -ForegroundColor Yellow
            docker system prune -f 2>$null | Out-Null
            Write-Host "[+] Docker cache cleaned." -ForegroundColor Green
        } else {
            Write-Host "[!] Docker not found, skipping." -ForegroundColor DarkGray
        }
    }
    Write-Host ""
}

function Update-RedzoneTerminal {
    Write-Host "`n[*] Checking GitHub for Redzone Terminal updates..." -ForegroundColor Cyan
    try {
        irm "https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/install.ps1" | iex
        . $PROFILE
        Write-Host "[+] Redzone Terminal updated successfully!`n" -ForegroundColor Green
    } catch {
        Write-Host "[!] Update failed: $($_.Exception.Message)`n" -ForegroundColor Red
    }
}

function Show-RedzoneDashboard {
    Clear-Host
    $t = $global:RedzoneTranslations[$global:RedzoneLang]
    if (-not $t) { $t = $global:RedzoneTranslations["en"] }

    $pal = $global:RedzoneThemes[$global:RedzoneTheme]
    if (-not $pal) { $pal = $global:RedzoneThemes["RedzoneClassic"] }

    $cpuRaw = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString", "Intel Core CPU")
    $cpuName = "$cpuRaw".Trim()

    $prodName = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName", "Windows 11")
    $dispVer = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DisplayVersion", "")
    $osName = if ($dispVer) { "$prodName ($dispVer)" } else { "$prodName" }

    $gpuRaw = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000", "DriverDesc", "Intel HD Graphics")
    $gpuName = "$gpuRaw".Trim()

    $os = Get-CimInstance Win32_OperatingSystem -Property TotalVisibleMemorySize, FreePhysicalMemory, LastBootUpTime
    $totalRam = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $usedRam = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
    $ramPercent = [math]::Round(($usedRam / $totalRam) * 100)
    
    $disk = [System.IO.DriveInfo]::new("C")
    $totalDisk = [math]::Round($disk.TotalSize / 1GB, 0)
    $usedDisk = [math]::Round(($disk.TotalSize - $disk.AvailableFreeSpace) / 1GB, 0)
    $diskPercent = [math]::Round(($usedDisk / $totalDisk) * 100)
    
    $uptime = (Get-Date) - $os.LastBootUpTime
    $uptimeStr = "{0}{1} {2}{3} {4}{5}" -f $uptime.Days, $t.Days, $uptime.Hours, $t.Hours, $uptime.Minutes, $t.Mins
    
    $localIP = $t.Off
    foreach ($nic in [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()) {
        if ($nic.OperationalStatus -eq 'Up' -and $nic.NetworkInterfaceType -ne 'Loopback') {
            foreach ($ua in $nic.GetIPProperties().UnicastAddresses) {
                if ($ua.Address.AddressFamily -eq 'InterNetwork') {
                    $localIP = $ua.Address.ToString()
                    break
                }
            }
        }
        if ($localIP -ne $t.Off) { break }
    }

    # Ghost / Streamer Privacy Masking
    $displayUser = if ($global:RedzoneGhost) { "[REDACTED]" } else { "$env:USERNAME@$env:COMPUTERNAME" }
    $displayIP   = if ($global:RedzoneGhost -and $localIP -ne $t.Off) {
        $octets = $localIP.Split('.')
        if ($octets.Count -eq 4) { "$($octets[0]).$($octets[1]).***.***" } else { "***.***.***.***" }
    } else {
        "$localIP"
    }

    function Get-Bar($percent) {
        $filled = [math]::Round($percent / 10)
        $empty = 10 - $filled
        return ("█" * $filled) + ("░" * $empty)
    }

    $ramBar = Get-Bar $ramPercent
    $diskBar = Get-Bar $diskPercent

    $subTitle = $t.Sub
    $padLeft = [math]::Max(0, [math]::Floor((61 - $subTitle.Length) / 2))
    $centeredSub = (" " * $padLeft) + $subTitle
    $centeredSub = $centeredSub.PadRight(61)

    $logo = @(
        "  ██████╗ ███████╗██████╗ ███████╗ ██████╗ ███╗   ██╗███████╗ ",
        "  ██╔══██╗██╔════╝██╔══██╗╚══███╔╝██╔═══██╗████╗  ██║██╔════╝ ",
        "  ██████╔╝█████╗  ██║  ██║  ███╔╝ ██║   ██║██╔██╗ ██║█████╗   ",
        "  ██╔══██╗██╔══╝  ██║  ██║ ███╔╝  ██║   ██║██║╚██╗██║██╔══╝   ",
        "  ██║  ██║███████╗██████╔╝███████╗╚██████╔╝██║ ╚████║███████╗ ",
        "  ╚═╝  ╚═╝╚══════╝╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ",
        "  ═══════════════════════════════════════════════════════════ ",
        "$centeredSub"
    )

    $info = @(
        @{ Label = $t.User; Value = "$displayUser" },
        @{ Label = $t.OS;   Value = "$osName" },
        @{ Label = $t.CPU;  Value = "$cpuName" },
        @{ Label = $t.GPU;  Value = "$gpuName" },
        @{ Label = $t.RAM;  Value = "[$ramBar] $usedRam / $totalRam GB ($ramPercent%)" },
        @{ Label = $t.Disk; Value = "[$diskBar] $usedDisk / $totalDisk GB ($diskPercent%)" },
        @{ Label = $t.Up;   Value = "$uptimeStr" },
        @{ Label = $t.IP;   Value = "$displayIP" }
    )

    Write-Host ""
    for ($i = 0; $i -lt $logo.Count; $i++) {
        Write-Host $logo[$i] -NoNewline -ForegroundColor $pal.Primary
        Write-Host "  │  " -NoNewline -ForegroundColor DarkGray
        Write-Host $info[$i].Label -NoNewline -ForegroundColor $pal.Secondary
        Write-Host $info[$i].Value -ForegroundColor $pal.Text
    }
    Write-Host "  ────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    $ghostBadge = if ($global:RedzoneGhost) { "  │  👻 GHOST MODE" } else { "" }
    Write-Host "  🌐 $($t.Name.ToUpper())  │  🎨 $($global:RedzoneTheme)$ghostBadge" -ForegroundColor DarkGray
    Write-Host ""
}

Show-RedzoneDashboard

function prompt {
    $pal = $global:RedzoneThemes[$global:RedzoneTheme]
    if (-not $pal) { $pal = $global:RedzoneThemes["RedzoneClassic"] }

    $path = $executionContext.SessionState.Path.CurrentLocation.Path
    $shortPath = if ($path -eq $HOME) {
        "~"
    } elseif ($global:RedzoneGhost -and $path -like "$HOME*") {
        $leaf = Split-Path $path -Leaf
        if ($leaf -eq $env:USERNAME) { "[GHOST]" } else { $leaf }
    } else {
        Split-Path $path -Leaf
    }

    Write-Host "┌─[" -NoNewline -ForegroundColor $pal.Secondary
    Write-Host "REDZONE" -NoNewline -ForegroundColor $pal.Primary
    Write-Host "]─[" -NoNewline -ForegroundColor $pal.Secondary
    Write-Host "$shortPath" -NoNewline -ForegroundColor Gray
    Write-Host "]" -ForegroundColor $pal.Secondary
    Write-Host "└─►" -NoNewline -ForegroundColor $pal.Primary
    return " "
}

Set-Alias -Name rz -Value Show-RedzoneDashboard
Set-Alias -Name redzone -Value Show-RedzoneDashboard
Set-Alias -Name lang -Value Set-RedzoneLanguage
Set-Alias -Name rz-theme -Value Set-RedzoneTheme
Set-Alias -Name rz-ghost -Value Set-RedzoneGhost
Set-Alias -Name rz-clean -Value Invoke-RedzoneClean
Set-Alias -Name rz-update -Value Update-RedzoneTerminal
'@

Set-Content -Path $ps7ProfilePath -Value $fullMultiLangScript -Encoding UTF8 -Force
Write-Host "`nRedzone Terminal V2.0 installed successfully! Please open Windows Terminal (or restart it)." -ForegroundColor Green
