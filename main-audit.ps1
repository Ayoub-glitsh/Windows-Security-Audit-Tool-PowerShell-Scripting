# ============================================
# Windows Security Audit Tool
# Main Script with Interactive Menu
# Version: 3.0
# Author: Ayoub Aguezar
# ============================================

# Script configuration
$ScriptVersion = "3.0"
$Company = "Security Engineering Portfolio"
$ReportsFolder = ".\reports"
$LogsFolder = ".\logs"
$ModulesFolder = ".\modules"

# Create necessary folders
function Initialize-Folders {
    Write-Host ""
    Write-Host "Initializing folders..." -ForegroundColor Yellow
    
    $folders = @($ReportsFolder, $LogsFolder)
    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
            Write-Host "  OK: $folder" -ForegroundColor Green
        }
    }
}

# Display banner
function Show-Banner {
    Clear-Host
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "     WINDOWS SECURITY AUDIT TOOL v$ScriptVersion              " -ForegroundColor Cyan
    Write-Host "     ====================================              " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "     Professional Windows Security Assessment Tool     " -ForegroundColor Cyan
    Write-Host "     Created by: Ayoub Aguezar                        " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Load security modules
function Load-SecurityModules {
    Write-Host ""
    Write-Host "Loading security modules..." -ForegroundColor Yellow
    
    $modules = @{
        "System"    = "SystemAudit.ps1"
        "Accounts"  = "AccountAudit.ps1"
        "Network"   = "NetworkAudit.ps1"
        "Defender"  = "DefenderAudit.ps1"
    }
    
    $loadedModules = @()
    $failedModules = @()
    
    foreach ($moduleName in $modules.Keys) {
        $moduleFile = $modules[$moduleName]
        $modulePath = Join-Path $ModulesFolder $moduleFile
        
        Write-Host "  . $moduleName" -NoNewline -ForegroundColor Gray
        
        if (Test-Path $modulePath) {
            try {
                . $modulePath
                
                # Check if main function exists
                $functionName = switch ($moduleName) {
                    "System"    { "Get-SystemInformation" }
                    "Accounts"  { "Get-AccountSecurityAudit" }
                    "Network"   { "Get-NetworkSecurityAudit" }
                    "Defender"  { "Get-DefenderSecurityAudit" }
                }
                
                if (Get-Command $functionName -ErrorAction SilentlyContinue) {
                    $loadedModules += $moduleName
                    Write-Host " [OK]" -ForegroundColor Green
                } else {
                    $failedModules += "$moduleName (function missing)"
                    Write-Host " [ERROR]" -ForegroundColor Red
                }
            } catch {
                $failedModules += "$moduleName (error: $($_.Exception.Message))"
                Write-Host " [ERROR]" -ForegroundColor Red
            }
        } else {
            $failedModules += "$moduleName (file missing)"
            Write-Host " [MISSING]" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "Status: $($loadedModules.Count) modules out of $($modules.Count) loaded" -ForegroundColor Cyan
    
    if ($failedModules.Count -gt 0) {
        Write-Host ""
        Write-Host "Failed modules:" -ForegroundColor Yellow
        foreach ($failed in $failedModules) {
            Write-Host "  - $failed" -ForegroundColor Yellow
        }
    }
    
    return $loadedModules
}

# Main menu
function Show-MainMenu {
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "                 MAIN MENU                             " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  1. Complete Security Audit" -ForegroundColor Green
    Write-Host "  2. System Audit Only" -ForegroundColor Green
    Write-Host "  3. Accounts Audit Only" -ForegroundColor Green
    Write-Host "  4. Network Audit Only" -ForegroundColor Green
    Write-Host "  5. Defender Audit Only" -ForegroundColor Green
    Write-Host "  6. Generate HTML Report" -ForegroundColor Green
    Write-Host "  7. View Existing Reports" -ForegroundColor Green
    Write-Host "  8. Help and Information" -ForegroundColor Green
    Write-Host "  9. Exit" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Your choice (1-9): " -NoNewline -ForegroundColor Yellow
}

# Complete audit
function Invoke-CompleteSecurityAudit {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host "        COMPLETE SECURITY AUDIT        " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host ""
    
    Write-Host "Audit started at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""
    
    $auditResults = @{}
    $scores = @()
    
    # 1. System audit
    Write-Host "[1/4] System Audit..." -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $systemResult = Get-SystemInformation
    $auditResults.System = $systemResult
    $scores += $systemResult.Score
    Start-Sleep -Milliseconds 700
    
    # 2. Accounts audit
    Write-Host ""
    Write-Host "[2/4] Accounts Audit..." -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $accountResult = Get-AccountSecurityAudit
    $auditResults.Account = $accountResult
    $scores += $accountResult.Score
    Start-Sleep -Milliseconds 700
    
    # 3. Network audit
    Write-Host ""
    Write-Host "[3/4] Network Audit..." -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $networkResult = Get-NetworkSecurityAudit
    $auditResults.Network = $networkResult
    $scores += $networkResult.Score
    Start-Sleep -Milliseconds 700
    
    # 4. Defender audit
    Write-Host ""
    Write-Host "[4/4] Windows Defender Audit..." -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $defenderResult = Get-DefenderSecurityAudit
    $auditResults.Defender = $defenderResult
    $scores += $defenderResult.Score
    
    # Calculate overall score
    $overallScore = [math]::Round(($scores | Measure-Object -Average).Average)
    $auditResults.OverallScore = $overallScore
    
    # Display results
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host "        FINAL RESULTS        " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host ""
    
    Write-Host "OVERALL SECURITY SCORE: $overallScore/100" -ForegroundColor Cyan
    Write-Host ""
    
    # Score details
    Write-Host "Details by category:" -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host "System:    $($systemResult.Score)/100" -ForegroundColor $(if($systemResult.Score -ge 80){"Green"}elseif($systemResult.Score -ge 60){"Yellow"}else{"Red"})
    Write-Host "Accounts:  $($accountResult.Score)/100" -ForegroundColor $(if($accountResult.Score -ge 80){"Green"}elseif($accountResult.Score -ge 60){"Yellow"}else{"Red"})
    Write-Host "Network:   $($networkResult.Score)/100" -ForegroundColor $(if($networkResult.Score -ge 80){"Green"}elseif($networkResult.Score -ge 60){"Yellow"}else{"Red"})
    Write-Host "Defender:  $($defenderResult.Score)/100" -ForegroundColor $(if($defenderResult.Score -ge 80){"Green"}elseif($defenderResult.Score -ge 60){"Yellow"}else{"Red"})
    
    # Evaluation
    Write-Host ""
    Write-Host "EVALUATION:" -ForegroundColor Cyan
    if ($overallScore -ge 85) {
        Write-Host "EXCELLENT - System is well secured" -ForegroundColor Green
    } elseif ($overallScore -ge 70) {
        Write-Host "GOOD - Some improvements possible" -ForegroundColor Yellow
    } elseif ($overallScore -ge 50) {
        Write-Host "FAIR - Improvements needed" -ForegroundColor Yellow
    } else {
        Write-Host "CRITICAL - Immediate action required!" -ForegroundColor Red
    }
    
    # Generate report
    $reportPath = Generate-Report -AuditResults $auditResults
    
    Write-Host ""
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host "Audit completed at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
    
    return $auditResults
}

# Generate report
function Generate-Report {
    param(
        [hashtable]$AuditResults
    )
    
    Write-Host ""
    Write-Host "Generating report..." -ForegroundColor Yellow
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportName = "security-audit-$timestamp"
    
    # 1. Text report
    $txtReport = @"
===========================================
     SECURITY AUDIT REPORT
===========================================

Date: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
System: $env:COMPUTERNAME
User: $env:USERNAME
Tool: Windows Security Audit Tool v$ScriptVersion

OVERALL SCORE: $($AuditResults.OverallScore)/100

DETAILED RESULTS:
-----------------

1. SYSTEM AUDIT: $($AuditResults.System.Score)/100
"@
    
    if ($AuditResults.System.Issues.Count -gt 0) {
        $txtReport += "   Issues detected:`n"
        foreach ($issue in $AuditResults.System.Issues) {
            $txtReport += "   - $issue`n"
        }
    } else {
        $txtReport += "   OK: No issues detected`n"
    }
    
    $txtReport += @"
2. ACCOUNTS AUDIT: $($AuditResults.Account.Score)/100
"@
    
    if ($AuditResults.Account.Issues.Count -gt 0) {
        $txtReport += "   Issues detected:`n"
        foreach ($issue in $AuditResults.Account.Issues) {
            $txtReport += "   - $issue`n"
        }
        if ($AuditResults.Account.Recommendations.Count -gt 0) {
            $txtReport += "`n   Recommendations:`n"
            foreach ($rec in $AuditResults.Account.Recommendations) {
                $txtReport += "   - $rec`n"
            }
        }
    } else {
        $txtReport += "   OK: No issues detected`n"
    }
    
    $txtReport += @"
3. NETWORK AUDIT: $($AuditResults.Network.Score)/100
"@
    
    if ($AuditResults.Network.Issues.Count -gt 0) {
        $txtReport += "   Issues detected:`n"
        foreach ($issue in $AuditResults.Network.Issues) {
            $txtReport += "   - $issue`n"
        }
    } else {
        $txtReport += "   OK: No issues detected`n"
    }
    
    $txtReport += @"
4. DEFENDER AUDIT: $($AuditResults.Defender.Score)/100
"@
    
    if ($AuditResults.Defender.Issues.Count -gt 0) {
        $txtReport += "   Issues detected:`n"
        foreach ($issue in $AuditResults.Defender.Issues) {
            $txtReport += "   - $issue`n"
        }
    } else {
        $txtReport += "   OK: No issues detected`n"
    }
    
    $txtReport += @"
RECOMMENDATIONS:
----------------
1. Update system regularly
2. Review administrator accounts
3. Close unnecessary network ports
4. Maintain antivirus updates
5. Perform regular security audits

===========================================
End of report
"@
    
    $txtPath = Join-Path $ReportsFolder "$reportName.txt"
    $txtReport | Out-File -FilePath $txtPath -Encoding UTF8
    
    # 2. HTML report (basic)
    $htmlReport = @'
<!DOCTYPE html>
<html>
<head>
    <title>Security Audit Report</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 5px; margin-bottom: 30px; }
        .score { font-size: 28px; font-weight: bold; padding: 20px; margin: 20px 0; border-radius: 5px; text-align: center; }
        .good { background: #27ae60; color: white; }
        .medium { background: #f39c12; color: white; }
        .poor { background: #e74c3c; color: white; }
        .section { background: #f8f9fa; padding: 20px; margin: 15px 0; border-left: 5px solid #3498db; }
        .issue { color: #c0392b; background: #ffeaea; padding: 5px; margin: 3px 0; border-radius: 3px; }
        .ok { color: #27ae60; }
        .footer { margin-top: 40px; font-size: 12px; color: #7f8c8d; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #2c3e50; color: white; }
        tr:hover { background: #f5f5f5; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Security Audit Report</h1>
            <p>Date: __DATE__</p>
            <p>System: __COMPUTERNAME__ | User: __USERNAME__</p>
        </div>
        
        <div class="score __SCORECLASS__">
            Overall Score: __OVERALLSCORE__/100
        </div>
        
        <h2>Audit Summary</h2>
        <table>
            <tr>
                <th>Category</th>
                <th>Score</th>
                <th>Status</th>
            </tr>
            <tr>
                <td>System</td>
                <td>__SYSTEMSCORE__/100</td>
                <td class="__SYSTEMCLASS__">__SYSTEMSTATUS__</td>
            </tr>
            <tr>
                <td>Accounts</td>
                <td>__ACCOUNTSCORE__/100</td>
                <td class="__ACCOUNTCLASS__">__ACCOUNTSTATUS__</td>
            </tr>
            <tr>
                <td>Network</td>
                <td>__NETWORKSCORE__/100</td>
                <td class="__NETWORKCLASS__">__NETWORKSTATUS__</td>
            </tr>
            <tr>
                <td>Defender</td>
                <td>__DEFENDERSCORE__/100</td>
                <td class="__DEFENDERCLASS__">__DEFENDERSTATUS__</td>
            </tr>
        </table>
        
        <div class="footer">
            <p>Report generated by Windows Security Audit Tool v__VERSION__</p>
            <p>Author: Ayoub Aguezar | Year: __YEAR__</p>
        </div>
    </div>
</body>
</html>
'@
    
    # Replace variables in HTML template
    $htmlReport = $htmlReport -replace "__DATE__", (Get-Date -Format "dd/MM/yyyy HH:mm:ss")
    $htmlReport = $htmlReport -replace "__COMPUTERNAME__", $env:COMPUTERNAME
    $htmlReport = $htmlReport -replace "__USERNAME__", $env:USERNAME
    $htmlReport = $htmlReport -replace "__OVERALLSCORE__", $AuditResults.OverallScore
    $htmlReport = $htmlReport -replace "__SYSTEMSCORE__", $AuditResults.System.Score
    $htmlReport = $htmlReport -replace "__ACCOUNTSCORE__", $AuditResults.Account.Score
    $htmlReport = $htmlReport -replace "__NETWORKSCORE__", $AuditResults.Network.Score
    $htmlReport = $htmlReport -replace "__DEFENDERSCORE__", $AuditResults.Defender.Score
    $htmlReport = $htmlReport -replace "__VERSION__", $ScriptVersion
    $htmlReport = $htmlReport -replace "__YEAR__", (Get-Date -Format "yyyy")
    
    # Determine CSS classes for scores
    $overallClass = if ($AuditResults.OverallScore -ge 85) { "good" } elseif ($AuditResults.OverallScore -ge 70) { "medium" } else { "poor" }
    $systemClass = if ($AuditResults.System.Score -ge 80) { "ok" } else { "" }
    $accountClass = if ($AuditResults.Account.Score -ge 80) { "ok" } else { "" }
    $networkClass = if ($AuditResults.Network.Score -ge 80) { "ok" } else { "" }
    $defenderClass = if ($AuditResults.Defender.Score -ge 80) { "ok" } else { "" }
    
    $systemStatus = if ($AuditResults.System.Score -ge 80) { "OK" } else { "Needs improvement" }
    $accountStatus = if ($AuditResults.Account.Score -ge 80) { "OK" } else { "Needs improvement" }
    $networkStatus = if ($AuditResults.Network.Score -ge 80) { "OK" } else { "Needs improvement" }
    $defenderStatus = if ($AuditResults.Defender.Score -ge 80) { "OK" } else { "Needs improvement" }
    
    $htmlReport = $htmlReport -replace "__SCORECLASS__", $overallClass
    $htmlReport = $htmlReport -replace "__SYSTEMCLASS__", $systemClass
    $htmlReport = $htmlReport -replace "__ACCOUNTCLASS__", $accountClass
    $htmlReport = $htmlReport -replace "__NETWORKCLASS__", $networkClass
    $htmlReport = $htmlReport -replace "__DEFENDERCLASS__", $defenderClass
    $htmlReport = $htmlReport -replace "__SYSTEMSTATUS__", $systemStatus
    $htmlReport = $htmlReport -replace "__ACCOUNTSTATUS__", $accountStatus
    $htmlReport = $htmlReport -replace "__NETWORKSTATUS__", $networkStatus
    $htmlReport = $htmlReport -replace "__DEFENDERSTATUS__", $defenderStatus
    
    $htmlPath = Join-Path $ReportsFolder "$reportName.html"
    $htmlReport | Out-File -FilePath $htmlPath -Encoding UTF8
    
    Write-Host "  OK: Text report: $txtPath" -ForegroundColor Green
    Write-Host "  OK: HTML report: $htmlPath" -ForegroundColor Green
    
    return @{
        TextReport = $txtPath
        HtmlReport = $htmlPath
    }
}

# View existing reports
function Show-ExistingReports {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host "        AVAILABLE REPORTS        " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host ""
    
    if (Test-Path $ReportsFolder) {
        $reports = Get-ChildItem -Path $ReportsFolder -Filter "*.txt" | Sort-Object LastWriteTime -Descending
        
        if ($reports.Count -gt 0) {
            Write-Host "Recent reports:" -ForegroundColor Cyan
            Write-Host ""
            
            $i = 1
            foreach ($report in $reports | Select-Object -First 10) {
                $age = (Get-Date) - $report.LastWriteTime
                $ageText = if ($age.Days -gt 0) { "$($age.Days) days" } 
                          elseif ($age.Hours -gt 0) { "$($age.Hours) hours" } 
                          else { "$($age.Minutes) minutes" }
                
                Write-Host "  $i. $($report.Name) ($ageText ago)" -ForegroundColor Gray
                $i++
            }
            
            Write-Host ""
            Write-Host "Open a report? (number or N): " -NoNewline -ForegroundColor Yellow
            $choice = Read-Host
            
            if ($choice -match '^\d+$' -and [int]$choice -le $reports.Count) {
                $selectedReport = $reports[[int]$choice - 1]
                Write-Host ""
                Write-Host "Opening report: $($selectedReport.Name)" -ForegroundColor Green
                Get-Content $selectedReport.FullName | Out-Host
            }
        } else {
            Write-Host ""
            Write-Host "No reports available." -ForegroundColor Yellow
            Write-Host "Run an audit first to generate reports." -ForegroundColor Gray
        }
    } else {
        Write-Host ""
        Write-Host "Reports folder not found." -ForegroundColor Yellow
    }
}

# Show help
function Show-HelpInformation {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host "        HELP AND INFORMATION        " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================================" -ForegroundColor Blue
    Write-Host ""
    
    Write-Host "DESCRIPTION:" -ForegroundColor Gray
    Write-Host "------------" -ForegroundColor Gray
    Write-Host "Windows Security Audit Tool is a comprehensive security" -ForegroundColor Gray
    Write-Host "assessment tool for Windows 10/11 systems." -ForegroundColor Gray
    Write-Host "Developed by Ayoub Aguezar for security portfolio." -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "FEATURES:" -ForegroundColor Gray
    Write-Host "--------" -ForegroundColor Gray
    Write-Host "- Complete system audit (OS, updates, configuration)" -ForegroundColor Gray
    Write-Host "- User accounts and privileges analysis" -ForegroundColor Gray
    Write-Host "- Network configuration verification" -ForegroundColor Gray
    Write-Host "- Windows Defender security check" -ForegroundColor Gray
    Write-Host "- Detailed report generation (TXT and HTML)" -ForegroundColor Gray
    Write-Host "- Automated security scoring" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "RECOMMENDED USAGE:" -ForegroundColor Gray
    Write-Host "-----------------" -ForegroundColor Gray
    Write-Host "1. Run complete audit (option 1) for detailed analysis" -ForegroundColor Gray
    Write-Host "2. Check generated reports in 'reports\' folder" -ForegroundColor Gray
    Write-Host "3. Follow recommendations to improve security" -ForegroundColor Gray
    Write-Host "4. Re-run audit after implementing fixes" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "TIPS:" -ForegroundColor Gray
    Write-Host "----" -ForegroundColor Gray
    Write-Host "- Run script as administrator for full details" -ForegroundColor Gray
    Write-Host "- Save reports for tracking progress" -ForegroundColor Gray
    Write-Host "- Document corrective actions taken" -ForegroundColor Gray
    Write-Host "- Perform regular audits (monthly recommended)" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "CONTACT:" -ForegroundColor Gray
    Write-Host "-------" -ForegroundColor Gray
    Write-Host "Author: Ayoub Aguezar" -ForegroundColor Gray
    Write-Host "Project: Security Engineering Portfolio" -ForegroundColor Gray
    Write-Host ""
}

# ============================================
# MAIN PROGRAM
# ============================================

# Initialization
Show-Banner
Initialize-Folders

# Load modules
$loadedModules = Load-SecurityModules

if ($loadedModules.Count -eq 0) {
    Write-Host ""
    Write-Host "ERROR: No modules loaded successfully." -ForegroundColor Red
    Write-Host "Check files in 'modules\' folder." -ForegroundColor Yellow
    Write-Host "Press Enter to exit..." -ForegroundColor Gray
    Read-Host
    exit 1
}

# Main loop
do {
    Show-MainMenu
    $choice = Read-Host
    
    Clear-Host
    Show-Banner
    
    switch ($choice) {
        '1' {
            # Complete audit
            if ($loadedModules.Count -ge 2) {
                Write-Host ""
                Write-Host "Loading modules..." -ForegroundColor Yellow
                
                # Reload modules to be sure
                . ".\modules\SystemAudit.ps1"
                . ".\modules\AccountAudit.ps1"
                . ".\modules\NetworkAudit.ps1"
                . ".\modules\DefenderAudit.ps1"
                
                $auditResults = Invoke-CompleteSecurityAudit
                
                Write-Host ""
                Write-Host "Press Enter to return to menu..." -ForegroundColor Gray
                Read-Host
            } else {
                Write-Host ""
                Write-Host "ERROR: Insufficient modules for complete audit!" -ForegroundColor Red
                Write-Host "Loaded: $($loadedModules -join ', ')" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "Press Enter to continue..." -ForegroundColor Gray
                Read-Host
            }
        }
        '2' {
            # System audit only
            if ("System" -in $loadedModules) {
                Write-Host ""
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host "        SYSTEM AUDIT        " -ForegroundColor White -BackgroundColor DarkBlue
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host ""
                
                . ".\modules\SystemAudit.ps1"
                Get-SystemInformation
            } else {
                Write-Host ""
                Write-Host "ERROR: System module not available!" -ForegroundColor Red
            }
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '3' {
            # Accounts audit only
            if ("Accounts" -in $loadedModules) {
                Write-Host ""
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host "        ACCOUNTS AUDIT        " -ForegroundColor White -BackgroundColor DarkBlue
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host ""
                
                . ".\modules\AccountAudit.ps1"
                Get-AccountSecurityAudit
            } else {
                Write-Host ""
                Write-Host "ERROR: Accounts module not available!" -ForegroundColor Red
            }
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '4' {
            # Network audit only
            if ("Network" -in $loadedModules) {
                Write-Host ""
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host "        NETWORK AUDIT        " -ForegroundColor White -BackgroundColor DarkBlue
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host ""
                
                . ".\modules\NetworkAudit.ps1"
                Get-NetworkSecurityAudit
            } else {
                Write-Host ""
                Write-Host "ERROR: Network module not available!" -ForegroundColor Red
            }
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '5' {
            # Defender audit only
            if ("Defender" -in $loadedModules) {
                Write-Host ""
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host "        DEFENDER AUDIT       " -ForegroundColor White -BackgroundColor DarkBlue
                Write-Host "========================================================" -ForegroundColor Blue
                Write-Host ""
                
                . ".\modules\DefenderAudit.ps1"
                Get-DefenderSecurityAudit
            } else {
                Write-Host ""
                Write-Host "ERROR: Defender module not available!" -ForegroundColor Red
            }
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '6' {
            # Generate HTML report (demo)
            Write-Host ""
            Write-Host "========================================================" -ForegroundColor Blue
            Write-Host "        REPORT GENERATION       " -ForegroundColor White -BackgroundColor DarkBlue
            Write-Host "========================================================" -ForegroundColor Blue
            Write-Host ""
            
            Write-Host ""
            Write-Host "This feature is included in complete audit." -ForegroundColor Yellow
            Write-Host "Run complete audit first (option 1)." -ForegroundColor Gray
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '7' {
            # View existing reports
            Show-ExistingReports
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '8' {
            # Help
            Show-HelpInformation
            Write-Host ""
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
        '9' {
            # Exit
            Write-Host ""
            Write-Host "========================================================" -ForegroundColor Blue
            Write-Host "        THANK YOU AND GOODBYE !        " -ForegroundColor White -BackgroundColor DarkBlue
            Write-Host "========================================================" -ForegroundColor Blue
            Write-Host ""
            
            Write-Host "Thank you for using Windows Security Audit Tool v$ScriptVersion" -ForegroundColor Cyan
            Write-Host "Author: Ayoub Aguezar" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "For your security portfolio:" -ForegroundColor Cyan
            Write-Host "- Keep generated reports" -ForegroundColor Gray
            Write-Host "- Document your methodology" -ForegroundColor Gray
            Write-Host "- Showcase PowerShell skills" -ForegroundColor Gray
            Write-Host "- Demonstrate audit methodology" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Your reports are in: $ReportsFolder" -ForegroundColor Green
            Write-Host ""
        }
        default {
            Write-Host "ERROR: Invalid choice! Please select option 1-9." -ForegroundColor Red
            Write-Host "Press Enter to continue..." -ForegroundColor Gray
            Read-Host
        }
    }
    
    Clear-Host
    Show-Banner
    
} while ($choice -ne '9')

Write-Host ""
Write-Host "Program ended. Goodbye!" -ForegroundColor Green