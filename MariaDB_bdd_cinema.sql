--connexion au serveur MySQL/MariaDB en ligne de commandes
-- mysql -h localhost -u root -p

--effacer la bdd si existante
DROP DATABASE IF EXISTS bdd_cinema;

--creation de la Database
CREATE DATABASE IF NOT EXISTS bdd_cinema;

--selectionner la bdd voulue
USE bdd_cinema;

--creations des tables
--SECURITE moteur de stockage transactionnel InnoDB

CREATE TABLE IF NOT EXISTS client(
    id_client INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nom_client VARCHAR(50) NOT NULL,
    date_naissance_client DATE NOT NULL,
    email_client VARCHAR(254) UNIQUE NOT NULL,
    password_client VARCHAR(60) NOT NULL
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS categorie_tarif (
    id_categorie_tarif INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    type_categorie_tarif VARCHAR(50) NOT NULL,
    prix_categorie_tarif DECIMAL(4,2) NOT NULL
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cinema(
    id_cinema INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_cinema VARCHAR(50) NOT NULL,
    telephone_cinema VARCHAR(15) NOT NULL,
    adresse_cinema VARCHAR(100) NOT NULL,
    CP_cinema VARCHAR(5) NOT NULL,
    ville_cinema VARCHAR(50) NOT NULL
) engine=InnoDB DEFAULT CHARSET=utf8mb4; 

CREATE TABLE IF NOT EXISTS roles(
    id_roles INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    type_roles VARCHAR(50) NOT NULL
) engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS personnel(
    id_personnel INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_personnel VARCHAR(50)NOT NULL,
    code_personnel INT UNIQUE NOT NULL,
    roles_id INT(11) NOT NULL,
    FOREIGN KEY (roles_id) REFERENCES roles(id_roles) 
) engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS employer(
    cinema_id INT(11) NOT NULL,
    personnel_id INT(11) NOT NULL,
    PRIMARY KEY (cinema_id, personnel_id),
    FOREIGN KEY (cinema_id) REFERENCES cinema (id_cinema),
    FOREIGN KEY (personnel_id) REFERENCES personnel (id_personnel)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salle(
    id_salle INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    numero_salle INT(11) NOT NULL,
    capacite_salle INT(11) NOT NULL,
    cinema_id INT(11) NOT NULL,
    FOREIGN KEY (cinema_id) REFERENCES cinema (id_cinema)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS genre(
    id_genre INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_genre VARCHAR(50) NOT NULL
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS paiement(
    id_paiement INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    methode_paiement VARCHAR(50) NOT NULL,
    moyen_paiement VARCHAR(50) NOT NULL
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS film(
    id_film INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    titre_film VARCHAR(50) NOT NULL,
    description_film TEXT NOT NULL,
    genre_id INT(11) NOT NULL,
    FOREIGN KEY (genre_id) REFERENCES genre (id_genre)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seance(
    id_seance INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    date_seance DATE NOT NULL,
    horaire_seance TIME NOT NULL,
    salle_id INT(11) NOT NULL,
    film_id INT(11) NOT NULL,
    FOREIGN KEY (salle_id) REFERENCES salle (id_salle),
    FOREIGN KEY (film_id) REFERENCES film (id_film)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS reservation_ticket(
    id_reservation_ticket INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    date_reservation_ticket DATE NOT NULL,
    quantite_reservation_ticket INT NOT NULL,
    seance_id INT(11) NOT NULL,
    client_id INT(11) NOT NULL,
    categorie_tarif_id INT(11) NOT NULL,
    FOREIGN KEY (seance_id) REFERENCES seance (id_seance),
    FOREIGN KEY (client_id) REFERENCES client (id_client),
    FOREIGN KEY (categorie_tarif_id) REFERENCES categorie_tarif (id_categorie_tarif)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS est_paye(
    reservation_ticket_id INT(11) NOT NULL,
    paiement_id INT(11) NOT NULL,
    date_paiement_est_paye DATE NOT NULL,
    PRIMARY KEY (reservation_ticket_id, paiement_id),
    FOREIGN KEY (reservation_ticket_id) REFERENCES reservation_ticket (id_reservation_ticket),
    FOREIGN KEY (paiement_id) REFERENCES paiement (id_paiement)
)engine=InnoDB DEFAULT CHARSET=utf8mb4;

--regarder ses tables--
SHOW TABLES;

--SECURITE password hashe by Bcrypt   
--insertion de valeurs fictives dans les tables via Mockaroo
INSERT INTO bdd_cinema.client(nom_client, date_naissance_client, email_client, password_client)   
VALUES('Bassingham', '2005-01-15', 'dbassingham0@rakuten.co.jp', '$2y$10$/c.eOiVhKPqZCL6NaihhQusOQkYFGQ4KDsrAon94ejR4wQwfN9T5u'),
      ('Sangster', '1954-04-25', 'dsangster1@ibm.com', '$2y$10$Qa./pxs4qvxB.BKgq.42vO56r/6Xwr3Xi28iRq92lrd4mSCDIRPTK'),
      ('Gracey', '1993-05-14', 'ngracey2@surveymonkey.com', '$2y$10$foVwzcpq4w0X9Qxa9Yxr2.43bfHPXI.BxXOYL1YWiWSF/H6Ig0lIK'),
      ('Cornels', '1966-02-07', 'jcornels3@comcast.net', '$2y$10$Niw52eVRAcloLkgRgfRZYuV2qpAL0l6fWPY97nXsgUuo32gr.gSvi'),
      ('Grewcock', '2004-03-10', 'ngrewcock4@shareasale.com', '$2y$10$7dEKhd.puAAsSIJOiF17w.Wqz9g8/Jq3h/4dMeq9vbTkcX9wrBX7a'),
      ('Blanning', '1969-10-17', 'iblanning5@youtube.com', '$2y$10$gyYkZYkxTTG8ROR2Y.ff9uWYkALxJ1JsS///h6SAdn0q.5SOrXmKK'),
      ('Griffitts', '1985-11-07', 'egriffitts6@usatoday.com', '$2y$10$RXWGrKAG9khYwYiODetV1uTWvdES3bNzYA.TmGHriNzA5r7E.hVJ2'),
      ('Christofe', '1999-02-09', 'achristofe7@reference.com', '$2y$10$8BiJa0OBvWhGTxvkDliVs.EQT.snq736hoi6AjfTHkZwq9GWUOdRW'),
      ('Goulston', '1973-03-02', 'mgoulston8@arstechnica.com', '$2y$10$3g7V8Rqlm4l0szQoUuK7M.gM26XDOwWqvXheo9ZHovJj1LsL4t2wa'),
      ('Merrien', '1981-12-02', 'nmerrien9@ebay.com', '$2y$10$mTF90JAAgXRVTEYnYJMGz.pMf54K7NU0ombTtrRlKk.ayG1MsXziW');

INSERT INTO bdd_cinema.categorie_tarif(type_categorie_tarif, prix_categorie_tarif)
VALUES('plein tarif', 9.20),
      ('etudiant', 7.60),
      ('enfant -14ans', 5.90);

INSERT INTO bdd_cinema.cinema(nom_cinema, telephone_cinema, adresse_cinema, CP_cinema, ville_cinema)
VALUES('Cinemax', '01.23.45.67.89', 'Rue du theatre', '74000', 'annecy'),
      ('MaxiCiné', '01.02.03.04.05', 'avenue du cinema', '74200', 'thonon'),
      ('Ciné le cercle', '06.05.04.03.02', 'rue du centre', '74210', 'allinges'),
      ('Cinemini', '01.03.05.07.09', 'rue du devant', '74250', 'ville-en-sallaz'),
      ('Gaumont', '02.20.33.01.11', 'centre du rêve', '74140', 'archamps');

INSERT INTO bdd_cinema.roles(type_roles)
VALUES('utilisateurs'),
      ('administrateur');

INSERT INTO bdd_cinema.personnel(nom_personnel, code_personnel, roles_id)
VALUES('Stevana', '6911', 1),
      ('Herc', '5719', 1),
      ('Anna', '7084', 1),
      ('Flor', '2244', 2),
      ('Mercy', '6557', 1),
      ('Hayley', '1587', 1),
      ('Barnebas', '9141', 1),
      ('Eugenia', '2977', 2),
      ('Waldon', '0975', 2),
      ('Colan', '9669', 1),
      ('Lilias', '4178', 2),
      ('Blinni', '4260', 1),
      ('Dennison', '6809', 1),
      ('Bartolemo', '8792', 1),
      ('Ashbey', '5043', 2),
      ('Novelia', '7931', 1),
      ('Holly-anne', '7083', 1),
      ('Dominique', '6069', 1),
      ('Elfreda', '3518', 2),
      ('Mureil', '2650', 1);

INSERT INTO bdd_cinema.salle(numero_salle, capacite_salle, cinema_id)
VALUES(1, 38, 1),
      (2, 30, 1),
      (3, 96, 1),
      (4, 76, 1),
      (5, 71, 2),
      (6, 57, 2),
      (7, 62, 2),
      (8, 88, 2),
      (9, 53, 3),
      (10, 97, 3),
      (11, 59, 3),
      (12, 83, 3),
      (13, 45, 4),
      (14, 50, 4),
      (15, 67, 4),
      (16, 86, 4),
      (17, 72, 5),
      (18, 53, 5),
      (19, 65, 5),
      (20, 76, 5);       

INSERT INTO bdd_cinema.employer(cinema_id, personnel_id)
VALUES(1, 1),
      (1, 2),
      (1, 3),
      (1, 4),
      (2, 5),
      (2, 6),
      (2, 7),
      (2, 8),
      (3, 9),
      (3, 10),
      (3, 11),
      (3, 12),
      (4, 13),
      (4, 14),
      (4, 15),
      (4, 16),
      (5, 17),
      (5, 18),
      (5, 19),
      (5, 20);

INSERT INTO bdd_cinema.genre(nom_genre)
VALUES('animation'),
      ('action'),
      ('comedie'),
      ('dramatique'),
      ('documentaire');

INSERT INTO bdd_cinema.paiement(methode_paiement, moyen_paiement)
VALUES('sur place', 'CB'),
      ('sur place', 'cheque'),
      ('sur place', 'espece'),
      ('en ligne', 'CB');

INSERT INTO bdd_cinema.film (titre_film, description_film, genre_id )   
VALUES('See You in Hell', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 1),
      ('Rita, Sue and Bob Too!', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', 2),
      ('Romasanta: The Werewolf Hunt', 'Etiam faucibus cursus urna.', 3),
      ('World War II: When Lions Roared', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3),
      ('Polite People (Kurteist fólk)', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 4),
      ('Love Guru, The', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 5);    

INSERT INTO bdd_cinema.seance(horaire_seance, date_seance, salle_id, film_id)   
VALUES('10:30:00', '2022-02-21', 13, 1),
      ('14:30:00', '2022-02-21', 20, 1),
      ('20:30:00', '2022-02-21', 9, 1),
      ('14:30:00', '2021-12-07', 7, 2),
      ('14:30:00', '2021-12-07', 12, 2),
      ('20:30:00', '2021-12-07', 8, 2),
      ('20:30:00', '2021-12-12', 1, 3),
      ('20:30:00', '2021-12-12', 10, 3),
      ('20:30:00', '2021-12-12', 13, 3),
      ('14:30:00', '2021-12-12', 16, 4),
      ('20:30:00', '2021-12-06', 4, 4),
      ('10:30:00', '2021-12-06', 14, 4),
      ('10:30:00', '2021-12-06', 2, 5),
      ('14:30:00', '2021-12-06', 5, 5),
      ('10:30:00', '2021-12-06', 19,5),
      ('20:30:00', '2021-12-19', 20, 6),
      ('20:30:00', '2021-12-19', 19, 6),
      ('14:30:00', '2021-12-19', 4, 6);
      
INSERT INTO bdd_cinema.reservation_ticket(date_reservation_ticket, quantite_reservation_ticket, seance_id, client_id, categorie_tarif_id)
VALUES('2022-02-19', 2, 1, 1, 1),
      ('2022-02-21', 4, 3, 2, 1),
      ('2022-01-20', 1, 5, 3, 3),
      ('2022-01-20', 1, 5, 3, 3),
      ('2022-01-20', 2, 6, 4, 2),
      ('2022-01-20', 1, 8, 5, 1),
      ('2022-01-20', 2, 9, 6, 1),      
      ('2022-01-20', 1, 10, 7, 1),
      ('2022-01-20', 2, 15, 8, 2),
      ('2022-01-20', 1, 16, 9, 3),
      ('2022-01-20', 2, 7, 10, 2);

INSERT INTO bdd_cinema.est_paye(reservation_ticket_id, paiement_id, date_paiement_est_paye)      
VALUES(1, 4, '2022-02-19'),
      (2, 1, '2022-02-21'),
      (1, 3, '2022-01-20');

--verification CRUD
--Afficher toutes les séances du jour d'un cinema
SELECT seance.date_seance AS 'date de la séance',
       film.titre_film AS 'nom du film',
       genre.nom_genre AS 'genre du film',
       salle.id_salle AS 'salle de projection',
       cinema.nom_cinema AS 'cinema'
FROM seance
JOIN film ON seance.film_id = film.id_film
JOIN genre ON film.genre_id = genre.id_genre
JOIN salle ON seance.salle_id = salle.id_salle
JOIN cinema ON salle.cinema_id = cinema.id_cinema
WHERE cinema.nom_cinema = 'cinemax' and seance.date_seance = '20220221'
ORDER BY seance.date_seance;

--Affiche le passage d'un même film au même horaire dans plusieurs salles
SELECT film.titre_film AS 'Titre du film',
       seance.horaire_seance AS 'Horaire séance',
       seance.date_seance AS 'Date de la séance',
       cinema.nom_cinema AS 'Cinéma'
FROM seance
JOIN salle ON seance.salle_id = salle.id_salle
JOIN film ON seance.film_id = film.id_film
JOIN cinema ON salle.cinema_id = cinema.id_cinema
ORDER BY film.titre_film;    

--Possibilité de réserver dans plusieurs cinema
SELECT reservation_ticket.id_reservation_ticket AS 'Numéro de réservation',
        client.nom_client AS'Nom du client',
        seance.date_seance AS 'Date de la séance',
        cinema.nom_cinema AS 'Cinéma',
        salle.id_salle AS 'N° de la salle'
FROM reservation_ticket
JOIN seance ON reservation_ticket.seance_id = seance.id_seance
JOIN client ON reservation_ticket.client_id = client.id_client
JOIN salle ON seance.salle_id = salle.id_salle
JOIN cinema ON salle.cinema_id = cinema.id_cinema
WHERE client.nom_client = 'Bassingham'         
  OR client.nom_client = 'Sangster'
  OR client.nom_client = 'Gracey'
ORDER BY client.nom_client;

--Affiche le nb de place disponible dans une salle pour une séance
SELECT cinema.nom_cinema AS 'Cinema',
       seance.id_seance AS 'N° séance',
       CONCAT(seance.date_seance, ' ', seance.horaire_seance) AS 'Date et heure de la séance',
       salle.id_salle AS 'N° de la salle',
       salle.capacite_salle AS 'Nombre de places dans la salle',
       COUNT(reservation_ticket.id_reservation_ticket) AS 'Nombre de réservations',
       salle.capacite_salle - COUNT(reservation_ticket.id_reservation_ticket) AS 'Nombre de places disponibles'
FROM reservation_ticket
JOIN seance ON reservation_ticket.seance_id = seance.id_seance 
JOIN salle ON seance.salle_id = salle.id_salle
JOIN cinema ON salle.cinema_id = cinema.id_cinema
WHERE seance.id_seance = 3;

--Affiche la liste des tarifs
SELECT * FROM categorie_tarif;

--Affiche les administrateurs 
SELECT employer.personnel_id AS 'code personnel',
       roles.type_roles AS 'rôle',
       employer.cinema_id AS 'Identifiant cinema',
       cinema.nom_cinema AS 'Nom du cinema'
FROM employer
JOIN personnel ON employer.personnel_id = personnel.id_personnel
JOIN roles ON personnel.roles_id = roles.id_roles
JOIN cinema ON employer.cinema_id = cinema.id_cinema
WHERE roles.id_roles = 2;

--Création de l'administrateur et de l'utilisateur
CREATE USER 'admin'@'%' IDENTIFIED BY 'Motdepasse123!';
GRANT ALL PRIVILEGES ON bdd_cinema.* TO 'admin'@'%';
FLUSH PRIVILEGES;

CREATE USER 'user'@'%' IDENTIFIED BY 'Motdepasse321*';
GRANT SELECT ON bdd_cinema.* TO 'user'@'%';
FLUSH PRIVILEGES;

--////////A FAIRE/////////
--GitHub => 
--Sauvegarde de la Base de données
