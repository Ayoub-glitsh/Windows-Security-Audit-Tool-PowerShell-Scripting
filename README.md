

# 🛡️ Windows Security Audit Tool

  

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://docs.microsoft.com/powershell/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Windows](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)
[![Version](https://img.shields.io/badge/Version-3.0-orange.svg)]()

  

**Outil professionnel d'audit de sécurité Windows**  

*Développé par Ayoub Aguezar*

  

## 📋 Table des Matières

- [✨ Fonctionnalités](#-fonctionnalités)
- [🖥️ Prérequis](#️-prérequis)
- [🚀 Installation Rapide](#-installation-rapide)
- [📁 Structure du Projet](#-structure-du-projet)
- [🎯 Utilisation](#-utilisation)
- [🔍 Détails des Modules](#-détails-des-modules)
- [📊 Format des Résultats](#-format-des-résultats)
- [🔧 Personnalisation](#-personnalisation)
- [🤝 Contribution](#-contribution)
- [📄 Licence](#-licence)
- [👤 Auteur](#-auteur)

  

## ✨ Fonctionnalités

  

### 🔍 **Audit Complet Multi-couches**

- **Système** : OS, mises à jour, matériel, uptime
- **Comptes** : Administrateurs, invité, politiques mot de passe
- **Réseau** : Ports ouverts, connexions, adaptateurs
- **Défense** : Windows Defender, protection temps réel

  

### ⚡ **Scoring Automatisé**

- Score par catégorie (0-100)
- Score global calculé automatiquement
- Détection des problèmes critiques
- Recommandations spécifiques

  

### 📄 **Génération de Rapports**

- Format console détaillé avec couleurs
- Rapports texte structurés
- Rapports HTML avec design professionnel
- Historique avec timestamps

  

### 🎨 **Interface Avancée**

- Deux modes : Menu interactif (`main-audit.ps1`) ou audit direct (`audit-complet.ps1`)
- Indicateurs visuels (✅ ⚠️ ❌)
- Code couleur pour sévérité
- Pauses visuelles pour lisibilité

  

## 🖥️ Prérequis

| Composant         | Version minimale      | Version recommandée                |
|-------------------|-----------------------|------------------------------------|
| **Système**       | Windows 10 / 11       | Windows 10 (build 19041+)          |
| **PowerShell**    | 5.1                   | PowerShell 5.1 ou supérieur        |
| **Permissions**   | Utilisateur standard  | **Administrateur** (audit complet) |
| **Espace disque** | 10 Mo                 | 100 Mo (rapports et logs)          |


  

## 🚀 Installation Rapide

  

### Méthode 1 : Menu Interactif (Recommandé)

```powershell
# 1. Démarrer PowerShell en tant qu'administrateur
# Clic droit → Exécuter en tant qu'administrateur

# 2. Autoriser l'exécution des scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Lancer l'outil avec menu complet
.main-audit.ps1
```

  

### Méthode 2 : Audit Direct

```powershell
# Pour un audit rapide sans navigation
.audit-complet.ps1
```

  

### Méthode 3 : Audit Spécifique

```powershell
# Charger et exécuter un module spécifique
. .modulesSystemAudit.ps1
Get-SystemInformation
```

  

##  Structure du Projet

```
Windows-Security-Audit-Tool/
├──  main-audit.ps1              # Script principal avec menu interactif (v3.0)
├──  audit-complet.ps1           # Script d'audit complet automatique
├──  modules/                    # Modules d'audit spécialisés
│   ├──  SystemAudit.ps1        # Audit système et matériel
│   ├──  AccountAudit.ps1       # Audit comptes et politiques
│   ├──  NetworkAudit.ps1       # Audit ports et réseau
│   ├──  Reporting.ps1        # Module de génération de rapports
│   └──  DefenderAudit.ps1     # Audit Windows Defender
├──  reports/                   # Rapports générés (auto-créé)
│   ├──  security-audit-YYYYMMDD-HHMMSS.txt
│   └──  security-audit-YYYYMMDD-HHMMSS.html
├──  logs/                      # Logs d'exécution (auto-créé)
└──  doc/                       # Documentation
    └──  screenshots/           # Captures d'écran
```

  

## 🎯 Utilisation

  

### Menu Principal (`main-audit.ps1`)

```
========================================================

     WINDOWS SECURITY AUDIT TOOL v3.0

========================================================

  

========================================================

                 MAIN MENU

========================================================

  1. Complete Security Audit
  2. System Audit Only
  3. Accounts Audit Only
  4. Network Audit Only
  5. Defender Audit Only
  6. Generate HTML Report
  7. View Existing Reports
  8. Help and Information
  9. Exit
========================================================
Your choice (1-9):
```

  

### Options Détaillées

  

#### 1. **Audit Complet** 

Exécute les 4 audits séquentiellement avec :

- Barres de progression
- Scores intermédiaires
- Génération automatique de rapports (TXT + HTML)
- Résumé final détaillé

#### 2. **Audit Système Seul** 

Vérifications incluses :

- Version et build Windows
- Dernières mises à jour installées
- Informations matériel (RAM, fabricant)
- Uptime du système
- Vérification des privilèges admin

#### 3. **Audit Comptes Seul** 

Vérifications incluses :

- Nombre d'administrateurs locaux
- État du compte "Administrator" intégré
- État du compte "Guest"
- Politiques d'expiration des mots de passe

#### 4. **Audit Réseau Seul** 

Vérifications incluses :

- Ports TCP en écoute
- Détection des ports risqués (21, 23, 135, 139, 445, 3389)
- Connexions réseau établies
- Adaptateurs réseau actifs


#### 5. **Audit Defender Seul** 

Vérifications incluses :

- Disponibilité de Windows Defender
- État de l'antivirus
- Protection en temps réel

  

#### 6. **Générer Rapport HTML** 

*Note : Les rapports sont générés automatiquement avec l'audit complet*

  

#### 7. **Voir Rapports Existants** 

Liste et affiche les 10 derniers rapports générés avec :

- Nom et date
- Âge du rapport
- Option pour visualiser

  

#### 8. **Aide et Information** 

Documentation complète sur :

- Description de l'outil
- Fonctionnalités
- Méthodologie recommandée
- Conseils pour le portfolio

  

### Audit Direct (`audit-complet.ps1`)

```powershell
.audit-complet.ps1
```

**Avantages :**

- Pas de navigation manuelle
- Rapport généré automatiquement
- Interface visuelle simplifiée
- Idéal pour automatisation

  

## 🔍 Détails des Modules

  

### 1. 🔧 **SystemAudit.ps1** - Audit Système

  

```powershell
function Get-SystemInformation {
    # Retourne : @{OSName, OSVersion, BuildNumber, SecurityScore, Issues, ...}
}
```

  

**Vérifications :**

1. **Informations OS** : Version, build, édition
2. **Mises à jour** : Dernier hotfix installé
3. **Matériel** : Fabricant, modèle, RAM
4. **Privilèges** : Vérification admin
5. **Uptime** : Temps depuis dernier démarrage

  

**Scoring :**

- -20 pts : Version OS obsolète (< build 19041)
- -15 pts : Mises à jour > 30 jours
- -10 pts : Exécution sans admin

  

### 2. 👥 **AccountAudit.ps1** - Audit Comptes

  

```powershell
function Get-AccountSecurityAudit {
    # Retourne : @{Score, Issues, Recommendations}
}
```

  

**Vérifications :**

1. **Administrateurs locaux** : Nombre > 3 = problème
2. **Compte "Administrator"** : Désactivation recommandée
3. **Compte "Guest"** : Désactivation obligatoire
4. **Mot de passe** : Expiration activée pour tous les comptes

  

**Scoring :**

- -20 pts : Plus de 3 administrateurs
- -30 pts : Compte Administrator activé
- -25 pts : Compte Guest activé
- -15 pts : Mots de passe sans expiration

  

### 3. **NetworkAudit.ps1** - Audit Réseau

  

```powershell
function Get-NetworkSecurityAudit {
    # Retourne : @{Score, Issues, Recommendations}
}
```

  

**Vérifications :**

1. **Ports en écoute** : Liste complète TCP
2. **Ports risqués** : Détection automatique (21, 23, 135, 139, 445, 3389)
3. **Connexions établies** : 10 dernières connexions
4. **Adaptateurs réseau** : État et description

  

**Scoring :**

- -5 pts par port risqué détecté

  

### 4. 🛡️ **DefenderAudit.ps1** - Audit Windows Defender

  

```powershell
function Get-DefenderSecurityAudit {
    # Retourne : @{Score, Issues, Recommendations, IsAvailable}
}
```

  

**Vérifications :**

1. **Disponibilité** : Module Defender accessible
2. **Antivirus** : État activé/désactivé
3. **Protection temps réel** : État activé/désactivé

  

**Scoring :**

- Score 90 : Mode test (défaut)
- Score 40 : Antivirus ou protection désactivé
- Score 10 : Defender non accessible

  

## 📊 Format des Résultats

  

### Sortie Console Exemple

```
=== AUDIT DES COMPTES ===

1. Vérification des administrateurs locaux...
   [INFO] 2 administrateur(s) trouvé(s)
   [OK] Nombre d'admins approprié

  

2. Vérification du compte Administrateur intégré...
   [OK] Compte Administrateur désactivé

=== RÉSUMÉ COMPTES ===
  Score sécurité comptes: 85/100

  Problèmes détectés:
    • 3 comptes avec mots de passe sans expiration

  Recommandations:
    • Activer l'expiration des mots de passe
```

  

### Rapport Texte (`reports/security-audit-*.txt`)

```
===========================================

     WINDOWS SECURITY AUDIT REPORT

===========================================

Generated: 2023-12-15 14:30:25
Computer: DESKTOP-ABC123
Audit Tool Version: 1.0

===========================================
OVERALL SECURITY SCORE: 78/100
STATUS: FAIR - Some improvements needed
DETAILED FINDINGS:
==================

1. SYSTEM INFORMATION
   OS: Microsoft Windows 10 Professionnel
   Version: 10.0.19045
   Build: 19045
   Security Score: 85/100
```

  

### Rapport HTML (`reports/security-audit-*.html`)

Rapport HTML avec :

- Header professionnel avec nom de la machine
- Score global avec couleur (vert/jaune/rouge)
- Sections détaillées pour chaque catégorie
- Liste des problèmes et recommandations
- Design responsive et moderne

  

## 🔧 Personnalisation

### Ajouter un Nouveau Vérification

1. **Dans un module existant** :

```powershell
# Ajouter dans SystemAudit.ps1 par exemple
function Get-SystemInformation {
    # ... code existant ...
    # Nouvelle vérification
    Write-Host "6. Vérification de BitLocker..." -ForegroundColor Yellow
    $bitlocker = Get-BitLockerVolume -ErrorAction SilentlyContinue
    if ($bitlocker.ProtectionStatus -ne "On") {
        $issues += "BitLocker non activé"
        $score -= 10
    }
    # ... retour final ...
}
```

  

2. **Créer un nouveau module** :

```powershell
# Créer FirewallAudit.ps1 dans modules/
function Get-FirewallSecurityAudit {
    # Votre logique ici
    return @{Score=95; Issues=@(); Recommendations=@()}
}
```

  

### Modifier les Scores

```powershell
# Dans AccountAudit.ps1, ajuster les pénalités
if ($adminCount -gt 3) {
    $accountFindings.Score -= 15  # Au lieu de 20
}
# Dans SystemAudit.ps1, ajuster les seuils
if ($daysSinceUpdate -gt 45) {  # Au lieu de 30
    $score -= 15
}
```

  

### Personnaliser les Rapports

Modifier `Reporting.ps1` ou la fonction `Generate-Report` dans `main-audit.ps1` :

- Changer les couleurs CSS
- Ajouter des sections supplémentaires
- Modifier la structure des tables
- Ajouter un logo ou en-tête personnalisé

  

## ⚠️ Dépannage
### Erreurs Courantes
**"File cannot be loaded because running scripts is disabled"**
```powershell
# Exécuter en PowerShell administrateur
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

  

**"Get-LocalGroupMember : Access is denied"**
```powershell
# Relancer PowerShell en tant qu'administrateur
# Clic droit → Exécuter en tant qu'administrateur
```

  

**Module non chargé**
```powershell
# Vérifier le chemin des modules
Test-Path .modulesSystemAudit.ps1
# Charger manuellement
. .modulesSystemAudit.ps1
Get-SystemInformation
```

  

### Amélioration des Résultats

1. **Pour des résultats complets** : Toujours exécuter en admin
2. **Pour les rapports** : Vérifier le dossier `reports`
3. **Pour le débogage** : Consulter les messages en jaune/rouge
4. **Pour la persistance** : Sauvegarder les rapports HTML

  

## 🤝 Contribution
### Structure de Contribution

1. **Bug fixes** : Corrections d'erreurs dans les modules existants
2. **Nouvelles vérifications** : Ajout de contrôles de sécurité
3. **Améliorations UI** : Interface plus intuitive
4. **Documentation** : Amélioration du README ou guides

  

### Normes de Code
- **Langue** : Français pour l'interface, anglais pour le code
- **Formatage** : 4 espaces, pas de tabulations
- **Commentaires** : Expliquer la logique complexe
- **Noms de fonctions** : Verbe-Nom en anglais (Get-, Test-, Invoke-)

  

### Tests

Tester sur :
- Windows 10 (différents builds)
- Windows 11
- Avec et sans droits administrateur
- Différentes configurations réseau

## 📄 Licence

  

Ce projet est sous licence **MIT**.

  

**Permissions :**

- ✅ Utilisation commerciale
- ✅ Modification
- ✅ Distribution
- ✅ Utilisation privée
- ✅ Inclusion dans un portfolio

  

**Limitations :**

- ❌ Responsabilité
- ❌ Garantie
- ❌ Utilisation malveillante

  

**Conservation des droits d'auteur :**

- L'attribution à Ayoub Aguezar doit être conservée
- Les modifications doivent être documentées

  

## 👤 Auteur

  

**Ayoub Aguezar**  
Software Engineer | Data Engineer | Cybersecurity Analyst ( Student )

  

### Objectifs du Projet

1. **Démontrer l'expertise PowerShell** : Scripting avancé, gestion système
2. **Montrer une méthodologie d'audit** : Approche structurée, reproductible
3. **Créer un outil professionnel** : Interface propre, rapports de qualité
4. **Documenter un processus complet** : Code, tests, documentation

  

### Compétences Développées

- **PowerShell Avancé** : Modules, fonctions, gestion d'erreurs
- **Sécurité Windows** : Audit système, comptes, réseau, antivirus
- **Génération de rapports** : Formats texte et HTML
- **Interface utilisateur** : Menus interactifs, code couleur
- **Gestion de projet** : Structure modulaire, documentation

  



### Contact

- **GitHub** : [github.com/votreusername](https://github.com/Ayoub-glitsh)
- **Portfolio** : [votresite.com](https://gleaming-caramel-c3fadf.netlify.app/)
- **Email** : ayoubaguezzar1@gmail.com

  

---

**⭐ Si ce projet vous est utile, n'hésitez pas à le star sur GitHub !**

*Dernière mise à jour : Décembre 2023 | Version : 3.0*

  






  

