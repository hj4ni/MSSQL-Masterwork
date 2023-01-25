# A megoldandó probléma

Az adatbázis elsődleges célja egy folyóirat és könyvkiadó alkalmazotti adatainak, termékeinek, valamint raktárkészletének és megrendeléseinek a dokumentálása. Erre a célra általában többféle szoftvert és keretrendszert használnak a kisebb cégek, egy ilyen összetett és többfunkciós SQL adatbázis segítéségével azonban lényegesen egyszerűbben és átláthatóbban megvalósítható a feladat.

# Tipikus felhasználási módok

Az adatbázisban a felmerülő probléma megoldásának céljából először az alkalmazottak személyes adatai kerülnek rögzítésre. Az összes alkalmazott egyedi azonosítóval rendelkezik (employeeID), külön kerülnek rögzítésre a személyes adataik (pl. név, születési idő, adószám, TAJ-szám, stb.), valamint a foglalkoztatással kapcsolatos adataik (beosztás, részmunkaidő, teljesmunkaidő, havi kötelező óraszám) és ezektől elkülönítve a szabadsághoz tartozó adatok (szabadság kezdete, vége, szabadnapok száma, kivett szabadnapok, stb.).

A vállalkozás sikeres működése érdekében kulcsfontosságú a készülő termékek adatainak naprakész nyilvántartása. Az adatbázisban tárolható az egyes kiadványok terjedelme, ISBN száma, tervezett és tényleges megjelenési ideje, továbbá a közreműküdő alkalmazottak azonosítója. Az adott termék elkészítésében résztvevő személyek munkaidő nyilvántartásának köszönhetően lehetőség van az adatbázis funkcióinak kibővítésére, igy munkaidő szervezési feladat ellátására is alkalmassá tehető további fejlesztés után (pl. egy tárolt eljárás, vagy view tábla hozzáadásával).

A megrendelések teljesítésének elengedhetetlen feltétele, hogy naprakészen kövessük a raktárkészletet, valamint a beérkező vásárlásokat. Nagyon hasznos, ha meg tudjuk jelölni egy rendelés várható kézbesítési idejét (estimatedDeliveryDate), melyik termékből nincs raktáron (stockQuantity), valamint rendelkezésünkre állnak a megrendelők kapcsolattartói és azok elérhetőségei is (customers tábla).

# Szükséges környezet

Az adatbázist, és a hozzá tartozó objektumokat létrehozó scriptek a Microsoft SQL Server 2019 Express Edition (64-bit) 15.0.4138.2-es verzióján készültek, futtatásukhoz ezzel kompatibilis környezet javasolt.

# A scripek végrehajtási sorrendje

Az adatbázis megfelelő működésének érdekében az SQL scripteket a következő sorrendben futtatssuk le:
- 01_create_database - Létrehozza a bookAndNewspaperPublisher adatbázist.
- 02_create_employees_schema - Létrehozza az employees sémát, az employees, employment és annualLeave táblákkal.
- 03_create_production_schema - Létrehozza a production sémát, a products, articles és books táblákkal.
- 04_create_trading_schema - Létrehozza a trading sémát, a customers, orders és warehouse táblákkal.
- 05_create_newspaper_view - Létrehozza a newspapers view-t, az articles és a products táblák adataiból.
- 06_create_addEmployee_SP - Létrehozza az addEmployee tárolt eljárást, amellyel hozzáadhatjuk az alkalmazottak személyes adatait az adatbázis employee táblájához.
- 07_create_calcAnnualLeave_UDF - Létrehozza a calcAnnualLeave egyéni függvényt (user defined function), amely az adataikból kiszámítja a dolgozók szabadságát.
- 08_create_addEmployment_SP - Létrehozza az addEmployment tárolt eljárást, amely segítségével hozzáadhatjuk a dolgozók foglalkoztatási adatait az adatbázis megfelelő táblájához (employment).
- 09_create_addAnnualLeave_SP - Létrehozza az addAnnualLeave tárolt eljárást, amely beilleszti a dolgozók szabadságolásával kapcsolatos adatokat az adatbázis annualLeave táblájába.
- 10_create_warehouse_update_Trigger - Létrehozza a warehouse_log táblát és a warehouse_update triggert.
- 11_create_orderStockCheck_SP - Létrehozza az orderStockCheck tárolt eljárást, amellyel lekérdezhető, hogy van-e elegendő raktárkészelt egy adott rendelés teljesítéséhez.
- 12_create_users_and_logins - Létrehoz három adatbázis felhasználót, a kapcsolódó server loginnal és hozzáadja őket a kijelölt szerepkörökhöz.
- 13_add_sample_data - A létrehozott tárolt eljárások és INSERT scriptek segítségével mintaadatokkal tölti fel az adatbázis tábláit.

