CREATE DATABASE najam_vozila;

USE najam_vozila;

CREATE TABLE pravna_osoba (
    id MEDIUMINT NOT NULL, 
    ime VARCHAR (100), 
    identifikacijski_broj VARCHAR (25),
    drzava_sjediste VARCHAR (47),
    grad_sjediste VARCHAR (100),
    adresa_sjediste VARCHAR (100),
    PRIMARY KEY (id),
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
    id SMALLINT NOT NULL,
    opis_zanimanja TEXT,
    odjel VARCHAR (50),
    PRIMARY KEY (id),
);

CREATE TABLE zaposlenik (
    id MEDIUMINT NOT NULL, 
    id_nadredeni_zaposlenik MEDIUMINT, 
    ime VARCHAR (30), 
    prezime VARCHAR (30), 
    identifikacijski_broj VARCHAR (15),
    drzava_radno_mjesto VARCHAR (47),
    grad_radno_mjesto VARCHAR (100),
    adresa_radno_mjesto VARCHAR (100),
    spol CHAR (1),
    broj_telefona VARCHAR (20),
    broj_mobitela VARCHAR (20),
    email VARCHAR (320),
    id_zanimanje SMALLINT, 
    PRIMARY KEY (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id)
);

CREATE TABLE kontakt_klijenta (
    id INT NOT NULL, 
    email VARCHAR (320), 
    broj_mobitela VARCHAR (20), 
    broj_telefona VARCHAR (20),
    id_klijent INT,
    PRIMARY KEY (id),
    FOREIGN KEY id_klijent REFERENCES klijent (id) ON DELETE CASCADE
);

CREATE TABLE prihod (
    id TINYINT NOT NULL, 
    opis TEXT,
    tip_prihoda VARCHAR (25),
    PRIMARY KEY (id)
);

CREATE TABLE transakcija (
    id BIGINT NOT NULL, 
    datum DATE, 
    iznos NUMERIC (12,2), 
    broj_racuna VARCHAR (7), 
    placeno NUMERIC (12,2),
    PRIMARY KEY (id),
);

CREATE TABLE prihod_za_zaposlenika (
    id INT NOT NULL,
    datum DATE,
    id_zaposlenik MEDIUMINT, 
    id_transakcija_prihoda INT,
    id_prihod TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id) ON DELETE CASCADE,
    FOREIGN KEY (id_transakcija_prihoda) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_prihod) REFERENCES prihod (id)
);

CREATE TABLE popust (
    id TINYINT NOT NULL, 
    tip_popusta VARCHAR 40,
    PRIMARY KEY (id),
);

CREATE TABLE popust_za_klijenta (
    id INT NOT NULL,
    datum_primitka DATE, 
    datum_koristenja DATE,
    status VARCHAR (10), 
    id_klijent INT,
    id_popust TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE,
    FOREIGN KEY (id_popust) REFERENCES popust (id)
);

CREATE TABLE poslovni_trosak (
    id INT NOT NULL, 
    id_transakcija_poslovnog_troska BIGINT, 
    svrha VARCHAR (40), 
    opis TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_poslovnog_troska) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE gotovinsko_placanje (
    id BIGINT NOT NULL, 
    id_transakcija_gotovina BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_gotovina) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE karticno_placanje (
    id BIGINT NOT NULL, 
    tip_kartice VARCHAR (20), 
    id_pravna_osoba_banka MEDIUMINT, 
    id_transakcija_kartica BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pravna_osoba_banka) REFERENCES pravna_osoba (id),
    FOREIGN KEY (id_transakcija_kartica) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE kriptovalutno_placanje (
    id BIGINT NOT NULL, 
    kriptovaluta VARCHAR (50), 
    broj_kripto_novcanika VARCHAR (60), 
    id_transakcija_kripto BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_kripto) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE kontakt_pravne_osobe (
    id INT NOT NULL, 
    email VARCHAR (320), 
    broj_mobitela VARCHAR (20), 
    broj_telefona VARCHAR (20),
    opis VARCHAR (100),
    id_pravna_osoba MEDIUMINT,
    PRIMARY KEY (id),
    FOREIGN KEY id_pravna_osoba REFERENCES pravna_osoba (id) ON DELETE CASCADE
);

CREATE TABLE vozilo (
    id INT NOT NULL,
    godina_proizvodnje CHAR(4), 
    registracijska_tablica VARCHAR (15), 
    tip_punjenja VARCHAR (10),
    PRIMARY KEY (id),
);

CREATE TABLE najam_vozila (
    id BIGINT NOT NULL, 
    id_transakcija_najam BIGINT, 
    id_klijent_najam INT, 
    id_zaposlenik_najam MEDIUMINT, 
    id_vozilo INT,
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    status VARCHAR (15),
    pocetna_kilometraza NUMERIC (10, 2), 
    zavrsna_kilometraza NUMERIC (10, 2), 
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_najam) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_klijent_najam) REFERENCES klijent (id),
    FOREIGN KEY (id_zaposlenik_najam) REFERENCES zaposlenik (id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id)
);

