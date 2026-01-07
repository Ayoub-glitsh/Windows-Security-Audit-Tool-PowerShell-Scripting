function Get-DefenderSecurityAudit {
    Write-Host "`n=== AUDIT WINDOWS DEFENDER ===" -ForegroundColor Cyan
    
    $result = @{
        Score = 90
        Issues = @("Version de test - vérifications limitées")
        Recommendations = @("Exécuter en admin pour plus de détails")
        IsAvailable = $true
    }
    
    Write-Host "1. Vérification de base..." -ForegroundColor Yellow
    
    try {
        $defender = Get-MpComputerStatus -ErrorAction Stop
        Write-Host "   [OK] Windows Defender disponible" -ForegroundColor Green
        
        if ($defender.AntivirusEnabled) {
            Write-Host "   [OK] Antivirus: ACTIF" -ForegroundColor Green
        } else {
            Write-Host "   [CRITIQUE] Antivirus: INACTIF" -ForegroundColor Red
            $result.Issues += "Antivirus désactivé"
            $result.Score = 40
        }
        
        if ($defender.RealTimeProtectionEnabled) {
            Write-Host "   [OK] Protection temps réel: ACTIVE" -ForegroundColor Green
        } else {
            Write-Host "   [CRITIQUE] Protection temps réel: INACTIVE" -ForegroundColor Red
            $result.Issues += "Protection temps réel désactivée"
            if ($result.Score -gt 40) { $result.Score = 40 }
        }
        
    } catch {
        Write-Host "   [INFO] Windows Defender non accessible" -ForegroundColor Yellow
        Write-Host "   Cause: $_" -ForegroundColor Gray
        $result.IsAvailable = $false
        $result.Score = 10
        $result.Issues += "Defender non accessible"
    }
    
    Write-Host "`n=== RÉSULTATS ===" -ForegroundColor Cyan
    Write-Host "Score Defender: $($result.Score)/100" -ForegroundColor Yellow
    
    if ($result.Issues.Count -gt 0) {
        Write-Host "Problèmes:" -ForegroundColor Red
        foreach ($issue in $result.Issues) {
            Write-Host "  • $issue" -ForegroundColor Yellow
        }
    }
    
    return $result
}