# Tervezési alapelvek és adatmodell

Az adatbázis a harmadik normálforma szabványának megfelelően készült.
A tervezett funkciók elkülönítésének érdekében az adatbázis táblái három különböző sémába kerültek. Az employees séma az alkalmazottak, a production a termékek, a warehouse pedig a raktárkészlet, a rendelések és a megrendelők adatait tárolja.

Az alkalmazottak adatai három jól elkülöníthető területhez tartoznak: személyes adatok, foglalkoztatási adatok és a szabadság. A személyes adatok kritikus fontosságú információk, így ezek egy különálló táblába kerültek. A foglalkoztatási adatok gyakrabban változhatnak, az adott alkalmazott teljes munkaidős foglalkoztatásból részmunkaidőre válthat, vagy átkerülhet egy másik területre, illetve több munkakört is kaphat (pl. egy tördelő lehet szerkesztő, korrektor, vagy illusztrátor is). Emiatt a foglalkoztatással kapcsolatos adatok is egy külön táblát alkotnak. Szintén elkülönítve tárolja az adatbázis az alkalmazottak szabadságával kapcsolatos információkat, hiszen ezek változnak a leggyakrabban.

Ez a fiktív cég folyóiratok és könyvek kiadásával foglalkozik. Ezen termékek elkészítése részben eltér egymástól, kialakításuk és terjedelmük pedig teljesen eltérő, így az adatbázisban is elkülönülő kategóriákat alkotnak. Ugyan termékként a folyóiratok jelennek meg az adatbázisban, a gyártás során viszont az egyes cikkek jelennek meg munkafolyamati egységként. Egy-egy folyóiraton akár több tucat alkalmazott is dolgozhat, a könyvekkel ellentétben nem feltétlenül rendelkeznek egységes designnal, tördeléssel. Ennek megfelelően az adatbázisban a cikkek alkotnak egy különálló táblát, az adatismétlődés elkerülésének okán a folyóiratok egy view-ban kerülnek tárolásra.

A trading séma tartalmazza az aktuális raktárkészlettel és a megrendelésekkel kapcsolatos adatokat. Külön-külön táblákba kerültek a megrendelők adatai, a leadott rendelések és az raktárkészlet nyilvántartás. Ezek ugyan jól elkülöníthető területek, mégis elég szoros kapcsolatban állnak egymással ahhoz, hogy azonos sémába kerüljenek.

# Adatbázis objektumok

## Adattáblák

### Employees.employees

