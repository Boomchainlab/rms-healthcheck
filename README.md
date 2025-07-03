# 🛡️ RMS Health Check Automation

## 🔍 Active Directory Rights Management Services (AD RMS) Monitor

This repository provides a fully automated script suite to monitor the health of your **on-premises AD RMS cluster**, validate endpoint availability, test certificate validity, and optionally send alerts via **email or Teams**.

---

### 📦 Repository Structure

```bash
rms-healthcheck/
├── scripts/
│   ├── RMS-HealthCheck.ps1            # Main PowerShell monitoring script
│   └── Run-RMSHealthCheck.bat         # Batch wrapper for task scheduler
├── scheduler/
│   └── RMSHealthCheck.task.xml        # Importable Windows Task Scheduler config
└── .github/
    └── workflows/
        └── windows-scheduled.yml      # (Optional) CI pipeline for GitHub-triggered health checks
🚀 Features
	•	✅ Auto-discovers AD RMS SCP (Service Connection Point)
	•	🌐 Validates RMS publishing & licensing endpoints
	•	🔐 Inspects SSL certificate validity (subject, issuer, expiry)
	•	🧾 Logs results to daily timestamped log files
	•	✉️ Sends alert via SMTP or posts to Teams (optional)
	•	📅 Easily scheduled using Windows Task Scheduler
🛠️ Installation Instructions

1. Clone the Repository
🛠️ Installation Instructions

1. Clone the Repository
