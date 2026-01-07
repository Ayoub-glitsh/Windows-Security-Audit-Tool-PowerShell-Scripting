function Get-AccountSecurityAudit {
    Write-Host "`n=== AUDIT DES COMPTES ===" -ForegroundColor Cyan
    
    $accountFindings = @{
        Issues = @()
        Recommendations = @()
        Score = 100
    }
    
    Write-Host "1. Vérification des administrateurs locaux..." -ForegroundColor Yellow
    
    try {
        $adminGroup = Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop
        $adminCount = ($adminGroup | Measure-Object).Count
        
        Write-Host "   [INFO] $adminCount administrateur(s) trouvé(s)" -ForegroundColor Green
        
        if ($adminCount -gt 3) {
            $accountFindings.Issues += "Trop d'administrateurs ($adminCount comptes)"
            $accountFindings.Recommendations += "Réduire à 2-3 administrateurs maximum"
            $accountFindings.Score -= 20
            Write-Host "   [ATTENTION] Trop de comptes admin!" -ForegroundColor Red
        } else {
            Write-Host "   [OK] Nombre d'admins approprié" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "   [INFO] Impossible de récupérer les administrateurs (droits admin requis)" -ForegroundColor Yellow
    }
    
    Write-Host "`n2. Vérification du compte Administrateur intégré..." -ForegroundColor Yellow
    
    try {
        $builtInAdmin = Get-LocalUser -Name "Administrator" -ErrorAction Stop
        if ($builtInAdmin.Enabled -eq $true) {
            $accountFindings.Issues += "Compte Administrateur intégré activé"
            $accountFindings.Recommendations += "Désactiver le compte Administrateur intégré"
            $accountFindings.Score -= 30
            Write-Host "   [CRITIQUE] COMPTE ADMINISTRATEUR ACTIVÉ!" -ForegroundColor Red
        } else {
            Write-Host "   [OK] Compte Administrateur désactivé" -ForegroundColor Green
        }
    } catch {
        Write-Host "   [INFO] Impossible de vérifier le compte Administrateur" -ForegroundColor Yellow
    }
    
    Write-Host "`n3. Vérification du compte Invité..." -ForegroundColor Yellow
    
    try {
        $guestAccount = Get-LocalUser -Name "Guest" -ErrorAction Stop
        if ($guestAccount.Enabled -eq $true) {
            $accountFindings.Issues += "Compte Invité activé"
            $accountFindings.Recommendations += "Désactiver immédiatement le compte Invité"
            $accountFindings.Score -= 25
            Write-Host "   [CRITIQUE] COMPTE INVITÉ ACTIVÉ!" -ForegroundColor Red
        } else {
            Write-Host "   [OK] Compte Invité désactivé" -ForegroundColor Green
        }
    } catch {
        Write-Host "   [INFO] Impossible de vérifier le compte Invité" -ForegroundColor Yellow
    }
    
    Write-Host "`n4. Vérification des politiques de mot de passe..." -ForegroundColor Yellow
    
    try {
        $users = Get-LocalUser | Where-Object {$_.Enabled -eq $true}
        $neverExpireCount = ($users | Where-Object {$_.PasswordNeverExpires -eq $true} | Measure-Object).Count
        
        if ($neverExpireCount -gt 0) {
            $accountFindings.Issues += "$neverExpireCount comptes avec mots de passe sans expiration"
            $accountFindings.Recommendations += "Activer l'expiration des mots de passe"
            $accountFindings.Score -= 15
            Write-Host "   [ATTENTION] $neverExpireCount comptes sans expiration de mot de passe" -ForegroundColor Red
        } else {
            Write-Host "   [OK] Tous les comptes ont l'expiration activée" -ForegroundColor Green
        }
    } catch {
        Write-Host "   [INFO] Impossible de vérifier les politiques de mot de passe" -ForegroundColor Yellow
    }
    
    # Display summary
    Write-Host "`n=== RÉSUMÉ COMPTES ===" -ForegroundColor Cyan
    Write-Host "  Score sécurité comptes: $($accountFindings.Score)/100" -ForegroundColor Cyan
    
    if ($accountFindings.Issues.Count -gt 0) {
        Write-Host "`n  Problèmes détectés:" -ForegroundColor Red
        foreach ($issue in $accountFindings.Issues) {
            Write-Host "    • $issue" -ForegroundColor Yellow
        }
        
        Write-Host "`n  Recommandations:" -ForegroundColor Green
        foreach ($rec in $accountFindings.Recommendations) {
            Write-Host "    • $rec" -ForegroundColor Green
        }
    } else {
        Write-Host "  [OK] Aucun problème de sécurité comptes détecté" -ForegroundColor Green
    }
    
    return $accountFindings
}