Ez a tábla szolgál a munkavállalók személyes adatainak tárolására.
- `employeeID` : A munkavállaló egyedi azonosítója. Automatikusan generálódik új adatsor beillesztésekor (identity), a tábla elsődleges kulcs (primary key), integer adattípusú.
- `firstName` és `lastName` : Az alkalmazott neve két oszlopban tárolva, nvarchar(20) adattípusban, null értéket nem vehet fel, kötelező kitölteni.
- `birthDay` : A dolgozó születésnapja, date adattípusban, nem vehet fel null értéket, fontos tényező a szabadság kiszámításában.
- `numberOfChildren` : Az alkalmazott gyermekeinek száma, tinyint adattípusú, null értéket nem vehet fel, a szabadság számításában szintén jelentős szerepet játszik.
- `socialSecurityIdentifier` : A munkavállaló TAJ száma, dec(9,0) adattípusú, null értéket nem vehet fel és csak egyedi értéke lehet (unique).
- `taxIdentifier` : A dolgozó adószáma, dec(11,0) adattípusú, és szintén nem lehet null, valamint csak egyedi érték lehet.

### Employees.employment

Az alkalmazottak foglalkoztatással kapcsolatos adatainak tárolására létrehozott adattábla.
- `employeeID` : Idegen kulcs (foreign key), az employees tábla azonos nevű oszlopához kötődik, az alkalmazott egyedi azonosítóját tartalmazza.
- `jobTitle` : Nvarchar(20) adattípusú oszlop, az alkalmazott beosztását tartalmazza, null értéket nem vehet fel.
- `fullTime`, `partTimeSix`, `partTimeFour`, `partTimeTwo` : Bit típusú oszlopok, értékük 0 és 1 lehet (igaz/hamis), azt jelölik, hogy az alkalmazott teljes munkaidős foglalkoztatásban, vagy részmunkaidőben dolgozik a cégnél.
- `maxWorkHoursPerMonth` : Tinyint adattípusú oszlop, null értéket nem vehet fel, az alkalmazott havi munkaidejét tartalmazza.

### Employees.annualLeave

Ez a tábla tartalmazza a cég munkavállalóinak szabadságával kapcsolatos adatokat.
- `employeeID` : Idegen kulcs, a munkavállalót azonosítja az employees táblából.
- `leaveBegin` : Date adattípusú oszlop, a szabadság kezdő dátuma.
- `leaveEnd` : Date típusú oszlop, a szabadság befejező dátuma (az első munkanapot megelőző nap)
- `annualLeave` : Tinyint típusú oszlop, a munkavállaló összes szabadságának száma.
- `leaveTaken` : Szintén tinyint adattípusú, a felhasznált szabadság mennyisége.
- `leaveAvailable` : A fennmaradó, még igénybe vehető szabadság mennyiége, tinyint adattípusú.

### Production.products

A products tábla funkciója a cég termékadatainak tárolása.
- `productID` : A termék egyedi azonosítója. Integer adattípusú elsődleges kulcs, értéke automatikusan generálódik új termék (sor) hozzáadásakor (identity).
- `title` : A termék (könyv, folyóirat) címe. A unicode karakterek használatának lehetősége miatt nvarchar(50) típusú oszlop, egyedi értékeket kell tartalmazzon (unique), hogy két különböző termék azonos címmel ne jelenhessen meg.
- `ISBN` : Az adott termék ISBN azonosítója, nvarchar(13) adattípusú oszlop, csak egyedi értékeket tartalmazhat.
- `genre` : A termék műfaja, nvarchar(20) adattípusú oszlop.
- `spread` : A termék terjedelme, smallint adattípusú.
- `plannedPublicationDate` : A termék tervezett megjelenési ideje, date típusú oszlop.
- `releaseDate` : A hivatalos megjelenési ideje az adott terméknek, date adattípusú.
- `retailPrice` : A termék eladási ára, integer adattípusú oszlop.

### Production.articles

