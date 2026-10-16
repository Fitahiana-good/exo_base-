CREATE TABLE commande (
    id_commande INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_commande DATE NOT NULL
);

CREATE TABLE ligne_commande (
    id_commande INTEGER NOT NULL,
    id_plat INTEGER NOT NULL,
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_commande, id_plat),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_plat) REFERENCES plat(id_plat)
);

WITH nouvelles_commandes AS (
    INSERT INTO commande (date_commande)
    VALUES ('2026-10-16'), ('2026-10-17')
    RETURNING id_commande, date_commande
),
plats_a_commander AS (
    SELECT nc.id_commande, v.nom_plat, v.quantite
    FROM nouvelles_commandes AS nc
    JOIN (
        VALUES
            ('2026-10-16'::date, 'Romazava', 2),
            ('2026-10-16'::date, 'Ranon''ampango', 2),
            ('2026-10-17'::date, 'Mi sao', 1),
            ('2026-10-17'::date, 'Mofo gasy (les 4)', 3)
    ) AS v(date_commande, nom_plat, quantite)
        ON v.date_commande = nc.date_commande
)
INSERT INTO ligne_commande (id_commande, id_plat, quantite)
SELECT pac.id_commande, p.id_plat, pac.quantite
FROM plats_a_commander AS pac
JOIN plat AS p ON p.nom = pac.nom_plat;

SELECT
    c.id_commande,
    c.date_commande,
    COALESCE(SUM(lc.quantite * p.prix), 0) AS montant_total
FROM commande AS c
LEFT JOIN ligne_commande AS lc ON lc.id_commande = c.id_commande
LEFT JOIN plat AS p ON p.id_plat = lc.id_plat
GROUP BY c.id_commande, c.date_commande
ORDER BY c.id_commande;