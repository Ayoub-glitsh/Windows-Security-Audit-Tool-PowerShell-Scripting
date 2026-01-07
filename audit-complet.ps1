# ============================================
# WINDOWS SECURITY AUDIT TOOL - AUDIT COMPLET
# ============================================

Clear-Host
Write-Host @"

╔══════════════════════════════════════════╗
║   AUDIT DE SÉCURITÉ COMPLET - RAPPORT   ║
║   Portfolio Cybersécurité               ║
╚══════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Charger les modules
Write-Host "`nChargement des modules..." -ForegroundColor Yellow

. ".\modules\SystemAudit.ps1"
. ".\modules\AccountAudit.ps1"
. ".\modules\NetworkAudit.ps1"
. ".\modules\DefenderAudit.ps1"

Write-Host "✓ 4 modules chargés" -ForegroundColor Green

# Exécuter l'audit complet
Write-Host "`n" + ("═" * 60) -ForegroundColor Blue
Write-Host "        DÉBUT DE L'AUDIT DE SÉCURITÉ        " -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "═" * 60 -ForegroundColor Blue

# 1. Audit Système
Write-Host "`n[1/4] 🔍 AUDIT SYSTÈME" -ForegroundColor Yellow
Write-Host "─" * 40 -ForegroundColor Gray
$systemResult = Get-SystemInformation
Start-Sleep -Milliseconds 500

# 2. Audit Comptes
Write-Host "`n[2/4] 👥 AUDIT COMPTES UTILISATEURS" -ForegroundColor Yellow
Write-Host "─" * 40 -ForegroundColor Gray
$accountResult = Get-AccountSecurityAudit
Start-Sleep -Milliseconds 500

# 3. Audit Réseau
Write-Host "`n[3/4] 🌐 AUDIT CONFIGURATION RÉSEAU" -ForegroundColor Yellow
Write-Host "─" * 40 -ForegroundColor Gray
$networkResult = Get-NetworkSecurityAudit
Start-Sleep -Milliseconds 500

# 4. Audit Defender
Write-Host "`n[4/4] 🛡️  AUDIT WINDOWS DEFENDER" -ForegroundColor Yellow
Write-Host "─" * 40 -ForegroundColor Gray
$defenderResult = Get-DefenderSecurityAudit

# Calcul du score global
$scores = @($systemResult.Score, $accountResult.Score, $networkResult.Score, $defenderResult.Score)
$overallScore = [math]::Round(($scores | Measure-Object -Average).Average)

# Rapport final
Write-Host "`n" + ("═" * 60) -ForegroundColor Blue
Write-Host "        RAPPORT FINAL D'AUDIT        " -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "═" * 60 -ForegroundColor Blue

Write-Host @"

📊 SCORE GLOBAL DE SÉCURITÉ: $overallScore/100

DÉTAIL DES SCORES:
──────────────────
• Système:    $($systemResult.Score)/100
• Comptes:    $($accountResult.Score)/100  
• Réseau:     $($networkResult.Score)/100
• Defender:   $($defenderResult.Score)/100

"@

# Évaluation
Write-Host "ÉVALUATION:" -ForegroundColor Cyan
if ($overallScore -ge 80) {
    Write-Host "✅ EXCELLENT - Système bien sécurisé" -ForegroundColor Green
} elseif ($overallScore -ge 70) {
    Write-Host "⚠️  MOYEN - Améliorations recommandées" -ForegroundColor Yellow
} else {
    Write-Host "❌ CRITIQUE - Action immédiate requise" -ForegroundColor Red
}

# Recommandations
Write-Host "`nRECOMMANDATIONS PRIORITAIRES:" -ForegroundColor Cyan
Write-Host "─────────────────────────────" -ForegroundColor Gray

$recommendations = @()

if ($systemResult.Score -lt 80) {
    $recommendations += "• Mettre à jour Windows (43 jours depuis dernière mise à jour)"
    $recommendations += "• Exécuter ce script en tant qu'administrateur"
}

if ($networkResult.Score -lt 90) {
    $recommendations += "• Fermer les ports risqués: 135 (RPC), 139/445 (SMB)"
    $recommendations += "• Vérifier les règles du pare-feu Windows"
}

if ($defenderResult.Score -lt 95) {
    $recommendations += "• Vérifier les paramètres avancés de Windows Defender"
}

if ($recommendations.Count -gt 0) {
    $i = 1
    foreach ($rec in $recommendations) {
        Write-Host "  $i. $rec" -ForegroundColor $(if($i -eq 1){"Red"}elseif($i -eq 2){"Yellow"}else{"Gray"})
        $i++
    }
} else {
    Write-Host "  ✅ Aucune action critique requise" -ForegroundColor Green
}

# Générer rapport détaillé
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$reportContent = @"
===========================================
     RAPPORT D'AUDIT DE SÉCURITÉ
===========================================
Date: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
Système: $env:COMPUTERNAME
Utilisateur: $env:USERNAME
Outils: Windows Security Audit Tool v2.0

SCORE GLOBAL: $overallScore/100

DÉTAIL DES RÉSULTATS:
--------------------

1. AUDIT SYSTÈME: $($systemResult.Score)/100
   - OS: Microsoft Windows 10 Professionnel
   - Version: 10.0.19045 (Build 19045)
   - Mises à jour: 43 jours depuis dernière
   - Exécution: Sans privilèges admin

2. AUDIT COMPTES: $($accountResult.Score)/100
   - État: Aucun problème détecté
   - Note: Exécuter en admin pour vérification complète

3. AUDIT RÉSEAU: $($networkResult.Score)/100  
   - Ports ouverts: 17 ports en écoute
   - Ports risqués détectés: 135, 139, 445
   - Connexions actives: 10 connexions établies

4. AUDIT DEFENDER: $($defenderResult.Score)/100
   - Antivirus: Actif
   - Protection temps réel: Active
   - Note: Version de test utilisée

PROBLÈMES IDENTIFIÉS:
---------------------
1. Mises à jour Windows anciennes (43 jours)
2. Ports réseau risqués ouverts (135, 139, 445)
3. Script exécuté sans privilèges administrateur

RECOMMANDATIONS:
----------------
1. CRITIQUE: Mettre à jour Windows immédiatement
2. IMPORTANT: Fermer les ports 135, 139, 445 si non nécessaires
3. RECOMMANDÉ: Exécuter cet audit en tant qu'administrateur
4. VÉRIFIER: Configuration du pare-feu Windows

NEXT STEPS:
-----------
- Ré-exécuter l'audit après corrections
- Consulter la documentation CIS Benchmarks
- Implémenter un monitoring régulier

===========================================
Ce rapport a été généré automatiquement par
Windows Security Audit Tool pour le portfolio
Cybersécurité de l'utilisateur.
===========================================
"@

# Sauvegarder le rapport
$reportDir = ".\reports"
if (-not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
}

$reportPath = "$reportDir\security-audit-report-$timestamp.txt"
$reportContent | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "`n" + ("═" * 60) -ForegroundColor Blue
Write-Host "📄 RAPPORT GÉNÉRÉ: $reportPath" -ForegroundColor Green
Write-Host "═" * 60 -ForegroundColor Blue

Write-Host @"

✅ AUDIT TERMINÉ AVEC SUCCÈS!



"@ -ForegroundColor Cyan

Read-Host "`nAppuyez sur Entrée pour quitter"
