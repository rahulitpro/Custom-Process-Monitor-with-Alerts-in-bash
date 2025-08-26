# Custom-Process-Monitor-with-Alerts-in-bash
Custom Process Monitor with Alerts  in bash

• Goal: Monitor CPU/memory usage of specific processes and trigger alerts (email, Telegram, desktop notification) when thresholds are exceeded.

• Features:
  ◦ Accept a PID or process name as input or find top load process in linux server by default.
  ◦ Log historical usage in a file.
  ◦ Send alert via API (e.g., Pushbullet, Slack webhook).

• Prerequisite: sysstat Package

• How to Use:
  ◦ open terminal window and run to start test upload api server

    python file_upload/main.py

  ◦ Edit Process monitoring script with API_URL and Run Process Monitor Script with either of below option

    ./process_monitor.sh <process_id>

    or 

    ./process_monitor.sh
