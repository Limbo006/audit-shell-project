#!/bin/bash

# ===== Bloc 1 : en-tete (ilyas) =====
# audit.sh : permet l'audit d'une machine linux(systeme, securite et reseau)
# Fait par : ilyas Joubaer, yacine Ben Ammar, khadija Jermouni
# ===== Bloc 2 : variables (ilyas) =====
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
# ===== Bloc 8 : menu interactif (khadija) =====
# ===== Bloc 9 : programme principal (ilyas) =====
if [ $# -ne 1 ]; then
	afficher_aide
	exit 1
fi

case "$1" in
	--system) audit_systeme ;;
	--network) audit_reseau ;;
	--security) audit_securite ;;
	--all) audit_systeme; audit_reseau ; audit_securite ;;
	--help) afficher_aide ; exit 0 ;;
	*) echo "Option inconnue : $1" ; afficher_aide ; exit 1 ;;
esac
