# 🛡️ Vigilante_awar
**Lightweight SSH Intrusion Detection & Automated Defense System**

`Vigilante_awar` is a high-performance, zero-dependency Bash utility designed for real-time monitoring of authentication logs. It proactively defends Linux servers by identifying brute-force patterns, blocking malicious IPs via UFW/IPTables, and sending instant alerts through the Telegram Bot API.

---

## 🚀 Key Features
* **Real-time Log Analysis:** Monitored via `tail -f` on `/var/log/auth.log`.
* **Proactive Defense:** Automatically triggers firewall rules (UFW/IPTables) after a configurable threshold of failed attempts.
* **Telegram Integration:** Receive instant notifications on your mobile device with detailed attack info.
* **IP Intelligence:** Integrated Geolocation API to identify the origin (Country/ISP) of the attacker.
* **Zero-Dependency:** Written entirely in Bash. No need for Python, Go, or heavy frameworks.

---

## 🛠️ Technical Stack
* **Language:** Bash (Shell Scripting)
* **Security Tools:** UFW / IPTables
* **Communication:** Telegram Bot API (cURL)
* **Data Processing:** Grep, Awk, Sed

---

## 📥 Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/aLeonhart87/Vigilante_awar.git](https://github.com/aLeonhart87/Vigilante_awar.git)
   cd Vigilante_awar
📊 How it Works
The script follows a simple but effective logic gate:

Detect: Monitors auth.log for "Failed password" strings.

Counter: Increments a failure count per IP address.

Analyze: Once the threshold is met, it fetches Geolocation data for the IP.

Action: Executes a ufw deny command and sends a Telegram alert with the map location and ISP.

🛡️ Why Bash?
While tools like Fail2Ban exist, Vigilante_awar was built with a minimalist hardening philosophy. It is designed for environments where system overhead must be kept to a minimum and where external dependencies are a security risk.

⚠️ Disclaimer
This tool is intended for educational purposes and personal server hardening. Always test in a staging environment before deploying to production.