Az újságcikkekkel kapcsolatos információkat tároljuk az articles táblában.
- `productID` : A folyóirat egyedi azonosítószáma, amelyben megjelenik az adott cikk. Idegen kulcs, a products táblához kapcsolódik.
- `articleID` : Az újságcikk egyedi azonosítója, integer adattípusú, elsődleges kulcs és automatikusan generálódik a tartalma új cikk hozzáadásakor.
- `title` : Az adott cikk címe, nvarchar(50) típusú, kizárólag egyedi értékeket tartalmazhat.
- `spread` : Az újságcikk terjedelme, smallint adattípusú.
- `editor`, `illustrator`, `layoutEditor`, `corrector` : Az újságcikken közreműködő alkalmazottak azonosítói, idegen kulcs, az employees táblához kapcsolódik.
- `editingWorkHours`, `illustrationWorkHours`, `layoutEditingWorkHours`, `correctionWorkHours` : Smallint típusú oszlopok, az adott munkafolyamatra fordított munkaórák számát tartalmazza az egyes újságcikkek vonatkozásában.

### Production.books

A cég által kiadott könyvek információinak tárolására szolgáló tábla.
- `productID` : A termék egyedi azonosítója, idegen kulcs, a products táblához kapcsolódik.
- `editor`, `illustrator`, `layoutEditor`, `corrector` : A könyvek elkészítésében résztvevő alkalmazottak azonosítói, idegen kulcs, az employees táblához kapcsolódik.
- `editingWorkHours`, `illustrationWorkHours`, `layoutEditingWorkHours`, `correctionWorkHours` : Smallint típusú oszlopok, az adott munkafolyamatra fordított munkaórák számát tartalmazza az egyes könyvek vonatkozásában.

### Production.newspapers View

Egy View tábla, amely a products és az articles táblák oszlopaiból állítja össze az egyes folyóiratokhoz kapcsolódó információkat. A következő oszlopokat tartalmazza:
- `productID` : A folyóirat termékazonosítója a product táblából.
- `articleID` : Az adott újságban szereplő cikkek azonosítói az articles táblából.
- `title AS newspaperTitle` : A folyóirat címe a products táblából.
- `title AS articleTitle` : Az egyes újságcikkek címei az articles táblából, amelyek a folyóiratban megjelentek.
- `spread AS magazinSpread` : A magazin teljes terjedelme.
- `spread AS articleSpread` : Az egyes újságcikkek terjedelme az articles táblából.
- `plannedPublicationDate` : A magazin tervezett megjelenési ideje a products táblából.
- `releaseDate` : A tényleges megjelenési dátum a products tábla alapján.
- `retailPrice` : A magazin eladási ára a products táblából.

### Trading.customers

Ez a tábla tartalmazza a vásárlók adatait. A kiadónál elsősorban viszonteladói megrendelésekre számítanak.
- `customerID` : Integer típusú egyedi azonosító, a tábla elsődleges kulcsa.
- `customerName` : A megrendelő neve, nvarchar(50) adattípusú, null értéket nem vehet fel.
- `registrationDate` : A vásárlói regisztráció időpontja, date adattípusú, null értéket nem vehet fel.
- `customerPostalID` : A megrendelő székhelyének irányítószáma, smallint adattípusú, null értéket nem vehet fel.
- `customerCity` : A megrendelő városa, nvarchar(20) adattípusú, nem lehet null.
- `customerAddress` : A megrendelő címe (utca, házszám), nvarchar(50) adattípusú, null értéket nem vehet fel.
- `shippingPostalID` : A szállítási cím irányítószám része, smallint adattípusú, null értéket nem vehet fel.
- `shippingCity` : A város megnevezése, ahova a megrendelést postázzák. Nvarchar(20) típusú oszlop, null értéke nem lehet.
- `shippingAddress` : A megrendelő postacíme (utca, házszám), nvarchar(50) adattípusú, null értéket nem vehet fel.
- `emailAddress` : A megrendelő email címe, nvarchar(255) adattípusú.
- `phoneNumber` : A megrendelő telefonszáma dec(9,0) adattípusú, nem vehet fel null értéket.
- `contactPersonLastName` : A kapcsolattartó személy keresztneve, nvarchar(20) típusú oszlop.
- `contactPersonFirstName` : A kapcsolattartó személy vezetékneve, nvarchar(20) adattípusú.

### Trading.orders

