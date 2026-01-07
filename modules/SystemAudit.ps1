function Get-SystemInformation {
    Write-Host "`n=== AUDIT SYSTÈME ===" -ForegroundColor Cyan
    
    $systemInfo = @{}
    
    # 1. Get OS Information
    Write-Host "  [1/5] Informations OS..." -ForegroundColor Yellow
    $os = Get-CimInstance Win32_OperatingSystem
    $systemInfo.OSName = $os.Caption
    $systemInfo.OSVersion = $os.Version
    $systemInfo.BuildNumber = $os.BuildNumber
    
    Write-Host "    - OS: $($systemInfo.OSName)" -ForegroundColor Green
    Write-Host "    - Version: $($systemInfo.OSVersion)" -ForegroundColor Green
    Write-Host "    - Build: $($systemInfo.BuildNumber)" -ForegroundColor Green
    
    # 2. Check last updates
    Write-Host "  [2/5] Vérification des mises à jour..." -ForegroundColor Yellow
    $hotfixes = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 5
    if ($hotfixes) {
        Write-Host "    - Dernière mise à jour: $($hotfixes[0].InstalledOn)" -ForegroundColor Green
        $systemInfo.LatestUpdate = $hotfixes[0].InstalledOn
    } else {
        Write-Host "    - Aucune mise à jour trouvée!" -ForegroundColor Red
    }
    
    # 3. Get hardware info
    Write-Host "  [3/5] Informations matériel..." -ForegroundColor Yellow
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $systemInfo.Manufacturer = $computerSystem.Manufacturer
    $systemInfo.Model = $computerSystem.Model
    $systemInfo.TotalMemoryGB = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    
    Write-Host "    - Fabricant: $($systemInfo.Manufacturer)" -ForegroundColor Green
    Write-Host "    - Modèle: $($systemInfo.Model)" -ForegroundColor Green
    Write-Host "    - Mémoire: $($systemInfo.TotalMemoryGB) GB" -ForegroundColor Green
    
    # 4. Check if running as Administrator
    Write-Host "  [4/5] Vérification des privilèges..." -ForegroundColor Yellow
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $systemInfo.IsAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    Write-Host "    - Exécution en admin: $($systemInfo.IsAdmin)" -ForegroundColor Green
    
    # 5. Get system uptime
    Write-Host "  [5/5] Temps de fonctionnement..." -ForegroundColor Yellow
    $lastBoot = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBoot
    $systemInfo.UptimeDays = [math]::Round($uptime.TotalDays, 2)
    
    Write-Host "    - Uptime: $($systemInfo.UptimeDays) jours" -ForegroundColor Green
    
    # Security assessment
    Write-Host "`n=== ÉVALUATION SÉCURITÉ ===" -ForegroundColor Cyan
    
    $issues = @()
    $score = 100
    
    # Check 1: OS build age
    if ($systemInfo.BuildNumber -lt 19041) {
        $issues += "Version OS obsolète"
        $score -= 20
        Write-Host "  [ATTENTION] Version OS ancienne" -ForegroundColor Red
    } else {
        Write-Host "  [OK] Version OS récente" -ForegroundColor Green
    }
    
    # Check 2: Update freshness
    if ($systemInfo.LatestUpdate) {
        $daysSinceUpdate = (New-TimeSpan -Start $systemInfo.LatestUpdate -End (Get-Date)).Days
        if ($daysSinceUpdate -gt 30) {
            $issues += "Mises à jour anciennes ($daysSinceUpdate jours)"
            $score -= 15
            Write-Host "  [ATTENTION] Mises à jour vieilles de $daysSinceUpdate jours" -ForegroundColor Red
        } else {
            Write-Host "  [OK] Mises à jour récentes" -ForegroundColor Green
        }
    }
    
    # Check 3: Admin privileges for script
    if (-not $systemInfo.IsAdmin) {
        $issues += "Script non exécuté en admin"
        $score -= 10
        Write-Host "  [INFO] Relancer en admin pour plus de vérifications" -ForegroundColor Yellow
    }
    
    $systemInfo.SecurityScore = $score
    $systemInfo.Issues = $issues
    
    Write-Host "`n  Score sécurité système: $score/100" -ForegroundColor Cyan
    
    if ($issues.Count -gt 0) {
        Write-Host "  Problèmes détectés:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "    • $issue" -ForegroundColor Yellow
        }
    }
    
    return $systemInfo
}
