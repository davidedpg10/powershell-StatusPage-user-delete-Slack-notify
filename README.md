# powershell-StatusPage-user-delete-Slack-notify
Script to delete user from StatusPage and notify slack.

This script utilizes the StatusPage API to get a list of users, then it will make use of the email address supplied to match it to a record, then submit a delete request for said record. Optionally The script will then notify a slack channel of the outcome, whether successful or failed, making use of a slack webhook.


# Use
## Example 1
With no switches the parameters will be taken in the following order: StatusPage org ID, StatusPage API token, email to be deleted, and optionally the slack webhook URL to send a notification of the outcome, whether it failed or succeeded.
' statuspage_userdel.ps1 <StatusPage_organization_ID> <StatusPage_Token> <email_address<span>@</span>domain.com> (Optional)<Slack_WebHook> '

#### Here is an example with mock-values
**statuspage_userdel.ps1** '"xabcd123 asdcefghijklmnop-1234567890"' '"existinguser@company.com"' '"https<span>://</span>hooks.slack.com/services/abcdef/abcdefgh/abcdefghijk"'


## Example 2
With specified switches the parameters can go in any order, in this example the order stays the same but it is not required.
> **statuspage_userdel.ps1** **-orgID** _xabcd123_ **-token** _asdcefghijklmnop-1234567890_ **-email** _existinguser@company.com_ **-slackURL** _ht<span>tps://</span>hooks.slack.com/services/abcdef/abcdefgh/abcdefghijk_

# Requirements for Full Functionality

####  StatusPage Owner account's API Token.

####  StatusPage Organization ID

####  Email address of Account to be deleted

####  [Optional] Slack channel with a WebHook application
