-- IZRADA BAZE PODATAKA

DROP DATABASE IF EXISTS tvrtka_za_najam_vozila;
CREATE DATABASE tvrtka_za_najam_vozila;
USE tvrtka_za_najam_vozila;

-- STVARANJE TABLICA

CREATE TABLE lokacija (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    drzava VARCHAR (47),
    grad VARCHAR (100),
    adresa VARCHAR (100),
    PRIMARY KEY (id)
);

CREATE TABLE pravna_osoba (
    id INT NOT NULL AUTO_INCREMENT, 
    ime VARCHAR (100), 
    identifikacijski_broj VARCHAR (25) NOT NULL UNIQUE,
    id_lokacija SMALLINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_lokacija) REFERENCES lokacija (id)
);

CREATE TABLE klijent (
    id INT NOT NULL,
    ime VARCHAR (30), 
    prezime VARCHAR (30), 
    identifikacijski_broj VARCHAR (13),
    id_pravna_osoba INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba (id)
);


CREATE TABLE zanimanje (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    naziv VARCHAR (50) NOT NULL UNIQUE,
    opis_zanimanja TEXT NOT NULL,
    odjel VARCHAR (50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE zaposlenik (
    id MEDIUMINT NOT NULL AUTO_INCREMENT, 
    id_nadredeni_zaposlenik MEDIUMINT, 
    ime VARCHAR (30) NOT NULL, 
    prezime VARCHAR (30) NOT NULL, 
    identifikacijski_broj VARCHAR (15) NOT NULL UNIQUE,
    spol CHAR (1) CHECK (spol IN ('M', 'F')),
    broj_mobitela VARCHAR (20) UNIQUE,
    broj_telefona VARCHAR (20),
    email VARCHAR (320) UNIQUE,
    id_zanimanje SMALLINT NOT NULL, 
    id_lokacija SMALLINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id),
    FOREIGN KEY (id_lokacija) REFERENCES lokacija (id)
);


CREATE TABLE kontakt_klijenta (
    id INT NOT NULL AUTO_INCREMENT, 
    email VARCHAR (320) UNIQUE, 
    broj_mobitela VARCHAR (20) UNIQUE, 
    broj_telefona VARCHAR (20) UNIQUE,
    id_klijent INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
);

CREATE TABLE prihod (
    id TINYINT NOT NULL AUTO_INCREMENT, 
    opis TEXT (200),
    tip_prihoda VARCHAR (25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE transakcija (
    id BIGINT NOT NULL AUTO_INCREMENT, 
    datum DATE, 
    iznos NUMERIC (12,2), 
    broj_racuna VARCHAR (7), 
    placeno NUMERIC (12,2),
    id_klijent INT,
    id_zaposlenik MEDIUMINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id)
);


CREATE TABLE prihod_za_zaposlenika (
    id INT NOT NULL AUTO_INCREMENT,
    datum DATE,
    id_transakcija_prihoda BIGINT NOT NULL,
    id_prihod TINYINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_prihoda) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_prihod) REFERENCES prihod (id)
);

CREATE TABLE popust (
    id TINYINT NOT NULL AUTO_INCREMENT, 
    tip_popusta VARCHAR(100) NOT NULL, -- zagrada
    PRIMARY KEY (id)
);

CREATE TABLE popust_za_klijenta (
    id INT NOT NULL AUTO_INCREMENT,
    datum_primitka DATE, 
    datum_koristenja DATE,
    status VARCHAR (10), 
    id_klijent INT NOT NULL,
    id_popust TINYINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE,
    FOREIGN KEY (id_popust) REFERENCES popust (id)
);

CREATE TABLE poslovni_trosak (
    id INT NOT NULL AUTO_INCREMENT, 
    id_transakcija_poslovnog_troska BIGINT NOT NULL, 
    svrha VARCHAR (40), 
    opis TEXT (200),
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_poslovnog_troska) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE gotovinsko_placanje (
    id BIGINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES transakcija (id)
);

/* 
Tablica `transakcija` ima primarni ključ s atributom `AUTO_INCREMENT`.
Ostale tablice (`gotovinsko_placanje`, `karticno_placanje`, `kriptovalutno_placanje`) 
referenciraju `id` iz tablice `transakcija` kao strani ključ bez korištenja `AUTO_INCREMENT`.
 Pretpostavlja se da su vrijednosti `id` već generirane u tablici `transakcija` i da će samo 
 referencirati te postojeće ID-ove.
 */
 
CREATE TABLE karticno_placanje (
    id BIGINT NOT NULL AUTO_INCREMENT, 
    tip_kartice VARCHAR (20), 
    id_pravna_osoba_banka INT, 
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES transakcija (id),
    FOREIGN KEY (id_pravna_osoba_banka) REFERENCES pravna_osoba (id)
);

CREATE TABLE kriptovalutno_placanje (
    id BIGINT NOT NULL AUTO_INCREMENT, 
    kriptovaluta VARCHAR (50) NOT NULL, 
    broj_kripto_novcanika VARCHAR (60) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES transakcija (id)
    );

CREATE TABLE kontakt_pravne_osobe (
    id INT NOT NULL AUTO_INCREMENT, 
    email VARCHAR (320) UNIQUE, 
    broj_mobitela VARCHAR (20) , 
    broj_telefona VARCHAR (20),
    opis VARCHAR (100),
    id_pravna_osoba INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba (id) ON DELETE CASCADE
    );

CREATE TABLE serija (
    id SMALLINT NOT NULL AUTO_INCREMENT, 
    ime VARCHAR (100) NOT NULL UNIQUE, 
    proizvodac VARCHAR (40), 
    tip_mjenjaca VARCHAR (10), 
    broj_sjedala TINYINT, -- TINYINT dodano
    broj_vrata TINYINT,
    PRIMARY KEY (id)
);

CREATE TABLE vozilo (
    id INT NOT NULL AUTO_INCREMENT,
    godina_proizvodnje CHAR(4), 
    registracijska_tablica VARCHAR (15) NOT NULL, 
    tip_punjenja VARCHAR (10),
    duljina NUMERIC (4, 2),
    visina NUMERIC (3, 2),
    nosivost NUMERIC (7, 2),
    id_serija SMALLINT,
    tip_vozila CHAR (1) CHECK (tip_vozila IN ('K', 'M', 'A')),
    PRIMARY KEY (id),
    FOREIGN KEY (id_serija) REFERENCES serija (id)
);


CREATE TABLE najam_vozila (
    id INT NOT NULL AUTO_INCREMENT, 
    id_transakcija_najam BIGINT NOT NULL, 
    id_vozilo INT NOT NULL,
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    status VARCHAR (15) NOT NULL,
    pocetna_kilometraza NUMERIC (10, 2), 
    zavrsna_kilometraza NUMERIC (10, 2), 
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_najam) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id)
);


CREATE TABLE slika_vozila (
    id INT NOT NULL AUTO_INCREMENT, 
    id_vozilo INT NOT NULL, 
    slika MEDIUMBLOB, -- MySQL-u ne postoji tip podatka VARBINARY(MAX), MEDIUMBLOB je do 16 MB
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE tip_osiguranja (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    id_osiguravajuca_kuca INT,
    tip_osiguranja VARCHAR (20),
    PRIMARY KEY (id),
    FOREIGN KEY (id_osiguravajuca_kuca) REFERENCES pravna_osoba (id)
);

CREATE TABLE osiguranje (
    id INT NOT NULL AUTO_INCREMENT, 
    id_vozilo INT, 
    id_transakcija BIGINT, 
    id_tip_osiguranja SMALLINT NOT NULL,
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    PRIMARY KEY (id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id) ON DELETE CASCADE,
    FOREIGN KEY (id_transakcija) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_tip_osiguranja) REFERENCES tip_osiguranja (id) ON DELETE CASCADE
);

CREATE TABLE steta (
    id INT NOT NULL AUTO_INCREMENT, 
    tip VARCHAR (10),
    opis TEXT (200),
    PRIMARY KEY (id)
);

CREATE TABLE naknada_stete (
    id INT NOT NULL AUTO_INCREMENT,  
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    id_transakcija BIGINT NOT NULL,
    id_osiguranje INT,
    id_steta INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_steta) REFERENCES steta (id) ON DELETE CASCADE,
    FOREIGN KEY (id_osiguranje) REFERENCES osiguranje (id)
);

CREATE TABLE punjenje (
    id INT NOT NULL AUTO_INCREMENT,
    id_transakcija_punjenje BIGINT NOT NULL,
    id_vozilo INT NOT NULL,
    kolicina NUMERIC(7, 3),
    tip_punjenja VARCHAR (10),
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_punjenje) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE odrzavanje (
    id INT NOT NULL AUTO_INCREMENT, 
    tip_odrzavanja VARCHAR (100), 
    id_transakcija_odrzavanje BIGINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_odrzavanje) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE rezervacija (
    id INT NOT NULL AUTO_INCREMENT, 
    datum_rezervacije DATE, 
    datum_potvrde DATE, 
    id_klijent INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
);

CREATE TABLE oprema (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    naziv VARCHAR (30),
    opis TEXT (200),
    PRIMARY KEY (id)
);

CREATE TABLE oprema_na_najmu (
    id INT NOT NULL AUTO_INCREMENT,
    id_najam_vozila INT NOT NULL,
    id_oprema SMALLINT NOT NULL,
    kolicina TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_najam_vozila) REFERENCES najam_vozila (id) ON DELETE CASCADE,
    FOREIGN KEY (id_oprema) REFERENCES oprema (id)
);

CREATE TABLE oprema_na_rezervaciji (
    id INT NOT NULL AUTO_INCREMENT,
    id_rezervacija INT NOT NULL,
    id_oprema SMALLINT NOT NULL,
    kolicina TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_oprema) REFERENCES oprema (id)
);

CREATE TABLE vozilo_na_rezervaciji (
    id INT NOT NULL AUTO_INCREMENT,
    id_rezervacija INT NOT NULL,
    id_vozilo INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id)
);

CREATE TABLE crna_lista (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    id_klijent INT NOT NULL,
    razlog TEXT, /*CHECK, /*LENGTH(razlog) > 30),*/
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
);

INSERT INTO lokacija (id, drzava, grad, adresa) VALUES -- Sebastijan
(1, "Hrvatska", "Zagreb", "Ilica 17"),
(2, "Hrvatska", "Zagreb", "Mirka Bogovića 8"),
(3, "Hrvatska", "Rijeka", "Slavka Krautzeka 14"),
(4, "Hrvatska", "Split", "Marmontova 18"),
(5, "Srbija", "Beograd", "Jastrebovljeva 9"),
(6, "Slovenija", "Ljubljana", "Kebetova ulica 12"),
(7, "Italija", "Torino", "Piazza Castello 2"),
(8, "Italija", "Milano", "Via Paolo Sarpi 3"),
(9, "Bosna i Hercegovina", "Sarajevo", "Baščaršija 14"),
(10, "Mađarska", "Budimpešta", "Király utca 23");
                       
