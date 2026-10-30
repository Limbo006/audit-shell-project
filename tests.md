# Tests du script audit.sh

Date : 29/10/2026

Machine : VM Linux `debian`, utilisateur `yacine`.

Noyau : `6.12.111+deb13-amd64`.

## Signification des codes retour

Le code retour indique comment le script s'est terminé. On l'affiche avec `echo $?` juste après la commande.

- **0** : le script s'est terminé normalement.
- **1** : le script a refusé une saisie incorrecte, par exemple une option inconnue, aucun argument ou un choix de menu invalide.
- **2** : le fichier `config/targets.conf` est absent ou illisible.

Ce code n'est pas le nombre de tests réseau réussis ou ratés. Par exemple, l'audit réseau peut afficher 1 réussite et 1 échec, puis renvoyer 0 : l'audit s'est bien déroulé, même si une cible n'a pas répondu.

Pour les essais avec une mauvaise saisie, obtenir 1 est le résultat attendu. Cela montre que le script refuse correctement cette saisie. De même, le code 2 est attendu pour le test du fichier de configuration manquant.

## Résultats des tests

Les résultats viennent des rapports et des essais réalisés sur la VM. Le code de retour a été affiché avec `echo $?` juste après les commandes. Le résultat du choix invalide a été confirmé après l'essai.

| Test | Commande ou action | Résultat obtenu | Code retour |
| --- | --- | --- | --- |
| T1 | `./audit.sh` | L'aide s'affiche avec les différentes options. | 1 |
| T2 | `./audit.sh --toto` | Le message « Option inconnue » et l'aide s'affichent. | 1 |
| T3 | `./audit.sh --system` | Le rapport contient le noyau, le temps depuis le démarrage, la mémoire, le disque et les cinq processus les plus gourmands. | 0 |
| T4 | `./audit.sh --network` | 127.0.0.1 répond et 192.0.2.10 ne répond pas. Le résumé indique 1 test réussi et 1 en échec. Seules les deux adresses sont testées. | 0 |
| T5 | `./audit.sh --all` | Le rapport contient les quatre sections. L'archive est créée et son contenu a été listé avec `tar -tzf` : le rapport est bien dedans. | 0 |
| T6 | Renommer temporairement targets.conf, puis lancer `./audit.sh --system` | Le message « config/targets.conf absent ou illisible » s'affiche. Le fichier a ensuite été remis à son nom d'origine. | 2 |
| T7 | `./audit.sh --interactive`, choix 2 | Le menu lance l'audit réseau avec 1 test réussi et 1 en échec. | 0 |
| T8 | `./audit.sh --interactive`, choix 9 | Le message « choix invalide » s'affiche et le script s'arrête. | 1 |
| T9 | `./audit.sh --network` | Le port 22 est indiqué « fermé ou filtré » pour les deux adresses. Les compteurs ping restent à 1 et 1. | 0 |
| Sécurité | Créer test_777, lui donner les droits 777, puis lancer `./audit.sh --security` | Le fichier est trouvé dans le rapport. Il a été supprimé après le test. | 0 |

## Vérification de l'archive

L'archive du dernier audit complet a été ouverte avec `tar -tzf`. Elle contient :

```text
audit_2026-10-29_23-32-55.txt
```

La lecture de l'archive renvoie le code 0.

## Vérification du fichier 777

Le fichier d'essai a été créé avec :

```bash
touch test_777
chmod 777 test_777
```

Après l'audit de sécurité, la recherche dans le rapport affiche :

```text
/home/yacine/Documents/audit-shell-project-main/test_777
```

Le fichier a ensuite été supprimé avec `rm -f test_777`.

## Bilan

Les essais donnent les résultats attendus pour les options, le réseau, le menu, l'archive et la détection du fichier 777. Le port 22 fermé ou filtré est un résultat normal du test.

