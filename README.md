# FocusBreath - Application Pomodoro + Respiration

Application mobile Flutter combinant un minuteur Pomodoro avec des exercices de respiration guidée.

## Fonctionnalités

- ✅ Minuteur Pomodoro (25/5/15 minutes)
- ✅ Exercices de respiration guidée (4-4-4-4, 4-7-8, cohérence cardiaque)
- ✅ Statistiques et suivi des progrès
- ✅ Système de réalisations
- ✅ Interface moderne et intuitive

## Installation

1. Assurez-vous d'avoir Flutter installé : https://flutter.dev/docs/get-started/install
2. Clonez ce projet
3. Exécutez `flutter pub get` pour installer les dépendances
4. Lancez l'application avec `flutter run`

## Structure du projet

\`\`\`
lib/
├── main.dart                 # Point d'entrée
└── screens/
├── home_screen.dart      # Écran d'accueil
├── timer_screen.dart     # Minuteur Pomodoro
├── breathing_screen.dart # Exercices de respiration
└── stats_screen.dart     # Statistiques
\`\`\`

## Technologies utilisées

- Flutter 3.0+
- Dart 3.0+
- Material Design 3

Titre : Rapport de projet — Focus Breath (application Pomodoro avec respiration guidée)

Résumé
Ce document présente la conception, l'implémentation et la validation de l'application mobile Focus Breath. L'application combine méthode Pomodoro et exercices de respiration, gère les réglages utilisateurs, les rappels programmés et les notifications. Le rapport couvre l'architecture, les choix techniques, les principaux composants, les problèmes rencontrés et les solutions appliquées.

Table des matières
1. Contexte et objectifs
2. Technologies et dépendances
3. Architecture logicielle
4. Conception des écrans principaux
5. Services et persistance
6. Problèmes rencontrés et corrections
7. Tests et validation
8. Guide d'utilisation et déploiement
9. Conclusion
Annexes : commandes utiles, fichiers modifiés clés

1. Contexte et objectifs
Objectif général : fournir une application mobile multiplateforme (Flutter) pour améliorer la productivité via la technique Pomodoro, enrichie par des exercices de respiration guidée et des rappels programmables.
Objectifs fonctionnels :
- Session Pomodoro avec minuteur visuel et respirations guidées.
- Page Réglages pour durées et options.
- Système de rappels persistants avec notifications à l'heure choisie.
- Sauvegarde locale des préférences et rappels.
Contraintes : fonctionnement en background, notifications fiables, gestion des autorisations Android récentes.

2. Technologies et dépendances
- Langage/Framework : Dart / Flutter.
- Plugins principaux :
  - `flutter_local_notifications` (notifications)
  - `timezone` (gestion temporelle)
  - `sqflite` / `shared_preferences` (persistance)
  - `permission_handler` (permissions)
- Outils : Android Studio, Gradle, Flutter SDK.
- Plateformes cibles : Android (principal), iOS (prévu).

3. Architecture logicielle
Architecture en couches :
- UI : écrans Flutter (PomodoroScreen, SettingsScreen, ReminderForm).
- Services : NotificationService, SettingsService, AppLifecycleService.
- Persistance : NotificationPrefs (sqflite/shared_preferences).
Communication :
- Les écrans appellent les services pour lire/enregistrer les préférences et planifier notifications.
- NotificationService encapsule `flutter_local_notifications` et la logique de scheduling (zonedSchedule / exactAllowWhileIdle).
Diagramme conceptuel (texte) :
UI ↔ Services ↔ Persistance
NotificationService ↔ OS (permissions / exact alarms)

4. Conception des écrans principaux
PomodoroScreen
- Affichage principal : cercle de progression, minuteur, contrôles (démarrer, pause, reset).
- Adaptativité : layout responsive pour éviter overflow sur petits écrans (SingleChildScrollView + ConstrainedBox / LayoutBuilder).
SettingsScreen
- Sliders pour durées (work, short break, long break) avec validation et clamp des valeurs.
- Boutons pour gérer autorisations notification / exact alarms.
ReminderForm
- Création/édition de rappels : titre, date/heure, répétition.
- Sauvegarde persistance + scheduling via NotificationService.

5. Services et persistance
NotificationService
- Initialisation : `tz.initializeTimeZones()`; fallback à `tz.local` si détection de fuseau non disponible.
- Méthodes : `scheduleOneTimeNotification`, `scheduleDailyNotification`, `cancelNotification`, `pendingNotificationRequests`.
- Gestion des permissions : demande `POST_NOTIFICATIONS` et vérification exact alarms.
SettingsService / NotificationPrefs
- Sauvegarde des réglages utilisateurs et rappels en base (shared_preferences / sqflite).
- Exposition de méthodes sync/async pour lecture et mise à jour.

6. Problèmes rencontrés et corrections
A. RenderFlex overflow (PomodoroScreen)
- Symptôme : assert RenderFlex overflowed by ~6.9 pixels.
- Cause : somme des widgets enfants dépassant la hauteur disponible.
- Correction : rendre la page toujours scrollable si l'espace est insuffisant ; utiliser `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight: constraints.maxHeight)` + dimensionnement dynamique du cercle. Ajout de `ClipRect`/`IntrinsicHeight` pour couper les très faibles débordements visuels en mode debug.

B. Slider hors bornes (SettingsScreen)
- Symptôme : assertion Slider value 25.0 not between min 1.0 and max 20.0.
- Cause : valeur par défaut / persistée hors plage.
- Correction : clamp des valeurs lues (`value = value.clamp(min, max)`), initialisation des valeurs par défaut à l'intérieur de la plage et validation lors de la sauvegarde.

C. Notifications / fuseau horaire / build error
- Symptôme initial : notifications non reçues à l'heure ; tentative d'ajout de `flutter_native_timezone` provoquant erreur Gradle (namespace not specified).
- Correction :
  - Retrait de `flutter_native_timezone` du `pubspec.yaml` pour résoudre l'erreur de build.
  - Maintien de `tz.initializeTimeZones()` et usage de `tz.local` en fallback.
  - Ajout de logs pour vérifier `pendingNotificationRequests`.
  - Recommandations : vérifier permissions `POST_NOTIFICATIONS` (Android 13+), autorisation exact alarms, désactivation optimisation batterie, éventuellement ajouter rescheduling on boot (manifest + receiver) pour robustesse.

7. Tests et validation
Tests réalisés :
- Tests manuels UI : navigation, mise à l'échelle du layout (portrait/paysage), accessibilité (text scale).
- Fonctionnels : création d'un rappel, vérification que `pendingNotificationRequests` contient l'élément planifié, simulation d'alarme à court terme (1–2 minutes).
- Scénarios couverts : changement de paramètres, redémarrage de l'app (rescheduling des rappels à l'initialisation).
Résultats :
- Overflow corrigé sur tailles réduites.
- Slider stable dans plage 1..20.
- Notifications programmées correctement visible dans les pending requests ; déclenchement dépendant des réglages permissions/OS.

8. Guide d'utilisation et déploiement
Commandes utiles (exécution locale) :
- Récupérer dépendances :
  - flutter pub get
- Lancer sur device :
  - flutter devices
  - flutter run -d <deviceId>
- Nettoyage :
  - flutter clean
Permissions à vérifier sur Android :
- Notifications (POST_NOTIFICATIONS).
- Exact alarms (Android S+) via réglages système si l'application demande des alarmes exactes.
Conseils pour tests :
- Créer un rappel à 1–2 minutes pour valider le scheduling.
- Consulter les logs pour voir les prints `[Notif]` ajoutés lors du scheduling.

9. Conclusion
Le projet Focus Breath fournit une base solide pour une application Pomodoro enrichie de respirations guidées et rappels. Les principaux problèmes rencontrés (layout overflow, slider assertions, gestion des notifications et build plugin) ont été identifiés et corrigés sans compromettre l’architecture. Les prochaines étapes recommandées : améliorer la résilience des notifications (rescheduling at boot), tests sur plusieurs devices/vendeurs, et ajouter couverture de tests unitaires/intégration.

Annexes
- Fichiers modifiés importants : `lib/screens/pomodoro_screen.dart`, `lib/screens/setting_screen.dart`, `lib/service/notification_service.dart`, `pubspec.yaml`.
- Dépendances clés listées dans `pubspec.yaml` : `flutter_local_notifications`, `timezone`, `sqflite`, `permission_handler`.
- Snippets de commandes déjà listés dans la section 8.

Fin du rapport.
