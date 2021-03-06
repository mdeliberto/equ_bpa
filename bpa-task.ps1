﻿. "$PSScriptRoot\bpa-date-functions.ps1"

enum TaskFrequency {
        Weekly =  416;
        Monthly = 417;
        Quarterly =  418;
        SemiAnnual = 419;
        Annual =    420;
        Daily   =   421;
}

enum TaskCategory {
        System      = 563
        Application = 564
        Network     = 565
        Desktop     = 566
        Security    = 567
        Cloud       = 568
        Storage     = 569
}

class Task {
    [string]$Summary
    [double]$Budget
    [TaskFrequency]$Frequency
    [TaskCategory]$Category
    [string]$Engineer
    [string]$DueDate
    [string]$Description

    Task([string]$Summary, [string]$Frequency, [double]$Budget, [string]$Engineer,[string]$InitialDescription, [string]$Category)     {
        [datetime]$TaskDueDate = Get-Date -Hour 17 -Minute 30 -Second 0;
        
        [bool] $parameterIssue = $false
        
        $this.Frequency = [TaskFrequency]$Frequency
        $this.Category = [TaskCategory]$Category
        $this.Summary = $Summary
        if ($Engineer -eq "?????") {
            #"Unassigned engineer"
            $this.Engineer = "TSenn"
        } else {    
            $this.Engineer = $Engineer
        }

        $This.Description = $InitialDescription

        $castBudget = [double]::Parse($Budget)
        if ($castBudget -lt 0) {
            Write-verbose "Budget is $castBudget. Changing to 0"
            $this.Budget = 0
        } else {
            $this.Budget = $castBudget
        }

        switch($this.Frequency) {
            ([TaskFrequency]::Weekly)
                {$TaskDueDate = get-WeeklyDueDate}
            ([TaskFrequency]::Monthly)
                 {$TaskDueDate = get-MonthlyDueDate}
            ([TaskFrequency]::Quarterly)
                 {$TaskDueDate = get-QuarterlyDueDate}
            ([TaskFrequency]::SemiAnnual)
                 {$TaskDueDate = get-SemiAnnualDueDate}
            ([TaskFrequency]::Annual)
                 {$TaskDueDate = get-AnnualDueDate}
            default
                {$TaskDueDate = Get-date -Hour 17 -Minute 30 -Second 0}
        }
        $this.DueDate = $($TaskDueDate).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ");
    }
}

function Load-ClientTasks {
    [CmdletBinding()]
    [OutputType([Task[]])]
    Param (
        [validateScript({ isNotEmptyFile($_) })]
        [string] $clientTasks)
    
    [Task[]]$retVal  =@()
    
    $taskImport = import-csv -Path $clientTasks
    
    if (-not (isNotEmptyNull($taskImport))) {
        write-error "$clientTasks returned a null or empty hashtable"
    }
    
    Write-Verbose "Imported from file: $clientTasks"
    $taskImport | FT | Out-String | Write-Verbose
    Write-Verbose "Located $($taskImport.Count) rows"
    
    foreach ($taskRow in $taskImport) {
        
        if ([string]::IsNullOrEmpty($taskRow.Summary)     -or [string]::IsNullOrWhiteSpace($taskRow.Summary) -or `
            [string]::IsNullOrEmpty($taskRow.Budget)      -or [string]::IsNullOrWhiteSpace($taskRow.Budget) -or `
            [string]::IsNullOrEmpty($taskRow.Category)   -or [string]::IsNullOrWhiteSpace($taskRow.Category) -or `
            [string]::IsNullOrEmpty($taskRow.Description) -or [string]::IsNullOrWhiteSpace($taskRow.Description) -or `
            [string]::IsNullOrEmpty($taskRow.Freq)        -or [string]::IsNullOrWhiteSpace($taskRow.Freq) -or `
            [string]::IsNullOrEmpty($taskRow.Engineer)    -or [string]::IsNullOrWhiteSpace($taskRow.Engineer)) {
            write-warning "Found an empty, null or white space string in file: $clientTasks `n will gracefully drop:`n$taskrow.`n Error: Your inputfile has empty/bad data."
            break;    
        } else {
           [Task]$NewTask = [Task]::new($taskRow.Summary, [TaskFrequency]$taskRow.Freq, $taskRow.Budget, $taskRow.Engineer, $taskRow.Description, [TaskCategory]$taskRow.Category)
                  
            if ($newTask -ne $null) {
                $retVal += $newTask
            }
        }
    }

    return $retVal;

}