-- IZRADA BAZE PODATAKA

DROP DATABASE IF EXISTS tvrtka_za_najam_vozila;
CREATE DATABASE tvrtka_za_najam_vozila;
USE tvrtka_za_najam_vozila;

-- STVARANJE TABLICA

CREATE TABLE pravna_osoba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    identifikacijski_broj VARCHAR(25) NOT NULL,
    drzava_sjediste VARCHAR(47) NOT NULL,
    grad_sjediste VARCHAR(100) NOT NULL,
    adresa_sjediste VARCHAR(100) NOT NULL
);

CREATE TABLE klijent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    identifikacijski_broj VARCHAR(13) NOT NULL,
    id_pravna_osoba INT,
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba(id)
);

CREATE TABLE zanimanje (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    opis_zanimanja VARCHAR(TEXT) NOT NULL,
    odjel VARCHAR(50) NOT NULL
);

CREATE TABLE zaposlenik (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_nadredeni_zaposlenik MEDIUMINT,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    identifikacijski_broj VARCHAR(15) NOT NULL,
    drzava_radno_mjesto VARCHAR(47) NOT NULL,
    grad_radno_mjesto VARCHAR(100) NOT NULL,
    adresa_radno_mjesto VARCHAR(100) NOT NULL,
    spol VARCHAR(1) NOT NULL,
    broj_telefona VARCHAR(20),
    broj_mobitela VARCHAR(20),
    email VARCHAR(320) UNIQUE,
    id_zanimanje SMALLINT,
    FOREIGN KEY (id_nadredeni_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje(id)
);

CREATE TABLE kontakt_klijenta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(320) UNIQUE,
    broj_mobitela VARCHAR(20),
    broj_telefona VARCHAR(20),
    id_klijent INT,
    FOREIGN KEY (id_klijent) REFERENCES klijent(id)
);

CREATE TABLE prihod (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    opis TEXT,
    tip_prihoda VARCHAR(25)
);

CREATE TABLE transakcija (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    datum DATE,
    iznos DECIMAL(12, 2),
    broj_racuna VARCHAR(7),
    placeno DECIMAL (12, 2)
);

CREATE TABLE prihod_za_zaposlenika (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datum DATE,
    id_zaposlenik MEDIUMINT,
    id_transakcija_prihoda INT,
    id_prihod TINYINT,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_transakcija_prihoda) REFERENCES transakcija(id),
    FOREIGN KEY (id_prihod) REFERENCES prihod(id)
);

CREATE TABLE popust (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    tip_popusta VARCHAR(40)
);

CREATE TABLE popust_za_klijenta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datum_primitka DATE,
    datum_koristenja DATE,
    status VARCHAR(10),
    id_klijent INT,
    id_popust INT,
    FOREIGN KEY (id_klijent) REFERENCES klijent(id),
    FOREIGN KEY (id_popust) REFERENCES popust(id)
);

CREATE TABLE poslovni_trosak (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_poslovnog_troska BIGINT,
    svrha VARCHAR(40),
    opis TEXT,
    FOREIGN KEY (id_transakcija_poslovnog_troska) REFERENCES transakcija(id)
);

CREATE TABLE gotovinsko_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_gotovina BIGINT,
    FOREIGN KEY (id_transakcija_gotovina) REFERENCES transakcija(id)
);

CREATE TABLE karticno_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tip_kartice VARCHAR(20),
    id_pravna_osoba_banka MEDIUMINT,
    id_transakcija_kartica BIGINT,
    FOREIGN KEY (id_pravna_osoba_banka) REFERENCES pravna_osoba(id),
    FOREIGN KEY (id_transakcija_kartica) REFERENCES transakcija(id)
);

CREATE TABLE kriptovalutno_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    kriptovaluta VARCHAR(50),
    broj_kripto_novcanika VARCHAR(60),
    id_transakcija_kripto BIGINT,
    FOREIGN KEY (id_transakcija_kripto) REFERENCES transakcija(id)
);

CREATE TABLE kontakt_pravne_osobe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(320) UNIQUE,
    broj_mobitela VARCHAR(20),
    broj_telefona VARCHAR(20),
    opis VARCHAR(100),
    id_pravna_osoba MEDIUMINT,
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba(id)
);

CREATE TABLE vozilo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    godina_proizvodnje CHAR (4),
    registracijska_tablica VARCHAR(15),
    tip_punjenja VARCHAR(10)
);

CREATE TABLE najam_vozila (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_najam BIGINT,
    id_klijent_najam INT,
    id_zaposlenik_najam MEDIUMINT,
    id_vozilo INT,
    datum_pocetka DATE,
    datum_zavrsetka DATE,
    status VARCHAR(15),
    pocetna_kilometraza DECIMAL (10, 2),
    zavrsna_kilometraza DECIMAL (10, 2),
    FOREIGN KEY (id_transakcija_najam) REFERENCES transakcija(id),
    FOREIGN KEY (id_klijent_najam) REFERENCES klijent(id),
    FOREIGN KEY (id_zaposlenik_najam) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE serija_auto_kamion (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100),
    proizvodac VARCHAR(40),
    najveca_brzina SMALLINT,
    konjska_snaga SMALLINT,
    tip_mjenjaca VARCHAR(10),
    broj_vrata TINYINT
);

CREATE TABLE automobil (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_auto_kamion SMALLINT,
    id_vozilo MEDIUMINT,
    duljina DECIMAL(3, 2),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE serija_motocikl (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100),
    proizvodac VARCHAR(40),
    najveca_brzina SMALLINT,
    konjska_snaga SMALLINT,
    broj_sjedala CHAR (1)
);

CREATE TABLE motocikl (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_motocikl SMALLINT,
    id_vozilo MEDIUMINT,
    duljina DECIMAL(3, 2),
    FOREIGN KEY (id_serija_motocikl) REFERENCES serija_motocikl(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE kamion (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_auto_kamion SMALLINT,
    id_vozilo MEDIUMINT,
    duljina DECIMAL(4, 2),
    visina DECIMAL(3, 2),
    nosivost DECIMAL(5, 2),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE slika_automobila (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_automobil MEDIUMINT,
    slika VARBINARY (8000),
    pozicija VARCHAR(30),
    FOREIGN KEY (id_automobil) REFERENCES automobil(id)
);

CREATE TABLE slika_kamiona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_kamion MEDIUMINT,
    slika VARBINARY (8000),
    pozicija VARCHAR(30),
    FOREIGN KEY (id_kamion) REFERENCES kamion(id)
);

CREATE TABLE slika_motora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_motocikl MEDIUMINT,
    slika VARBINARY (8000),
    pozicija VARCHAR(30),
    FOREIGN KEY (id_motocikl) REFERENCES motocikl(id)
);

CREATE TABLE osiguranje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_osiguravacka_kuca MEDIUMINT,
    id_vozilo MEDIUMINT,
    id_transakcija BIGINT,
    datum_pocetka DATE,
    datum_zavrsetka DATE,
    tip_osiguranja VARCHAR(20),
    FOREIGN KEY (id_osiguravacka_kuca) REFERENCES pravna_osoba(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id),
    FOREIGN KEY (id_transakcija) REFERENCES transakcija(id)
);

CREATE TABLE steta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tip VARCHAR(7),
    opis TEXT
);

CREATE TABLE naknada_stete (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datum_pocetka DATE,
    datum_zavrsetka DATE,
    id_transakcija BIGINT,
    id_osiguranje INT,
    id_steta INT,
    FOREIGN KEY (id_transakcija) REFERENCES transakcija(id),
    FOREIGN KEY (id_osiguranje) REFERENCES osiguranje(id),
    FOREIGN KEY (id_steta) REFERENCES steta(id)
);

