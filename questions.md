# Teoriakysymykset -- Azure IaC ja Bicep

Vastaa seuraaviin kysymyksiin omin sanoin. Vastausten ei tarvitse olla pitkiä -- muutama lause riittää, kunhan osoitat ymmärryksesi.

---

## Osa 1: Infrastructure as Code

### Kysymys 1: IaC:n perusidea

Selitä omin sanoin, mitä Infrastructure as Code tarkoittaa ja miksi sitä käytetään. Anna esimerkki tilanteesta, jossa IaC on hyödyllisempi kuin resurssien luominen käsin Azure Portalissa.

- Infrastructure as Code eli IaC tarkoittaa infrastruktuurin hallintaa kooditiedostojen kautta manuaalisen hallinnan sijaan. Sitä käytetään koska se on nopea tapa pystyttää infra ja koska se on helposti toistettava, eli sama koodi tuottaa aina saman infran. IaC on hyödyllinen kun otetaan käyttöön identtisiä sovelluksia mutta eri ympäristöissä esim. development, production jne.

### Kysymys 2: Deklaratiivinen vs. imperatiivinen

Selitä ero deklaratiivisen ja imperatiivisen IaC-lähestymistavan välillä. Kumpaan kategoriaan Bicep kuuluu?

- Deklaratiivinen on vähän kuin "mitä haluan?" ja imperatiivinen on "miten teen?". Bicep on deklaratiivinen eli kerrot sille mitä haluat ja se tekee puolesta. imperatiivisessä lähestymistavassa pitäisi kertoa itse jokainen askel.

### Kysymys 3: Idempotenssi

Mitä tarkoittaa, kun sanotaan, että IaC on **idempotenttia**? Miksi tämä ominaisuus on hyödyllinen?

- Se tarkoittaa että sama koodi tuottaa aina saman tuloksen. On hyödyllinen toistettavuuden ja odotettavuuden kannalta. Eli vaikka jos luot jonkun resurssiryhmän IaC:llä ja koitat luoda sen uudestaan samalla tavalla, sitä ei luoda uudestaan.

### Kysymys 4: Konfiguraation ajautuminen (drift)

Selitä, mitä "configuration drift" tarkoittaa. Miten IaC auttaa estämään sitä?

- Configuration drift tarkoittaa tilannetta, jossa järjestelmän todellinen konfiguraatio poikkeaa halutusta tilasta. IaC estää ja korjaa configuration driftin varmistamalla että infrastruktuuri vastaa aina sitä mitä koodissa on.

---

## Osa 2: Bicep

### Kysymys 5: Bicep vs. ARM

Miksi Bicep kehitettiin ARM JSON -templatejen tilalle? Mainitse vähintään 2 etua.

- Bicep kehitettiin ratkaisemaan ARM JSON templatejen käytettävyys- ja ylläpito-ongelmia. Bicep on luettavampi ja selkeämpi. Siinä on vähemmän virheitä. Bicep tukee myös moduuleita

### Kysymys 6: Parametrit ja `@secure()`

Miksi tietokantasalasana merkitään `@secure()`-dekoraattorilla Bicepissä? Mitä tapahtuisi ilman sitä?

- Secure piilottaa akaluontoiset asiat kuten salasanat. Ilman sitä arkaluotoiset asiat esitettäisiin normi tekstinä ja ne voivat näkyä vaikka ja missä lokeissa ym. Iso tietoturva riski.

### Kysymys 7: Moduulit

Miksi infrastruktuurikoodi jaettiin tässä tehtävässä kolmeen erilliseen moduuliin (`acr.bicep`, `postgresql.bicep`, `appservice.bicep`) yhden ison tiedoston sijaan? Mainitse vähintään 2 syytä.

- Selkeys. Jokainen moduuli vastaa yhdestä resurssityypistä. helpompi testaus ja debuggaus.

### Kysymys 8: `uniqueString()`

Miksi ACR:n ja PostgreSQL-palvelimen nimissä käytetään `uniqueString(resourceGroup().id)` -funktiota? Mitä tapahtuisi ilman sitä?

- varmistaa nimien yksilöllisyyden. ilman sitä nimet voivat olla päällekkäisiä muiden resurssejen kanssa tai deployment ei onnistu koska nimi on jo olemassa.

### Kysymys 9: `targetScope`

Mitä tarkoittaa `targetScope = 'subscription'` main.bicep-tiedostossa? Miksi emme käytä oletusarvoa `resourceGroup`?

- Deployment kohdistuu tilaustasolle eikä yksittäiseen resurssiryhmään.
subscription-scopea käytetään, kun deploymentin pitää hallita tai luoda resursseja resource group tason yläpuolella.

---

## Osa 3: Azure-resurssit

### Kysymys 10: Resource Group

Mikä on Azure Resource Groupin tarkoitus? Miksi kaikki sovelluksen resurssit kannattaa sijoittaa samaan resource groupiin?

- Looginen paikka mistä köytää helposti kaikki samaan juttuun liittyvät asiat. Helppo hallita kokonaisuutta.

### Kysymys 11: Ympäristömuuttujat ja Connection String

Selitä, miten sovelluksen tietokantayhteys konfiguroidaan eri ympäristöissä:
- Miten connection string asetetaan **Docker Composessa** (lokaalissa kehityksessä)?
Connection string asetetaan environment-muuttujana docker-compose.yml-tiedostossa

- Miten **sama** connection string asetetaan **Azure App Servicessä**?
Connection string asetetaan Application Settings- tai Connection strings -kohtaan. Azure injektoi env muuttujan ajon aikana

- Miksi sovelluksen koodi ei muutu, vaikka ympäristö vaihtuu?
Ympäristökohtainen arvo tulee ulkoisesta konfiguraatiosta, ei koodista


### Kysymys 13: PostgreSQL Flexible Server -- Firewall

Miksi PostgreSQL-palvelimeen luodaan firewall-sääntö `AllowAzureServices` (IP-alue `0.0.0.0 - 0.0.0.0`)? Mitä tapahtuisi ilman sitä?

- Että azuren sisäiset palvelut pääsevät tietokantaan ilman erillistä IP ositetta. Ilman sitä muut azuren palvelut eivät pääse tietokantaan.

---

## Osa 4: Deployment ja turvallisuus

### Kysymys 15: What-if

Miksi `what-if` on tärkeä vaihe ennen deploymenttia? Anna esimerkki tilanteesta, jossa what-if estäisi ongelman.

- What if komento näyttää mitä tulee tapahtumaan kun ajaa vaikka deployment komennon, mutta ei oikeasti tee mitään. Se on hyvä varmistamaan että deployment/päivitys ei tee mitään odottamatonta kuten vaikka poista jotain tärkeää.

### Kysymys 16: Tagit

Miksi kaikkiin Azure-resursseihin lisättiin tagit (`Application`, `Environment`, `ManagedBy`)? Miten ne hyödyttävät käytännössä?

- ne toimivat metadatana resurssien hallintaan, organisointiin ja automaatioon. Niitten avulla voidaan erottaa esim ympäristöt.

### Kysymys 17: Siivous ja kustannukset

Miksi on tärkeää poistaa kehitysresurssit Azuresta kun niitä ei enää tarvita? Mikä on helpoin tapa poistaa kaikki tämän tehtävän resurssit kerralla?

- Ettei se jää päälle ja kuluta turhaan rahaa/kredittejä. helpoin tapa on luoda scripti joka poistaa kaikki luodut instanssit.

---

