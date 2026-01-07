function Get-NetworkSecurityAudit {
    Write-Host "`n=== AUDIT RÉSEAU ===" -ForegroundColor Cyan
    
    $networkFindings = @{
        Issues = @()
        Recommendations = @()
        Score = 100
    }
    
    # 1. Check listening ports
    Write-Host "1. Vérification des ports en écoute..." -ForegroundColor Yellow
    
    try {
        $listeningPorts = Get-NetTCPConnection -State Listen -ErrorAction Stop | 
                         Select-Object LocalPort, OwningProcess | 
                         Sort-Object LocalPort -Unique
        
        $portCount = ($listeningPorts | Measure-Object).Count
        Write-Host "   [INFO] $portCount ports en écoute" -ForegroundColor Green
        
        # Check for risky ports
        $riskyPorts = @(21, 23, 135, 139, 445, 3389)
        $foundRisky = @()
        
        foreach ($port in $listeningPorts) {
            if ($riskyPorts -contains $port.LocalPort) {
                $foundRisky += $port.LocalPort
            }
        }
        
        if ($foundRisky.Count -gt 0) {
            $portList = $foundRisky -join ", "
            $networkFindings.Issues += "Ports risqués ouverts: $portList"
            $networkFindings.Recommendations += "Revoir la nécessité des ports: $portList"
            $networkFindings.Score -= ($foundRisky.Count * 5)
            Write-Host "   [ATTENTION] Ports risqués ouverts: $portList" -ForegroundColor Red
        } else {
            Write-Host "   [OK] Aucun port risqué critique détecté" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "   [INFO] Impossible de récupérer les ports en écoute" -ForegroundColor Yellow
    }
    
    # 2. Check active connections
    Write-Host "`n2. Vérification des connexions actives..." -ForegroundColor Yellow
    
    try {
        $connections = Get-NetTCPConnection -State Established -ErrorAction Stop | 
                      Select-Object -First 10
        
        $connCount = ($connections | Measure-Object).Count
        Write-Host "   [INFO] $connCount connexions établies" -ForegroundColor Green
        
        if ($connCount -gt 0) {
            Write-Host "`n   Connexions récentes:" -ForegroundColor Gray
            $connections | ForEach-Object {
                $localAddress = $_.LocalAddress + ":" + $_.LocalPort
                $remoteAddress = $_.RemoteAddress + ":" + $_.RemotePort
                Write-Host "     $localAddress -> $remoteAddress" -ForegroundColor Gray
            }
        }
    } catch {
        Write-Host "   [INFO] Impossible de récupérer les connexions actives" -ForegroundColor Yellow
    }
    
    # 3. Check network adapters
    Write-Host "`n3. Vérification des adaptateurs réseau..." -ForegroundColor Yellow
    
    try {
        $adapters = Get-NetAdapter -Physical -ErrorAction Stop | Where-Object {$_.Status -eq "Up"}
        
        Write-Host "   [INFO] $($adapters.Count) adaptateurs réseau actifs" -ForegroundColor Green
        
        foreach ($adapter in $adapters) {
            Write-Host "     $($adapter.Name): $($adapter.InterfaceDescription)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   [INFO] Impossible de récupérer les adaptateurs réseau" -ForegroundColor Yellow
    }
    
    # Display summary
    Write-Host "`n=== RÉSUMÉ RÉSEAU ===" -ForegroundColor Cyan
    Write-Host "  Score sécurité réseau: $($networkFindings.Score)/100" -ForegroundColor Cyan
    
    if ($networkFindings.Issues.Count -gt 0) {
        Write-Host "`n  Problèmes détectés:" -ForegroundColor Red
        foreach ($issue in $networkFindings.Issues) {
            Write-Host "    • $issue" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [OK] Aucun problème réseau critique détecté" -ForegroundColor Green
    }
    
    return $networkFindings
}