A megrendelők által leadott rendeléseket tartalmazza.
- `orderID` : A megrendelések egyedi azonosítója, integer típusú, automatikusan generálódik, a tábla elsődleges kulcsa.
- `customerID` : A megrendelő azonosítója, idegen kulcs, a customers tábla azonos oszlopához kapcsolódik.
- `productID` : A megrendelt termék azonosítója, idegen kulcs, a production.products azonos nevű oszlopához kapcsolódik.
- `unitPrice` : A termékek egységára, dec(7,2) adattípusú oszlop.
- `taxRate` : A termék ÁFA kulccsa, dec(2,2) adattípusú oszlop.
- `orderedQuantity` : A rendelés darabszáma, integer adattípusú, nem vehet fel null értéket.
- `orderDate` : A megrendelés dátuma, date adattípusú, null értéket nem vehet fel.
- `orderPickupDate` : A rendelés a futárszolgálatnak történő átadásának időpontja, date adattípusú.
- `estimatedDeliveryDate` : A kézbesítés várható ideje, date adattípusú oszlop.
- `comments` : Vásárlói észrevétel, hozzászólás, üzenet, nvarchar(max) adatípusú oszlop.

### Trading.warehouse

A cég raktárkészletének nyilvántartására szolgáló tábla.
- `warehouseID` : A termék egyedi raktári azonosítója, integer adattípusú, automatikusan generálódik, a tábla elsődleges kulcsa.
- `productID` : A termék egyedi azonosítója, idegen kulcs, a production.products tábla azonos oszlopához kapcsolódik.
- `stockQuantity` : Az aktuálisan tárolt mennyiség, integer adattípusú, nem vehet fel null értéket.
- `quantityPerPackage` : A csomagonkénti darabszáma a terméknek, integer típusú oszlop, null értéket nem vehet fel.
- `stockingStartDate` : A tárolás kezdő időpontja, date típusú, alapértelmezett értéke az aktuális dátum (default current_timestamp).
- `lastEditDate` : Az utolsó módosítás dátuma, date típusú oszlop, alapértelmezetten az aktuális dátum az értéke.
- `editedBy` : A módosítást végző alkalmazott azonosítója, integer típusú oszlop, idegen kulcs, az employees.employees tábla azonos nevű oszlopához kapcsolódik.
- `responsibleStorekeeper` : A termék raktározásáért felelős raktáros beosztású alkalmazott azonosítója, idegen kulcs, az employees.employees tábla azonos nevű oszlopához kapcsolódik.
- `comment` : Nvarchar(max) típusú oszlop, a termék tárolásához kapcsolódó megjegyzéseket tartalmazza.

## Tárolt eljárások és triggerek
### addEmployee tárolt eljárás

Ez a tárolt eljárás teszi lehetővé az employee tábla adatainak gyors feltöltését. Hat paramétert fogad (firstName, lastName, birthDay, numberOfChildren, socialSecurityIdentifier, taxIdentifier), amelyek az adattábla azonos nevű soraiba illesztik a megadott értéket.
Az adatok beillesztése előtt az eljárás ellenőrzést végez:
- Nem enged beilleszteni 1900-01-01-től korábbi és az aktuális dátumnál későbbi születési időt.
- A gyerekek számának nem fogad el 0-nál kisebb értéket.
- TAJ számnak (socialSecurityIdentifier) nem fogad el olyan értéket, amely nem 9 karakter hosszúságú, vagy már szerepel a táblában.
- Adószámnak (taxIdentifier) szintén nem enged olyan értéket megadni, amely nem 11 karakter hosszúságú, vagy már szerepel a táblában.

### calcAnnualLeave user defined function

Ez az egyedi function szintén az employees sémához kapcsolódik. Egy alkalmazott employeeID-ját fogadja paraméterként, és az employee táblában szereplő születési időből, valamint a gyerekek számából kiszámolja az adott munkavállaló szabadságának számát. A visszatérési értéke az annualLeave tábla azonos nevű oszlopának megfelelően tinyint.

