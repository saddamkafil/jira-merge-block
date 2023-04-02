#!/bin/bash
ticket_id=$(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2) # assumes branch name is in the format "feature/XXX-1234-description"
jira_status=$(curl -s -u $JIRA_USER:$JIRA_API_TOKEN -X GET $JIRA_API_URL/rest/api/3/issue/$ticket_id | jq -r '.fields.status.name')
if [[ "$jira_status" != "Ready" ]]; then
  echo "Error: Jira ticket is not in Ready status"
  exit 1
fi