CREATE TABLE serija_auto_kamion (
    id SMALLINT NOT NULL, 
    ime VARCHAR (100), 
    proizvodac VARCHAR (40), 
    najveca_brzina SMALLINT, 
    konjska_snaga SMALLINT, 
    tip_mjenjaca VARCHAR (10), 
    broj_vrata TINYINT,
    PRIMARY KEY (id),
);

CREATE TABLE automobil (
    id MEDIUMINT NOT NULL, 
    id_serija_auto_kamion SMALLINT,
    id_vozilo MEDIUMINT,
    duljina NUMERIC (3, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion (id),
    FOREIGN KEY id_vozilo REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE serija_motocikl (
    id SMALLINT NOT NULL,
    ime VARCHAR (100),
    proizvodac VARCHAR (40),
    najveca_brzina SMALLINT,
    konjska_snaga SMALLINT,
    broj_sjedala CHAR(1),
    PRIMARY KEY (id),
);

CREATE TABLE motocikl (
    id MEDIUMINT NOT NULL, 
    id_serija_motocikl SMALLINT,
    id_vozilo MEDIUMINT,
    duljina NUMERIC (3, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (id_serija_motocikl) REFERENCES serija_motocikl (id),
    FOREIGN KEY id_vozilo REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE kamion (
    id MEDIUMINT NOT NULL, 
    id_serija_auto_kamion SMALLINT,
    id_vozilo MEDIUMINT,
    duljina NUMERIC (4, 2),
    visina NUMERIC (3, 2),
    nosivost NUMERIC (5, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion (id),
    FOREIGN KEY id_vozilo REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE slika_automobila (
    id INT NOT NULL, 
    id_automobil MEDIUMINT, 
    slika VARBINARY(MAX),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_automobil) REFERENCES automobil (id) ON DELETE CASCADE
);

CREATE TABLE slika_kamiona (
    id INT NOT NULL, 
    id_kamion MEDIUMINT, 
    slika VARBINARY(MAX),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_kamion) REFERENCES kamion (id) ON DELETE CASCADE
);

CREATE TABLE slika_motora (
    id INT NOT NULL, 
    id_motocikl MEDIUMINT, 
    slika VARBINARY(MAX),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_motocikl) REFERENCES motocikl (id) ON DELETE CASCADE
);

CREATE TABLE osiguranje (
    id INT NOT NULL, 
    id_osiguravacka_kuca MEDIUMINT, 
    id_vozilo MEDIUMINT, 
    id_transakcija BIGINT, 
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    tip_osiguranja VARCHAR (20),
    PRIMARY KEY (id),
    FOREIGN KEY (id_osiguravacka_kuca) REFERENCES pravna_osoba (id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id) ON DELETE CASCADE,
    FOREIGN KEY (id_transakcija) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE steta (
    id INT NOT NULL, 
    tip VARCHAR (7),
    opis TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE naknada_stete (
    id INT NOT NULL,  
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    id_transakcija BIGINT,
    id_osiguranje INT,
    id_steta INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_steta) REFERENCES steta (id) ON DELETE CASCADE,
    FOREIGN KEY (id_osiguranje) REFERENCES osiguranje (id)
);

CREATE TABLE punjenje (
    id BIGINT NOT NULL,
    id_transakcija_punjenje BIGINT,
    id_vozilo MEDIUMINT,
    kolicina NUMERIC(7, 3),
    tip_punjenja VARCHAR (10),
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_punjenje) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id) ON DELETE CASCADE
);

CREATE TABLE odrzavanje (
    id BIGINT NOT NULL, 
    tip odrzavanja VARCHAR (100), 
    id_zaposlenik MEDIUMINT, 
    id_transakcija_odrzavanje BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id),
    FOREIGN KEY (id_transakcija_odrzavanje) REFERENCES transakcija (id) ON DELETE CASCADE
);

CREATE TABLE rezervacija (
    id BIGINT NOT NULL, 
    datum_rezervacije DATE, 
    datum_potvrde DATE, 
    id_klijent INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
);

CREATE TABLE oprema (
    id SMALLINT NOT NULL,
    naziv VARCHAR (30),
    opis TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE oprema_na_najmu (
    id BIGINT NOT NULL,
    id_najam_vozila,
    id_oprema,
    kolicina TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_vozilo_na_najmu) REFERENCES najam_vozila (id) ON DELETE CASCADE,
    FOREIGN KEY (id_oprema) REFERENCES oprema (id)
);

CREATE TABLE oprema_na_rezervaciji (
    id BIGINT NOT NULL,
    id_rezervacija BIGINT,
    id_oprema INT,
    kolicina TINYINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_oprema) REFERENCES oprema (id)
)

CREATE TABLE vozilo_na_rezervaciji (
    id BIGINT NOT NULL,
    id_rezervacija BIGINT,
    id_vozilo MEDIUMINT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id),
)

CREATE TABLE crna_lista (
    id SMALLINT NOT NULL,
    id_klijent INT,
    razlog TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
)

