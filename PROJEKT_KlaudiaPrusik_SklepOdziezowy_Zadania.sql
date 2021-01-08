/*
pkt 8. Wy�wietl wszystkie produkty z wszystkimi danymi od dostawcy, kt�ry znajduje si� na pozycji 1 w tabeli Dostawca*/

SELECT 
    *
FROM
    Produkt p
        INNER JOIN
    Dostawca d ON p.Id_producenta = d.Id_producenta
WHERE
    d.Id_producenta = 1;

--pkt 9. Posortuj te produkty po Nazwie od A-B

SELECT 
    *
FROM
    Produkt p
        INNER JOIN
    Dostawca d ON p.Id_producenta = d.Id_producenta
WHERE
    d.Id_producenta = 1
ORDER BY p.Nazwa_produktu;

--pkt 10. Wylicz �redni� cen� za produktu od tego dostawcy

SELECT 
    p.Nazwa_produktu,
    AVG(p.Cena_netto_zakupu) AS Srednia_CenaNetto_Produktu
FROM
    Produkt p
        INNER JOIN
    Dostawca d ON p.Id_producenta = d.Id_producenta
WHERE
    d.Id_producenta = 1
GROUP BY p.Nazwa_produktu;

/*pkt 11. Wy�wietl dwie grupy produkt�w tego dostawcy:Po�owa najta�szych to grupa: �Tanie�, Pozosta�e to grupa: �Drogie� */

SELECT a.nazwa_produktu, a.Cena_brutto_sprzedazy, 
   CASE
   WHEN kwartyl = '1' THEN 'drogo'
   WHEN kwartyl = '2' THEN 'tanio'
   END AS Grupa
  FROM 
  ( SELECT nazwa_produktu, Cena_brutto_sprzedazy, NTILE(2) 
   OVER 
  ( ORDER BY Cena_brutto_sprzedazy DESC) AS kwartyl
   FROM dbo.Produkt) AS a;

--pkt 12. Wy�wietl produkty zam�wione, wy�wietlaj�c nazw�

SELECT DISTINCT
    p.Nazwa_produktu
FROM
    Zamowienie z
        LEFT JOIN
    Produkt p ON z.Id_produktu = p.Id_produktu;

--pkt 13. Wy�wietl wszystkie produkty zam�wione � ograniczaj�c do wy�wietlonych 5 pozycji

SELECT DISTINCT TOP 5 p.Nazwa_produktu
   FROM Zamowienie z
   LEFT JOIN Produkt p
   ON z.Id_produktu = p.Id_produktu;

--pkt 14.  Policz warto�� wszystkich zam�wie�

SELECT 
    SUM(p.Cena_brutto_sprzedazy) AS Suma_zamowien
FROM
    Produkt p
        RIGHT JOIN
    Zamowienie z ON p.Id_produktu = z.Id_produktu;

/* pkt 15. Wy�wietl wszystkie zam�wienia wraz z produktami sortuj�c je wg daty od najstarszego do najnowszego*/

SELECT 
    *
FROM
    Zamowienie z
        LEFT JOIN
    Produkt p ON z.Id_produktu = p.Id_produktu
ORDER BY z.Data_zamowienia;

/* pkt.16.Sprawd� czy w tabeli produkty maj� uzupe�nione wszystkie dane � wy�wietl pozycje dla kt�rych brakuje danych */

SELECT 
    *
FROM
    Produkt
WHERE
    Id_produktu IS NULL
        OR Id_producenta IS NULL
        OR Nazwa_produktu IS NULL
        OR Opis_produktu IS NULL
        OR Cena_netto_zakupu IS NULL
        OR Cena_brutto_zakupu IS NULL
        OR Cena_netto_sprzedazy IS NULL
        OR Cena_brutto_sprzedazy IS NULL
        OR Procent_VAT_sprzedazy IS NULL;

--pkt 17. Wy�wietl produkty najcz�ciej sprzedawane wraz z ich cen�

WITH Cte AS (
   SELECT Id_produktu, ROW_NUMBER() OVER( PARTITION BY Id_produktu  ORDER BY Id_produktu DESC) ilosc
    FROM Zamowienie	)

 SELECT z.Id_produktu, p.Nazwa_produktu, p.Cena_brutto_sprzedazy, z.ilosc
    FROM CTE z
    INNER JOIN Produkt p ON z.Id_produktu = p.Id_produktu
    WHERE ilosc = (SELECT max(ilosc) FROM Cte);


--pkt 18. Znajd� dzie� w kt�rym najwi�cej zosta�o z�o�onych zam�wie�

WITH tbl AS (
SELECT Data_zamowienia, ROW_NUMBER() OVER (PARTITION BY Data_zamowienia ORDER BY Data_zamowienia DESC) Liczba_zamowien
   FROM Zamowienie)

SELECT Data_zamowienia, Liczba_zamowien
   FROM tbl
   WHERE Liczba_zamowien = (SELECT MAX(Liczba_zamowien) FROM tbl);

