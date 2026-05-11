# 🎮 Infinite Pixel Dungeon - Fork Setup & Development Guide

## ✅ Setup-Status: ABGESCHLOSSEN

### GitHub Repositories
- **Dein Fork**: https://github.com/TmYNooB/Infinite-Pixel-Dungeon
- **Privates Repo**: https://github.com/TmYNooB/InfinitePD-NoobModified (für Notizen/Backups)
- **Original Fork**: https://github.com/DragonMaster14545/Infinite-Pixel-Dungeon
- **Quelle**: https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone

### Lokale Konfiguration
```
Pfad: E:\ProgrammingProjects\InfiniteDgnModified
Git-Remote "origin": TmYNooB/Infinite-Pixel-Dungeon
Git-Remote "upstream": DragonMaster14545/Infinite-Pixel-Dungeon
Aktuelle Version: v0.1.9d (final)
Branch: master
```

---

## 📚 Projektstruktur (Kurze Übersicht)

```
Infinite Pixel Dungeon/
├── core/                          # Haupt-Spiellogik (plattformunabhängig)
│   └── src/main/java/com/
│       ├── shatteredpixeldungeon/ # Core Engine
│       ├── hero/                  # 5 Spielerklassen
│       ├── actors/                # Gegner & NPCs
│       ├── items/                 # Equipment/Inventar
│       ├── levels/                # Dungeon-Generierung
│       ├── mechanics/             # Gameplay-Regeln
│       └── ui/                    # Benutzeroberfläche
│
├── android/                       # Android APK App
├── desktop/                       # Windows/Linux JAR App
├── SPD-classes/                   # Gemeinsame Utilities
├── services/                      # Updates & News-System
└── docs/                          # Kompilierungs-Guides
```

---

## 🛠️ Kompilieren & Ausführen

### Desktop (Windows/Linux - JAR)
```bash
# Debug-Version (für schnelle Tests)
./gradlew desktop:debug

# Release-Version (optimiert)
./gradlew desktop:release
# Output: /desktop/build/libs/Infinite-Pixel-Dungeon-*.jar
```

### Android (APK/AAB)
```bash
# Release APK
./gradlew android:assembleRelease

# Google Play Bundle (empfohlen)
./gradlew android:bundleRelease
# Output: /android/build/outputs/
```

---

## 🎯 Wichtige Java Packages & Funktionen

### Game Core (`com.shatteredpixeldungeon`)
- Hauptspiel-Engine und Event-Loop
- LibGDX Framework Integration
- Rendering und Input-Handling

### Charactere (`com.hero.*`)
- **Warrior** - Tank mit hohem HP
- **Mage** - Magier mit Zauberstäben
- **Rogue** - Schurke mit Stealth/Bewegung
- **Huntress** - Rangerin mit Pfeil-Fähigkeiten
- **Duelist** - Neuerer Charakter mit einzigartigen Fähigkeiten

### Game Mechanics
- **Levels** - Prozedurales Dungeon-Design
- **Rooms** - Verschiedene Raumtypen
- **Enemies** - Gegner-KI und Verhalten
- **Items** - Ausrüstung, Tränke, Zauberstäbe, Artefakte
- **Abilities** - Charakter-Spezialfähigkeiten (Forks-Feature)

### UI System
- **Windows** - Dialogfenster, Menus
- **UI Elements** - Buttons, Slider, etc.
- **Sprites** - Animation und Rendering

---

## 📝 Git Workflow

### Security Guardrails (lokal + CI)
```bash
# Einmal pro Clone: lokale Hooks aktivieren
git config core.hooksPath .githooks
```

Was wird blockiert:
- Commit von `android/keystore.properties`, `.jks`, `.keystore`
- Commit von Signing-Passwörtern oder GitHub Token-Mustern

CI schützt zusätzlich serverseitig per Workflow vor Secret-Leaks.

### Updates vom Original-Fork holen
```bash
# Hole neueste Version vom Original
git fetch upstream
git merge upstream/master

# Oder mit Rebase (cleaner history)
git rebase upstream/master
```

### Deine Änderungen pushen
```bash
git add .
git commit -m "Beschreibung deiner Änderung"
git push origin master
```

### Branches für Features
```bash
git checkout -b feature/deine-feature
# ... mache Änderungen ...
git push -u origin feature/deine-feature
```

---

## 🔧 Code-Muster & Conventions

### Entity-System
Die meisten Spielobjekte (Charaktere, Gegner, Items) erben von `Actor`:
```java
public class MyClass extends Actor {
    // act() wird jeden Frame aufgerufen
    public void act() { }
}
```

### Object Pooling
Performance-Optimierung - Objekte werden wiederverwendet statt neu erstellt:
```java
// Statt: new Effect()
Effect effect = Emitter.recycle();
```

### Event System
Kommunikation zwischen UI und Game:
```java
// Listen for events
GameScene.addEffect(new MyEffect());
```

---

## 📋 Dateistruktur für Modifikationen

### Neue Item-Klasse hinzufügen
```
core/src/main/java/com/items/
└── NewItem.java  (erbt von Item)
```

### Neuer Gegner
```
core/src/main/java/com/mobs/
└── NewMob.java  (erbt von Mob)
```

### Neue Fähigkeit (Fork-Feature)
```
core/src/main/java/com/abilities/
└── NewAbility.java
```

### Neue Level-Feature
```
core/src/main/java/com/levels/
└── NewFeature.java
```

---

## 🚀 Nächste Schritte

1. **Änderungen planen** - Was willst du modifizieren?
2. **Branch erstellen** - `git checkout -b feature/xyz`
3. **Code ändern** - Folge den Code-Patterns
4. **Testen** - `./gradlew desktop:debug`
5. **Commit & Push** - `git commit` → `git push`
6. **Build erzeugen** - `./gradlew desktop:release` oder Android

---

## 📚 Dokumentation
- [Desktop Compilation](docs/getting-started-desktop.md)
- [Android Compilation](docs/getting-started-android.md)
- [Recommended Changes](docs/recommended-changes.md)

---

## 🎓 Learning Resources
- **LibGDX Framework**: https://libgdx.com/wiki
- **Gradle Build System**: https://gradle.org/guides
- **Git Workflow**: https://git-scm.com/book/en/v2

---

## ⚡ Quick Commands Reference

```bash
# Projekt-Build
./gradlew build                    # Alles bauen
./gradlew clean                    # Cache löschen
./gradlew desktop:debug            # Desktop Debug starten

# Git
git status                         # Status anzeigen
git log --oneline -10             # Letzten 10 Commits anzeigen
git diff core/...                 # Änderungen im Core
git stash                         # Nicht committete Änderungen speichern

# Remote Sync
git fetch upstream                # Updates vom Original
git fetch origin                  # Updates von deinem Fork
git pull origin master            # Pull + Merge
```