INSERT INTO pravna_osoba (id, ime, identifikacijski_broj, id_lokacija) VALUES -- Vedrana
(1, 'MEP', '32132132132', 1),
(2, 'CTK', '12312312312', 2),
(3, 'Zaključni list', '00402711154', 3),
(4, 'Amica', '45645645645', 4),
(5, 'Liste', '48484848985', 5),
(6, 'Figure', '12584548748', 6),
(7, 'Zone', '54565456458', 7),
(8, 'Croatia Osiguranje', '54584587458', 8),
(9, 'Metis', '78787457895', 9),
(10, 'TLM', '12451245124', 10),
(11, 'Zagrebačka banka', '01012325412', 1),
(12, 'Optima Telekom', '13123131312', 2),
(13, 'Business Sphere', '16456456487', 3),
(14, 'Transporto', '45800012456', 4),
(15, 'Berlin Trans', '62432156847', 5),
(16, 'HM', '45612342421', 6),
(17, 'Inovativna Solutions d.o.o.', '98765432110', 7),
(18, 'Global Trade Corp.', '98765432101', 8),
(19, 'SoftLab d.o.o.', '98765432112', 9),
(20, 'TechSupport Plus d.o.o.', '65498732101', 10),
(21, 'InovaIT Solutions d.o.o.', '32178965410', 1),
(22, 'SoftTech Solutions d.o.o.', '12345678910', 2),
(23, 'InnovateLab d.o.o.', '10987654321', 3),
(24, 'FutureGen Systems d.o.o.', '87654321098', 4),
(25, 'TechInnovations Plus d.o.o.', '54321098765', 5),
(26, 'SmartLab Ltd.', '21098765432', 6),
(27, 'InnovaTech AG', '78932145612', 7),
(28, 'EuroSoft Solutions Ltd.', '98732165400', 8),
(29, 'TechSavvy Ventures Inc.', '65412398701', 9),
(30, 'GeniusTech d.o.o.', '78932145615', 10);

INSERT INTO klijent (id, ime, prezime, identifikacijski_broj, id_pravna_osoba) VALUES -- Mirela
(1, 'Luka', 'Novosel', '1234567890123', 4),
(2, 'Ana', 'Kovačević', '2345678901234', 7),
(3, 'Ivan', 'Horvat', '3456789012345', 3),
(4, 'Petra', 'Marić', '4567890123456', 1),
(5, 'Marko', 'Pavić', '5678901234567', 10),
(6, 'Martina', 'Knežević', '6789012345678', 6),
(7, 'Nikola', 'Perić', '7890123456789', 8),
(8, 'Kristina', 'Jurić', '8901234567890', 2),
(9, 'Filip', 'Kovačić', '9012345678901', 9),
(10, 'Ivana', 'Šimunović', '0123456789012', 5),
(11, 'Ivo', 'Horvat', '9876543210987', 4),
(12, 'Maja', 'Petrović', '8765432109876', 7),
(13, 'Lucija', 'Novak', '7654321098765', 3),
(14, 'Matej', 'Šimić', '6543210987654', 1),
(15, 'Ana', 'Kovač', '5432109876543', 10),
(16, 'Petar', 'Ilić', '4321098765432', 6),
(17, 'Lana', 'Horvat', '3210987654321', 8),
(18, 'Ivan', 'Pavić', '2109876543210', 2),
(19, 'Marija', 'Kovačević', '1098765432109', 9),
(20, 'Ante', 'Marinović', '0987654321098', 5),
(21, 'Lucija', 'Perić', '0192837465029', 4),
(22, 'Matija', 'Knežević', '1827364550912', 7),
(23, 'Luka', 'Horvat', '2748192650374', 3),
(24, 'Iva', 'Pavić', '3647281902748', 1),
(25, 'Petra', 'Jurić', '4567382910563', 10),
(26, 'Ivan', 'Kovačić', '5126347890123', 6),
(27, 'Martina', 'Marinović', '6748291028473', 8),
(28, 'Nikola', 'Horvat', '7456128390471', 2),
(29, 'Elena', 'Novak', '8192736450128', 9),
(30, 'Roko', 'Knežević', '9283746510293', 5);



