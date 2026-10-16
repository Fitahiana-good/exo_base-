-- 1. Créer la table des catégories
CREATE TABLE categorie (
    id_categorie INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO categorie (nom) VALUES
('Plat malagasy'),
('Plat chinois'),
('Soupe'),
('Dessert et goûter'),
('Boisson');


ALTER TABLE plat
ADD COLUMN id_categorie INTEGER;


UPDATE plat AS p
SET id_categorie = c.id_categorie
FROM categorie AS c
WHERE c.nom = CASE p.nom
    WHEN 'Romazava' THEN 'Plat malagasy'
    WHEN 'Ravitoto sy henakisoa' THEN 'Plat malagasy'
    WHEN 'Akoho sy voanio' THEN 'Plat malagasy'
    WHEN 'Mi sao' THEN 'Plat chinois'
    WHEN 'Soupe chinoise' THEN 'Soupe'
    WHEN 'Mofo gasy (les 4)' THEN 'Dessert et goûter'
    WHEN 'Ranon''ampango' THEN 'Boisson'
END;

ALTER TABLE plat
ALTER COLUMN id_categorie SET NOT NULL;

ALTER TABLE plat
ADD CONSTRAINT fk_plat_categorie
FOREIGN KEY (id_categorie)
REFERENCES categorie(id_categorie);