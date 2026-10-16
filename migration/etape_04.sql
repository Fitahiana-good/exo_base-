CREATE TABLE client (
    id_client INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

INSERT INTO client (nom) VALUES
('Miora Randria'),
('Hery Rakoto');

ALTER TABLE commande
ADD COLUMN id_client INTEGER;

ALTER TABLE commande
ADD CONSTRAINT fk_commande_client
FOREIGN KEY (id_client) REFERENCES client(id_client);

UPDATE commande
SET id_client = (
    SELECT id_client
    FROM client
    WHERE nom = 'Miora Randria'
)
WHERE id_commande = (
    SELECT MIN(id_commande)
    FROM commande
);

SELECT
    c.id_commande,
    c.date_commande,
    COALESCE(cl.nom, 'client de passage') AS nom_client
FROM commande AS c
LEFT JOIN client AS cl ON cl.id_client = c.id_client
ORDER BY c.id_commande;