INSERT INTO zanimanje (id, naziv, opis_zanimanja, odjel) VALUES -- Sebastijan
                      (1, "Marketinški stručnjak", "Priprema marketinških kampanja", "Marketing"),
                      (2, "Marketinški direktor", "Vođenje odjela za marketing, donošenje odluka o ulaganjima u
                       kampanje, razmatranje širenja tržišta, istraživanje raznih tržišta", "Marketing"),
                      (3, "Istražitelj tržišta", "Fizičko istraživanje novih tržišta u svrhu razmatranja širenja u
                       ista", "Marketing"),
                      (4, "Računovođa", "Knjiženje računa", "Računovodstvo"),
                      (5, "Direktor Računovodstva", "Vođenje odjela za računovodstvo, plaćanje računa, isplata prihoda
                       zaposlenicima", "Računovodstvo"),
                      (6, "Rukovoditelj ljudskih resursa", "Vođenje odjela za ljudske resurse, pronalaženje novih talenata",
                      "Ljudski resursi"),
                      (7, "Održavatelj vozila", "Briga o održavanju i popravcima vozila", "Prodaja"),
                      (8, "Prodavač", "Iznajmljivanje vozila i ostale opreme", "Prodaja"),
                      (9, "Direktor prodaje", "Briga o održavanju i najmu vozila", "Prodaja"),
                      (10, "Vlasnik", "Vođenje kompanije", 'Uprava'),
                      (11, "IT tehničar", "Briga o održavanju IT sustava u firmi", "IT"),
                      (12, "IT direktor", "Vođenje IT odjela", "IT");



INSERT INTO zaposlenik (id, id_nadredeni_zaposlenik, ime, prezime, identifikacijski_broj, spol, broj_mobitela, broj_telefona, email,
                        id_zanimanje, id_lokacija) VALUES  -- Mirela 
                        (1, NULL, "Mario", "Babić", 84592314443, "M", 1977341293, 985214763, "marko.babic8923@gmail.com", 10, 1),
                        (2, 1, "Ivana", "Klasnić", 38045222084, "F", 191599834, 852147963, "ivanaklasnic34@gmail.com", 2, 1),
                        (3, 1, "Marko", "Novak", 59034111073, "M", 198347110, 745698123, "markonovak123@gmail.com", 9, 1),
                        (4, 1, "Ana", "Horvat", 72903000023, "F", 1912344678, 698541237, "ana.horvat@gmail.com", 5, 1),
                        (5, 1, "Petra", "Kovač", 87299948023, "F", 195558123, 573416298, "petra.kovac@gmail.com", 6, 1),
                        (6, 1, "Luka", "Vuković", 93208333032, "M", 1987654221, 412587963, "luka.vukovic4@gmail.com", 12, 1),
                        (7, 2, "Martina", "Jurić", 50293855532, "F", 1913456799, 321456987, "martina.juric@gmail.com", 1, 1),
                        (8, 2, "Ivan", "Marić", 39047998948, "M", 195432189, 214569873, "imaric28@gmail.com", 1, 1),
                        (9, 3, "Marina", "Knežević", 68065690328, "F", 198865432, 105987456, "mknez34@gmail.com", 2, 1),
                        (10, 4, "Mateo", "Barić", 84203932370, "M", 191234577, 995478214, "mbaric@gmail.com", 1, 1),
                        (11, 4, "Lucija", "Mihaljević", 59121857203, "F", 195671123, 884455228, "lucija.mihaljevic@gmail.com", 1, 1),
                        (12, 6, "Luka", "Petrović", 68304545428, "M", 191239567, 774411587, "luka.petrovic@gmail.com", 11, 1),
                        (13, 6, "Luka", "Horvat", 30948578734, "M", 191234067, 669854789, "luka.horvat@gmail.com", 11, 1),
                        (14, 3, "Mihajlo", "Dobrisavljević", 3141850204, "M", 554123698, 0987654321, "mdobrisavljevic@gmail.com", 7, 5),
                        (15, 3, "Lana", "Matić", 48505254570, "F", 191234767, 447896521, "lmatic@gmail.com", 8, 5),
                        (16, 3, "Filip", "Horvat", 59306367203, "M", 195673123, 330214569, "filip.horvat23@gmail.com", 7, 4),
                        (17, 3, "Ana", "Kovačević", 39446963048, "F", 198725432, 221025874, "ana.kovacevic@gmail.com", 8, 4),
                        (18, 3, "Petar", "Petrovič", 68358590328, "M", 191224567, 110258741, "petar.petrovic@gmail.com", 7, 6),
                        (19, 3, "Ivona", "Ilič", 84203474570, "F", 195678223, 999478521, "ivona.ilic2@gmail.com", 8, 6),
                        (20, 3, "Giovanna", "Bianchi", 59399957233, "M", 1187654321, 888741256, "giovanna.bianchi@gmail.com", 7, 7),
                        (21, 3, "Mia", "Esposito", 30948508574,"F", 191230567, 777532145, "mia.espos33@gmail.com", 8, 7),
                        (22, 3, "Niccolo", "De Luca", 48503220170, "M", 195670123, 666547896, "nickdeluca@gmail.com", 7, 8),
                        (23, 3, "Marina", "Ferrari", 39043023148, "F", 198760432, 555412369, "marina.ferrari75@gmail.com", 8, 8),
                        (24, 3, "Tea", "Ambešković", 84200218570, "F", 195608123, 444785214, "tea.amb@gmail.com", 7, 9),
                        (25, 3, "Marta", "Lovac", 59304222233, "F", 1980654321, 333214785, "marta.baric@gmail.com", 8, 9),
                        (26, 3, "Ana", "Mihaljević", 48503147570, "F", 190678123, 222587412, "ana.mihaljevic@gmail.com", 7, 3),
                        (27, 3, "Ivan", "Kovačević", 39625293048, "M", 198765402, 111598745, "ivan.kovacevic@gmail.com", 8, 3),
                        (28, 3, "Szilvia", "Nagy", 68304474328, "F", 191034567, 999947852, "szilvia.nagy@gmail.com", 7, 10),
                        (29, 3, "László", "Varga", 84205658570, "M", 195678023, 888847854, "laszlo.varga90@gmail.com", 8, 10),
                        (30, 3, "Viktória", "Balogh", 99904777203, "F", 1907654321, 777725896, "vikkibalogh@gmail.com", 8, 1),
                        (31, 3, "Kristofor", "Antijević", 34548884568, "M", 1013456871, 666621478, "kantijevicas@gmail.com", 7, 1),
                        (32, 3, "Andrea", "Klobučar", 48333205746, "F", 199991237, 555514789, "andrea.klobucar@gmail.com", 8, 1),
                        (33, 3, "Budimir", "Janeš", 58441949043, "M", 1989871234, 444458963, "bjanes@gmail.com", 7, 1),
                        (34, 3, "Mate", "Krišto", 93747719883, "M", 1988881453, 333354125, "mate.kristo14@gmail.com", 7, 2),
                        (35, 3, "Klaudija", "Raspudić", 47877093423, "F", 191348910, 222214789, "klaudija.raspudic.posl@gmail.com", 8, 2);

INSERT INTO kontakt_klijenta (id, email, broj_mobitela, broj_telefona, id_klijent) VALUES -- Mirela
(1, 'luka.novosel@gmail.com', '0987654321', '0912345678', 1),
(2, 'ana.kovacevic@gmail.com', '0912345679', '0923456789', 2),
(3, 'ivan.horvat@gmail.com', '0923456790', '0934567890', 3),
(4, 'petra.maric@gmail.com', '0934567901', '0945678901', 4),
(5, 'marko.pavic@gmail.com', '0945678012', '0956789012', 5),
(6, 'martina.knezevic@gmail.com', '0956789123', '0967890123', 6),
(7, 'nikola.peric@gmail.com', '0967890234', '0978901234', 7),
(8, 'kristina.juric@gmail.com', '0978901345', '0989012345', 8),
(9, 'filip.kovacic@gmail.com', '0989012456', '0990123456', 9),
(10, 'ivana.simunovic@gmail.com', '0990123567', '0913456789', 10),
(11, 'ivo.horvat@gmail.com', '0912345670', '0924567890', 1),
(12, 'maja.petrovic@gmail.com', '0923456781', '0935678901', 2),
(13, 'lucija.novak@gmail.com', '0934567892', '0946789012', 3),
(14, 'matej.simic@gmail.com', '0945678903', '0957890123', 4),
(15, 'ana.kovac@gmail.com', '0956789014', '0968901234', 5),
(16, 'petar.ilic@gmail.com', '0967890125', '0979012345', 6),
(17, 'lana.horvat@gmail.com', '0978901236', '0980123456', 7),
(18, 'ivan.pavic@gmail.com', '0989012347', '0991234567', 8),
(19, 'marija.kovacevic@gmail.com', '0990123458', '0912345671', 9),
(20, 'ante.marinovic@gmail.com', '0912345672', '0923456782', 10),
(21, 'lucija.peric@gmail.com', '0923456783', '0934567893', 1),
(22, 'matija.knezevic@gmail.com', '0934567894', '0945678904', 2),
(23, 'luka.horvat@gmail.com', '0945678905', '0956789015', 3),
(24, 'iva.pavic@gmail.com', '0956789016', '0967890126', 4),
(25, 'petra.juric@gmail.com', '0967890127', '0978901237', 5),
(26, 'ivan.kovacic@gmail.com', '0978901238', '0989012348', 6),
(27, 'martina.marinovic@gmail.com', '0989012349', '0990123459', 7),
(28, 'nikola.horvat@gmail.com', '0990123460', '0912345673', 8),
(29, 'elena.novak@gmail.com', '0912345674', '0923456784', 9),
(30, 'roko.knezevic@gmail.com', '0923456785', '0934567895', 10);




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

INSERT INTO transakcija (id, datum, iznos, broj_racuna, placeno, id_klijent, id_zaposlenik) VALUES -- Mirela
(1, STR_TO_DATE('2024-05-11', '%Y-%m-%d'), 150.00, 'ABC1234', 150.00, 1, 1),
(2, STR_TO_DATE('2024-05-22', '%Y-%m-%d'), 200.50, 'DEF5678', 200.50, 2, 2),
(3, STR_TO_DATE('2024-05-03', '%Y-%m-%d'), 75.25, 'GHI9012', 75.25, 3, 3),
(4, STR_TO_DATE('2024-05-04', '%Y-%m-%d'), 100.00, 'JKL3456', 100.00, 4, 4),
(5, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), 300.75, 'MNO7890', 300.75, 5, 5),
(6, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), 51.50, 'PQR1234', 50.50, 6, 6),
(7, STR_TO_DATE('2024-05-17', '%Y-%m-%d'), 90.00, 'STU5678', 90.00, 7, 7),
(8, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), 120.25, 'VWX9012', 120.25, 8, 8),
(9, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 180.75, 'YZA3456', 180.75, 9, 9),
(10, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 250.00, 'BCD7890', 250.00, 10, 10),
(11, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), 300.50, 'EFG1234', 300.50, 11, 11),
(12, STR_TO_DATE('2024-05-12', '%Y-%m-%d'), 78.25, 'HIJ5678', 80.25, 12, 12),
(13, STR_TO_DATE('2024-05-13', '%Y-%m-%d'), 150.75, 'KLM9012', 150.75, 13, 13),
(14, STR_TO_DATE('2024-05-14', '%Y-%m-%d'), 200.00, 'NOP3456', 200.00, 14, 14),
(15, STR_TO_DATE('2024-05-25', '%Y-%m-%d'), 95.50, 'QRS7890', 95.50, 15, 15),
(16, STR_TO_DATE('2024-05-16', '%Y-%m-%d'), 130.25, 'TUV1234', 130.25, 16, 16),
(17, STR_TO_DATE('2024-05-17', '%Y-%m-%d'), 175.75, 'WXY5678', 175.75, 17, 17),
(18, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), 220.00, 'ZAB9012', 220.00, 18, 18),
(19, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 70.50, 'CDE3456', 70.50, 19, 19),
(20, STR_TO_DATE('2024-05-20', '%Y-%m-%d'), 180.25, 'FGH7890', 180.25, 20, 20),
(21, STR_TO_DATE('2024-05-21', '%Y-%m-%d'), 300.75, 'IJK1234', 300.75, 21, 21),
(22, STR_TO_DATE('2024-05-22', '%Y-%m-%d'), 50.00, 'LMN5678', 50.00, 22, 22),
(23, STR_TO_DATE('2024-05-23', '%Y-%m-%d'), 110.50, 'OPQ9012', 110.50, 23, 23),
(24, STR_TO_DATE('2024-05-04', '%Y-%m-%d'), 360.25, 'RST3456', 260.25, 24, 24),
(25, STR_TO_DATE('2024-05-16', '%Y-%m-%d'), 140.75, 'UVW7890', 140.75, 25, 25),
(26, STR_TO_DATE('2024-05-04', '%Y-%m-%d'), 190.00, 'XYZ1234', 190.00, 26, 26),
(27, STR_TO_DATE('2024-05-27', '%Y-%m-%d'), 85.50, 'ABC5678', 85.50, 27, 27),
(28, STR_TO_DATE('2024-05-18', '%Y-%m-%d'), 200.25, 'DEF9012', 200.25, 28, 28),
(29, STR_TO_DATE('2024-05-29', '%Y-%m-%d'), 150.75, 'GHI3456', 150.75, 29, 29),
(30, STR_TO_DATE('2024-05-30', '%Y-%m-%d'), 220.00, 'JKL7890', 220.00, 30, 30);

INSERT INTO prihod_za_zaposlenika (id, datum, id_transakcija_prihoda, id_prihod) VALUES -- Vedrana
(1, STR_TO_DATE('2024-01-01', '%Y-%m-%d'), 9, 5),
(2, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), 16, 8),
(3, STR_TO_DATE('2024-01-16', '%Y-%m-%d'), 28, 12),
(4, STR_TO_DATE('2024-01-18', '%Y-%m-%d'), 1, 26),
(5, STR_TO_DATE('2024-02-15', '%Y-%m-%d'), 19, 9),
(6, STR_TO_DATE('2024-04-27', '%Y-%m-%d'), 23, 28),
(7, STR_TO_DATE('2024-04-28', '%Y-%m-%d'), 4, 11),
(8, STR_TO_DATE('2024-04-29', '%Y-%m-%d'), 22, 3),
(9, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), 7, 24),
(10, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), 29, 30),
(11, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), 10, 16),
(12, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 14, 1),
(13, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 21, 29),
(14, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), 15, 14),
(15, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), 12, 18),
(16, STR_TO_DATE('2024-05-07', '%Y-%m-%d'), 30, 10),
(17, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), 11, 22),
(18, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 17, 7),
(19, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 8, 15),
(20, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 3, 2),
(21, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 13, 17),
(22, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 2, 13),
(23, STR_TO_DATE('2023-12-31', '%Y-%m-%d'), 18, 21),
(24, STR_TO_DATE('2022-12-31', '%Y-%m-%d'), 27, 6),
(25, STR_TO_DATE('2023-01-01', '%Y-%m-%d'), 25, 20),
(26, STR_TO_DATE('2023-03-28', '%Y-%m-%d'), 20, 19),
(27, STR_TO_DATE('2023-08-19', '%Y-%m-%d'), 6, 27),
(28, STR_TO_DATE('2023-08-19', '%Y-%m-%d'), 24, 25),
(29, STR_TO_DATE('2023-06-12', '%Y-%m-%d'), 5, 4),
(30, STR_TO_DATE('2023-07-15', '%Y-%m-%d'), 26, 23);

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
(1, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 'iskorišten', 1, 22),
(2, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), NULL, 'aktivan', 2, 8),
(3, STR_TO_DATE('2024-05-03', '%Y-%m-%d'), NULL, 'aktivan', 3, 4),
(4, STR_TO_DATE('2024-05-04', '%Y-%m-%d'), STR_TO_DATE('2024-05-15', '%Y-%m-%d'), 'iskorišten', 4, 18),
(5, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), NULL, 'aktivan', 5, 11),
(6, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), STR_TO_DATE('2024-05-20', '%Y-%m-%d'), 'iskorišten', 6, 24),
(7, STR_TO_DATE('2024-05-07', '%Y-%m-%d'), STR_TO_DATE('2024-05-22', '%Y-%m-%d'), 'iskorišten', 7, 25),
(8, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), NULL, 'aktivan', 8, 17),
(9, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), NULL, 'aktivan', 9, 5),
(10, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), NULL, 'aktivan', 10, 6),
(11, STR_TO_DATE('2024-05-11', '%Y-%m-%d'), NULL, 'aktivan', 11, 9),
(12, STR_TO_DATE('2024-05-12', '%Y-%m-%d'), STR_TO_DATE('2024-05-25', '%Y-%m-%d'), 'iskorišten', 12, 1),
(13, STR_TO_DATE('2024-05-13', '%Y-%m-%d'), NULL, 'aktivan', 13, 2),
(14, STR_TO_DATE('2024-05-14', '%Y-%m-%d'), NULL, 'aktivan', 14, 28),
(15, STR_TO_DATE('2024-05-15', '%Y-%m-%d'), NULL, 'aktivan', 15, 20),
(16, STR_TO_DATE('2024-05-16', '%Y-%m-%d'), NULL, 'aktivan', 16, 19),
(17, STR_TO_DATE('2024-05-17', '%Y-%m-%d'), NULL, 'aktivan', 17, 26),
(18, STR_TO_DATE('2024-05-18', '%Y-%m-%d'), NULL, 'aktivan', 18, 30),
(19, STR_TO_DATE('2024-05-19', '%Y-%m-%d'), STR_TO_DATE('2024-05-30', '%Y-%m-%d'), 'iskorišten', 19, 12),
(20, STR_TO_DATE('2024-05-20', '%Y-%m-%d'), NULL, 'aktivan', 20, 13),
(21, STR_TO_DATE('2024-05-21', '%Y-%m-%d'), STR_TO_DATE('2024-06-01', '%Y-%m-%d'), 'iskorišten', 21, 3),
(22, STR_TO_DATE('2024-05-22', '%Y-%m-%d'), NULL, 'aktivan', 22, 7),
(23, STR_TO_DATE('2024-05-23', '%Y-%m-%d'), NULL, 'aktivan', 23, 21),
(24, STR_TO_DATE('2024-05-24', '%Y-%m-%d'), NULL, 'aktivan', 24, 15),
(25, STR_TO_DATE('2024-05-25', '%Y-%m-%d'), STR_TO_DATE('2024-06-05', '%Y-%m-%d'), 'iskorišten', 25, 10),
(26, STR_TO_DATE('2024-05-26', '%Y-%m-%d'), NULL, 'aktivan', 26, 27),
(27, STR_TO_DATE('2024-05-27', '%Y-%m-%d'), NULL, 'aktivan', 27, 14),
(28, STR_TO_DATE('2024-05-28', '%Y-%m-%d'), NULL, 'aktivan', 28, 16),
(29, STR_TO_DATE('2024-05-29', '%Y-%m-%d'), NULL, 'aktivan', 29, 23),
(30, STR_TO_DATE('2024-05-30', '%Y-%m-%d'), STR_TO_DATE('2024-06-10', '%Y-%m-%d'), 'iskorišten', 30, 29);


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

