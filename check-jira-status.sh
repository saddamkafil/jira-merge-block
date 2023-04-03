#!/bin/bash
ticket_id=$(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2) # assumes branch name is in the format "feature/XXX-1234-description"
jira_status=$(curl -s -u saddamshaik.devops@gmail.com:ATATT3xFfGF0MxNWpYNDrGQTZ7gLyWhOOUczwROC0t8m9nf2jb0oMrrSZVoH87RSBC2amXKsdV8LFLFjX4xbmw87T-K2Rd6DMiZ1e_99oO3xaL1luiTtfF4r4dijsdpGvmtqGBKnlWYQ6Jr9fzLT_HCfr_c5upC4C2hQNO8i6r6lh3uoTBOQdek=6EB5B98E -X GET $https://proklouds.atlassian.net//rest/api/3/issue/$ticket_id | jq -r '.fields.status.name')
if [[ "$jira_status" != "Ready" ]]; then
  echo "Error: Jira ticket is not in Ready status"
  exit 1
fi