CREATE TABLE punjenje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_punjenje BIGINT,
    id_vozilo MEDIUMINT,
    kolicina DECIMAL(7, 3),
    tip_punjenja VARCHAR(10),
    FOREIGN KEY (id_transakcija_punjenje) REFERENCES transakcija(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE odrzavanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tip VARCHAR(100),
    id_zaposlenik MEDIUMINT,
    id_transakcija_odrzavanje BIGINT,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_transakcija_odrzavanje) REFERENCES transakcija(id)
);

CREATE TABLE rezervacija (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    datum_rezervacije DATE,
    datum_potvrde DATE,
    id_klijent INT,
    FOREIGN KEY (id_klijent) REFERENCES klijent(id)
);

CREATE TABLE oprema (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(30),
    opis TEXT
);

CREATE TABLE oprema_na_najmu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_najam_vozila BIGINT,
    id_oprema INT,
    kolicina TINYINT,
    FOREIGN KEY (id_najam_vozila) REFERENCES najam_vozila(id),
    FOREIGN KEY (id_oprema) REFERENCES oprema(id)
);

CREATE TABLE oprema_na_rezervaciji (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_rezervacija BIGINT,
    id_oprema INT,
    kolicina TINYINT,
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id),
    FOREIGN KEY (id_oprema) REFERENCES oprema(id)
);

