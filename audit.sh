#!/bin/bash

# ===== Bloc 1 : en-tete (ilyas) =====
# audit.sh : permet l'audit d'une machine linux(systeme, securite et reseau)
# Fait par : ilyas Joubaer, yacine Ben Ammar, khadija Jarmouni
# ===== Bloc 2 : variables (ilyas) =====
DIR=$(cd "$(dirname "$0")" && pwd)
LOG="$DIR/logs/audit.log"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
RAPPORT="$DIR/reports/audit_$DATE.txt"
# ===== Bloc 3 : aide, journal, en-tete du rapport (ilyas) =====
# afficher l'aide d'emploie de script
afficher_aide(){
	echo "Usage: $0 option"
	echo "--system	 	audit du systeme"
	echo "--network         test reseau"
	echo "--security        controle de securite"
	echo "--all             les trois audits"
	echo "--help            cette aide"
 echo "--interactive   menu interactive"

}

journaliser(){
	echo "[$(date '+%F %T')] $1" >> "$LOG"
}

ecrire_entete(){
	{
		echo "RAPPORT D'AUDIT"
		echo "Date 	 : $(date '+%F %T')"
		echo "Machine    : $(hostname)"
		echo "Utilisateur: $(whoami)"
		echo
	} > "$RAPPORT"
}
# ===== Bloc 4 : audit systeme (yacine) =====
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

# ===== Bloc 5 : compteurs et audit reseau (yacine) =====
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
# ===== Bloc 6 : audit securite (khadija) =====
# controle  securite : comptes bash ,portes en ecoute , fichiers 777 
audit_securite(){
{
echo "[3] Analyse de sécurité"
echo "Comptes avec un shell bash :"
grep 'bash$' /etc/passwd | cut -d: -f1
echo "Ports en écoute :"
ss -tuln
echo "Fichiers en mode 777 dans $HOME :"
find "$HOME" -type f -perm 0777 2>/dev/null
echo "(indicateurs a examiner, pas une preuve de vulnerabilite)"
} >> "$RAPPORT"
journaliser "Audit sécurité terminé"

}
# ===== Bloc 7 : resume et archives (ilyas) =====
archiver_rapport(){
	archive="$DIR/archives/audit_$DATE.tar.gz"
	tar -czf "$archive" -C "$DIR/reports" "$(basename "$RAPPORT")"
	journaliser "Archive cree: $(basename "$archive")"
}

ecrire_resume(){
        {
		echo
                echo "[4] Resume"
                echo "Test OK       : $NB_OK"
                echo "Test echec    : $NB_ERREUR"
        } >> "$RAPPORT"

}
# ===== Bloc 8 : menu interactif (khadija) =====
# menu par  choisir un audit avec read et case
menu_interactif(){
echo "1) audit systeme "
echo "2) audit reseau"
echo "3) audit securite"
echo "4) tous les audits"
echo "5) quitter"
read -p "votre choix : " choix
case $choix in
1) option="--system" ;;
2) option="--network" ;;
3) option="--security" ;;
4) option="--all" ;;
5) exit 0 ;;
*) echo "choix invalide" ; exit 1 ;;
esac
}

# ===== Bloc 9 : programme principal (ilyas) =====
mkdir -p "$DIR/reports" "$DIR/logs" "$DIR/archives"

if [ $# -ne 1 ]; then
	afficher_aide
	exit 1
fi

if [ ! -r "$DIR/config/targets.conf" ];then
	echo "Erreur : config/targets.conf absent ou illisible" >&2
	exit 2
fi

option="$1"
if [ "$option" = "--interactive" ]; then
menu_interactif
fi
case "$option" in 
	--system) ecrire_entete ; audit_systeme ;;
	--network) ecrire_entete ; audit_reseau ;;
	--security) ecrire_entete ; audit_securite ;;
	--all) ecrire_entete ; audit_systeme; audit_reseau ; audit_securite ;;
	--help) afficher_aide ; exit 0 ;;
	*) echo "Option inconnue : $1" ; afficher_aide ; exit 1 ;;
esac
ecrire_resume
archiver_rapport
journaliser "Audit $option termine"
echo "Rapport cree: reports/$(basename "$RAPPORT")"
echo "Tests OK : $NB_OK - Tests en echec: $NB_ERREUR"