INSERT INTO gotovinsko_placanje (id) VALUES -- Vedrana
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30);

INSERT INTO karticno_placanje (id, tip_kartice, id_pravna_osoba_banka) VALUES -- Vedrana
(1, 'Visa', 15),
(2, 'MasterCard', 8),
(3, 'American Express', 20),
(4, 'Visa', 3),
(5, 'MasterCard', 18),
(6, 'American Express', 10),
(7, 'Visa', 26),
(8, 'MasterCard', 5),
(9, 'American Express', 23),
(10, 'Visa', 12),
(11, 'MasterCard', 29),
(12, 'American Express', 7),
(13, 'Visa', 21),
(14, 'MasterCard', 9),
(15, 'American Express', 30),
(16, 'Visa', 1),
(17, 'MasterCard', 16),
(18, 'American Express', 25),
(19, 'Visa', 4),
(20, 'MasterCard', 19),
(21, 'American Express', 11),
(22, 'Visa', 27),
(23, 'MasterCard', 6),
(24, 'American Express', 24),
(25, 'Visa', 13),
(26, 'MasterCard', 28),
(27, 'American Express', 2),
(28, 'Visa', 22),
(29, 'MasterCard', 14),
(30, 'American Express', 17);


INSERT INTO kriptovalutno_placanje (id, kriptovaluta, broj_kripto_novcanika) VALUES -- Vedrana
(1, 'Bitcoin', '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa'),
(2, 'Ethereum', '0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B'),
(3, 'Ripple', 'rLW9gnQo7BQhU6igk5keqYnH3TVrCxGRzm'),
(4, 'Litecoin', 'LTdsVS8VDw6syvfQADdhf2PHAm3rMGJvPX'),
(5, 'Cardano', 'DdzFFzCqrhsqbWfBGm7cNsFtpeUe9E9pCn'),
(6, 'Polkadot', '14K3Td2RntYpjh8k3ZNRhhbUaFKSGR6jCH'),
(7, 'Stellar', 'GBRKY3RSQ4B4NEC27E6SNUFNFO6JR2BL6WFHZUM7DXTK7JFYQCOE3GGN'),
(8, 'Chainlink', '0xF37c348b7d19B17B29CD5cFA64Cfa48e2FfCc0D0'),
(9, 'VeChain', '0xd46e8dd67c5d32be8058bb8eb970870f07244567'),
(10, 'EOS', 'eosio.token'),
(11, 'Tezos', 'tz1bDXD6CwB9ixN1K5CEPB3YnsjmrFzdFQeF'),
(12, 'Bitcoin Cash', 'qrq4sk49ayvepqzs7fxfk2k8q43l4ennqvj89zq29c'),
(13, 'Tron', 'TPmZDMXGjNuckdvHFVsJ3oEoyVdZR5A6xW'),
(14, 'Dai', '0x6B175474E89094C44Da98b954EedeAC495271d0F'),
(15, 'Monero', '44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs'),
(16, 'Bitcoin SV', 'qpm2qsznhks23z7629mms6s4cwef74vcwvy22gdx6a'),
(17, 'NEO', 'AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y'),
(18, 'Cosmos', 'cosmos1hqrdl6wgt6z79ls8m5afwz0z0dventcx8pxyq9'),
(19, 'Dash', 'XbUwAtGtQXPwXLSHcQgjJnM1dAazfrP1qx'),
(20, 'Ethereum Classic', '0x3BbDf7cFf337e0C7Ad2C14A4E31B77E6e46D6a0d'),
(21, 'Zcash', 't1PW3q9CgBFG5KjDFyTf7FSNivVwzGws1QS'),
(22, 'Waves', '3PQmDCyxjXbykMEeR1aBNPbrfy6NVFj6jQx'),
(23, 'ICON', 'hx976b6eFf9A2F4984b73C1A10bf89F3e9Ea6e64a9'),
(24, 'Ontology', 'AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzm'),
(25, 'Ethereum Name Service', '0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85'),
(26, 'Aave', '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9'),
(27, 'Theta', '0x0f158571b8d15b12cbedbe14b14891e029f6c653'),
(28, 'Maker', '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2'),
(29, 'Compound', '0xc00e94cb662c3520282e6f5717214004a7f26888'),
(30, 'SushiSwap', '0x6b3595068778dd592e39a122f4f5a5cf09c90fe2');

INSERT INTO kontakt_pravne_osobe (id, email, broj_mobitela, broj_telefona, opis, id_pravna_osoba) VALUES -- Vedrana
(1, 'matej.kovac@example.hr', '+385989541333', '+38511234567', 'Glavni kontakt', 14),
(2, 'sara.jankovic@example.ba', '+385989541332', '+38511234569', 'Podrška', 22),
(3, 'marta.stankovic@example.rs', '+385989541331', '+38511234567', 'Prodaja', 5),
(4, 'lisa.mihajlovic@example.ba', '+4917712345678', '+493012345679', 'Računovodstvo', 25),
(5, 'lena.novak@example.si', '+447912345678', '+38511234568', 'Tehnička podrška', 27),
(6, 'tim.petric@example.hr', '+33612345678', '+33123456789', 'Korisnička podrška', 21),
(7, 'ivana.zupan@example.si', '+385989541338', '+38511234567', 'Marketing', 30),
(8, 'giulia.ivanovic@example.rs', '+393471234567', '+39123456782', 'Odnosi s javnošću', 17),
(9, 'elena.krajnc@example.si', '+393491234567', '+39123456780', 'Logistika', 19),
(10, 'boris.jakovljevic@example.ba', '+385989541328', '+38511234568', 'Nabava', 20),
(11, 'leo.pavlovic@example.hr', '+33623456789', '+33123456783', 'Administracija', 12),
(12, 'ana.peric@example.rs', '+385989541326', '+38511234567', 'Istraživanje i razvoj', 16),
(13, 'raphael.knez@example.si', '+393921234567', '+39123456789', 'Kvaliteta', 3),
(14, 'nina.stojanovic@example.ba', '+4915112345678', '+493012345672', 'Proizvodnja', 6),
(15, 'julie.kovac@example.si', '+33123456782', '+33123456782', 'Uprava', 7),
(16, 'marko.kovacevic@example.hr', '+385989541324', '+38511234567', 'Glavni kontakt', 11),
(17, 'claire.vidovic@example.si', '+33633456789', '+33123456784', 'Podrška', 4),
(18, 'louis.markovic@example.rs', '+33612456789', '+33123456781', 'Prodaja', 15),
(19, 'ivana.milosevic@example.ba', '+385989541322', '+38511234567', 'Računovodstvo', 26),
(20, 'matej.kralj@example.si', '+385989541320', '+38511234567', 'Tehnička podrška', 28),
(21, 'sara.horvat@example.hr', '+385989541318', '+38511234569', 'Korisnička podrška', 23),
(22, 'lena.jankovic@example.rs', '+385989541316', '+38511234568', 'Marketing', 8),
(23, 'tim.stojanovic@example.si', '+33614567890', '+33123456789', 'Odnosi s javnošću', 9),
(24, 'giulia.petric@example.si', '+393191234567', '+39123456782', 'Logistika', 10),
(25, 'boris.nikolic@example.rs', '+385989541310', '+38511234568', 'Nabava', 18),
(26, 'leo.stojanovic@example.ba', '+33614789523', '+33123456783', 'Administracija', 1),
(27, 'ana.kovacevic@example.rs', '+385989541304', '+38511234567', 'Istraživanje i razvoj', 2),
(28, 'raphael.milosevic@example.si', '+393921234567', '+39123456789', 'Kvaliteta', 13),
(29, 'nina.zupan@example.ba', '+4915112345678', '+493012345672', 'Proizvodnja', 24),
(30, 'julie.kralj@example.si', '+33611234567', '+33123456782', 'Uprava', 29);

