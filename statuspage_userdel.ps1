<#

.SYNOPSIS
Delete user from StatusPage - Notify Slack

.DESCRIPTION
This script will make use of the StatusPage API and get a list of users, then it will match the provided email address and send a delete request to delete said user, afterwards it will notify a specific slack channel of the outcome.

.EXAMPLE
scriptname.ps1 "StatusPage_organization_ID" "StatusPage_Token" "email_address@domain.com" [Optional]"Slack_WebHook"

With no switches the parameters will be taken in the following order: StatusPage org ID, StatusPage API token, email to be deleted, and optionally the slack webhook URL to send a notification of the outcome, whether it failed or succeeded.

.EXAMPLE
scriptname.ps1 -orgID xabcd123 -token asdcefghijklmnop-1234567890 -email existinguser@company.com -slackURL "https://hooks.slack.com/services/abcdef/abcdefgh/abcdefghijk"

.NOTES
Script created by Ernesto Portillo

.LINK
https://github.com/davidedpg10/powershell-StatusPage-user-delete-Slack-notify

#>

Param(
    [string]$orgID,
    [string]$token,
    [string]$email,
    [string]$slackURL
)

if (($email) -and ($token) -and ($orgID)){
    
    $statusPageURL = $("https://api.statuspage.io/v1/organizations/$orgID/users.json")
    ################################################################################
    ##################     Get List of USERS  ######################################
    ################################################################################
    $authorization = "OAuth $token"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", $authorization)
    $user_list = Invoke-RestMethod -Method get $statusPageURL -Headers $headers
    ##################################################################################
    ##################################################################################
    
    if ($user_list.Where({$_.email -eq $email})){
    ##################################################################################
    #########    Parses the list of users to select specified user  ##################
    ##################################################################################   
    $url = $("https://api.statuspage.io/v1/organizations/$orgID/users/"`
    + $($user_list.Where({$_.email -eq $email}) | Select-Object -ExpandProperty id)`
    + ".json")
    ##################################################################################
    ########    Utilizing the parsed URL, sends the delete API Call  #################
    ##################################################################################
    Try {
        Invoke-RestMethod -Method Delete $url -Headers $headers -ErrorAction Stop
        if ($slackURL){
            $body = @{
            "username" = "User.Watcher"
            "icon_emoji" = ":white_check_mark:"
            "text" = "User with email ``$email`` was removed from StatusPage Team Member list";
            }
            Invoke-WebRequest -Uri $slackURL `
            -Method Post -Body (ConvertTo-Json -Compress $body)
        }
    }
    Catch {
        $errorMessage = $_.Exception.Message
        $failedItem = $_.Exception.GetType().FullName
        if ($slackURL){
        $body = @{
            "username" = "Error.Reporter"
            "icon_emoji" = ":X:"
            "text" = "In an attempt to delete user with email ``$email`` from StatusPage an error occurred.
        Error: *$failedItem*
        Message: *$errorMessage*"
            }
            Invoke-WebRequest -Uri $slackURL `
    
    }        -Method Post -Body (ConvertTo-Json -Compress $body)
    }
    
    }
    
    
    
    Else {
        if ($slackURL){
            "User does not exist"
                $body = @{
                "username" = "User.Watcher"
                "icon_emoji" = ":high_brightness:"
                "text" = "An attempt was made to remove user with email ``$email`` from StatusPage, but user did not exist";
            }
            
            Invoke-WebRequest -Uri $slackURL `
            -Method Post -Body (ConvertTo-Json -Compress $body)
        }
    }
}
else {Get-Help $PSCommandPath -full}
