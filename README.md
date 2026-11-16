<div align="center">

# 🔴 REDZONE TERMINAL V2.0
S Y S T E M   C O N T R O L   &   T E L E M E T R Y

[![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-CC0000?style=for-the-badge)](LICENSE)

*Turn your Windows Terminal into a sleek, dark-crimson command center with a single command.*

[Features](#-features) • [Installation](#-installation) • [Commands](#-commands) • [Languages](#-languages) • [Uninstall](#-uninstall)

</div>

---

## 📸 Preview

<img width="1365" height="717" alt="image" src="https://github.com/user-attachments/assets/602d09f3-c4cd-4a06-91d1-524918c1b5de" />

---

## ✨ Features

* **⚡ One-Click Provisioning:** Automatically checks and installs **PowerShell 7** and **Windows Terminal** via `winget`, setting Windows Terminal as your system's default console.
* **🎨 Live Theme Sync:** Switch between **RedzoneClassic**, **Cyberpunk**, **Matrix**, and **Minimal** themes on the fly—automatically syncing both PowerShell colors and Windows Terminal's `background`, `cursorColor`, and `tabColor` in `settings.json`.
* **👻 Ghost / Streamer Privacy Mode:** Instantly mask your username, host name, and local IP address (`[REDACTED]` / `192.168.***.***`) with `rz-ghost` before taking screenshots, recording videos, or screen sharing (`rz-ghost -stop` to disable).
* **📊 Ultra-Fast System Telemetry:** Reads CPU, GPU, OS build, RAM/Disk usage bars, system uptime, and local IP directly from the Windows Registry and CIM for near-instant startup times.
* **🌐 10-Language Support:** Switch the entire dashboard interface on the fly without restarting your terminal.
* **🧹 System Maintenance:** Built-in tools like `rz-clean` for cleaning temporary files, PowerShell history, and Docker caches, plus `rz-update` for instant GitHub updates.
*  **🗑 Clean Uninstaller:** Includes `uninstaller.ps1` to revert all terminal profiles, themes, and configuration files safely.

---

## 🚀 Installation

Open **PowerShell** (as Administrator is recommended for `winget` & registry changes) and run:

```powershell
irm https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/install.ps1 | iex
```

---

## 💻 Commands

Once installed, you can use the following built-in commands anywhere in your terminal:

| Command | Alias | Description |
| :--- | :--- | :--- |
| `Show-RedzoneDashboard` | `rz` / `redzone` | Clears the screen and refreshes the live system dashboard. |
| `Set-RedzoneLanguage` | `lang` | Lists all available languages and highlights the active one. |
| `Set-RedzoneLanguage <code>` | `lang tr` | Switches dashboard language immediately (e.g., `lang en`, `lang az`). |
| `Set-RedzoneTheme <name>` | `rz-theme` | Lists or switches themes (`RedzoneClassic`, `Cyberpunk`, `Matrix`, `Minimal`). Use `rz-theme -stop` to reset. |
| `Set-RedzoneGhost` | `rz-ghost` | Enables Ghost privacy mode. Use `rz-ghost -stop` to disable. |
| `Invoke-RedzoneClean` | `rz-clean` | Cleans Windows `%TEMP%` files (supports `-History` and `-Docker` flags). |
| `Update-RedzoneTerminal` | `rz-update` | Pulls and installs the latest version directly from GitHub. |

---

## 🌐 Languages

Redzone Terminal persists your language choice in `~/.redzone_lang`:

| Code | Language | Code | Language |
| :--- | :--- | :--- | :--- |
| `en` | English *(Default)* | `fr` | Français |
| `az` | Azərbaycan | `es` | Español |
| `tr` | Türkçe | `ar` | العربية |
| `ru` | Русский | `zh` | 中文 |
| `de` | Deutsch | `ja` | 日本語 |

---

## 🗑️ Uninstall

If you ever want to revert your PowerShell profile back to default:

```powershell
irm https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/uninstaller.ps1 | iex
```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
