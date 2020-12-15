CREATE DATABASE Sklep_odziezowy;
use Sklep_odziezowy;

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[is_nip]
(
-- Add the parameters for the function here
@nip varchar(255)
)
RETURNS int
AS
BEGIN

if @nip is null begin return -5 end

set @nip = replace(@nip,'-','')
--zla dlugosc numeru nip
if len(@nip) != 10 begin return -4 end

if ISNUMERIC(@nip) = 0 begin return -3 end

-- zwroc wartosci skompromitowane
if @nip='0000000000' begin return -2 end
if @nip='1234567891' begin return -2 end
if @nip='1111111111' begin return -2 end
if @nip='1111111112' begin return -2 end
if @nip='9999999999' begin return -2 end
if @nip like '0%' begin return -2 end
if @nip like '_0%' and @nip not like '1%' begin return -2 end

if (
( ( cast(substring(@nip,1,1) as bigint)*6)
+(cast(substring(@nip,2,1) as bigint)*5)
+(cast(substring(@nip,3,1) as bigint)*7)
+(cast(substring(@nip,4,1) as bigint)*2)
+(cast(substring(@nip,5,1) as bigint)*3)
+(cast(substring(@nip,6,1) as bigint)*4)
+(cast(substring(@nip,7,1) as bigint)*5)
+(cast(substring(@nip,8,1) as bigint)*6)
+(cast(substring(@nip,9,1) as bigint)*7)
) % 11
= right(@nip,1) )
begin
return 1;
end

return 0;

END

GO







CREATE TABLE dbo.Dostawca
(
	Id_producenta INT,
	Nazwa_producenta VARCHAR(255),
	Adres_producenta VARCHAR(255),
	NIP_producenta CHAR(10) CHECK ([dbo].[is_nip](NIP_producenta) = 1),
	Data_umowy DATE,
	CONSTRAINT PK_idproducenta PRIMARY KEY (Id_producenta)

);

CREATE TABLE Produkt
(
	Id_produktu INT,
	Id_producenta INT,
	Nazwa_produktu VARCHAR(255),
	Opis_produktu VARCHAR(255),
	Cena_netto_zakupu FLOAT,
	Cena_brutto_zakupu FLOAT,
	Cena_netto_sprzedazy FLOAT,
	Cena_brutto_sprzedazy FLOAT,
	Procent_VAT_sprzedazy NUMERIC(3,2),
	CONSTRAINT PK_idproduktu PRIMARY KEY (Id_produktu),
	CONSTRAINT FK_idproducenta FOREIGN KEY (Id_producenta) REFERENCES Dostawca(Id_producenta)

);

CREATE TABLE Klient
(
	Id_klienta INT,
	Imie VARCHAR(255),
	Nazwisko VARCHAR (255),
	Adres VARCHAR(255),
	CONSTRAINT PK_idklienta PRIMARY KEY (Id_klienta)

);

CREATE TABLE Zamowienie
(
	Id_zamowienia INT,
	Id_klienta INT,
	Id_produktu INT,
	Data_zamowienia DATE,
	CONSTRAINT FK_idklienta FOREIGN KEY (Id_klienta) REFERENCES Klient(Id_klienta),
	CONSTRAINT FK_idproduktu FOREIGN KEY (Id_produktu) REFERENCES Produkt(Id_produktu)

);




INSERT INTO Klient
VALUES
   (001, 'Joanna', 'Nowakowska', 'ul.Lipowa 7, 01-320 Warszawa'),
   (002, 'Ewelina', 'Lis', 'ul.Warszawska 765, 00-854 Warszawa'),
   (003, 'Anna', 'Sosnowska', 'ul.Jana Paw³a II 20, 02-200 Piaseczno'),
   (004, 'Marzena', 'Nowak', 'ul.Sosnowa 21, 01-340 Piaseczno'),
   (005, 'Piotr', 'Ma³ecki', 'ul.Grzybowska 130, 00-850 Warszawa'),
   (006, 'Micha³', 'Lech', 'ul.Idzikowska 89, 00-210 Sochaczew'),
   (007, 'Agnieszka', 'Krakowska', 'ul.Szeroka 20, 00-210 Pruszków'),
   (008, 'Michalina', 'Dobrowolska', 'ul.Dobra 8, 01-320 Warszawa'),
   (009, 'Jan', 'Krawczyk', 'ul.Mi³a 89, 04-200 Raszyn'),
   (010, 'Urszula', 'Jankiewicz', 'ul.Tramwajowa 01-378 Warszawa');


