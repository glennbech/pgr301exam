ALL GITHUB SECRETS names:

AWS_ACCESS_KEY_ID

AWS_REGION

AWS_SECRET_ACCESS_KEY

ECR_REGISTRY_URL


1b
burde kjøre, må kanskje wrappe keys med ""
docker build -t kjellpy . 
docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket kjellpy

add /scan-ppe?bucketName=kjellsimagebucket to the url in browser to see json object after running mvn spring-boot:run

2a
burde kjøre, må kanskje wrappe keys med ""
docker build -t ppe . 
docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket ppe


4a
måleinstrumentene jeg har brukt er LongTaskTimer som tracker tiden det tar å scanne s3 bucketen for masker, timeren starter
når scanningen starter og stopper når den er ferdig. Grunnen til at jeg har valgt å ha den med er fordi det er god informasjon
å ha når man skal sjekke hvor effektiv scanneprosessen er.

Jeg har brukt DistributionSummary for å telle antall individer i de scannede bildene,
jeg inbiller meg at det kan være en god statistikk gitt at bildene var tatt på tilfeldige tidspunkter 
og steder i et sykehus. Det kan fortelle noe om hvor mange leger er sammen til vanlig og hvor mange av de som har på maske til vanlig.

Jeg har også med Gague som ikke egentlig er så relevant for eksamenen, men kan være relevant hvis man skalerer
opp programmet til å scanne mange bilder flere ganger, det kan gi god informasjon om hvor stor workload x antall bilder per scan krever.


4b
namespace på alarm.tf er hardcoded siden jeg hadde noen problemer, e-postadressen endres i variables.tf som må endres til hvem en
som skal få e-post.



Oppgave 5 kandidat 2029
A
Kontinuerlig integrasjon innebærer at man jevnlig pusher kode til et delt repository, ofte flere ganger 
daglig. Ved hver kodeinnsending verifiseres koden gjennom en automatisert bygg- og testprosess, for 
å sikre at den nye koden fungerer sammen med den eksisterende koden. Hovedmålet med CI er å 
raskt identifisere Bugs, konflikter og integrasjonsproblemer. Dette gjør det enklere å vedlikeholde 
store kodebaser, siden man kan adressere problemer enkeltvis, i stedet for alle på en gang under en 
større utrulling.
Fordelene med CI inkluderer hyppigere oppdagelse av bugs og problemer, noe som fører til enklere 
feilsøking. Dette bidrar også til å opprettholde en høy standard på koden, ettersom den kontinuerlig 
testes og kontrolleres for kompatibilitet. CI automatiserer integrasjons- og testprosessen, reduserer 
manuelt arbeid og risikoen for menneskelige feil, noe som fører til raskere utviklingsprosesser. 
Utviklere får også umiddelbar tilbakemelding på endringene sine, som gjør det mulig å foreta raske 
justeringer og fremskynde utrulling av oppdateringer til brukerne.
I et utviklingsteam på fire til fem personer som benytter CI i GitHub, består den praktiske 
implementeringen av å sette opp automatiserte arbeidsflyter med GitHub Actions. Dette involverer 
bygging og testing av kode hver gang endringer blir pushet eller pull requests blir opprettet. Denne 
prosessen sikrer at bidrag fra hvert teammedlem raskt blir integrert og validert, noe som forbedrer 
samarbeid og opprettholder kodekvaliteten gjennom hele utviklingslivssyklusen.
B
Scrum, som en del av den agile metodikken, fokuserer på iterativ utvikling gjennom tidsbestemte 
sprinter og vektlegger fleksibilitet, samarbeid og kundetilbakemeldinger. Sentrale roller som Scrum 
Master og Product Owner samarbeider nært med utviklingsteamet for å sikre en effektiv arbeidsflyt. 
Scrum styrke ligger i dens evne til å tilpasse seg raskt endrede krav, noe som gjør det ideelt for 
prosjekter med skiftende behov. Imidlertid kan det møte utfordringer i mer rigide eller tradisjonelt 
strukturerte miljøer. I kontrast fokuserer DevOps på integrasjonen av utvikling og drift for å forbedre 
hastigheten og kvaliteten på programvareleveranser. Dette oppnås gjennom automatisering, 
kontinuerlig integrasjon og kontinuerlig levering, med mål om å forkorte utviklingssyklusene og øke 
hyppigheten av utrullinger. DevOps er særlig effektivt i prosjekter der raske og hyppige oppdateringer 
er nødvendige, men krever en betydelig kulturell endring og en dyp forståelse av 
automatiseringsverktøy.
Når Scrum/Agile og DevOps sammenlignes, er det tydelig at begge metodikkene forbedrer 
programvarekvaliteten og leveringshastigheten, men på forskjellige måter. Scrum utmerker seg i 
håndteringen og tilpasningen til endrede prosjektkrav, mens DevOps fokuserer mer på effektiviteten 
og hastigheten i utvikling-til-utrulling-prosessen. Valget mellom Scrum/Agile og DevOps, eller en 
kombinasjon av begge, avhenger av spesifikke prosjektbehov, teamets struktur og 
organisasjonsmiljøet. Hver har sine unike styrker, og beslutningen bør være i samsvar med 
prosjektets mål og teamets evner.
C
Ved implementering av ny funksjonalitet i en applikasjon, er etableringen av en sterk feedback-loop
viktig for å sikre at den møter brukernes behov. Innledningsvis kan brukerhistorier og akseptkriterier 
veilede utviklingen, men etter distribusjon blir teknikker som brukerundersøkelser, 
brukbarhetstesting og analyseverktøy essensielle. Overvåking av brukerinteraksjoner med den nye 
funksjonen via analyser kan gi kvantitativ tilbakemelding om bruken og ytelsen av tjenesten. 
Kvalitativ tilbakemelding kan samles inn gjennom direkte brukerundersøkelser eller fokusgrupper, 
som tilbyr innsikt i brukertilfredshet og områder for forbedring.
Integrering av tilbakemeldinger i ulike stadier av utviklingslivssyklusen er nøkkelen til kontinuerlig 
forbedring. I planleggingsfasen kan tilbakemeldinger informere prioritering av funksjoner. Under 
utviklingsstadiet kan rask prototyping og brukertesting validere forutsetninger før fullskala 
implementering. Etter distribusjon hjelper kontinuerlig overvåking og brukertilbakemeldinger med å 
finpusse funksjonen, noe som forbedrer brukeropplevelsen og verdien. Denne iterative prosessen 
med å søke, analysere og anvende tilbakemeldinger sikrer at applikasjonen utvikler seg i samsvar 
med brukernes behov og forventninger, og leder til et mer vellykket og brukersentrisk produkt.