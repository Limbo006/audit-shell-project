# ===== Bloc 4 : audit système (Yacine) =====

# Ajoute les informations système et les cinq processus les plus gourmands au rapport.
audit_systeme() {
    {
        printf '\n[1] Informations système\n'
        printf 'Noyau : %s\n' "$(uname -r)"
        printf 'Démarrée : %s\n' "$(uptime -p)"
        printf '\nMémoire :\n'
        free -h
        printf '\nDisque racine :\n'
        df -h /
        printf '\nLes 5 processus les plus gourmands :\n'
        ps aux --sort=-%cpu | head -n 6
    } >> "$RAPPORT"

    journaliser "Audit système terminé"
}

# ===== Bloc 5 : audit réseau (Yacine) =====

NB_OK=0
NB_ERREUR=0

# Teste les cibles par ping et indique l'état du port 22 sans modifier les compteurs de ping.
audit_reseau() {
    local cible

    printf '\n[2] Tests réseau\n' >> "$RAPPORT"

    while IFS= read -r cible || [ -n "$cible" ]; do
        cible="${cible%$'\r'}"

        case "$cible" in
            ''|\#*) continue ;;
        esac

        if ping -c 1 -W 1 "$cible" > /dev/null 2>&1; then
            printf '[OK] %s répond\n' "$cible" >> "$RAPPORT"
            NB_OK=$((NB_OK + 1))
        else
            printf '[ERREUR] %s ne répond pas\n' "$cible" >> "$RAPPORT"
            NB_ERREUR=$((NB_ERREUR + 1))
        fi

        if ! command -v nc > /dev/null 2>&1; then
            printf '    port 22 : non testé (nc absent)\n' >> "$RAPPORT"
        elif nc -z -w 1 "$cible" 22 > /dev/null 2>&1; then
            printf '    port 22 : ouvert\n' >> "$RAPPORT"
        else
            printf '    port 22 : fermé ou filtré\n' >> "$RAPPORT"
        fi
    done < "$DIR/config/targets.conf"

    journaliser "Audit réseau terminé"
}
