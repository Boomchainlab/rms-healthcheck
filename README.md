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
https://github.com/Boomchainlab/rms-healthcheck.git
2. Run Manual Check
.\RMS-HealthCheck.ps1
3. Schedule Automatic Checks

Open Task Scheduler > Import Task
➡️ Load: scheduler\RMSHealthCheck.task.xml
schtasks /Create /TN "RMS Health Check" /XML "..\scheduler\RMSHealthCheck.task.xml"
4. Configure Email Alerts (Optional)

Update SMTP config in RMS-HealthCheck.ps1:
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$from = "rms-monitor@boomchainlab.com"
$to = "admin@boomchainlab.com"
$username = "rms-monitor@boomchainlab.com"
$password = "YOUR_APP_PASSWORD" # Replace or load from GitHub Secret

📬 Teams or Slack Webhook Integration (Optional)

Coming soon: native support for Microsoft Teams incoming webhook alerts.

⸻

🤝 Maintainer

Boomchainlab – boomchainlab.com
Contact: support@boomchainlab.com

📄 License

MIT License
