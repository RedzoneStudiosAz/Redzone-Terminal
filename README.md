Markdown<div align="center">

# 🔴 REDZONE TERMINAL V2.0
**S Y S T E M    C O N T R O L    &    T E L E M E T R Y**

[![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-CC0000?style=for-the-badge)](LICENSE)

*Turn your Windows Terminal into a sleek, dark-crimson command center with a single command.*

[Features](#-features) • [Installation](#-installation) • [Commands](#-commands) • [Languages](#-languages) • [Uninstall](#-uninstall)

</div>

---

## 📸 Preview

<img width="1360" height="715" alt="Redzone Terminal Preview" src="https://github.com/user-attachments/assets/e1155a8f-c92f-4c5d-ae6b-f0ba3edee84d" />

---

## ✨ Features

- **⚡ One-Click Provisioning:** Automatically checks and installs **PowerShell 7** and **Windows Terminal** via `winget`, setting Windows Terminal as your system's default console.
- **🎨 Live Theme Sync:** Switch between **RedzoneClassic**, **Cyberpunk**, **Matrix**, and **Minimal** themes on the fly—automatically syncing both PowerShell colors and Windows Terminal's `background`, `cursorColor`, and `tabColor` in `settings.json`.
- **👻 Ghost / Streamer Privacy Mode:** Instantly mask your username, host name, and local IP address (`[REDACTED]` / `192.168.***.***`) with `rz-ghost` before taking screenshots, recording videos, or screen sharing.
- **📊 Ultra-Fast System Telemetry:** Reads CPU, GPU, OS build, RAM/Disk usage bars, system uptime, and local IP directly from the Windows Registry and CIM for near-instant startup times.
- **🌐 10-Language Support:** Switch the entire dashboard interface on the fly without restarting your terminal.

---

## 🚀 Installation

Open **PowerShell** (as Administrator is recommended for `winget` & registry changes) and run:

```powershell
irm [https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/install.ps1](https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/install.ps1) | iex
💻 CommandsOnce installed, you can use the following built-in commands anywhere in your terminal:CommandAliasDescriptionShow-RedzoneDashboardrz / redzoneClears the screen and refreshes the live system dashboard.Set-RedzoneLanguagelangLists all available languages and highlights the active one.Set-RedzoneLanguage <code>lang trSwitches dashboard language immediately (e.g., lang en, lang az).Set-RedzoneTheme <name>rz-themeLists or switches themes (RedzoneClassic, Cyberpunk, Matrix, Minimal). Use rz-theme -stop to reset to default.Set-RedzoneGhostrz-ghostEnables Ghost/Streamer privacy mode. Use rz-ghost -stop to disable it.Invoke-RedzoneCleanrz-cleanCleans Windows %TEMP% files (supports -History and -Docker flags).Update-RedzoneTerminalrz-updatePulls and installs the latest version directly from GitHub.🌐 LanguagesRedzone Terminal persists your language choice in ~/.redzone_lang:CodeLanguageCodeLanguageenEnglish (Default)frFrançaisazAzərbaycanesEspañoltrTürkçearالعربيةruРусскийzh中文deDeutschja日本語🗑️ UninstallIf you ever want to revert your PowerShell profile back to default:PowerShellirm [https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/uninstaller.ps1](https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/uninstaller.ps1) | iex
📄 LicenseDistributed under the MIT License. See LICENSE for more information.
