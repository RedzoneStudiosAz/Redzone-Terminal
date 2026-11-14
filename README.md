<div align="center">

# REDZONE TERMINAL V1
**S Y S T E M    C O N T R O L    &    T E L E M E T R Y**


[![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-CC0000?style=for-the-badge)](LICENSE)

*Turn your Windows Terminal into a sleek, dark-crimson command center with a single command.*

[Features](#-features) • [Installation](#-installation) • [Commands](#-commands) • [Languages](#-supported-languages) • [Uninstall](#-uninstall)

</div>

---

## 📸 Preview
<img width="1360" height="715" alt="Redzone Terminal Preview" src="https://github.com/user-attachments/assets/e1155a8f-c92f-4c5d-ae6b-f0ba3edee84d" />

---

## ✨ Features

- **⚡ One-Click Provisioning:** Automatically checks and installs **PowerShell 7** and **Windows Terminal** via `winget`, setting Windows Terminal as your system's default console.
- **🎨 Redzone Crimson Theme:** Applies a custom high-contrast dark-red color palette (`#0D0505` background, `#FF1E1E` accents), Acrylic transparency (`88%` opacity), filled-box cursor, and a minimal two-line prompt.
- **📊 Ultra-Fast System Telemetry:** Reads CPU, GPU, OS build, RAM/Disk usage bars, system uptime, and local IP directly from the Windows Registry and CIM for near-instant startup times.
- **🌐 10-Language Support:** Switch the entire dashboard interface on the fly without restarting your terminal.

---

## 🚀 Installation

### Option 1: One-Line Quick Install (Recommended)
Open **PowerShell** (as Administrator is recommended for `winget` & registry changes) and run:

```powershell
irm https://raw.githubusercontent.com/redzonestudiosdeveloper-ai/Redzone-Terminal/refs/heads/main/install.ps1 | iex
