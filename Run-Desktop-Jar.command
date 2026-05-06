#!/bin/zsh

set -u
set -o pipefail

SCRIPT_DIR=${0:A:h}
LIB_DIR="$SCRIPT_DIR/desktop/build/libs"

show_alert() {
    local message="$1"
    /usr/bin/osascript -e "display alert \"InfinitePD Launcher\" message \"${message//\"/\\\"}\" as critical"
}

pick_jar() {
    local picked
    local -a basenames
    local -a jars

    jars=("$LIB_DIR"/*.jar(N))
    if (( ${#jars[@]} == 0 )); then
        show_alert "Keine JAR-Datei gefunden in: $LIB_DIR"
        return 1
    fi

    if (( ${#jars[@]} == 1 )); then
        print -r -- "$jars[1]"
        return 0
    fi

    basenames=(${jars:t})
    picked=$(/usr/bin/osascript - "${basenames[@]}" <<'OSA'
on run argv
    set jarChoices to argv
    set selectedJar to choose from list jarChoices with title "InfinitePD Launcher" with prompt "Welche JAR soll gestartet werden?" default items {item 1 of jarChoices}
    if selectedJar is false then
        return ""
    end if
    return item 1 of selectedJar
end run
OSA
)

    if [[ -z "$picked" ]]; then
        return 1
    fi

    print -r -- "$LIB_DIR/$picked"
}

find_java() {
    if [[ -x /opt/homebrew/opt/openjdk@17/bin/java ]]; then
        print -r -- /opt/homebrew/opt/openjdk@17/bin/java
        return 0
    fi

    local java_home_output
    java_home_output=$(/usr/libexec/java_home -v 17 2>/dev/null) || true
    if [[ -n "$java_home_output" && -x "$java_home_output/bin/java" ]]; then
        print -r -- "$java_home_output/bin/java"
        return 0
    fi

    if command -v java >/dev/null 2>&1; then
        command -v java
        return 0
    fi

    return 1
}

main() {
    local jar_path
    local java_bin

    if (( $# >= 1 )) && [[ -f "$1" ]]; then
        jar_path="$1"
    else
        jar_path=$(pick_jar) || exit 0
    fi

    java_bin=$(find_java) || {
        show_alert "Kein Java gefunden. Installiere bitte Java 17 oder passe den Launcher an."
        exit 1
    }

    cd "$SCRIPT_DIR" || exit 1

    "$java_bin" -XstartOnFirstThread -jar "$jar_path"
    local exit_code=$?

    if (( exit_code != 0 )); then
        echo
        echo "Der Start ist mit Exit-Code $exit_code beendet worden."
        echo "Druecke Enter, um das Fenster zu schliessen."
        read -r
    fi

    exit $exit_code
}

main "$@"