INSERT INTO Dostawca
VALUES
   (01, 'M_MODA', 'ul.Bielañska 233 01-820 Jab³onowo', 6772001669, '2005-04-21'),
   (02, 'MOON', 'Aleja Katowicka 51 05-830 Nadarzyn', 5272780836, '2002-10-09'),
   (03, 'ITALIAN_FASHION', 'Aleja Katowicka 51 05-830 Nadarzyn', 5213109829, '2012-09-23'),
   (04, 'M.K.MODA', 'ul. ¯eromskiego 6, 95-030 Rzgów', 5272227588, '2007-03-01');

INSERT INTO Produkt
VALUES
   (10001, 01, 'P³aszcz damski', 'we³na', 490, 603, 790, 972, 0.23),
   (10002, 01, 'P³aszcz mêski', 'we³na', 550, 677, 850, 1048, 0.23),
   (10003, 01, 'Kurtka damska', 'skóra', 250, 308, 400, 492, 0.23),
   (10004, 01, 'Kurtka mêska', 'skóra', 280, 344, 480, 590, 0.23),
   (10005, 01, 'Kurtka dzieciêca', 'puffer', 70, 86, 130, 160, 0.23),
   (20001, 02, 'Spodnie damskie', 'eleganckie', 90, 111, 159, 196, 0.23),
   (20002, 02, 'Spodnie damskie', 'jeans', 50, 62, 129, 159, 0.23),
   (20003, 02, 'Spodnie mêskie', 'eleganckie', 90, 111, 159, 196, 0.23),
   (20004, 02, 'Spodnie mêskie', 'jeans', 50, 62, 129, 159, 0.23),
   (20005, 02, 'Spodnie dzieciêce', 'dzianina', 30, 37, 69, 85, 0.23),
   (30001, 03, 'Sweter damski', 'kaszmir', 300, 369, 550, 677, 0.23),
   (30002, 03, 'Sweter damski', 'dzianina', 100, 123, 210, 258, 0.23),
   (30003, 03, 'Sweter mêski', 'kaszmir', 300, 369, 550, 677, 0.23),
   (30004, 03, 'Sweter mêski', 'dzianina', 100, 123, 210, 258, 0.23),
   (30005, 03, 'Sweter dziêciêcy', 'dzianina', 40, 49, 79, 97, 0.23),
   (40001, 04, 'Czapka damska', 'we³na', 20, 25, 49, 60, 0.23),
   (40002, 04, 'Kapelusz damski', 'filc', 40, 49, 89, 109, 0.23),
   (40003, 04, 'Rêkawiczki damskie', 'skóra', 30, 37, 55, 68, 0.23),
   (40004, 04, 'Pasek damski', 'skóra', 25, 31, 59, 73, 0.23),
   (40005, 04, 'Torebka damska', 'skóra', 200, 246, 450, 554, 0.23);


INSERT INTO Zamowienie
VALUES
   (20200001, 001, 10001, '2020-01-23'),
   (20200001, 001, 40003, '2020-01-23'),
   (20200002, 002, 40005, '2020-01-23'),
   (20200003, 003, 30001, '2020-02-03'),
   (20200004, 004, 30001, '2020-02-03'),
   (20200005, 005, 20001, '2020-02-08'),
   (20200005, 005, 20004, '2020-02-08'),
   (20200005, 005, 20005, '2020-02-08'),
   (20200006, 003, 40001, '2020-02-10'),
   (20200007, 006, 10005, '2020-03-02'),
   (20200008, 006, 20005, '2020-03-04'),
   (20200008, 006, 40001, '2020-03-04'),
   (20200009, 005, 30001, '2020-03-06'),
   (20200010, 005, 40002, '2020-03-12'),
   (20200010, 005, 40003, '2020-03-12'),
   (20200010, 005, 40004, '2020-03-12'),
   (20200010, 005, 40005, '2020-03-12'),
   (20200011, 008, 40001, '2020-03-18');
   