### addEmployment tárolt eljárás

Az addEmployment tárolt eljárás felelős a dolgozók foglalkoztatással kapcsolatos adatainak beviteléért az adatbázis employment táblájába. Öt paramétert fogad (employeeID, jobTitle, fullTime, partTimeSix, partTimeFour, partTimeTwo) és beilleszti az adattábla megfelelő oszlopaiba az értékeiket, valamint kiegészíti azokat számított oszlopértékekkel.
Az adatok betöltése előtt ez az eljárás is ellenőrzi azokat:
- Az employeeID automatikusan generálódik az addEmployee tárolt eljárás futtatása után (amikor beilleszti az adatokat a táblába), így az alkalmazott azonosítóját a másik táblából tudjuk kiolvasni. Az addEmployment tárolt eljárás csak olyan employeeID-t fogad el paraméterként, amely szerepel az employee táblában, de az employment még nem tartalmazza.
- A fullTime, partTimeSix, partTimeFour és a partTimeTwo oszlopok BIT adattípusúak, értékük így csak 0 és 1 lehet (true/false), az eljárás ellenőrzi, hogy a négy oszlop értékei közül csak egy legyen true (egy alkalmazott nem dolgozhat ugyanannál a cégnél teljes állásban és részmunkaidőben is egyszerre).
- A tábla utolsó oszlopának, a maxWorkhoursPerMonth-nak az értékeit az eljárás automatikusan kicsámolja a megadott foglalkoztatási forma alapján (fullTime 180 óra, partTimeSix 135, stb.).

### addAnnualLeave tárolt eljárás

Ez a tárolt eljárás az alkalmazottak szabadáságával kapcsolatos adatait illeszti be az annualLeave táblába. Négy paramétert fogad, az employeeID-vel azonosítja a munkavállalót, a leaveBegin a szabadság kezdő dátuma, a leaveEnd a vége, a leaveTaken pedig a felhasznált szabadnapok száma. Ez az eljárás hívja meg a calcAnnualLeave függvényt, és illeszti be annak eredményét az annualLeave tábla megfelelő oszlopába.

### warehouse_update_Trigger

Ez a trigger a trading.warehouse tábla módosításai után aktiválódik és illeszti be a módosított értékeket a warehouse_log táblába, ennek köszönhetően monitorozhatók a raktárkészlet változtatásai.

### orderStockCheck tárolt eljárás

Az orderStockCheck eljárással lekérdezhetjük, hogy egy konkrét megrendeléshez kapcsolódó termékből van-e elegendő raktáron. Paraméterként fogadja a megrendelés azonosítóját (orderID) és visszaadja az adott rendeléshez kapcsolódó termék productID-ját, címét, ISBN számát, megjelenési idejét, a rendelt mennyiséget, és a raktáron lévő készletet. Amennyiben van elegendő termék a rendelés teljesítéséhez egy új oszlopban megjeleníti az 'Available', ha nincs elegendő az 'Insufficient Stock' kifejezést.

# Felhasználók és jogosultságok

Az adatbázishoz három login került létrehozásra eltérő jogosultságokkal:
- Az administrator login-hoz tartozó, azonos nevű felhasználó, adatbázis szintű datawriter jogosultságokkal rendelkező user. Feladata az adatbázis karbantartása, alapértelmezett sémája az employees séma.
- A storekeeper login azonos nevű userének alapértelmezett sémája a trading séma. Mivel ennek a felhasználónak a feladata a raktárkészlet ellenőrzésre korlátozódik, így csak a trading.warehouse táblára van jogosultsága, arra viszont írási, olvasási és módosítási.
- A production login felhasználója az azonos nevű user. Feladata a termékek adatainak kezelése, folyamatos nyomon követése, ennek megfelelően a production sémára van írási, olvasási és módosítási jogosultsága.