# Schéma relationnel — Gargote de Rado

## Niveau 1 — Étape 1 : la carte

### Table

**PLAT**(**id_plat**, nom, prix)

- `id_plat` : clé primaire, identifiant unique du plat.
- `nom` : nom du plat.
- `prix` : prix du plat, stocké en entier en ariary (sans centimes).


# Étape 2 — Les catégories

## Schéma relationnel après modification

- CATEGORIE(**id_categorie**, nom)
- PLAT(**id_plat**, nom, prix, #id_categorie)


# Étape 3 — Les commandes

## Schéma

- COMMANDE(**id_commande**, date_commande)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite)

# Étape 4 — Les habitués

## Schéma

- CLIENT(**id_client**, nom)
- COMMANDE(**id_commande**, date_commande, #id_client?)
