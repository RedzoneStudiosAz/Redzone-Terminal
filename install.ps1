Write-Host "Installing Redzone Terminal V1..." -ForegroundColor Red

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

# 4. Write 10-Language Redzone System Dashboard V1 Profile (Default: English)
$ps7ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$profileDir = Split-Path $ps7ProfilePath
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

$fullMultiLangScript = @'
$langFile = "$env:USERPROFILE\.redzone_lang"
if (-not (Test-Path $langFile)) { Set-Content -Path $langFile -Value "en" -Encoding UTF8 }
$global:RedzoneLang = (Get-Content $langFile -Raw).Trim()

$global:RedzoneTranslations = @{
    "en" = @{
        Name="English"; Sub="S Y S T E M   C O N T R O L   V 1";
        User="User       : "; OS="OS         : "; CPU="Processor  : "; GPU="Graphics   : ";
        RAM="Memory RAM : "; Disk="Disk (C:)  : "; Up="Uptime     : "; IP="Local IP   : ";
        Days="d"; Hours="h"; Mins="m"; Off="Offline";
        Hint="Change lang: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Available languages:"; Active="[ACTIVE]"; Usage="Usage: lang az  (or lang tr, lang ru, etc.)";
        Err="Error: '{0}' is not supported. Type 'lang' to see list."
    }
    "az" = @{
        Name="Azərbaycan"; Sub="S İ S T E M   N Ə Z A R Ə T İ   V 1";
        User="İstifadəçi : "; OS="Sistem     : "; CPU="Prosessor  : "; GPU="Qrafika    : ";
        RAM="Yaddaş RAM : "; Disk="Disk (C:)  : "; Up="İşləmə vaxt: "; IP="Lokal IP   : ";
        Days="g"; Hours="s"; Mins="d"; Off="Şəbəkə yoxdur";
        Hint="Dil dəyiş: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Mövcud dillər:"; Active="[AKTİV]"; Usage="İstifadə: lang en  (və ya lang tr, lang ru və s.)";
        Err="Xəta: '{0}' dəstəklənmir. Siyahı üçün 'lang' yazın."
    }
    "tr" = @{
        Name="Türkçe"; Sub="S İ S T E M   K O N T R O L   V 1";
        User="Kullanıcı  : "; OS="Sistem     : "; CPU="İşlemci    : "; GPU="Grafik     : ";
        RAM="Bellek RAM : "; Disk="Disk (C:)  : "; Up="Çalışma    : "; IP="Yerel IP   : ";
        Days="g"; Hours="s"; Mins="dk"; Off="Çevrimdışı";
        Hint="Dil değiştir: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Mevcut diller:"; Active="[AKTİF]"; Usage="Kullanım: lang en  (veya lang az, lang ru vb.)";
        Err="Hata: '{0}' desteklenmiyor. Liste için 'lang' yazın."
    }
    "ru" = @{
        Name="Русский"; Sub="К О Н Т Р О Л Ь   С И С Т Е М Ы   V 1";
        User="Юзер       : "; OS="Система    : "; CPU="Процессор  : "; GPU="Графика    : ";
        RAM="Память RAM : "; Disk="Диск (C:)  : "; Up="Аптайм     : "; IP="Локал IP   : ";
        Days="д"; Hours="ч"; Mins="м"; Off="Офлайн";
        Hint="Сменить язык: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Доступные языки:"; Active="[АКТИВЕН]"; Usage="Использование: lang en  (или lang az, lang tr и т.д.)";
        Err="Ошибка: '{0}' не поддерживается. Введите 'lang' для списка."
    }
    "de" = @{
        Name="Deutsch"; Sub="S Y S T E M K O N T R O L L E   V 1";
        User="Benutzer   : "; OS="System     : "; CPU="Prozessor  : "; GPU="Grafik     : ";
        RAM="Speicher   : "; Disk="Festplatte : "; Up="Laufzeit   : "; IP="Lokale IP  : ";
        Days="T"; Hours="Std"; Mins="Min"; Off="Offline";
        Hint="Sprache ändern: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Verfügbare Sprachen:"; Active="[AKTIV]"; Usage="Verwendung: lang en  (oder lang az, lang tr usw.)";
        Err="Fehler: '{0}' wird nicht unterstützt. Geben Sie 'lang' ein."
    }
    "fr" = @{
        Name="Français"; Sub="C O N T R Ô L E   S Y S T È M E   V 1";
        User="Utilisateur: "; OS="Système    : "; CPU="Processeur : "; GPU="Graphiques : ";
        RAM="Mémoire    : "; Disk="Disque (C:): "; Up="Disponibil.: "; IP="IP Locale  : ";
        Days="j"; Hours="h"; Mins="m"; Off="Hors ligne";
        Hint="Changer langue: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Langues disponibles :"; Active="[ACTIF]"; Usage="Utilisation : lang en  (ou lang az, lang tr, etc.)";
        Err="Erreur : '{0}' non pris en charge. Tapez 'lang'."
    }
    "es" = @{
        Name="Español"; Sub="C O N T R O L   D E L   S I S T E M A   V 1";
        User="Usuario    : "; OS="Sistema    : "; CPU="Procesador : "; GPU="Gráficos   : ";
        RAM="Memoria RAM: "; Disk="Disco (C:) : "; Up="Actividad  : "; IP="IP Local   : ";
        Days="d"; Hours="h"; Mins="m"; Off="Desconectado";
        Hint="Cambiar idioma: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="Idiomas disponibles:"; Active="[ACTIVO]"; Usage="Uso: lang en  (o lang az, lang tr, etc.)";
        Err="Error: '{0}' no soportado. Escribe 'lang' para ver la lista."
    }
    "ar" = @{
        Name="العربية"; Sub="التحكم في النظام  V 1";
        User="المستخدم   : "; OS="النظام     : "; CPU="المعالج    : "; GPU="الرسوميات  : ";
        RAM="الذاكرة    : "; Disk="القرص (C:) : "; Up="وقت التشغيل: "; IP="IP المحلي  : ";
        Days="ي"; Hours="س"; Mins="د"; Off="غير متصل";
        Hint="تغيير اللغة: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="اللغات المتاحة:"; Active="[نشط]"; Usage="الاستخدام: lang en  (أو lang az، lang tr، إلخ)";
        Err="خطأ: '{0}' غير مدعوم. اكتب 'lang' لعرض القائمة."
    }
    "zh" = @{
        Name="中文"; Sub="系统控制中心  V 1";
        User="用户       : "; OS="系统       : "; CPU="处理器     : "; GPU="显卡       : ";
        RAM="内存 RAM   : "; Disk="磁盘 (C:)  : "; Up="运行时间   : "; IP="本地 IP    : ";
        Days="天"; Hours="时"; Mins="分"; Off="离线";
        Hint="切换语言: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="可用语言:"; Active="[当前]"; Usage="用法: lang en  (或 lang az, lang tr 等)";
        Err="错误: 不支持 '{0}'。输入 'lang' 查看列表。"
    }
    "ja" = @{
        Name="日本語"; Sub="システムコントロール  V 1";
        User="ユーザー   : "; OS="OS         : "; CPU="CPU        : "; GPU="GPU        : ";
        RAM="メモリ     : "; Disk="ディスク   : "; Up="稼働時間   : "; IP="ローカルIP : ";
        Days="日"; Hours="時間"; Mins="分"; Off="オフライン";
        Hint="言語変更: lang [en|az|tr|ru|de|fr|es|ar|zh|ja]";
        Avail="利用可能な言語:"; Active="[有効]"; Usage="使用法: lang en  (または lang az, lang tr など)";
        Err="エラー: '{0}' はサポートされていません。'lang' で一覧を表示します。"
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

function Show-RedzoneDashboard {
    Clear-Host
    $t = $global:RedzoneTranslations[$global:RedzoneLang]
    if (-not $t) { $t = $global:RedzoneTranslations["en"] }

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
        @{ Label = $t.User; Value = "$env:USERNAME@$env:COMPUTERNAME" },
        @{ Label = $t.OS;   Value = "$osName" },
        @{ Label = $t.CPU;  Value = "$cpuName" },
        @{ Label = $t.GPU;  Value = "$gpuName" },
        @{ Label = $t.RAM;  Value = "[$ramBar] $usedRam / $totalRam GB ($ramPercent%)" },
        @{ Label = $t.Disk; Value = "[$diskBar] $usedDisk / $totalDisk GB ($diskPercent%)" },
        @{ Label = $t.Up;   Value = "$uptimeStr" },
        @{ Label = $t.IP;   Value = "$localIP" }
    )

    Write-Host ""
    for ($i = 0; $i -lt $logo.Count; $i++) {
        Write-Host $logo[$i] -NoNewline -ForegroundColor Red
        Write-Host "  │  " -NoNewline -ForegroundColor DarkGray
        Write-Host $info[$i].Label -NoNewline -ForegroundColor DarkRed
        Write-Host $info[$i].Value -ForegroundColor White
    }
    Write-Host "  ────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  🌐 $($t.Name.ToUpper())  │  $($t.Hint)" -ForegroundColor DarkGray
    Write-Host ""
}

Show-RedzoneDashboard

function prompt {
    $path = $executionContext.SessionState.Path.CurrentLocation.Path
    $shortPath = if ($path -eq $HOME) { "~" } else { Split-Path $path -Leaf }
    Write-Host "┌─[" -NoNewline -ForegroundColor DarkRed
    Write-Host "REDZONE" -NoNewline -ForegroundColor Red
    Write-Host "]─[" -NoNewline -ForegroundColor DarkRed
    Write-Host "$shortPath" -NoNewline -ForegroundColor Gray
    Write-Host "]" -ForegroundColor DarkRed
    Write-Host "└─►" -NoNewline -ForegroundColor Red
    return " "
}

Set-Alias -Name rz -Value Show-RedzoneDashboard
Set-Alias -Name redzone -Value Show-RedzoneDashboard
Set-Alias -Name lang -Value Set-RedzoneLanguage
'@

Set-Content -Path $ps7ProfilePath -Value $fullMultiLangScript -Encoding UTF8 -Force
Write-Host "`nRedzone Terminal V1 installed successfully! Please open Windows Terminal (or restart it)." -ForegroundColor Green
