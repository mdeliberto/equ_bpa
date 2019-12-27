﻿. "$PSScriptRoot\cwm-server-rest.ps1"
. "$PSScriptRoot\cwm-company.ps1"
. "$PSScriptRoot\bpa-date-functions.ps1"
. "$PSScriptRoot\bpa-validator-functions.ps1"
. "$PSScriptRoot\bpa-task.ps1"


$TaskFolder = "$PSScriptRoot\Tasks2"
$CompanyIDFile = "$PSScriptRoot\CompanyIDs.csv"

$VerbosePreference = "continue"
#$VerbosePreference = "SilentlyContinue"


$Server = [CWServer]::new("equilibrium", "eqwf.equilibriuminc.com", "MLDBHBvh5LNLyvuK", "QMcVdAojN8p6EA9J")
$null = $server.connect()


$Companies = Load-CompanyData $CompanyIDFile $TaskFolder

$Companies | ft

foreach ($company in $Companies) {
    $company
    write-host $company.path
    $tasks = Load-ClientTasks $company.path
    foreach ($task in $tasks) {
        #if (isNewWeek) {
            #Create Weelkies
            if ($Task.Frequency -eq "Weekly") {
                $company.abbreviation
                $task.Summary
                #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
            }
        #}
        #if (isNewMonth) {
            if ($Task.Frequency -eq "Monthly") {
                $company.abbreviation
                $task.Summary
                #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
            }
        #}
        #if (isNewQuarter) {
            if ($Task.Frequency -eq "Quarterly") {
                $company.abbreviation
                $task.Summary
                #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
            }
        #}
        #if (isNewHalfYear) {
            if ($Task.Frequency -eq "SemiAnnual") {
                $company.abbreviation
                $task.Summary
                #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
            }
        #}
        #if (isNewYear) {
                if ($Task.Frequency -eq "Annual") {
                $company.abbreviation
                $task.Summary
                #$newTask = [Task]::new($task.Task, $Task.Freq, $Task.Budget, "System", $Task.Engineer, "None")
                #$Server.CreateTicket($newTask.Summary, "None at this time", $company.id, $newTask.owner, 71, $newTask.Type, $newTask.subtype, 1022, $newtask.DueDate, $newTask.budget)
            }
        #}
    }
}
