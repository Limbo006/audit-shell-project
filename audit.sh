#!/bin/bash

# ===== Bloc 1 : en-tete (ilyas) =====
# audit.sh : permet l'audit d'une machine linux(systeme, securite et reseau)
# Fait par : ilyas Joubaer, yacine Ben Ammar, khadija Jermouni
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
# Provisoire: remplace par yacine a etape3
audit_systeme(){
	echo "Audit systeme"
}
# ===== Bloc 5 : compteurs et audit reseau (yacine) =====
# Provisoire : remplace apr yacine a etape4
audit_reseau(){
	echo "Audit reseau"
}
# ===== Bloc 6 : audit securite (khadija) =====
#Provisoire : remplace par khadija etape5
audit_securite(){
	echo "Audit securite"
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

case "$1" in
	--system) ecrire_entete ; audit_systeme ;;
	--network) ecrire_entete ; audit_reseau ;;
	--security) ecrire_entete ; audit_securite ;;
	--all) ecrire_entete ; audit_systeme; audit_reseau ; audit_securite ;;
	--help) afficher_aide ; exit 0 ;;
	*) echo "Option inconnue : $1" ; afficher_aide ; exit 1 ;;
esac
ecrire_resume
archiver_rapport
journaliser "Audit $1 termine"
echo "Rapport cree: reports/$(basename "$RAPPORT")"
echo "Tests OK : $NB_OK - Tests en echec: $NB_ERREUR"