INSERT INTO serija (id, ime, proizvodac, tip_mjenjaca, broj_sjedala, broj_vrata) VALUES -- Vedrana
(1, 'Yaris', 'Toyota', 'Automatski', 5, 4),
(2, 'Civic', 'Honda', 'Ručni', 5, 4),
(3, 'Focus', 'Ford', 'Automatski', 5, 4),
(4, 'Camaro', 'Chevrolet', 'Ručni', NULL, 2),
(5, 'Altima', 'Nissan', 'Automatski', 5, 4),
(6, 'Golf', 'Volkswagen', 'Ručni', 5, 4),
(7, '3 Series', 'BMW', 'Automatski', 5, 4),
(8, 'E-Class', 'Mercedes-Benz', 'Ručni', 5, 4),
(9, 'A4', 'Audi', 'Automatski', 5, 4),
(10, 'Elantra', 'Hyundai', 'Ručni', 5, 4),
(11, 'Corolla', 'Toyota', 'Automatski', 5, 4),
(12, 'Accord', 'Honda', 'Ručni', 5, 4),
(13, 'Fusion', 'Ford', 'Automatski', 5, 4),
(14, 'Malibu', 'Chevrolet', 'Ručni', 5, 4),
(15, 'Maxima', 'Nissan', 'Automatski', 5, 4),
(16, 'Passat', 'Volkswagen', 'Ručni', 5, 4),
(17, '5 Series', 'BMW', 'Automatski', 5, 4),
(18, 'C-Class', 'Mercedes-Benz', 'Ručni', 5, 4),
(19, 'A6', 'Audi', 'Automatski', 5, 4),
(20, 'Sonata', 'Hyundai', 'Ručni', 5, 4),
(21, 'Supra', 'Toyota', 'Automatski', 5, 2),
(22, 'CR-V', 'Honda', 'Ručni', 5, 4),
(23, 'Escape', 'Ford', 'Automatski', 5, 4),
(24, 'Equinox', 'Chevrolet', 'Ručni', 5, 4),
(25, 'Rogue', 'Nissan', 'Automatski', 5, 4),
(26, 'Tiguan', 'Volkswagen', 'Ručni', 5, 4),
(27, 'X3', 'BMW', 'Automatski', 5, 4),
(28, 'GLC', 'Mercedes-Benz', 'Ručni', 5, 4),
(29, 'Q5', 'Audi', 'Automatski', 5, 4),
(30, 'Santa Fe', 'Hyundai', 'Ručni', 5, 4);

INSERT INTO vozilo (id, godina_proizvodnje, registracijska_tablica, tip_punjenja, duljina, visina, nosivost, id_serija, tip_vozila) VALUES -- Mirela
(1, '2018', 'ZG1234AB', 'Električno', 4.50, 1.60, 1000.00, 1, 'K'),
(2, '2019', 'ST5678CD', 'Hibridno', 4.70, 1.75, 1200.00, 2, 'M'),
(3, '2017', 'ZG9012EF', 'Benzin', 4.30, 1.50, 800.00, 1, 'A'),
(4, '2020', 'RI3456GH', 'Diesel', 4.60, 1.70, 1100.00, 3, 'K'),
(5, '2018', 'OS7890IJ', 'Električno', 4.55, 1.65, 1050.00, 2, 'M'),
(6, '2019', 'PU2345KL', 'Benzin', 4.80, 1.80, 1250.00, 3, 'A'),
(7, '2023', 'DU6789MN', 'Hibridno', 4.50, 1.60, 1000.00, 1, 'K'),
(8, '2020', 'KA1234OP', 'Diesel', 4.75, 1.78, 1150.00, 2, 'M'),
(9, '2024', 'ZG5678QR', 'Električno', 4.40, 1.55, 950.00, 3, 'A'),
(10, '2022', 'ST9012RS', 'Benzin', 4.65, 1.72, 1100.00, 1, 'K'),
(11, '2021', 'ZG3456TU', 'Hibridno', 4.70, 1.75, 1200.00, 2, 'M'),
(12, '2020', 'RI7890VW', 'Diesel', 4.60, 1.70, 1150.00, 3, 'A'),
(13, '2018', 'OS1234XY', 'Električno', 4.55, 1.65, 1000.00, 1, 'K'),
(14, '2019', 'PU5678ZA', 'Benzin', 4.80, 1.80, 1250.00, 2, 'M'),
(15, '2010', 'DU9012BC', 'Hibridno', 4.50, 1.60, 950.00, 3, 'A'),
(16, '2020', 'KA3456DE', 'Diesel', 4.65, 1.72, 1050.00, 1, 'K'),
(17, '2018', 'ZG7890FG', 'Električno', 4.70, 1.75, 1150.00, 2, 'M'),
(18, '2023', 'ST1234HI', 'Benzin', 4.80, 1.80, 1200.00, 3, 'A'),
(19, '2017', 'ZG5678JK', 'Hibridno', 4.60, 1.70, 1100.00, 1, 'K'),
(20, '2020', 'RI9012LM', 'Diesel', 4.75, 1.78, 1250.00, 2, 'M'),
(21, '2015', 'OS3456NO', 'Električno', 4.55, 1.65, 950.00, 3, 'A'),
(22, '2019', 'PU7890PQ', 'Benzin', 4.80, 1.80, 1300.00, 1, 'K'),
(23, '2017', 'DU1234RS', 'Hibridno', 4.50, 1.60, 1000.00, 2, 'M'),
(24, '2020', 'KA5678TU', 'Diesel', 4.70, 1.75, 1150.00, 3, 'A'),
(25, '2018', 'ZG9012VW', 'Električno', 4.40, 1.55, 900.00, 1, 'K'),
(26, '2019', 'ST3456XY', 'Benzin', 4.60, 1.70, 1100.00, 2, 'M'),
(27, '2017', 'ZG7890ZA', 'Hibridno', 4.55, 1.65, 950.00, 3, 'A'),
(28, '2022', 'RI1234BC', 'Diesel', 4.80, 1.80, 1250.00, 1, 'K'),
(29, '2018', 'OS5678DE', 'Električno', 4.70, 1.75, 1150.00, 2, 'M'),
(30, '2019', 'PU9012FG', 'Benzin', 4.75, 1.78, 1200.00, 3, 'A');



INSERT INTO najam_vozila (id, id_transakcija_najam, id_vozilo, datum_pocetka, datum_zavrsetka, status, pocetna_kilometraza, zavrsna_kilometraza) VALUES -- Mirela
(1, 20, 17, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 'Aktivan', 1000.00, 1470.00),
(2, 3, 5, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), STR_TO_DATE('2024-05-11', '%Y-%m-%d'), 'Aktivan', 980.00, 1100.00),
(3, 12, 23, STR_TO_DATE('2024-05-03', '%Y-%m-%d'), STR_TO_DATE('2024-05-12', '%Y-%m-%d'), 'Aktivan', 980.00, 1300.00),
(4, 27, 13, STR_TO_DATE('2024-05-04', '%Y-%m-%d'), STR_TO_DATE('2024-05-13', '%Y-%m-%d'), 'Neaktivan', 950.00, 1150.00),
(5, 8, 29, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), STR_TO_DATE('2024-05-14', '%Y-%m-%d'), 'Neaktivan', 1050.00, 1250.00),
(6, 26, 30, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), STR_TO_DATE('2024-05-15', '%Y-%m-%d'), 'Aktivan', 980.00, 1180.00),
(7, 15, 21, STR_TO_DATE('2024-05-07', '%Y-%m-%d'), STR_TO_DATE('2024-05-16', '%Y-%m-%d'), 'Neaktivan', 1180.00, 1350.00),
(8, 7, 8, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), STR_TO_DATE('2024-05-17', '%Y-%m-%d'), 'Aktivan', 1020.00, 1200.00),
(9, 18, 14, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 'Aktivan', 1080.00, 1200.00),
(10, 9, 28, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), STR_TO_DATE('2024-05-12', '%Y-%m-%d'), 'Aktivan', 1005.00, 1585.00),
(11, 11, 24, STR_TO_DATE('2024-05-11', '%Y-%m-%d'), STR_TO_DATE('2024-05-12', '%Y-%m-%d'), 'Aktivan', 950.00, 1150.00),
(12, 28, 3, STR_TO_DATE('2024-05-12', '%Y-%m-%d'), STR_TO_DATE('2024-05-14', '%Y-%m-%d'), 'Aktivan', 970.00, 1170.00),
(13, 1, 4, STR_TO_DATE('2024-05-13', '%Y-%m-%d'), STR_TO_DATE('2024-05-22', '%Y-%m-%d'), 'Aktivan', 990.00, 1190.00),
(14, 23, 15, STR_TO_DATE('2024-05-14', '%Y-%m-%d'), STR_TO_DATE('2024-05-16', '%Y-%m-%d'), 'Aktivan', 1025.00, 1225.00),
(15, 5, 22, STR_TO_DATE('2024-05-15', '%Y-%m-%d'), STR_TO_DATE('2024-05-18', '%Y-%m-%d'), 'Aktivan', 975.00, 1175.00),
(16, 13, 22, STR_TO_DATE('2024-05-16', '%Y-%m-%d'), STR_TO_DATE('2024-05-20', '%Y-%m-%d'), 'Aktivan', 1030.00, 1330.00),
(17, 19, 18, STR_TO_DATE('2024-05-17', '%Y-%m-%d'), STR_TO_DATE('2024-05-20', '%Y-%m-%d'), 'Neaktivan', 1015.00, 1215.00),
(18, 6, 2, STR_TO_DATE('2024-05-18', '%Y-%m-%d'), STR_TO_DATE('2024-05-19', '%Y-%m-%d'), 'Aktivan', 980.00, 1180.00),
(19, 25, 22, STR_TO_DATE('2024-05-19', '%Y-%m-%d'), STR_TO_DATE('2024-05-28', '%Y-%m-%d'), 'Aktivan', 1100.00, 1300.00),
(20, 22, 19, STR_TO_DATE('2024-05-20', '%Y-%m-%d'), STR_TO_DATE('2024-05-29', '%Y-%m-%d'), 'Aktivan', 960.00, 1110.00),
(21, 4, 7, STR_TO_DATE('2024-05-21', '%Y-%m-%d'), STR_TO_DATE('2024-05-30', '%Y-%m-%d'), 'Aktivan', 1000.00, 1200.00),
(22, 14, 7, STR_TO_DATE('2024-05-22', '%Y-%m-%d'), STR_TO_DATE('2024-05-31', '%Y-%m-%d'), 'Aktivan', 1035.00, 1235.00),
(23, 30, 20, STR_TO_DATE('2024-05-23', '%Y-%m-%d'), STR_TO_DATE('2024-06-01', '%Y-%m-%d'), 'Aktivan', 990.00, 1190.00),
(24, 10, 7, STR_TO_DATE('2024-05-24', '%Y-%m-%d'), STR_TO_DATE('2024-06-02', '%Y-%m-%d'), 'Aktivan', 1020.00, 1290.00),
(25, 17, 1, STR_TO_DATE('2024-05-25', '%Y-%m-%d'), STR_TO_DATE('2024-06-03', '%Y-%m-%d'), 'Aktivan', 980.00, 1180.00),
(26, 24, 11, STR_TO_DATE('2024-05-26', '%Y-%m-%d'), STR_TO_DATE('2024-06-04', '%Y-%m-%d'), 'Aktivan', 1005.00, 1205.00),
(27, 2, 27, STR_TO_DATE('2024-05-27', '%Y-%m-%d'), STR_TO_DATE('2024-06-05', '%Y-%m-%d'), 'Neaktivan', 1050.00, 1250.00),
(28, 29, 30, STR_TO_DATE('2024-05-28', '%Y-%m-%d'), STR_TO_DATE('2024-06-06', '%Y-%m-%d'), 'Neaktivan', 920.00, 1170.00),
(29, 21, 9, STR_TO_DATE('2024-05-29', '%Y-%m-%d'), STR_TO_DATE('2024-06-07', '%Y-%m-%d'), 'Aktivan', 1025.00, 1225.00),
(30, 16, 6, STR_TO_DATE('2024-05-30', '%Y-%m-%d'), STR_TO_DATE('2024-06-08', '%Y-%m-%d'), 'Aktivan', 1000.00, 1150.00);

