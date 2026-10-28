# ===== Bloc 4 : audit système (Yacine) =====

# Ajoute les informations système et les cinq processus les plus gourmands au rapport.

audit_systeme() {
    {
        echo "[1] Informations système"
        echo "Noyau : $(uname -r)"
        echo "Démarrée : $(uptime -p)"
        echo
        echo "Mémoire :"
        free -h
        echo
        echo "Disque racine :"
        df -h /
        echo
        echo "Les 5 processus les plus gourmands :"
        ps aux --sort=-%cpu | head -n 6
    } >> "$RAPPORT"

    journaliser "Audit système terminé"
}

# ===== Bloc 5 : audit réseau (Yacine) =====

NB_OK=0
NB_ERREUR=0

# Teste les cibles et leur port 22, puis compte les résultats ping.
audit_reseau() {
    echo "[2] Tests réseau" >> "$RAPPORT"

    while read -r cible; do
        if [ -z "$cible" ] || [ "${cible:0:1}" = "#" ]; then
            continue
        fi

        if ping -c 1 -W 1 "$cible" > /dev/null 2>&1; then
            echo "[OK] $cible répond" >> "$RAPPORT"
            NB_OK=$((NB_OK + 1))
        else
            echo "[ERREUR] $cible ne répond pas" >> "$RAPPORT"
            NB_ERREUR=$((NB_ERREUR + 1))
        fi

        if ! command -v nc > /dev/null 2>&1; then
            echo "    port 22 : non testé (nc absent)" >> "$RAPPORT"
        elif nc -z -w 1 "$cible" 22 > /dev/null 2>&1; then
            echo "    port 22 : ouvert" >> "$RAPPORT"
        else
            echo "    port 22 : fermé ou filtré" >> "$RAPPORT"
        fi
    done < "$DIR/config/targets.conf"

    journaliser "Audit réseau terminé"
}
