# Projet - Audit Linux

Projet réalisé par Ilyas, Yacine et Khadija en première année à 3iL.

## À quoi sert le script ?

Le script `audit.sh` permet de récupérer des informations sur une machine Linux. Il donne des informations sur le système, teste deux adresses réseau et fait quelques vérifications de sécurité.

Les résultats sont enregistrés dans un rapport texte. Le script garde aussi un journal et crée une archive du rapport.

## Installation

Il faut placer le dossier du projet sur une machine Linux, puis ouvrir un terminal dans ce dossier.

On rend le script exécutable avec :

```bash
chmod +x audit.sh
```

Le fichier `config/targets.conf` doit contenir :

```text
# Cibles autorisées
127.0.0.1

192.0.2.10
```

Il faut enregistrer le fichier au format Linux et laisser un retour à la ligne après la dernière adresse. Le commentaire et la ligne vide sont ignorés par le script. On utilise seulement les deux adresses données dans le sujet, sans `sudo`.

## Les options

| Option | Ce qu'elle fait |
| --- | --- |
| `--system` | Affiche le noyau, le temps depuis le démarrage, la mémoire, le disque et les cinq processus les plus gourmands en CPU. |
| `--network` | Teste les deux adresses avec ping et vérifie le port 22. |
| `--security` | Affiche les comptes utilisant Bash, les ports en écoute et les fichiers en mode 777 dans le dossier personnel. |
| `--all` | Lance les trois audits. |
| `--help` | Affiche l'aide. |
| `--interactive` | Permet de choisir l'audit dans un menu. |

## Exemple d'utilisation

Pour lancer l'audit complet :

```bash
./audit.sh --all
```

Exemple de sortie attendue dans le cas prévu par le sujet :

```text
Rapport créé : reports/audit_2026-10-28_08-00-00.txt
Tests OK : 1 - Tests en échec : 1
```

La date change à chaque lancement. Dans la partie réseau, on doit normalement retrouver :

```text
[2] Tests réseau
[OK] 127.0.0.1 répond
    port 22 : fermé ou filtré
[ERREUR] 192.0.2.10 ne répond pas
    port 22 : fermé ou filtré
```

C'est un exemple : le résultat du port 22 dépend de la machine et du réseau. Si `nc` n'est pas installé, le rapport indique que le port n'a pas été testé.

Les fichiers sont enregistrés dans :

- `reports/` pour les rapports ;
- `logs/audit.log` pour le journal ;
- `archives/` pour les rapports compressés en `.tar.gz`.

## Limites

Une machine peut être allumée sans répondre à ping. Un échec ne veut donc pas forcément dire qu'elle est éteinte.

Les compteurs concernent seulement ping, pas le test du port 22. Ce dernier nécessite la commande `nc`.

La recherche des fichiers en mode 777 se fait seulement dans le dossier personnel. Les contrôles de sécurité donnent des points à vérifier, mais ne prouvent pas qu'il y a une faille.

Si on lance le script deux fois dans la même seconde, les rapports peuvent avoir le même nom et être écrasés.

## Lancement automatique

Pour lancer le script tous les jours à 8 h, on pourrait utiliser cette ligne dans cron :

```cron
0 8 * * * /chemin/audit-shell-project/audit.sh --all
```

Le premier champ est la minute, puis l'heure, le jour du mois, le mois et le jour de la semaine. Ici, cela veut dire à 8 h 00, tous les jours.

Il faut remplacer le chemin par celui du projet. Cette ligne est seulement donnée comme exemple, elle n'est pas installée.

## Améliorations

Les deux améliorations prévues dans le projet sont le menu interactif et le test du port 22 avec `nc -z -w 1`.

Les commandes et les résultats des tests sont regroupés dans `tests.md`.