INSERT INTO slika_vozila (id, id_vozilo, slika, pozicija) VALUES -- Marinela
(1, 1, 'http://tvrtka-za-najam-vozila.com/slike/vozilo1.jpg', 'prednja'),
(2, 1, 'http://tvrtka-za-najam-vozila.com/slike/vozilo2.jpg', 'bočna'),
(3, 1, 'http://tvrtka-za-najam-vozila.com/slike/vozilo3.jpg', 'stražnja'),
(4, 2, 'http://tvrtka-za-najam-vozila.com/slike/vozilo4.jpg', 'stražnja'),
(5, 2, 'http://tvrtka-za-najam-vozila.com/slike/vozilo5.jpg', 'bočna'),
(6, 2, 'http://tvrtka-za-najam-vozila.com/slike/vozilo6.jpg', 'prednja'),
(7, 3, 'http://tvrtka-za-najam-vozila.com/slike/vozilo7.jpg', 'bočna'),
(8, 3, 'http://tvrtka-za-najam-vozila.com/slike/vozilo8.jpg', 'prednja'),
(9, 4, 'http://tvrtka-za-najam-vozila.com/slike/vozilo9.jpg', 'stražnja'),
(10, 5, 'http://tvrtka-za-najam-vozila.com/slike/vozilo10.jpg', 'stražnja'),
(11, 5, 'http://tvrtka-za-najam-vozila.com/slike/vozilo11.jpg', 'prednja'),
(12, 6, 'http://tvrtka-za-najam-vozila.com/slike/vozilo12.jpg', 'bočna'),
(13, 6, 'http://tvrtka-za-najam-vozila.com/slike/vozilo13.jpg', 'stražnja'),
(14, 7, 'http://tvrtka-za-najam-vozila.com/slike/vozilo14.jpg', 'stražnja'),
(15, 7, 'http://tvrtka-za-najam-vozila.com/slike/vozilo15.jpg', 'bočna'),
(16, 7, 'http://tvrtka-za-najam-vozila.com/slike/vozilo16.jpg', 'prednja'),
(17, 8, 'http://tvrtka-za-najam-vozila.com/slike/vozilo17.jpg', 'bočna'),
(18, 8, 'http://tvrtka-za-najam-vozila.com/slike/vozilo18.jpg', 'stražnja'),
(19, 9, 'http://tvrtka-za-najam-vozila.com/slike/vozilo19.jpg', 'stražnja'),
(20, 9, 'http://tvrtka-za-najam-vozila.com/slike/vozilo20.jpg', 'bočna'),
(21, 10, 'http://tvrtka-za-najam-vozila.com/slike/vozilo21.jpg', 'prednja'),
(22, 10, 'http://tvrtka-za-najam-vozila.com/slike/vozilo22.jpg', 'bočna'),
(23, 10, 'http://tvrtka-za-najam-vozila.com/slike/vozilo23.jpg', 'stražnja'),
(24, 11, 'http://tvrtka-za-najam-vozila.com/slike/vozilo24.jpg', 'stražnja'),
(25, 11, 'http://tvrtka-za-najam-vozila.com/slike/vozilo25.jpg', 'bočna'),
(26, 12, 'http://tvrtka-za-najam-vozila.com/slike/vozilo26.jpg', 'prednja'),
(27, 12, 'http://tvrtka-za-najam-vozila.com/slike/vozilo27.jpg', 'bočna'),
(28, 13, 'http://tvrtka-za-najam-vozila.com/slike/vozilo28.jpg', 'prednja'),
(29, 13, 'http://tvrtka-za-najam-vozila.com/slike/vozilo29.jpg', 'stražnja'),
(30, 14, 'http://tvrtka-za-najam-vozila.com/slike/vozilo30.jpg', 'stražnja'),
(31, 14, 'http://tvrtka-za-najam-vozila.com/slike/vozilo31.jpg', 'prednja'),
(32, 15, 'http://tvrtka-za-najam-vozila.com/slike/vozilo32.jpg', 'bočna'),
(33, 15, 'http://tvrtka-za-najam-vozila.com/slike/vozilo33.jpg', 'stražnja'),
(34, 16, 'http://tvrtka-za-najam-vozila.com/slike/vozilo34.jpg', 'stražnja'),
(35, 17, 'http://tvrtka-za-najam-vozila.com/slike/vozilo35.jpg', 'bočna'),
(36, 17, 'http://tvrtka-za-najam-vozila.com/slike/vozilo36.jpg', 'prednja'),
(37, 18, 'http://tvrtka-za-najam-vozila.com/slike/vozilo37.jpg', 'bočna'),
(38, 19, 'http://tvrtka-za-najam-vozila.com/slike/vozilo38.jpg', 'prednja'),
(39, 19, 'http://tvrtka-za-najam-vozila.com/slike/vozilo39.jpg', 'stražnja'),
(40, 20, 'http://tvrtka-za-najam-vozila.com/slike/vozilo40.jpg', 'stražnja'),
(41, 20, 'http://tvrtka-za-najam-vozila.com/slike/vozilo41.jpg', 'prednja'),
(42, 21, 'http://tvrtka-za-najam-vozila.com/slike/vozilo42.jpg', 'bočna'),
(43, 21, 'http://tvrtka-za-najam-vozila.com/slike/vozilo43.jpg', 'stražnja'),
(44, 22, 'http://tvrtka-za-najam-vozila.com/slike/vozilo44.jpg', 'stražnja'),
(45, 22, 'http://tvrtka-za-najam-vozila.com/slike/vozilo45.jpg', 'bočna'),
(46, 23, 'http://tvrtka-za-najam-vozila.com/slike/vozilo46.jpg', 'prednja'),
(47, 24, 'http://tvrtka-za-najam-vozila.com/slike/vozilo47.jpg', 'bočna'),
(48,24, 'http://tvrtka-za-najam-vozila.com/slike/vozilo48.jpg', 'stražnja'),
(49, 25, 'http://tvrtka-za-najam-vozila.com/slike/vozilo49.jpg', 'stražnja'),
(50, 25, 'http://tvrtka-za-najam-vozila.com/slike/vozilo50.jpg', 'bočna'),
(51, 26, 'http://tvrtka-za-najam-vozila.com/slike/vozilo51.jpg', 'prednja'),
(52, 27, 'http://tvrtka-za-najam-vozila.com/slike/vozilo52.jpg', 'bočna'),
(53, 27, 'http://tvrtka-za-najam-vozila.com/slike/vozilo53.jpg', 'stražnja'),
(54, 28, 'http://tvrtka-za-najam-vozila.com/slike/vozilo54.jpg', 'stražnja'),
(55, 28, 'http://tvrtka-za-najam-vozila.com/slike/vozilo55.jpg', 'bočna'),
(56, 28, 'http://tvrtka-za-najam-vozila.com/slike/vozilo56.jpg', 'prednja'),
(57, 29, 'http://tvrtka-za-najam-vozila.com/slike/vozilo57.jpg', 'bočna'),
(58, 29, 'http://tvrtka-za-najam-vozila.com/slike/vozilo58.jpg', 'prednja'),
(59, 30, 'http://tvrtka-za-najam-vozila.com/slike/vozilo59.jpg', 'prednja'),
(60, 30, 'http://tvrtka-za-najam-vozila.com/slike/vozilo60.jpg', 'stražnja');

INSERT INTO tip_osiguranja (id, id_osiguravajuca_kuca, tip_osiguranja) VALUES -- Marinela
(1, 14, 'osnovno'),
(2, 3, 'kasko'),
(3, 21, 'premium'),
(4, 7, 'osnovno'),
(5, 30, 'kasko'),
(6, 18, 'premium'),
(7, 4, 'osnovno'),
(8, 16, 'osnovno'),
(9, 29, 'premium'),
(10, 11, 'osnovno'),
(11, 2, 'kasko'),
(12, 23, 'osnovno'),
(13, 5, 'osnovno'),
(14, 27, 'kasko'),
(15, 1, 'premium'),
(16, 20, 'osnovno'),
(17, 6, 'kasko'),
(18, 25, 'osnovno'),
(19, 8, 'osnovno'),
(20, 22, 'kasko'),
(21, 10, 'kasko'),
(22, 13, 'osnovno'),
(23, 9, 'kasko'),
(24, 28, 'premium'),
(25, 12, 'osnovno'),
(26, 19, 'kasko'),
(27, 17, 'premium'),
(28, 26, 'osnovno'),
(29, 24, 'kasko'),
(30, 15, 'premium');

