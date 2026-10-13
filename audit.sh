#!/usr/bin/env bash

# Ce script va permettre de collecter des informations sur la machine(nom,utilisateur,version ...)
# mais aussi de tester le reseau et faire les verifications de securite necessaire.
# Afin de produire a la fin un rapport

# projet1: Automatisation d'un audit systeme, reseau et securite
# Auteurs: Ilyas JOUBAER , Yacine Ben Omar, Doha LAAYOUNI


# ---------------------  0. EN-TETE ET VARIABLES GLOBALES (ilyas) ---------------------------------

set -u
export LC_ALL=C

nom_du_dossier="$(dirname "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$nom_du_dossier" && pwd)"

CONFIG_DIR="$SCRIPT_DIR/config"
REPORTS_DIR="$SCRIPT_DIR/reports"
LOGS_DIR="$SCRIPT_DIR/logs"
ARCHIVES_DIR="$SCRIPT_DIR/archives"
TMP_BASE="$SCRIPT_DIR/tmp"

TARGETS_FILE="$CONFIG_DIR/targets.conf"
AUDIT_CONF="$CONFIG_DIR/audits.conf"

LOG_FILE="$LOGS_DIR/audit.log"


