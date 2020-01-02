﻿. "$PSScriptRoot\cwm-server-rest.ps1"
. "$PSScriptRoot\cwm-company.ps1"
. "$PSScriptRoot\bpa-date-functions.ps1"
. "$PSScriptRoot\bpa-validator-functions.ps1"
. "$PSScriptRoot\bpa-task.ps1"

$TaskFolder = "$PSScriptRoot\Tasks"
$CompanyIDFile = "$PSScriptRoot\CompanyIDs.csv"

#$VerbosePreference = "continue"
#$WarningAction Inquire
$VerbosePreference = "SilentlyContinue"

[bool] $forceWeekly = $false
[bool] $forceMonthly = $false
[bool] $forceQuarterly = $false
[bool] $forceSemiAnnual = $false
[bool] $forceAnnual = $false
[bool] $forceAll = $false

if ($forceAll) {
    $forceWeekly = $forceMonthly = $forceQuarterly = $forceSemiAnnual = $forceAnnual = $true
}

[string] $onboardCustomer = "FEC,AEP"

$Server = [CWServer]::new("equilibrium", "eqwf.equilibriuminc.com", "MLDBHBvh5LNLyvuK", "QMcVdAojN8p6EA9J")
$null = $server.connect()

$Companies = Load-CompanyData $CompanyIDFile $TaskFolder

foreach ($company in $Companies) {
    $tasks = Load-ClientTasks $company.path
    foreach ($task in $tasks) {
        if ($onboardCustomer -eq "") {
            if ($(isNewWeek) -or $forceWeekly) {
                #Create Weelkies
                if ($Task.Frequency -eq "Weekly") {
                    $company.abbreviation
                    $task
                    #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                    #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
                }
            }
            if ($(isNewMonth) -or $forceMonthly) {
                if ($Task.Frequency -eq "Monthly") {
                    $company.abbreviation
                    $task
                    #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                    #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
                }
            }
            if ($(isNewQuarter) -or $forceQuarterly) {
                if ($Task.Frequency -eq "Quarterly") {
                    $company.abbreviation
                    $task
                    #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                    #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
                }
            }
            if ($(isNewHalfYear) -or $forceSemiAnnual) {
                if ($Task.Frequency -eq "SemiAnnual") {
                    $company.abbreviation
                    $task
                    #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                    #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
                }
            }
            if ($(isNewYear) -or $forceAnnual) {
                    if ($Task.Frequency -eq "Annual") {
                    $company.abbreviation
                    $task
                    #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                    #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
                }
            }
        } elseif ($onboardCustomer -like "*$($company.abbreviation)*") {
           $company.abbreviation
           $task            
            
        }
    }
}