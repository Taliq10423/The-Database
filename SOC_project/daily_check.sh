#!/bin/bash

echo "==== Daily Log Check: $(date) ====" > DailyCheckReport.txt

echo -e "\n-- Failed Login Attempts --" >> DailyCheckReport.txt
jq '.[] | select(.status == "failed")' auth_log.json >> DailyCheckReport.txt

echo -e "\n-- IPs with 5+ Failed Logins --" >> DailyCheckReport.txt
jq -r '.[] | select(.status == "failed") | .ip' auth_log.json | sort | uniq -c | awk '$1 >= 5' >> DailyCheckReport.txt

echo -e "\n-- Unauthorized Events in System Log --" >> DailyCheckReport.txt
jq '.[] | select(.message | test("unauthorized"; "i"))' sys_log.json >> DailyCheckReport.txt
