CREATE TABLE serveur (
    id_serveur INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

INSERT INTO serveur (nom) VALUES
('Njaka Rakoto'),
('Lalao Rasoa');

CREATE TABLE table_salle (
    id_table_salle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero INTEGER NOT NULL UNIQUE
);

INSERT INTO table_salle (numero)
SELECT generate_series(1, 8);

ALTER TABLE commande
ADD COLUMN id_serveur INTEGER REFERENCES serveur(id_serveur),
ADD COLUMN id_table_salle INTEGER REFERENCES table_salle(id_table_salle);

WITH c AS (
    SELECT id_commande, ROW_NUMBER() OVER (ORDER BY id_commande) AS n
    FROM commande
),
s AS (
    SELECT id_serveur, ROW_NUMBER() OVER (ORDER BY id_serveur) AS n
    FROM serveur
)
UPDATE commande AS cmd
SET id_serveur = s.id_serveur
FROM c
JOIN s ON s.n = ((c.n - 1) % 2) + 1
WHERE cmd.id_commande = c.id_commande;

ALTER TABLE commande
ALTER COLUMN id_serveur SET NOT NULL;

UPDATE commande
SET id_table_salle = (
    SELECT id_table_salle
    FROM table_salle
    WHERE numero = 1
)
WHERE id_commande = (
    SELECT MIN(id_commande)
    FROM commande
);

SELECT
    s.nom,
    COUNT(DISTINCT c.id_commande) AS nombre_commandes,
    COALESCE(SUM(l.quantite * p.prix), 0) AS chiffre_affaires
FROM serveur AS s
LEFT JOIN commande AS c ON c.id_serveur = s.id_serveur
LEFT JOIN ligne_commande AS l ON l.id_commande = c.id_commande
LEFT JOIN plat AS p ON p.id_plat = l.id_plat
GROUP BY s.id_serveur, s.nom;