INSERT INTO osiguranje (id, id_vozilo, id_transakcija, id_tip_osiguranja, datum_pocetka, datum_zavrsetka) VALUES -- Vedrana
(1, 22, 18, 19, STR_TO_DATE('2023-05-03', '%Y-%m-%d'), STR_TO_DATE('2024-05-02', '%Y-%m-%d')),
(2, 5, 26, 2, STR_TO_DATE('2023-06-05', '%Y-%m-%d'), STR_TO_DATE('2024-06-04', '%Y-%m-%d')),
(3, 11, 3, 14, STR_TO_DATE('2023-07-07', '%Y-%m-%d'), STR_TO_DATE('2024-07-06', '%Y-%m-%d')),
(4, 15, 9, 30, STR_TO_DATE('2023-08-09', '%Y-%m-%d'), STR_TO_DATE('2024-08-08', '%Y-%m-%d')),
(5, 25, 15, 22, STR_TO_DATE('2023-09-11', '%Y-%m-%d'), STR_TO_DATE('2024-09-10', '%Y-%m-%d')),
(6, 27, 30, 7, STR_TO_DATE('2023-10-13', '%Y-%m-%d'), STR_TO_DATE('2024-10-12', '%Y-%m-%d')),
(7, 17, 4, 16, STR_TO_DATE('2023-11-15', '%Y-%m-%d'), STR_TO_DATE('2024-11-14', '%Y-%m-%d')),
(8, 9, 23, 11, STR_TO_DATE('2023-12-17', '%Y-%m-%d'), STR_TO_DATE('2024-12-16', '%Y-%m-%d')),
(9, 18, 3, 24, STR_TO_DATE('2024-01-19', '%Y-%m-%d'), STR_TO_DATE('2025-01-18', '%Y-%m-%d')),
(10, 3, 16, 4, STR_TO_DATE('2024-02-21', '%Y-%m-%d'), STR_TO_DATE('2025-02-20', '%Y-%m-%d')),
(11, 29, 12, 5, STR_TO_DATE('2024-03-23', '%Y-%m-%d'), STR_TO_DATE('2025-03-22', '%Y-%m-%d')),
(12, 22, 29, 17, STR_TO_DATE('2024-04-25', '%Y-%m-%d'), STR_TO_DATE('2025-04-24', '%Y-%m-%d')),
(13, 7, 10, 28, STR_TO_DATE('2024-05-27', '%Y-%m-%d'), STR_TO_DATE('2025-05-26', '%Y-%m-%d')),
(14, 2, 21, 6, STR_TO_DATE('2024-06-29', '%Y-%m-%d'), STR_TO_DATE('2025-06-28', '%Y-%m-%d')),
(15, 21, 2, 23, STR_TO_DATE('2024-07-31', '%Y-%m-%d'), STR_TO_DATE('2025-07-30', '%Y-%m-%d')),
(16, 12, 17, 15, STR_TO_DATE('2024-08-02', '%Y-%m-%d'), STR_TO_DATE('2025-08-01', '%Y-%m-%d')),
(17, 28, 20, 10, STR_TO_DATE('2024-09-04', '%Y-%m-%d'), STR_TO_DATE('2025-09-03', '%Y-%m-%d')),
(18, 14, 22, 12, STR_TO_DATE('2024-10-06', '%Y-%m-%d'), STR_TO_DATE('2025-10-05', '%Y-%m-%d')),
(19, 26, 6, 1, STR_TO_DATE('2024-11-08', '%Y-%m-%d'), STR_TO_DATE('2025-11-07', '%Y-%m-%d')),
(20, 10, 25, 13, STR_TO_DATE('2024-12-10', '%Y-%m-%d'), STR_TO_DATE('2025-12-09', '%Y-%m-%d')),
(21, 24, 19, 8, STR_TO_DATE('2025-01-12', '%Y-%m-%d'), STR_TO_DATE('2026-01-11', '%Y-%m-%d')),
(22, 8, 1, 20, STR_TO_DATE('2025-02-14', '%Y-%m-%d'), STR_TO_DATE('2026-02-13', '%Y-%m-%d')),
(23, 30, 26, 25, STR_TO_DATE('2025-03-16', '%Y-%m-%d'), STR_TO_DATE('2026-03-15', '%Y-%m-%d')),
(24, 6, 14, 18, STR_TO_DATE('2025-04-18', '%Y-%m-%d'), STR_TO_DATE('2026-04-17', '%Y-%m-%d')),
(25, 19, 9, 27, STR_TO_DATE('2025-05-20', '%Y-%m-%d'), STR_TO_DATE('2026-05-19', '%Y-%m-%d')),
(26, 1, 24, 3, STR_TO_DATE('2025-06-22', '%Y-%m-%d'), STR_TO_DATE('2026-06-21', '%Y-%m-%d')),
(27, 16, 8, 26, STR_TO_DATE('2025-07-26', '%Y-%m-%d'), STR_TO_DATE('2026-07-25', '%Y-%m-%d')),
(28, 13, 27, 29, STR_TO_DATE('2025-08-28', '%Y-%m-%d'), STR_TO_DATE('2026-08-27', '%Y-%m-%d')),
(29, 23, 26, 21, STR_TO_DATE('2025-09-29', '%Y-%m-%d'), STR_TO_DATE('2026-09-28', '%Y-%m-%d')),
(30, 4, 18, 15, STR_TO_DATE('2025-10-31', '%Y-%m-%d'), STR_TO_DATE('2026-09-28', '%Y-%m-%d'));

