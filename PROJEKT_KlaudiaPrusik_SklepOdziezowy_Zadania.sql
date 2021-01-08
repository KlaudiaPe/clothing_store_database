/*
pkt 8. Wyœwietl wszystkie produkty z wszystkimi danymi od dostawcy, który znajduje siê na pozycji 1 w tabeli Dostawca*/

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

--pkt 10. Wylicz œredni¹ cenê za produktu od tego dostawcy

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

/*pkt 11. Wyœwietl dwie grupy produktów tego dostawcy:Po³owa najtañszych to grupa: „Tanie”, Pozosta³e to grupa: „Drogie” */

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

--pkt 12. Wyœwietl produkty zamówione, wyœwietlaj¹c nazwê

SELECT DISTINCT
    p.Nazwa_produktu
FROM
    Zamowienie z
        LEFT JOIN
    Produkt p ON z.Id_produktu = p.Id_produktu;

--pkt 13. Wyœwietl wszystkie produkty zamówione – ograniczaj¹c do wyœwietlonych 5 pozycji

SELECT DISTINCT TOP 5 p.Nazwa_produktu
   FROM Zamowienie z
   LEFT JOIN Produkt p
   ON z.Id_produktu = p.Id_produktu;

--pkt 14.  Policz wartoœæ wszystkich zamówieñ

SELECT 
    SUM(p.Cena_brutto_sprzedazy) AS Suma_zamowien
FROM
    Produkt p
        RIGHT JOIN
    Zamowienie z ON p.Id_produktu = z.Id_produktu;

/* pkt 15. Wyœwietl wszystkie zamówienia wraz z produktami sortuj¹c je wg daty od najstarszego do najnowszego*/

SELECT 
    *
FROM
    Zamowienie z
        LEFT JOIN
    Produkt p ON z.Id_produktu = p.Id_produktu
ORDER BY z.Data_zamowienia;

/* pkt.16.SprawdŸ czy w tabeli produkty maj¹ uzupe³nione wszystkie dane – wyœwietl pozycje dla których brakuje danych */

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

--pkt 17. Wyœwietl produkty najczêœciej sprzedawane wraz z ich cen¹

WITH Cte AS (
   SELECT Id_produktu, ROW_NUMBER() OVER( PARTITION BY Id_produktu  ORDER BY Id_produktu DESC) ilosc
    FROM Zamowienie	)

 SELECT z.Id_produktu, p.Nazwa_produktu, p.Cena_brutto_sprzedazy, z.ilosc
    FROM CTE z
    INNER JOIN Produkt p ON z.Id_produktu = p.Id_produktu
    WHERE ilosc = (SELECT max(ilosc) FROM Cte);


--pkt 18. ZnajdŸ dzieñ w którym najwiêcej zosta³o z³o¿onych zamówieñ

WITH tbl AS (
SELECT Data_zamowienia, ROW_NUMBER() OVER (PARTITION BY Data_zamowienia ORDER BY Data_zamowienia DESC) Liczba_zamowien
   FROM Zamowienie)

SELECT Data_zamowienia, Liczba_zamowien
   FROM tbl
   WHERE Liczba_zamowien = (SELECT MAX(Liczba_zamowien) FROM tbl);

