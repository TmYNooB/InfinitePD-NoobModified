# Desktop JAR Starten auf macOS

Wenn macOS `.jar` Dateien nicht per Doppelklick startet, kannst du stattdessen `Run-Desktop-Jar.command` verwenden.

Der Launcher:
- sucht JAR-Dateien in `desktop/build/libs`
- zeigt bei mehreren Dateien einen Auswahldialog
- bevorzugt Java 17 aus Homebrew oder `java_home`
- startet die gewaehlte JAR mit `-XstartOnFirstThread`

Benutzung:
1. Doppelklicke `Run-Desktop-Jar.command`
2. Waehle die gewuenschte Desktop-JAR aus

Optional:
- Du kannst auch eine `.jar` Datei auf `Run-Desktop-Jar.command` ziehen.