INSERT INTO steta (id, tip, opis) VALUES -- Vedrana
(1, 'Oštećenje', 'Oštećenje lijevog retrovizora'),
(2, 'Krađa', 'Ukraden radio iz vozila'),
(3, 'Oštećenje', 'Oštećenje prednjeg branika'),
(4, 'Nesreća', 'Zamjena stražnjeg branika nakon sudara'),
(5, 'Krađa', 'Ukraden laptop iz vozila'),
(6, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana'),
(7, 'Nesreća', 'Oštećenje vrata nakon parkiranja'),
(8, 'Oštećenje', 'Oštećenje bočnog retrovizora'),
(9, 'Krađa', 'Ukradena navigacija iz vozila'),
(10, 'Oštećenje', 'Oštećenje lijevog bočnog stakla'),
(11, 'Krađa', 'Ukradena registracijska pločica'),
(12, 'Oštećenje', 'Oštećenje desnog bočnog stakla'),
(13, 'Nesreća', 'Oštećenje haube nakon sudara'),
(14, 'Oštećenje', 'Oštećenje lijevog prednjeg blatobrana'),
(15, 'Krađa', 'Ukradena antena s vozila'),
(16, 'Oštećenje', 'Oštećenje desnog retrovizora'),
(17, 'Krađa', 'Ukraden volan iz vozila'),
(18, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(19, 'Nesreća', 'Oštećenje stražnjeg stakla nakon sudara'),
(20, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(21, 'Krađa', 'Ukraden CD player iz vozila'),
(22, 'Oštećenje', 'Oštećenje desnog bočnog stakla'),
(23, 'Nesreća', 'Oštećenje stražnjeg branika nakon sudara'),
(24, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(25, 'Krađa', 'Ukradena oprema za prvu pomoć iz vozila'),
(26, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana'),
(27, 'Nesreća', 'Oštećenje lijevog prednjeg blatobrana nakon sudara'),
(28, 'Oštećenje', 'Oštećenje lijevog bočnog stakla'),
(29, 'Krađa', 'Ukraden mobitel iz vozila'),
(30, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana');

INSERT INTO naknada_stete (id, datum_pocetka, datum_zavrsetka, id_transakcija, id_osiguranje, id_steta) VALUES -- Vedrana
(1, STR_TO_DATE('2023-08-01', '%Y-%m-%d'), STR_TO_DATE('2024-02-01', '%Y-%m-%d'), 12, 3, 21),
(2, STR_TO_DATE('2023-09-15', '%Y-%m-%d'), STR_TO_DATE('2024-03-15', '%Y-%m-%d'), 7, 18, 14),
(3, STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2024-04-20', '%Y-%m-%d'), 20, 24, 5),
(4, STR_TO_DATE('2023-11-05', '%Y-%m-%d'), STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 4, 16, 27),
(5, STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2024-06-10', '%Y-%m-%d'), 25, 20, 11),
(6, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-07-15', '%Y-%m-%d'), 29, 8, 1),
(7, STR_TO_DATE('2024-02-20', '%Y-%m-%d'), STR_TO_DATE('2024-08-20', '%Y-%m-%d'), 17, 30, 15),
(8, STR_TO_DATE('2024-03-05', '%Y-%m-%d'), STR_TO_DATE('2024-09-05', '%Y-%m-%d'), 23, 14, 22),
(9, STR_TO_DATE('2024-04-10', '%Y-%m-%d'), STR_TO_DATE('2024-10-10', '%Y-%m-%d'), 5, 22, 9),
(10, STR_TO_DATE('2024-05-15', '%Y-%m-%d'), STR_TO_DATE('2024-11-15', '%Y-%m-%d'), 21, 26, 18),
(11, STR_TO_DATE('2024-06-20', '%Y-%m-%d'), STR_TO_DATE('2024-12-20', '%Y-%m-%d'), 1, 10, 26),
(12, STR_TO_DATE('2024-07-25', '%Y-%m-%d'), STR_TO_DATE('2025-01-25', '%Y-%m-%d'), 19, 2, 8),
(13, STR_TO_DATE('2024-08-30', '%Y-%m-%d'), STR_TO_DATE('2025-02-28', '%Y-%m-%d'), 11, 6, 13),
(14, STR_TO_DATE('2024-10-05', '%Y-%m-%d'), STR_TO_DATE('2025-04-05', '%Y-%m-%d'), 30, 28, 16),
(15, STR_TO_DATE('2024-11-10', '%Y-%m-%d'), STR_TO_DATE('2025-05-10', '%Y-%m-%d'), 15, 4, 23),
(16, STR_TO_DATE('2024-12-15', '%Y-%m-%d'), STR_TO_DATE('2025-06-15', '%Y-%m-%d'), 28, 12, 6),
(17, STR_TO_DATE('2025-01-20', '%Y-%m-%d'), STR_TO_DATE('2025-07-20', '%Y-%m-%d'), 13, 16, 29),
(18, STR_TO_DATE('2025-02-25', '%Y-%m-%d'), STR_TO_DATE('2025-08-25', '%Y-%m-%d'), 24, 26, 19),
(19, STR_TO_DATE('2025-04-01', '%Y-%m-%d'), STR_TO_DATE('2025-10-01', '%Y-%m-%d'), 22, 8, 2),
(20, STR_TO_DATE('2025-05-05', '%Y-%m-%d'), STR_TO_DATE('2025-11-05', '%Y-%m-%d'), 2, 18, 10),
(21, STR_TO_DATE('2025-06-10', '%Y-%m-%d'), STR_TO_DATE('2025-12-10', '%Y-%m-%d'), 16, 20, 4),
(22, STR_TO_DATE('2025-07-15', '%Y-%m-%d'), STR_TO_DATE('2026-01-15', '%Y-%m-%d'), 10, 24, 12),
(23, STR_TO_DATE('2025-08-20', '%Y-%m-%d'), STR_TO_DATE('2026-02-20', '%Y-%m-%d'), 27, 6, 25),
(24, STR_TO_DATE('2025-09-25', '%Y-%m-%d'), STR_TO_DATE('2026-03-25', '%Y-%m-%d'), 9, 14, 7),
(25, STR_TO_DATE('2025-10-30', '%Y-%m-%d'), STR_TO_DATE('2026-04-30', '%Y-%m-%d'), 6, 18, 20),
(26, STR_TO_DATE('2025-12-05', '%Y-%m-%d'), STR_TO_DATE('2026-06-05', '%Y-%m-%d'), 18, 26, 3),
(27, STR_TO_DATE('2026-01-10', '%Y-%m-%d'), STR_TO_DATE('2026-07-10', '%Y-%m-%d'), 8, 4, 17),
(28, STR_TO_DATE('2026-02-15', '%Y-%m-%d'), STR_TO_DATE('2026-08-15', '%Y-%m-%d'), 25, 10, 24),
(29, STR_TO_DATE('2026-03-20', '%Y-%m-%d'), STR_TO_DATE('2026-09-20', '%Y-%m-%d'), 3, 22, 28),
(30, STR_TO_DATE('2026-04-25', '%Y-%m-%d'), STR_TO_DATE('2026-10-25', '%Y-%m-%d'), 26, 28, 1);

INSERT INTO punjenje (id, id_transakcija_punjenje, id_vozilo, kolicina, tip_punjenja) VALUES -- Vedrana
(1, 12, 3, 45.5, 'benzin'),
(2, 8, 22, 60.2, 'dizel'),
(3, 20, 14, 35.8, 'električno'),
(4, 4, 16, 42.3, 'plin'),
(5, 25, 20, 55.1, 'benzin'),
(6, 27, 30, 48.6, 'dizel'),
(7, 17, 4, 39.9, 'električno'),
(8, 9, 23, 57.4, 'plin'),
(9, 18, 3, 43.7, 'benzin'),
(10, 3, 16, 50.8, 'dizel'),
(11, 29, 12, 38.5, 'električno'),
(12, 22, 29, 52.9, 'plin'),
(13, 7, 10, 47.3, 'benzin'),
(14, 2, 21, 34.6, 'dizel'),
(15, 21, 2, 56.7, 'električno'),
(16, 12, 17, 41.2, 'plin'),
(17, 28, 20, 48.3, 'benzin'),
(18, 14, 22, 37.4, 'dizel'),
(19, 26, 6, 53.2, 'električno'),
(20, 10, 25, 46.8, 'plin'),
(21, 24, 19, 51.5, 'benzin'),
(22, 8, 1, 36.7, 'dizel'),
(23, 30, 26, 54.6, 'električno'),
(24, 6, 14, 40.9, 'plin'),
(25, 19, 9, 49.1, 'benzin'),
(26, 1, 24, 33.7, 'dizel'),
(27, 16, 8, 52.4, 'električno'),
(28, 13, 27, 37.8, 'plin'),
(29, 23, 26, 55.7, 'benzin'),
(30, 4, 18, 44.6, 'dizel');

INSERT INTO odrzavanje (id, tip_odrzavanja, id_transakcija_odrzavanje) VALUES -- Marinela
(1, 'Godišnji servis', 5),
(2, 'Godišnji servis', 13),
(3, 'Zamjena ulja', 8),
(4, 'Zamjena filtera', 16),
(5, 'Popravak kočnica', 3),
(6, 'Ispitivanje guma', 29),
(7, 'Popravak karoserije', 1),
(8, 'Punjenje klima uređaja', 12),
(9, 'Balansiranje kotača', 19),
(10, 'Zamjena svjećica', 4),
(11, 'Servis kočnica', 18),
(12, 'Zamjena akumulatora', 25),
(13, 'Zamjena auspuha', 20),
(14, 'Servis brave', 15),
(15, 'Popravak upravljača', 22),
(16, 'Zamjena diskova', 24),
(17, 'Popravak amortizera', 10),
(18, 'Zamjena svjetala', 7),
(19, 'Servis motora', 27),
(20, 'Popravak elektronike', 30),
(21, 'Zamjena remenja', 11),
(22, 'Servis kvačila', 14),
(23, 'Popravak auspuha', 23),
(24, 'Zamjena brisača', 2),
(25, 'Popravak mjerača', 6),
(26, 'Zamjena brave', 21),
(27, 'Zamjena trapa', 17),
(28, 'Servis akumulatora', 9),
(29, 'Zamjena stakla', 28),
(30, 'Popravak podvozja', 26);

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

INSERT INTO oprema_na_najmu (id, id_oprema, id_najam_vozila, kolicina) VALUES -- Marinela
(1, 7, 24, 4),
(2, 4, 18, 3),
(3, 9, 7, 8),
(4, 8, 1, 7),
(5, 10, 3, 1),
(6, 1, 20, 5),
(7, 5, 29, 6),
(8, 3, 5, 2),
(9, 4, 28, 3),
(10, 2, 6, 2),
(11, 6, 15, 8),
(12, 7, 9, 1),
(13, 8, 11, 7),
(14, 10, 22, 5),
(15, 1, 14, 6),
(16, 3, 17, 3),
(17, 2, 26, 4),
(18, 6, 2, 1),
(19, 7, 25, 3),
(20, 8, 8, 4),
(21, 10, 16, 5),
(22, 1, 30, 1),
(23, 5, 10, 2),
(24, 2, 21, 3),
(25, 3, 27, 2),
(26, 4, 4, 3),
(27, 6, 19, 2),
(28, 7, 13, 1),
(29, 9, 23, 2),
(30, 10, 12, 4);

INSERT INTO oprema_na_rezervaciji (id, id_rezervacija, id_oprema, kolicina) VALUES -- Marinela
(1, 23, 12, 1),
(2, 8, 4, 2),
(3, 14, 9, 1),
(4, 30, 3, 1),
(5, 6, 6, 1),
(6, 19, 5, 1),
(7, 11, 2, 1),
(8, 3, 10, 2),
(9, 27, 7, 1),
(10, 5, 12, 1),
(11, 29, 1, 1),
(12, 2, 4, 2),
(13, 18, 11, 1),
(14, 7, 6, 1),
(15, 21, 9, 1),
(16, 12, 7, 1),
(17, 1, 10, 2),
(18, 25, 5, 1),
(19, 9, 8, 2),
(20, 15, 1, 1),
(21, 28, 3, 1),
(22, 17, 11, 1),
(23, 22, 2, 1),
(24, 4, 8, 2),
(25, 16, 4, 1),
(26, 26, 10, 2),
(27, 20, 6, 2),
(28, 10, 9, 1),
(29, 24, 5, 1),
(30, 13, 7, 1);

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
(6, 14, 'Oštećenje vozila');

-- 1.Pronađi sve klijente koji su na crnoj listi - Marinela
SELECT k.id, k.ime, k.prezime
FROM klijent k
JOIN crna_lista cl ON k.id = cl.id_klijent;

-- 2.Izlistaj sve serije automobila koje imaju automatski tip mjenjača - Marinela
SELECT *
FROM serija_auto_kamion sak
JOIN automobil a ON sak.id = a.id_serija_auto_kamion
WHERE sak.tip_mjenjaca = 'Automatski';

-- 3.Prikaži ukupan broj iznajmljenih komada određene opreme po rezervaciji - Marinela
SELECT r.id, o.naziv, SUM(onr.kolicina) AS broj_komada
FROM rezervacija r
JOIN oprema_na_rezervaciji onr ON r.id = onr.id_rezervacija
JOIN oprema o ON onr.id_oprema = o.id
GROUP BY r.id, o.naziv;

-- 4.Prikaži sve rezervacije koje uključuju opremu 'GPS navigacija' i poredaj ih po datumu rezervacije
-- Marinela
SELECT r.*, o.*
FROM rezervacija r
JOIN oprema_na_rezervaciji onr ON r.id = onr.id_rezervacija
JOIN oprema o ON onr.id_oprema = o.id
WHERE o.naziv = 'GPS navigacija'
ORDER BY r.datum_rezervacije;

-- 5.Pregled ukupnog broja transakcija po vrsti plaćanja - Marinela
SELECT tip_placanja, COUNT(*) AS broj_transakcija
FROM (
    SELECT 'Gotovinsko' AS tip_placanja FROM gotovinsko_placanje
    UNION ALL
    SELECT 'Kartično' AS tip_placanja FROM karticno_placanje
    UNION ALL
    SELECT 'Kriptovalutno' AS tip_placanja FROM kriptovalutno_placanje
) AS sve_transakcije
GROUP BY tip_placanja;

CREATE VIEW pregled_opreme AS
SELECT o.id AS id_opreme, o.naziv, o.opis, COUNT(r.id) AS broj_rezervacija
FROM oprema o
LEFT JOIN oprema_na_rezervaciji onr ON o.id = onr.id_oprema
LEFT JOIN rezervacija r ON onr.id_rezervacija = r.id
GROUP BY o.id, o.naziv, o.opis;



-- 1.	PRIKAŽI 3 KLIJENTA S NAJVIŠE POTROŠENOG NOVCA NA NAJAM VOZILA I OPREME -- Mirela
SELECT k.id AS id_klijent,
    CONCAT(k.ime, ' ', k.prezime) AS ime_prezime_klijenta,
    SUM(t.iznos) AS ukupni_iznos
FROM klijent k
INNER JOIN najam_vozila nv ON k.id = nv.id_klijent_najam
INNER JOIN transakcija t ON nv.id_transakcija_najam = t.id
INNER JOIN oprema_na_najmu onr ON nv.id = onr.id_najam_vozila
GROUP BY k.id
ORDER BY ukupni_iznos DESC
LIMIT 3;


-- 2.   PRIKAZ 5 VRSTA DODATNE OPREMU KOJA SE NAJMANJE PUTA IZNAJMILA -- Mirela
CREATE VIEW Broj_Najmova_Opreme AS
SELECT o.naziv AS Vrsta_Opreme, COUNT(onr.id_najam_vozila) AS Broj_Najmova
FROM oprema o
LEFT JOIN oprema_na_najmu onr ON o.id = onr.id_oprema
GROUP BY o.naziv;

SELECT Vrsta_Opreme
FROM Broj_Najmova_Opreme
ORDER BY Broj_Najmova ASC
LIMIT 5;


-- 3.  PROVJERA NAJMA VOZILA KOJI CU PREMAŠILI ODREĐENI BROJ KILOMETARA -- Mirela
SELECT nv.id, v.registracijska_tablica, nv.datum_pocetka, nv.datum_zavrsetka,
       nv.zavrsna_kilometraza - nv.pocetna_kilometraza AS Prijeđeni_Kilometri
FROM najam_vozila nv
INNER JOIN vozilo v ON nv.id_vozilo = v.id
WHERE nv.zavrsna_kilometraza - nv.pocetna_kilometraza > 100;


-- 4.  PRIKAŽI SVE POSLOVNE TROŠKOVE ZA REZERVACIJE KOJE SU SE DOGODILE U PRVIH 6 MJESECI U 2024.GOD -- Mirela
SELECT pt.* 
FROM poslovni_trosak pt
JOIN transakcija t ON pt.id_transakcija_poslovnog_troska = t.id 
WHERE (MONTH(t.datum) BETWEEN 1 AND 6) AND YEAR(t.datum) = 2024; 


-- 5.  PRONALAŽENJE NAJMA VOZILA PO DRŽAVI SJEDIŠTA PRAVNE OSOBE -- Mirela
SELECT p.drzava_sjediste AS Drzava, COUNT(nv.id) AS Broj_Najmova
FROM pravna_osoba p
INNER JOIN klijent k ON p.id = k.id_pravna_osoba
INNER JOIN najam_vozila nv ON k.id = nv.id_klijent_najam
GROUP BY p.drzava_sjediste
ORDER BY Broj_Najmova DESC;


-- 6.  PRIKAZ TROŠKOVA NAJMA VOZILA PO ZAPOSLENIKU -- Mirela
CREATE VIEW Ukupni_Troskovi_Najma_Zaposlenika AS
SELECT z.id AS id_zaposlenik, z.ime, z.prezime, SUM(t.iznos) AS ukupni_troskovi
FROM zaposlenik z
INNER JOIN najam_vozila nv ON z.id = nv.id_zaposlenik_najam
INNER JOIN transakcija t ON nv.id_transakcija_najam = t.id
GROUP BY z.id, z.ime, z.prezime;

SELECT ime, prezime, ukupni_troskovi
FROM Ukupni_Troskovi_Najma_Zaposlenika
ORDER BY ukupni_troskovi DESC;







