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
# controle  securite : comptes bash ,portes en ecoute , fichiers 777 
audit_securite(){
{
echo "[3] analyse de securite"
echo "comptes avec un shell bash"
grep 'bash$' /etc/passwd | cut -d: -f1
echo "ports en ecoute ;"
ss -tuln
echo "fichiers en mode 777 dans $HOME ;"
find "$HOME" -type f -perm 0777 2>/dev/null
echo "(indicateurs a examiner, pas une preuve de vulnerabilite)"
} >> "$RAPPORT"
journaliser "audit securite termine"

}
# ===== Bloc 7 : resume et archives (ilyas) =====
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

ecrire_entete
case "$1" in
	--system) audit_systeme ;;
	--network) audit_reseau ;;
	--security) audit_securite ;;
	--all) audit_systeme; audit_reseau ; audit_securite ;;
	--help) afficher_aide ; exit 0 ;;
	*) echo "Option inconnue : $1" ; afficher_aide ; exit 1 ;;
esac
journaliser "Audit $1 termine"
