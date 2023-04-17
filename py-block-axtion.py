name: Check Jira ticket before merging to develop

on:
  pull_request:
    types: [opened, edited, reopened, synchronize]
    branches: [main]

jobs:
  merge-to-develop:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.x'

      - name: Install Jira module
        run: pip install jira

      - name: Check Jira ticket status
        env:
          JIRA_API_KEY: ${{ secrets.JIRA_API_KEY }}
        run: |
          pr_title=$(echo "${{ github.event.pull_request.title }}" | grep -oP "(?<=\\[).*?(?=\\])")
          if [[ -z "$pr_title" ]]; then
            echo "PR title doesn't contain a Jira ticket reference. Merge to develop is allowed."
            exit 0
          fi
          jira_ticket_status=$(python -c "import jira; j=jira.JIRA('https://<your-jira-url>', basic_auth=('<your-jira-username>', '$JIRA_API_KEY')); print(j.issue('$pr_title').fields.status.name)")
          if [[ "$jira_ticket_status" == "Resolved" ]]; then
            echo "Jira ticket $pr_title is marked as Resolved. Merge to develop is allowed."
            exit 0
          else
            echo "Jira ticket $pr_title is not marked as Resolved. Merge to develop is not allowed."
            exit 1
          fi