CREATE TABLE vozilo_na_rezervaciji (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_rezervacija BIGINT,
    id_vozilo MEDIUMINT,
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE crna_lista (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    id_klijent INT,
    razlog TEXT,
    FOREIGN KEY (id_klijent) REFERENCES klijent(id)
);

INSERT INTO vozilo VALUES -- Mirela
(1, '2018', 'ZG1234AB', 'Električno'),
(2, '2019', 'ST5678CD', 'Hibridno'),
(3, '2017', 'ZG9012EF', 'Benzin'),
(4, '2020', 'RI3456GH', 'Diesel'),
(5, '2018', 'OS7890IJ', 'Električno'),
(6, '2019', 'PU2345KL', 'Benzin'),
(7, '2023', 'DU6789MN', 'Hibridno'),
(8, '2020', 'KA1234OP', 'Diesel'),
(9, '2024', 'ZG5678QR', 'Električno'),
(10, '2022', 'ST9012RS', 'Benzin'),
(11, '2021', 'ZG3456TU', 'Hibridno'),
(12, '2020', 'RI7890VW', 'Diesel'),
(13, '2018', 'OS1234XY', 'Električno'),
(14, '2019', 'PU5678ZA', 'Benzin'),
(15, '2010', 'DU9012BC', 'Hibridno'),
(16, '2020', 'KA3456DE', 'Diesel'),
(17, '2018', 'ZG7890FG', 'Električno'),
(18, '2023', 'ST1234HI', 'Benzin'),
(19, '2017', 'ZG5678JK', 'Hibridno'),
(20, '2020', 'RI9012LM', 'Diesel'),
(21, '2015', 'OS3456NO', 'Električno'),
(22, '2019', 'PU7890PQ', 'Benzin'),
(23, '2017', 'DU1234RS', 'Hibridno'),
(24, '2020', 'KA5678TU', 'Diesel'),
(25, '2018', 'ZG9012VW', 'Električno'),
(26, '2019', 'ST3456XY', 'Benzin'),
(27, '2017', 'ZG7890ZA', 'Hibridno'),
(28, '2022', 'RI1234BC', 'Diesel'),
(29, '2018', 'OS5678DE', 'Električno'),
(30, '2019', 'PU9012FG', 'Benzin');

INSERT INTO najam_vozila VALUES -- Mirela
(1, 20, 14, 9, 17, '2024-05-01', '2024-05-10', 'Aktivan', 1000.00, 1200.00),
(2, 3, 10, 25, 5, '2024-05-02', '2024-05-11', 'Aktivan', 900.00, 1100.00),
(3, 12, 1, 25, 23, '2024-05-03', '2024-05-12', 'Aktivan', 1100.00, 1300.00),
(4, 27, 28, 2, 13, '2024-05-04', '2024-05-13', 'Neaktivan', 950.00, 1150.00),
(5, 8, 21, 16, 29, '2024-05-05', '2024-05-14', 'Neaktivan', 1050.00, 1250.00),
(6, 26, 6, 12, 30, '2024-05-06', '2024-05-15', 'Aktivan', 980.00, 1180.00),
(7, 15, 5, 19, 21, '2024-05-07', '2024-05-16', 'Neaktivan', 1150.00, 1350.00),
(8, 7, 22, 7, 8, '2024-05-08', '2024-05-17', 'Aktivan', 1020.00, 1220.00),
(9, 18, 29, 7, 14, '2024-05-09', '2024-05-10', 'Aktivan', 1080.00, 1280.00),
(10, 9, 4, 24, 28, '2024-05-10', '2024-05-12', 'Aktivan', 1005.00, 1205.00),
(11, 11, 7, 23, 24, '2024-05-11', '2024-05-12', 'Aktivan', 950.00, 1150.00),
(12, 28, 17, 11, 3, '2024-05-12', '2024-05-14', 'Aktivan', 970.00, 1170.00),
(13, 1, 2, 30, 4, '2024-05-13', '2024-05-22', 'Aktivan', 990.00, 1190.00),
(14, 23, 7, 14, 15, '2024-05-14', '2024-05-16', 'Aktivan', 1025.00, 1225.00),
(15, 5, 8, 7, 22, '2024-05-15', '2024-05-18', 'Aktivan', 975.00, 1175.00),
(16, 13, 15, 1, 22, '2024-05-16', '2024-05-20', 'Aktivan', 1030.00, 1230.00),
(17, 19, 7, 5, 18, '2024-05-17', '2024-05-20', 'Neaktivan', 1015.00, 1215.00),
(18, 6, 30, 28, 2, '2024-05-18', '2024-05-19', 'Aktivan', 980.00, 1180.00),
(19, 25, 19, 6, 22, '2024-05-19', '2024-05-28', 'Aktivan', 1100.00, 1300.00),
(20, 22, 9, 26, 19, '2024-05-20', '2024-05-29', 'Aktivan', 960.00, 1160.00),
(21, 4, 24, 27, 7, '2024-05-21', '2024-05-30', 'Aktivan', 1000.00, 1200.00),
(22, 14, 18, 10, 7, '2024-05-22', '2024-05-31', 'Aktivan', 1035.00, 1235.00),
(23, 30, 16, 13, 20, '2024-05-23', '2024-06-01', 'Aktivan', 990.00, 1190.00),
(24, 10, 11, 8, 7, '2024-05-24', '2024-06-02', 'Aktivan', 1020.00, 1220.00),
(25, 17, 13, 15, 1, '2024-05-25', '2024-06-03', 'Aktivan', 980.00, 1180.00),
(26, 24, 27, 9, 11, '2024-05-26', '2024-06-04', 'Aktivan', 1005.00, 1205.00),
(27, 2, 26, 4, 27, '2024-05-27', '2024-06-05', 'Neaktivan', 1050.00, 1250.00),
(28, 29, 3, 12, 30, '2024-05-28', '2024-06-06', 'Neaktivan', 970.00, 1170.00),
(29, 21, 20, 17, 9, '2024-05-29', '2024-06-07', 'Aktivan', 1025.00, 1225.00),
(30, 16, 22, 2, 6, '2024-05-30', '2024-06-08', 'Aktivan', 1000.00, 1200.00);

INSERT INTO klijent (id, ime, prezime, identifikacijski_broj, id_pravna_osoba) VALUES -- Mirela
(1, 'Luka', 'Novosel', '1234567890123', 1),
(2, 'Ana', 'Kovačević', '2345678901234', 2),
(3, 'Ivan', 'Horvat', '3456789012345', 3),
(4, 'Petra', 'Marić', '4567890123456', 4),
(5, 'Marko', 'Pavić', '5678901234567', 5),
(6, 'Martina', 'Knežević', '6789012345678', 6),
(7, 'Nikola', 'Perić', '7890123456789', 7),
(8, 'Kristina', 'Jurić', '8901234567890', 8),
(9, 'Filip', 'Kovačić', '9012345678901', 9),
(10, 'Ivana', 'Šimunović', '0123456789012', 10),
(11, 'Ivo', 'Horvat', '9876543210987', 11),
(12, 'Maja', 'Petrović', '8765432109876', 12),
(13, 'Lucija', 'Novak', '7654321098765', 13),
(14, 'Matej', 'Šimić', '6543210987654', 14),
(15, 'Ana', 'Kovač', '5432109876543', 15),
(16, 'Petar', 'Ilić', '4321098765432', 16),
(17, 'Lana', 'Horvat', '3210987654321', 17),
(18, 'Ivan', 'Pavić', '2109876543210', 18),
(19, 'Marija', 'Kovačević', '1098765432109', 19),
(20, 'Ante', 'Marinović', '0987654321098', 20),
(21, 'Lucija', 'Perić', '9876543210987', 21),
(22, 'Matija', 'Knežević', '8765432109876', 22),
(23, 'Luka', 'Horvat', '7654321098765', 23),
(24, 'Iva', 'Pavić', '6543210987654', 24),
(25, 'Petra', 'Jurić', '5432109876543', 25),
(26, 'Ivan', 'Kovačić', '4321098765432', 26),
(27, 'Martina', 'Marinović', '3210987654321', 27),
(28, 'Nikola', 'Horvat', '2109876543210', 28),
(29, 'Elena', 'Novak', '1098765432109', 29),
(30, 'Roko', 'Knežević', '0987654321098', 30);

INSERT INTO kontakt_klijenta (id, email, broj_mobitela, broj_telefona, id_klijent) VALUES -- Mirela
(1, 'luka.novosel@gmail.com', '0987654321', '0123456789', 1),
(2, 'ana.kovacevic@gmail.com', '0912345678', '023456789', 2),
(3, 'ivan.horvat@gmail.com', '092345678', '034567890', 3),
(4, 'petra.maric@gmail.com', '093456789', '045678901', 4),
(5, 'marko.pavic@gmail.com', '094567890', '056789012', 5),
(6, 'martina.knezevic@gmail.com', '095678901', '067890123', 6),
(7, 'nikola.peric@gmail.com', '096789012', '078901234', 7),
(8, 'kristina.juric@gmail.com', '097890123', '089012345', 8),
(9, 'filip.kovacic@gmail.com', '098901234', '090123456', 9),
(10, 'ivana.simunovic@gmail.com', '099012345', '901234567', 10),
(11, 'ivo.horvat@gmail.com', '012345678', '912345678', 11),
(12, 'maja.petrovic@gmail.com', '123456789', '923456789', 12),
(13, 'lucija.novak@gmail.com', '234567890', '934567890', 13),
(14, 'matej.simic@gmail.com', '345678901', '945678901', 14),
(15, 'ana.kovac@gmail.com', '456789012', '956789012', 15),
(16, 'petar.ilic@gmail.com', '567890123', '967890123', 16),
(17, 'lana.horvat@gmail.com', '678901234', '978901234', 17),
(18, 'ivan.pavic@gmail.com', '789012345', '989012345', 18),
(19, 'marija.kovacevic@gmail.com', '890123456', '990123456', 19),
(20, 'ante.marinovic@gmail.com', '901234567', '001234567', 20),
(21, 'lucija.peric@gmail.com', '012345678', '012345678', 21),
(22, 'matija.knezevic@gmail.com', '123456789', '023456789', 22),
(23, 'luka.horvat@gmail.com', '234567890', '034567890', 23),
(24, 'iva.pavic@gmail.com', '345678901', '045678901', 24),
(25, 'petra.juric@gmail.com', '456789012', '056789012', 25),
(26, 'ivan.kovacic@gmail.com', '567890123', '067890123', 26),
(27, 'martina.marinovic@gmail.com', '678901234', '078901234', 27),
(28, 'nikola.horvat@gmail.com', '789012345', '089012345', 28),
(29, 'elena.novak@gmail.com', '890123456', '099012345', 29),
(30, 'roko.knezevic@gmail.com', '901234567', '109012345', 30);

INSERT INTO zaposlenik VALUES -- Mirela
(1, NULL, 'Ana', 'Horvat', 'AB123456789012', 'Hrvatska', 'Zagreb', 'Ilica 10', 'Ž', '0123456789', '0987654321', 'ana.horvat@gmail.com', 1),
(2, 1, 'Ivan', 'Kovačević', 'CD987654321098', 'Hrvatska', 'Zagreb', 'Trg Bana Jelačića 5', 'M', '023456789', '0912345678', 'ivan.kovacevic@gmail.com', 13),
(3, 1, 'Petra', 'Novak', 'EF456789012345', 'Hrvatska', 'Zagreb', 'Knez Mislav 2', 'Ž', '034567890', '092345678', 'petra.novak@gmail.com', 9),
(4, NULL, 'Marko', 'Petrović', 'GH321098765432', 'Hrvatska', 'Zagreb', 'Frankopanska 15', 'M', '045678901', '093456789', 'marko.petrovic@gmail.com', 4),
(5, 4, 'Ivana', 'Knežević', 'IJ789012345678', 'Hrvatska', 'Zagreb', 'Savska 7', 'Ž', '056789012', '094567890', 'ivana.knezevic@gmail.com', 12),
(6, 4, 'Luka', 'Šimunović', 'KL234567890123', 'Hrvatska', 'Zagreb', 'Petrova 20', 'M', '067890123', '095678901', 'luka.simunovic@gmail.com', 6),
(7, 4, 'Martina', 'Marić', 'MN890123456789', 'Hrvatska', 'Zagreb', 'Heinzelova 10', 'Ž', '078901234', '096789012', 'martina.maric@gmail.com', 3),
(8, NULL, 'Filip', 'Horvat', 'OP654321098765', 'Hrvatska', 'Zagreb', 'Trnavačka 25', 'M', '089012345', '097890123', 'filip.horvat@gmail.com', 5),
(9, 8, 'Sanja', 'Perić', 'QR901234567890', 'Hrvatska', 'Zagreb', 'Kvaternikov trg 3', 'Ž', '090123456', '098901234', 'sanja.peric@gmail.com', 2),
(10, 8, 'Ivan', 'Šimić', 'ST543210987654', 'Hrvatska', 'Zagreb', 'Selska 8', 'M', '901234567', '099012345', 'ivan.simic@gmail.com', 7),
(11, 8, 'Lucija', 'Tomljanović', 'UV012345678901', 'Hrvatska', 'Zagreb', 'Vlaška 12', 'Ž', '912345678', '012345678', 'lucija.tomljanovic@gmail.com', 10),
(12, NULL, 'Stjepan', 'Ilić', 'WX432109876543', 'Hrvatska', 'Zagreb', 'Jurja Križanića 17', 'M', '923456789', '123456789', 'stjepan.ilic@gmail.com', 28),
(13, 12, 'Maja', 'Jurić', 'YZ789012345678', 'Hrvatska', 'Zagreb', 'Radnička cesta 80', 'Ž', '934567890', '234567890', 'maja.juric@gmail.com', 14),
(14, 12, 'Matej', 'Horvat', 'ZA123456789012', 'Hrvatska', 'Zagreb', 'Avenija Dubrovnik 12', 'M', '945678901', '345678901', 'matej.horvat@gmail.com', 21),
(15, 12, 'Nina', 'Kovač', 'BC345678901234', 'Hrvatska', 'Zagreb', 'Zagrebačka avenija 100', 'Ž', '956789012', '456789012', 'nina.kovac@gmail.com', 18),
(16, NULL, 'Dario', 'Pavić', 'CD678901234567', 'Hrvatska', 'Zagreb', 'Jurišićeva 23', 'M', '967890123', '567890123', 'dario.pavic@gmail.com', 23),
(17, 16, 'Kristina', 'Jakovljević', 'EF901234567890', 'Hrvatska', 'Zagreb', 'Slavonska avenija 2', 'Ž', '978901234', '678901234', 'kristina.jakovljevic@gmail.com', 20),
(18, 16, 'Petra', 'Kovačević', 'GH123456789012', 'Hrvatska', 'Zagreb', 'Nova cesta 15', 'Ž', '989012345', '789012345', 'petra.kovacevic@gmail.com', 25),
(19, 16, 'Ante', 'Marković', 'IJ456789012345', 'Hrvatska', 'Zagreb', 'Gajeva 12', 'M', '990123456', '890123456', 'ante.markovic@gmail.com', 29),
(20, NULL, 'Marija', 'Novak', 'KL789012345678', 'Hrvatska', 'Zagreb', 'Ulica grada Vukovara 68', 'Ž', '001234567', '901234567', 'marija.novak@gmail.com', 17),
(21, 20, 'Igor', 'Vuković', 'MN012345678901', 'Hrvatska', 'Zagreb', 'Nova Ves 18', 'M', '012345678', '012345678', 'igor.vukovic@gmail.com', 8),
(22, 20, 'Lana', 'Pavlović', 'OP345678901234', 'Hrvatska', 'Zagreb', 'Savska cesta 30', 'Ž', '023456789', '123456789', 'lana.pavlovic@gmail.com', 11),
(23, 20, 'Matija', 'Marić', 'QR678901234567', 'Hrvatska', 'Zagreb', 'Heinzelova 25', 'M', '034567890', '234567890', 'matija.maric@gmail.com', 16),
(24, 23, 'Elena', 'Kovačić', 'ST901234567890', 'Hrvatska', 'Zagreb', 'Selska 18', 'Ž', '045678901', '345678901', 'elena.kovacic@gmail.com', 11),
(25, 23, 'Roko', 'Jurić', 'UV123456789012', 'Hrvatska', 'Zagreb', 'Vlaška 30', 'M', '056789012', '456789012', 'roko.juric@gmail.com', 19),
(26, 23, 'Ana', 'Pavić', 'WX345678901234', 'Hrvatska', 'Zagreb', 'Jurja Dobrile 5', 'Ž', '067890123', '567890123', 'ana.pavic@gmail.com', 27),
(27, 23, 'Iva', 'Horvat', 'YZ012345678901', 'Hrvatska', 'Zagreb', 'Prilaz baruna Filipovića 22', 'Ž', '078901234', '678901234', 'iva.horvat@gmail.com', 8),
(28, NULL, 'Robert', 'Knežević', 'AB345678901234', 'Hrvatska', 'Zagreb', 'Haulikova 3', 'M', '089012345', '789012345', 'robert.knezevic@gmail.com', 17),
(29, 28, 'Nikola', 'Perić', 'CD901234567890', 'Hrvatska', 'Zagreb', 'Kačićeva 7', 'M', '090123456', '901234567', 'nikola.peric@gmail.com', 26),
(30, 28, 'Ivana', 'Marić', 'EF123456789012', 'Hrvatska', 'Zagreb', 'Vlaška 35', 'Ž', '901234567', '012345678', 'ivana.maric@gmail.com', 24);

INSERT INTO transakcija (id, datum, iznos, broj_racuna, placeno) VALUES -- Mirela
(1, '2024-05-01', 150.00, 'ABC1234', 150.00),
(2, '2024-05-02', 200.50, 'DEF5678', 200.50),
(3, '2024-05-03', 75.25, 'GHI9012', 75.25),
(4, '2024-05-04', 100.00, 'JKL3456', 100.00),
(5, '2024-05-05', 300.75, 'MNO7890', 300.75),
(6, '2024-05-06', 50.50, 'PQR1234', 50.50),
(7, '2024-05-07', 90.00, 'STU5678', 90.00),
(8, '2024-05-08', 120.25, 'VWX9012', 120.25),
(9, '2024-05-09', 180.75, 'YZA3456', 180.75),
(10, '2024-05-10', 250.00, 'BCD7890', 250.00),
(11, '2024-05-11', 300.50, 'EFG1234', 300.50),
(12, '2024-05-12', 80.25, 'HIJ5678', 80.25),
(13, '2024-05-13', 150.75, 'KLM9012', 150.75),
(14, '2024-05-14', 200.00, 'NOP3456', 200.00),
(15, '2024-05-15', 95.50, 'QRS7890', 95.50),
(16, '2024-05-16', 130.25, 'TUV1234', 130.25),
(17, '2024-05-17', 175.75, 'WXY5678', 175.75),
(18, '2024-05-18', 220.00, 'ZAB9012', 220.00),
(19, '2024-05-19', 70.50, 'CDE3456', 70.50),
(20, '2024-05-20', 180.25, 'FGH7890', 180.25),
(21, '2024-05-21', 300.75, 'IJK1234', 300.75),
(22, '2024-05-22', 50.00, 'LMN5678', 50.00),
(23, '2024-05-23', 110.50, 'OPQ9012', 110.50),
(24, '2024-05-24', 260.25, 'RST3456', 260.25),
(25, '2024-05-25', 140.75, 'UVW7890', 140.75),
(26, '2024-05-26', 190.00, 'XYZ1234', 190.00),
(27, '2024-05-27', 85.50, 'ABC5678', 85.50),
(28, '2024-05-28', 200.25, 'DEF9012', 200.25),
(29, '2024-05-29', 150.75, 'GHI3456', 150.75),
(30, '2024-05-30', 220.00, 'JKL7890', 220.00);

INSERT INTO zanimanje (id, opis_zanimanja, odjel) VALUES -- Mirela
(1, 'Vozač kamiona', 'Vozači'),
(2, 'Administrator', 'Administracija'),
(3, 'Računovođa', 'Računovodstvo'),
(4, 'Vozač automobila', 'Vozači'),
(5, 'Tehničar za održavanje vozila', 'Održavanje vozila'),
(6, 'Agent za korisničku podršku', 'Korisnička podrška'),
(7, 'Marketing specijalist', 'Marketing'),
(8, 'Vozač motocikla', 'Vozači'),
(9, 'Upravitelj flote', 'Upravljanje flotom'),
(10, 'Specijalist za osiguranje vozila', 'Osiguranje'),
(11, 'Inženjer za razvoj softvera', 'Razvoj softvera'),
(12, 'Voditelj ljudskih resursa', 'Ljudski resursi'),
(13, 'Serviser vozila', 'Servis vozila'),
(14, 'Financijski analitičar', 'Financije'),
(15, 'Operativni menadžer', 'Operacije'),
(16, 'Vozač automobila', 'Vozači'),
(17, 'Električar za vozila', 'Električna vozila'),
(18, 'Serviser vozila', 'Servis vozila'),
(19, 'Pomoćnik prodaje vozila', 'Prodaja'),
(20, 'Koordinator događaja', 'Organizacija događaja'),
(21, 'Logistički koordinator', 'Logistika'),
(22, 'Tehničar za motocikle', 'Održavanje vozila'),
(23, 'Vozač automobila', 'Vozači'),
(24, 'Serviser vozila', 'Servis vozila'),
(25, 'Serviser vozila', 'Servis vozila'),
(26, 'Instruktor vožnje', 'Obuka'),
(27, 'Inspektor vozila', 'Kontrola kvalitete'),
(28, 'Koordinator korisničke podrške', 'Korisnička podrška'),
(29, 'Specijalist za osiguranje vozila', 'Osiguranje'),
(30, 'Posrednik za najam vozila', 'Prodaja');

INSERT INTO popust (id, tip_popusta) VALUES -- Mirela
(1, '10% popusta na najam vozila duži od 7 dana'),
(2, 'Besplatno osiguranje za najam vozila'),
(3, '25% popusta za rezervacije putem mobilne aplikacije'),
(4, 'Dodatni dan najma besplatno'),
(5, '20% popusta na dodatnu opremu vozila'),
(6, 'Gratis dječje sjedalo uz najam obiteljskog automobila'),
(7, 'Besplatna dostava i preuzimanje vozila na aerodromu'),
(8, '30% popusta za online rezervacije unaprijed'),
(9, 'Paket cestarine uključen u cijenu najma'),
(10, '15% popusta za studente'),
(11, 'Program vjernosti: svaki 5. najam besplatan'),
(12, 'Poklon kartica za sljedeći najam vozila'),
(13, 'Dodatni vozač besplatno'),
(14, '20% popusta za članove kluba vjernosti'),
(15, 'Besplatna nadogradnja vozila na veći model'),
(16, '25% popusta na najam u izvansezonskim mjesecima'),
(17, 'Poklon kartica za sljedeći najam vozila'),
(18, 'Dodatno osiguranje uključeno u cijenu najma'),
(19, 'Posebna ponuda za obitelji: drugo vozilo 50% popusta'),
(20, 'Gratis navigacija uz najam vozila'),
(21, 'Besplatno parkirno mjesto u centru grada za vrijeme najma'),
(22, 'Dodatni kilometri besplatno'),
(23, '15% popusta za vozače starije od 60 godina'),
(24, 'Poklon bon za sljedeći najam vozila'),
(25, '20% popusta na najam kombija za prijevoz tereta'),
(26, 'Dodatni popust za članove udruge vozača'),
(27, 'Besplatna pomoć na cesti 24/7'),
(28, 'Gratis dnevna najamka u slučaju kašnjenja s isporukom vozila'),
(29, '10% popusta na najam za vikend'),
(30, 'Posebna ponuda za firme: 30% popusta na korporativne rezervacije');


INSERT INTO popust_za_klijenta (id, datum_primitka, datum_koristenja, status, id_klijent, id_popust) VALUES -- Mirela
(1, '2024-05-01', '2024-05-10', 'iskorišten', 1, 22),
(2, '2024-05-02', NULL, 'aktivan', 2, 8),
(3, '2024-05-03', NULL, 'aktivan', 3, 4),
(4, '2024-05-04', '2024-05-15', 'iskorišten', 4, 18),
(5, '2024-05-05', NULL, 'aktivan', 5, 11),
(6, '2024-05-06', '2024-05-20', 'iskorišten', 6, 24),
(7, '2024-05-07', '2024-05-22', 'iskorišten', 7, 25),
(8, '2024-05-08', NULL, 'aktivan', 8, 17),
(9, '2024-05-09', NULL, 'aktivan', 9, 5),
(10, '2024-05-10', NULL, 'aktivan', 10, 6),
(11, '2024-05-11', NULL, 'aktivan', 11, 9),
(12, '2024-05-12', '2024-05-25', 'iskorišten', 12, 1),
(13, '2024-05-13', NULL, 'aktivan', 13, 2),
(14, '2024-05-14', NULL, 'aktivan', 14, 28),
(15, '2024-05-15', NULL, 'aktivan', 15, 20),
(16, '2024-05-16', NULL, 'aktivan', 16, 19),
(17, '2024-05-17', NULL, 'aktivan', 17, 26),
(18, '2024-05-18', NULL, 'aktivan', 18, 30),
(19, '2024-05-19', '2024-05-30', 'iskorišten', 19, 12),
(20, '2024-05-20', NULL, 'aktivan', 20, 13),
(21, '2024-05-21', '2024-06-01', 'iskorišten', 21, 3),
(22, '2024-05-22', NULL, 'aktivan', 22, 7),
(23, '2024-05-23', NULL, 'aktivan', 23, 21),
(24, '2024-05-24', NULL, 'aktivan', 24, 15),
(25, '2024-05-25', '2024-06-05', 'iskorišten', 25, 10),
(26, '2024-05-26', NULL, 'aktivan', 26, 27),
(27, '2024-05-27', NULL, 'aktivan', 27, 14),
(28, '2024-05-28', NULL, 'aktivan', 28, 16),
(29, '2024-05-29', NULL, 'aktivan', 29, 23),
(30, '2024-05-30', '2024-06-10', 'iskorišten', 30, 29);

INSERT INTO poslovni_trosak (id, id_transakcija_poslovnog_troska, svrha, opis) VALUES -- Mirela
(1, 1, 'Nabava uredskog materijala', 'Kupnja papira, olovaka i bilježnica'),
(2, 2, 'Trošak goriva', 'Plaćanje benzinske postaje za gorivo'),
(3, 3, 'Plaćanje usluge čišćenja', 'Čišćenje uredskih prostorija'),
(4, 4, 'Nabava računalne opreme', 'Kupnja novog računala i monitora'),
(5, 5, 'Trošak telekomunikacija', 'Plaćanje računa za mobilni i fiksni telefon'),
(6, 6, 'Održavanje web stranice', 'Plaćanje usluge održavanja web stranice'),
(7, 7, 'Nabava kancelarijskog namještaja', 'Kupnja stolica, stolova i ormara'),
(8, 8, 'Trošak električne energije', 'Plaćanje računa za električnu energiju'),
(9, 9, 'Osiguranje poslovnih prostorija', 'Plaćanje mjesečne premije osiguranja'),
(10, 10, 'Trošak marketinga', 'Plaćanje reklamne kampanje na društvenim mrežama'),
(11, 11, 'Nabava potrošnog materijala', 'Kupnja toalet papira, sapuna i slično'),
(12, 12, 'Trošak knjigovodstvenih usluga', 'Plaćanje knjigovođi za usluge vođenja poslovnih knjiga'),
(13, 13, 'Nabava kuhinjske opreme', 'Kupnja mikrovalne pećnice, hladnjaka i štednjaka'),
(14, 14, 'Trošak putovanja', 'Plaćanje putnih troškova za službeno putovanje'),
(15, 15, 'Održavanje vozila', 'Plaćanje servisa i popravaka za službeno vozilo'),
(16, 16, 'Nabava softverskih licenci', 'Kupnja licenci za poslovni softver'),
(17, 17, 'Trošak knjiga i edukacija', 'Plaćanje troškova za knjige i seminare zaposlenika'),
(18, 18, 'Nabava inventara', 'Kupnja inventara za opremanje novih prostorija'),
(19, 19, 'Trošak internet usluga', 'Plaćanje računa za internet usluge'),
(20, 20, 'Trošak dostave', 'Plaćanje usluge dostave materijala i proizvoda'),
(21, 21, 'Nabava radne odjeće', 'Kupnja uniformi za radnike'),
(22, 22, 'Trošak leasinga', 'Plaćanje mjesečnih rata za zakup vozila'),
(23, 23, 'Nabava alata', 'Kupnja alata za održavanje poslovnih prostorija'),
(24, 24, 'Trošak seminara', 'Plaćanje kotizacije za sudjelovanje na poslovnom seminaru'),
(25, 25, 'Nabava bilježaka', 'Kupnja blokova i bilježaka za sastanke i konferencije'),
(26, 26, 'Trošak rekreacije zaposlenika', 'Plaćanje članarine u teretani za zaposlenike'),
(27, 27, 'Nabava radnih materijala', 'Kupnja materijala za proizvodnju'),
(28, 28, 'Trošak godišnjeg odmora', 'Plaćanje troškova smještaja i putovanja za godišnji odmor'),
(29, 29, 'Nabava pribora za pisanje', 'Kupnja olovaka, markera i flomastera'),
(30, 30, 'Trošak osiguranja vozila', 'Plaćanje mjesečne premije osiguranja za vozila');

INSERT INTO prihod (id, opis, tip_prihoda) VALUES -- Mirela
(1, 'Redovna plaća', 'Plaća'),
(2, 'Redovna plaća', 'Plaća'),
(3, 'Bonus za rad tijekom praznika ili vikenda', 'Bonus'),
(4, 'Redovna plaća', 'Plaća'),
(5, 'Redovna plaća', 'Plaća'),
(6, 'Redovna plaća', 'Plaća'),
(7, 'Redovna plaća', 'Plaća'),
(8, 'Redovna plaća', 'Plaća'),
(9, 'Redovna plaća', 'Plaća'),
(10, 'Redovna plaća', 'Plaća'),
(11, 'Redovna plaća', 'Plaća'),
(12, 'Redovna plaća', 'Plaća'),
(13, 'Redovna plaća', 'Plaća'),
(14, 'Redovna plaća', 'Plaća'),
(15, 'Redovna plaća', 'Plaća'),
(16, 'Bonus/nagrada za zaposlenika mjeseca', 'Bonus'),
(17, 'Božićnica dana svim zaposlenicima na odluku uprave', 'Božićnica'),
(18, 'Redovna plaća', 'Plaća'),
(19, 'Redovna plaća', 'Plaća'),
(20, 'Redovna plaća', 'Plaća'),
(21, 'Redovna plaća', 'Plaća'),
(22, 'Redovna plaća', 'Plaća'),
(23, 'Redovna plaća', 'Plaća'),
(24, 'Redovna plaća', 'Plaća'),
(25, 'Redovna plaća', 'Plaća'),
(26, 'Bonus za postignute prodajne rezultate', 'Bonus'),
(27, 'Redovna plaća', 'Plaća'),
(28, 'Nagrada za lojalnost firmi - 15 godina', 'Bonus'),
(29, 'Redovna plaća', 'Plaća'),
(30, 'Bonus za rad u smjenama', 'Bonus');

INSERT INTO slika_automobila (id_automobil, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/automobil1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/automobil2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/automobil3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/automobil4.jpg', 'krovna'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/automobil5.jpg', 'unutrašnja'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/automobil6.jpg', 'stražnja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/automobil7.jpg', 'stražnja'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/automobil8.jpg', 'stražnja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/automobil9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/automobil10.jpg', 'bočna'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/automobil11.jpg', 'bočna'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/automobil12.jpg', 'bočna'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/automobil13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/automobil14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/automobil15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/automobil16.jpg', 'unutrašnjost'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/automobil17.jpg', 'prednja'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/automobil18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/automobil19.jpg', 'unutrašnjost'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/automobil20.jpg', 'prednja'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/automobil21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/automobil22.jpg', 'stražnja'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/automobil23.jpg', 'bočna'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/automobil24.jpg', 'prednja'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/automobil25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/automobil26.jpg', 'krovna'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/automobil27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/automobil28.jpg', 'unutrašnjost'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/automobil29.jpg', 'bočna'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/automobil30.jpg', 'bočna');


INSERT INTO slika_motora (id_motocikl, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/motocikl1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/motocikl2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/motocikl3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/motocikl4.jpg', 'stražnja'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/motocikl5.jpg', 'bočna'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/motocikl6.jpg', 'prednja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/motocikl7.jpg', 'bočna'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/motocikl8.jpg', 'prednja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/motocikl9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/motocikl10.jpg', 'stražnja'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/motocikl11.jpg', 'prednja'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/motocikl12.jpg', 'bočna'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/motocikl13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/motocikl14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/motocikl15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/motocikl16.jpg', 'prednja'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/motocikl17.jpg', 'bočna'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/motocikl18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/motocikl19.jpg', 'stražnja'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/motocikl20.jpg', 'bočna'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/motocikl21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/motocikl22.jpg', 'bočna'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/motocikl23.jpg', 'stražnja'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/motocikl24.jpg', 'stražnja'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/motocikl25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/motocikl26.jpg', 'prednja'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/motocikl27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/motocikl28.jpg', 'prednja'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/motocikl29.jpg', 'stražnja'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/motocikl30.jpg', 'stražnja');

INSERT INTO slika_kamiona (id_kamion, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/kamion1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/kamion2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/kamion3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/kamion4.jpg', 'krovna'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/kamion5.jpg', 'unutrašnja'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/kamion6.jpg', 'stražnja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/kamion7.jpg', 'bočna'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/kamion8.jpg', 'stražnja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/kamion9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/kamion10.jpg', 'bočna'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/kamion11.jpg', 'bočna'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/kamion12.jpg', 'prednja'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/kamion13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/kamion14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/kamion15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/kamion16.jpg', 'bočna'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/kamion17.jpg', 'prednja'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/kamion18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/kamion19.jpg', 'bočna'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/kamion20.jpg', 'prednja'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/kamion21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/kamion22.jpg', 'stražnja'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/kamion23.jpg', 'bočna'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/kamion24.jpg', 'bočna'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/kamion25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/kamion26.jpg', 'prednja'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/kamion27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/kamion28.jpg', 'stražnja'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/kamion29.jpg', 'prednja'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/kamion30.jpg', 'bočna');

INSERT INTO odrzavanje (id, tip, id_zaposlenik, id_transakcija_odrzavanje) VALUES -- Marinela
(1, 'Godišnji servis', 17, 5),
(2, 'Godišnji servis', 29, 13),
(3, 'Zamjena ulja', 5, 8),
(4, 'Zamjena filtera', 23, 16),
(5, 'Popravak kočnica', 8, 3),
(6, 'Ispitivanje guma', 18, 29),
(7, 'Popravak karoserije', 30, 1),
(8, 'Punjenje klima uređaja', 10, 12),
(9, 'Balansiranje kotača', 9, 19),
(10, 'Zamjena svjećica', 11, 4),
(11, 'Servis kočnica', 20, 18),
(12, 'Zamjena akumulatora', 21, 25),
(13, 'Zamjena auspuha', 14, 20),
(14, 'Servis brave', 4, 15),
(15, 'Popravak upravljača', 3, 22),
(16, 'Zamjena diskova', 25, 24),
(17, 'Popravak amortizera', 13, 10),
(18, 'Zamjena svjetala', 12, 7),
(19, 'Servis motora', 1, 27),
(20, 'Popravak elektronike', 24, 30),
(21, 'Zamjena remenja', 28, 11),
(22, 'Servis kvačila', 6, 14),
(23, 'Popravak auspuha', 19, 23),
(24, 'Zamjena brisača', 16, 2),
(25, 'Popravak mjerača', 22, 6),
(26, 'Zamjena brave', 27, 21),
(27, 'Zamjena trapa', 15, 17),
(28, 'Servis akumulatora', 7, 9),
(29, 'Zamjena stakla', 2, 28),
(30, 'Popravak podvozja', 26, 26);

INSERT INTO rezervacija (id, datum_rezervacije, datum_potvrde, id_klijent) VALUES -- Marinela
(1, STR_TO_DATE('2023-02-15', '%Y-%m-%d'), STR_TO_DATE('2023-02-20', '%Y-%m-%d'), 12),
(2, STR_TO_DATE('2023-05-08', '%Y-%m-%d'), STR_TO_DATE('2023-05-15', '%Y-%m-%d'), 25),
(3, STR_TO_DATE('2023-09-20', '%Y-%m-%d'), STR_TO_DATE('2023-09-25', '%Y-%m-%d'), 5),
(4, STR_TO_DATE('2023-11-11', '%Y-%m-%d'), STR_TO_DATE('2023-11-17', '%Y-%m-%d'), 30),
(5, STR_TO_DATE('2023-12-04', '%Y-%m-%d'), STR_TO_DATE('2023-12-10', '%Y-%m-%d'), 18),
(6, STR_TO_DATE('2023-06-21', '%Y-%m-%d'), STR_TO_DATE('2023-06-28', '%Y-%m-%d'), 3),
(7, STR_TO_DATE('2023-04-12', '%Y-%m-%d'), STR_TO_DATE('2023-04-19', '%Y-%m-%d'), 10),
(8, STR_TO_DATE('2023-08-30', '%Y-%m-%d'), STR_TO_DATE('2023-09-06', '%Y-%m-%d'), 15),
(9, STR_TO_DATE('2023-10-25', '%Y-%m-%d'), STR_TO_DATE('2023-11-01', '%Y-%m-%d'), 22),
(10, STR_TO_DATE('2023-01-17', '%Y-%m-%d'), STR_TO_DATE('2023-01-24', '%Y-%m-%d'), 7),
(11, STR_TO_DATE('2023-07-09', '%Y-%m-%d'), STR_TO_DATE('2023-07-16', '%Y-%m-%d'), 30),
(12, STR_TO_DATE('2023-03-28', '%Y-%m-%d'), STR_TO_DATE('2023-04-04', '%Y-%m-%d'), 12),
(13, STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2023-12-17', '%Y-%m-%d'), 28),
(14, STR_TO_DATE('2023-02-02', '%Y-%m-%d'), STR_TO_DATE('2023-02-09', '%Y-%m-%d'), 6),
(15, STR_TO_DATE('2023-05-30', '%Y-%m-%d'), STR_TO_DATE('2023-06-06', '%Y-%m-%d'), 14),
(16, STR_TO_DATE('2023-09-12', '%Y-%m-%d'), STR_TO_DATE('2023-09-19', '%Y-%m-%d'), 2),
(17, STR_TO_DATE('2023-11-26', '%Y-%m-%d'), STR_TO_DATE('2023-12-03', '%Y-%m-%d'), 25),
(18, STR_TO_DATE('2023-06-17', '%Y-%m-%d'), STR_TO_DATE('2023-06-24', '%Y-%m-%d'), 18),
(19, STR_TO_DATE('2023-04-20', '%Y-%m-%d'), STR_TO_DATE('2023-04-27', '%Y-%m-%d'), 11),
(20, STR_TO_DATE('2023-08-03', '%Y-%m-%d'), STR_TO_DATE('2023-08-10', '%Y-%m-%d'), 30),
(21, STR_TO_DATE('2023-10-29', '%Y-%m-%d'), STR_TO_DATE('2023-11-05', '%Y-%m-%d'), 3),
(22, STR_TO_DATE('2023-01-30', '%Y-%m-%d'), STR_TO_DATE('2023-02-06', '%Y-%m-%d'), 19),
(23, STR_TO_DATE('2023-07-23', '%Y-%m-%d'), STR_TO_DATE('2023-07-30', '%Y-%m-%d'), 12),
(24, STR_TO_DATE('2023-03-17', '%Y-%m-%d'), STR_TO_DATE('2023-03-24', '%Y-%m-%d'), 27),
(25, STR_TO_DATE('2023-11-05', '%Y-%m-%d'), STR_TO_DATE('2023-11-12', '%Y-%m-%d'), 5),
(26, STR_TO_DATE('2023-02-22', '%Y-%m-%d'), STR_TO_DATE('2023-03-01', '%Y-%m-%d'), 20),
(27, STR_TO_DATE('2023-06-05', '%Y-%m-%d'), STR_TO_DATE('2023-06-12', '%Y-%m-%d'), 7),
(28, STR_TO_DATE('2023-09-26', '%Y-%m-%d'), STR_TO_DATE('2023-10-03', '%Y-%m-%d'), 18),
(29, STR_TO_DATE('2023-01-13', '%Y-%m-%d'), STR_TO_DATE('2023-01-20', '%Y-%m-%d'), 29),
(30, STR_TO_DATE('2023-05-19', '%Y-%m-%d'), STR_TO_DATE('2023-05-26', '%Y-%m-%d'), 4);

INSERT INTO oprema (id, naziv, opis) VALUES -- Marinela
(1, 'Wi-fi uređaj', 'wi-fi hotspot, spajanje 5 uređaja istovremeno, 32 GB memorije'),
(2, 'GPS navigacija', 'Uključuje nosače za vjetrobransko staklo, Upozorenje na kamere za kontrolu brzine na vašoj ruti'),
(3, 'Pomoć na cesti', 'Popravak vozila na cesti, vuča vozila'),
(4, 'Dječja sjedalica baby seat', 'Sjedalica za djecu od 0-12 mj'),
(5, 'Dječja sjedalica child seat', 'Sjedalica za djecu od 9-36kg'),
(6, 'Dječja sjedalica booster seat', 'Sjedalica za djecu od 4 do 7 godina'),
(7, 'Nosači za bicikle', 'Krovni nosači za dva bicikla'),
(8, 'Motorističke kacige', 'Otvorena kaciga s vizirom'),
(9, 'Autoprikolica', 'Nosivost 750kg'),
(10, 'Motorističke rukavice', 'Pružaju zaštitu ruku od vjetra, sunca i ozljeda'),
(11, 'Bočne bisage', 'Za veću pohranu – alat, odjeća'),
(12, 'Stražnje bisage', 'Za pohranu manje količine stvari'),
(13, 'Nosači za svijetla', 'Za pričvršćivanje dodatnih svjetala ili reflektora na kamion');

INSERT INTO oprema_na_najmu (id, id_oprema, id_najam, kolicina, status_opreme, datum_pocetka_najma, datum_zavrsetka_najma) VALUES -- Marinela
(1, 7, 24, 10, 'iznajmljeno', STR_TO_DATE('2024-04-20', '%Y-%m-%d'), STR_TO_DATE('2024-04-27', '%Y-%m-%d')),
(2, 4, 18, 15, 'dostupno', STR_TO_DATE('2023-08-08', '%Y-%m-%d'), STR_TO_DATE('2023-08-15', '%Y-%m-%d')),
(3, 9, 7, 8, 'rezervirano', STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2023-12-17', '%Y-%m-%d')),
(4, 8, 1, 7, 'iznajmljeno', STR_TO_DATE('2024-02-29', '%Y-%m-%d'), STR_TO_DATE('2024-03-09', '%Y-%m-%d')),
(5, 10, 3, 10, 'dostupno', STR_TO_DATE('2023-07-01', '%Y-%m-%d'), STR_TO_DATE('2023-07-09', '%Y-%m-%d')),
(6, 1, 20, 5, 'iznajmljeno', STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-01-24', '%Y-%m-%d')),
(7, 5, 29, 6, 'dostupno', STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2023-10-%27', '%Y-%m-%d')),
(8, 3, 5, 12, 'iznajmljeno', STR_TO_DATE('2023-11-11', '%Y-%m-%d'), STR_TO_DATE('2023-11-21', '%Y-%m-%d')),
(9, 4, 28, 3, 'rezervirano', STR_TO_DATE('2023-09-05', '%Y-%m-%d'), STR_TO_DATE('2023-09-%15', '%Y-%m-%d')),
(10, 2, 6, 20, 'dostupno', STR_TO_DATE('2024-02-14', '%Y-%m-%d'), STR_TO_DATE('2024-02-%23', '%Y-%m-%d')),
(11, 6, 15, 8, 'iznajmljeno', STR_TO_DATE('2023-05-12', '%Y-%m-%d'), STR_TO_DATE('2023-05-%21', '%Y-%m-%d')),
(12, 7, 9, 10, 'dostupno', STR_TO_DATE('2024-06-02', '%Y-%m-%d'), STR_TO_DATE('2024-06-%09', '%Y-%m-%d')),
(13, 8, 11, 7, 'rezervirano', STR_TO_DATE('2023-04-09', '%Y-%m-%d'), STR_TO_DATE('2023-04-%16', '%Y-%m-%d')),
(14, 10, 22, 15, 'iznajmljeno', STR_TO_DATE('2024-03-27', '%Y-%m-%d'), STR_TO_DATE('2024-03-%05', '%Y-%m-%d')),
(15, 1, 14, 6, 'dostupno', STR_TO_DATE('2023-01-20', '%Y-%m-%d'), STR_TO_DATE('2023-01-%27', '%Y-%m-%d')),
(16, 3, 17, 8, 'iznajmljeno', STR_TO_DATE('2024-06-05', '%Y-%m-%d'), STR_TO_DATE('2024-06-%13', '%Y-%m-%d')),
(17, 2, 26, 4, 'rezervirano', STR_TO_DATE('2023-08-08', '%Y-%m-%d'), STR_TO_DATE('2023-08-%16', '%Y-%m-%d')),
(18, 6, 2, 10, 'dostupno', STR_TO_DATE('2024-05-07', '%Y-%m-%d'), STR_TO_DATE('2024-05-%16', '%Y-%m-%d')),
(19, 7, 25, 13, 'iznajmljeno', STR_TO_DATE('2023-11-28', '%Y-%m-%d'), STR_TO_DATE('2023-12-%06', '%Y-%m-%d')),
(20, 8, 8, 9, 'dostupno', STR_TO_DATE('2024-03-10', '%Y-%m-%d'), STR_TO_DATE('2024-03-%19', '%Y-%m-%d')),
(21, 10, 16, 5, 'iznajmljeno', STR_TO_DATE('2023-07-30', '%Y-%m-%d'), STR_TO_DATE('2023-08-%07', '%Y-%m-%d')),
(22, 1, 30, 11, 'dostupno', STR_TO_DATE('2024-01-02', '%Y-%m-%d'), STR_TO_DATE('2024-01-%13', '%Y-%m-%d')),
(23, 5, 10, 8, 'iznajmljeno', STR_TO_DATE('2023-10-18', '%Y-%m-%d'), STR_TO_DATE('2023-10-%27', '%Y-%m-%d')),
(24, 2, 21, 6, 'dostupno', STR_TO_DATE('2024-04-04', '%Y-%m-%d'), STR_TO_DATE('2024-04-%12', '%Y-%m-%d')),
(25, 3, 27, 12, 'iznajmljeno', STR_TO_DATE('2023-12-15', '%Y-%m-%d'), STR_TO_DATE('2023-12-%25', '%Y-%m-%d')),
(26, 4, 4, 3, 'dostupno', STR_TO_DATE('2024-01-01', '%Y-%m-%d'), STR_TO_DATE('2024-01-%08', '%Y-%m-%d')),
(27, 6, 19, 20, 'iznajmljeno', STR_TO_DATE('2023-09-02', '%Y-%m-%d'), STR_TO_DATE('2023-09-%11', '%Y-%m-%d')),
(28, 7, 13, 9, 'dostupno', STR_TO_DATE('2024-03-28', '%Y-%m-%d'), STR_TO_DATE('2024-04-%06', '%Y-%m-%d')),
(29, 9, 23, 5, 'iznajmljeno', STR_TO_DATE('2023-06-10', '%Y-%m-%d'), STR_TO_DATE('2023-06-%17', '%Y-%m-%d')),
(30, 10, 12, 14, 'dostupno', STR_TO_DATE('2024-05-19', '%Y-%m-%d'), STR_TO_DATE('2024-05-%27', '%Y-%m-%d'));

INSERT INTO oprema_na_rezervaciji (id, id_oprema, kolicina) VALUES -- Marinela
(1, 12, 1),
(2, 4, 2),
(3, 9, 1),
(4, 3, 1),
(5, 6, 1),
(6, 5, 1),
(7, 2, 1),
(8, 10, 2),
(9, 7, 1),
(10, 12, 1),
(11, 1, 1),
(12, 4, 2),
(13, 11, 1),
(14, 6, 1),
(15, 9, 1),
(16, 7, 1),
(17, 10, 2),
(18, 5, 1),
(19, 8, 2),
(20, 1, 1),
(21, 3, 1),
(22, 11, 1),
(23, 2, 1),
(24, 8, 2),
(25, 4, 1),
(26, 10, 2),
(27, 6, 2),
(28, 9, 1),
(29, 5, 1),
(30, 7, 1);

INSERT INTO vozilo_na_rezervaciji (id, id_vozilo, id_rezervacija) VALUES -- Marinela
(1, 23, 4),
(2, 6, 26),
(3, 7, 30),
(4, 29, 15),
(5, 25, 7),
(6, 2, 12),
(7, 14, 29),
(8, 14, 5),
(9, 15, 9),
(10, 5, 25),
(11, 17, 20),
(12, 15, 3),
(13, 6, 22),
(14, 11, 23),
(15, 1, 6),
(16, 12, 27),
(17, 22, 11),
(18, 7, 14),
(19, 6, 10),
(20, 12, 8),
(21, 8, 19),
(22, 9, 24),
(23, 17, 18),
(24, 3, 21),
(25, 5, 1),
(26, 16, 17),
(27, 2, 13),
(28, 11, 2),
(29, 20, 16),
(30, 29, 28);

INSERT INTO crna_lista (id, id_klijent, razlog) VALUES -- Marinela
(1, 2, 'Nepoštivanje uvjeta ugovora'),
(2, 9, 'Ponavljanje prekršaja'),
(3, 29, 'Korištenje vozila za nezakonite svrhe'),
(4, 24, 'Ponavljanje prekršaja'),
(5, 11, 'Neplaćanje računa'),
(6, 14, 'Oštećenje vozila')
