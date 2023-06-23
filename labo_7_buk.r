---
output:
  pdf_document: default
  html_document: default
---
  
# Ikerketa Operatiboa
# 5. Laboratorio-saioa: Eredu linealen ebazpena `lpSolveAPI` erabiliz

Laboratorio-saio honen helburua optimizazio-ereduak ebazteko erabiltzen den R inplementazio bat erabiltzen ikastea da: `lpSolveAPI` paketea. Informazio gehiagorako, ikus lpSolveAPI-ren eskuliburua
(https://cran.r-project.org/web/packages/lpSolveAPI/index.html) eta lp_solve 5.5.2.5 dokumentazioa, a Mixed Integer Linear Programming (MILP) solver (http://lpsolve.sourceforge.net/5.5/index.htm). Erabilerari buruzko manual txiki bat aurkituko duzu hemen: https://lpsolve.r-forge.r-project.org/

RStudio-tik bertatik jaitsi eta instala dezakezu, horrela: 

```{r, eval=FALSE}
#install.packages("lpSolve")
#install.packages("lpSolveAPI")
library(lpSolveAPI)
```

Paketea instalatu eta kargatu ondoren, RStudioren "Paketeak" atalera joan eta `lpSolveAPI` paketearen izenaren gainean klik egin dezakezu, bertan definitutako funtzio guztien laguntza-orriak ikusteko. `ls("package:lpSolveAPI")` aginduaren bidez paketean definitutako funtzio guztien zerrenda ikus daiteke. Horietako edozein funtzioren laguntza eskatzeko `help` erabil dezakezu, adibidez `help(make.lp)`. Interneten ere aurkituko duzu laguntza-orrien dokumentua (https://cran.r-project.org/web/packages/lpSolveAPI/lpSolveAPI.pdf)

Paketea erabiliko dugu problema linealak ebazteko, itzal-prezioak interpretatzeko eta ereduko aldaketa diskretu batzuk aztertzeko (sentikortasunaren azterketa). Har dezagun problema lineal bat adibide gisa (Eredu linealak gaiko 12. ariketa).

## Adibide bat: ekoizpen-problema bat

Lantegi batek hiru ongarri-mota sortu nahi ditu: $O_{5-10-5}, O_{5-10-10}$ eta $O_{10-10-10}$. Zenbakiek adierazten dutena zera da: ongarri-mota bakoitzean dagoen nitrato, fosfato eta potasa portzentaia. Bestelako materia ere erabiltzen da nahasketan, baina hori ez dago kantitate aldetik mugatuta. 

Lantegiak 1.000 tona nitrato, 1.800 tona fosfato eta 1.200 tona potasa ditu erabilgarri. Prezio desberdinetan erosi ditu, tona erostearen kostua nitratoa (1600), fosfatoa (400), potasa (1000), bestelako materia (50).

Nahasketak egin eta ongarriak salmentarako prestatzeak kostuak sortzen ditu, berberak hiru ongarri motatarako: 150 unit. ongarri tonako. Hala ere, ongarriak prezio desberdinean saltzen dira: $O_{5-10-5}$ (400), $O_{5-10-10}$ (500), $O_{10-10-10}$ (600). Bestalde, kontutan izan behar da lantegiak 6.000 tona $O_{5-10-5}$ ongarri zerbitzatzeko konpromezua hartu duela. 

Irabazia maximizatzeko ongarri-mota bakoitzetik zenbat ekoitzi beharko litzatekeen jakin nahi dute lantegian. Honako eredu linealak problema adierazten du.

$$
\begin{array}{rr}
\max\ z=40x_1 + 92.5x_2 + 115x_3 &\\
\mbox{hauen mende}\hspace{3.5cm} &\\
0.05x_1 + 0.05x_2 + 0.1x_3 \leq 1000 &\quad \mbox{(Nitratoa)}\\
0.1x_1 + 0.1x_2 + 0.1x_3 \leq 1800 &\quad \mbox{(Fosfatoa)}\\
0.05x_1 + 0.1x_2 + 0.1x_3 \leq 1200 &\quad \mbox{(Potasa)}\\
x_1 \hspace{3cm} \geq 6000 & \\
x_{1},x_{2}, x_3\geq 0 &
\end{array}
$$


# `lpSolveAPI` paketearen erabilpena
Ikus ditzagun paketean definitutako funtzio erabilgarri batzuk.

## Eredu linealaren definizioa

Lehenik, eredu lineala definitu behar da. Oso erabilgarriak dira funtzio hauek: `make.lp` funtzioak lpSolve-rako eredu lineal motako objektu berri bat sortzen du, `set.column` funtzioarekin matrizeko zutabe bateko balioak ematen dira, `set.objfn` funtzioarekin helburu-funtzioko koefizienteak finkatzen dira, `set.constr.value`-ekin $\mathbf{b}$ bektorea definitzen da eta `set.constr.type`-ek murrizketa-motak ezartzen ditu. Aldagaiak eta murrizketak izendatzeko `dimnames` erabil daiteke. `set.column` aginduak helburu-funtzioko koefizienteei eragiten dienez, helburu-funtzioko koefizienteak ($\mathbf{c}$ bektorea) definitu baino lehen $\mathbf{A}$ matrizearen zutabeak definitu behar dira. Besterik esan ezean, aldagaiak ez-negatibo direla ulertuko da. Eta, besterik esan ezean helburua minimizatzea dela ulertuko da. Aldatzeko `lp.control` funtzioa erabil daiteke

```{r, eval=FALSE}
rm(list=ls())
model.example <- make.lp(nrow=4, ncol=3)
model.example
lp.control(model.example, sense="max")
model.example
set.objfn(lprec=model.example, obj=c(40, 92.5, 115), indices=1:3) 
model.example
set.column(lprec=model.example, column=1, x=c(0.05, 0.1, 0.05, 1))
set.column(lprec=model.example, column=2, x=c(0.05, 0.1, 0.1, 0))
set.column(lprec=model.example, column=3, x=c(0.1, 0.1, 0.1, 0))
model.example
set.objfn(lprec=model.example, obj=c(40, 92.5, 115), indices=1:3)
model.example
set.constr.value(lprec=model.example, rhs=c(1000, 1800, 1200, 6000), constraints=1:4)
set.constr.type(model.example, types=c("<=", "<=", "<=", ">="), constraints=1:4)
model.example
variables   <- c("x1","x2","x3")
constraints <- c("1. murrizketa", "2. murrizketa", "3. murrizketa", "4. murrizketa") 
dimnames(model.example) <- list(constraints, variables)
model.example
```
Fitxategi batetik ere irakur daiteke lpSolve-rako eredu lineal baten objektu bat `read.lp` funtzioa erabiliz. "lp" motako formatua erabiltzen badugu, horrela ikusten da eredua:

```
max: 40x1 + 92.5x2 + 115x3;
Nitratoa: 0.05x1 + 0.05x2 + 0.1x3 <= 1000;
Fosfatoa: 0.1x1 + 0.1x2 + 0.1x3 <= 1800;
Potasa: 0.05x1 + 0.1x2 + 0.1x3 <= 1200;
Eskaria: x1>=6000;
```

Fitxategi batean gordeta, RStudio-n karga dezakegu:

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
model.example
```

## Ereduaren ebazpena

Eredu lineala adierazten duen objektua sortu ondoren, `solve` funtzioa erabil daiteke eredua ebazteko. Informazio gehiago nahi izanez gero, idatzi `?solve.lpExtPtr` RStudio-ren "help" leihoan. Egoera-kodea adierazten duen zenbaki oso bat itzultzen da; 0 itzultzen bada, horrek esan nahi du soluzio optimoa aurkitu dela. Gainera, informazio gehiago erakusten da pantailan. Soluzio optimoa eta helburu-funtziorako balio optimoa ikusteko, `get.variables` eta `get.objective` funtzioak erabil daitezke.

```{r, eval=FALSE}
?solve.lpExtPtr
solve(model.example)
get.variables(model.example)
get.objective(model.example)
```
Ekoizpen-problemaren soluzio optimoa honako hau da: $x_1^*=6000$, $x_2^*=4000$, $x_3^*=5000$. Horrek esan nahi du enpresak 6000 tona $O_{5-10-5}$ ongarri ekoitzi beharko lituzkeela, 4000 tona $O_{5-10-10}$ eta 5000 tona $O_{10-10-10}$. Produkzio optimo horrek 1185000 euroko irabazi maximoa ematen du.

## Itzal-prezioen interpretazioa

Itzal-prezioei esker (soluzio dualaren interpretazio ekonomikoa), baliabideen erabilera azter dezakegu, eta enpresak ekoizpena mugatzen duen baliabideren baten unitate gehiago erostea erabakitzen badu, baliabide-unitate bakoitzeko gehienez ordaindu beharko luken prezioari buruzko informazioa lortzen da.

Itzal-prezioak interpretatzeko, dualaren soluzio optimoa behar dugu. Interpretazioa egiaztatzeko, eredu linealeko $\mathbf{b}$ bektorea aldatuko dugu, eta berriro ebatziko dugu. Baliabideen erabilera ikusteko murrizketak ere egiaztatuko ditugu.

Oso erabilgarriak dira, besteak beste, `get.sensitivity.rhs` funtzioa, aldagai dualen balio optimoak eta $\mathbf{b}$ bektoreko balioen tartea (goiko eta beheko mugak) lortzeko, `set.rhs` funtzioa, $\mathbf{b}$ bektoreko elementuak finkatzeko eta `get.constraints` funtzioa, murrizketak egiaztatzeko.

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
model.example
solve(model.example)
get.variables(model.example)
z_opt <- get.objective(model.example)
z_opt 
dual <- get.sensitivity.rhs(model.example)
dual
dual$duals 

# Itzal-prezioen interpretazioa. b1 (Nitratoa) baliabidearekin erlazionatuta y1^* 
get.rhs(model.example) 
set.rhs(model.example, c(1001, 1800, 1200, 6000)) 
get.rhs(model.example) 
solve(model.example)
get.variables(model.example) 
z_opt_new <- get.objective(model.example)
z_opt_new 
z_opt 
dual$duals[1]
emaitza_b1 <- get.variables(model.example)
get.constraints(model.example)
z_opt_new == z_opt + dual$duals[1] 

# Itzal-prezioen interpretazioa. b2 (Fosfatoa) baliabidearekin y_2* . Ez du ekoizpena mugatzen
set.rhs(model.example, c(1000, 1799, 1200, 6000))
get.rhs(model.example) 
solve(model.example)
get.variables(model.example) 
z_opt_new <- get.objective(model.example)
z_opt_new 
z_opt 
dual$duals[2]
emaitza_b2 <- get.variables(model.example)
z_opt_new == z_opt - dual$duals[2]

get.constraints(model.example) 
```

### Galderak

* Idatz ezazu dualaren soluzio optimoa, $y^*_1=$\quad , $y^*_2=$\quad , $y^*_3=$\quad , $y^*_4=$\quad .













 

* Interpreta itzazu $y^*_1$ eta $y^*_2$ itzal-prezioak.













* Arrazona ezazu baliabideen erabilera soluzio optimoa murrizketetan egiaztatuz.















## Sentikortasunaren analisia 

Itzal-prezioen interpretazioa baliabideen aldaketa unitarioei dagokie. Oro har, baliabideen $\mathbf{b}$ bektorean eman daitezkeen aldaketek soluzio optimoan eta irabazi optimoan izango duten eragina aztertzeko, sentikortasunaren analisia erabil daiteke. Eredu linealean eman daitezkeen beste aldaketa diskretu batzuk ere azter daitezke sentikortasunaren analisiarekin, ez bakarrik baliabideen bektorean gertatzen direnak.

## Aldaketak $\mathbf{b}$ bektorean

Hasteko, interesgarria da  $\mathbf{b}$ bektoreko elementuen balio-tarteak (goiko eta beheko mugak) aztertzea, hau da, zein balio-tartetan alda daitezkeen baliabideen kantitateak uneko oinarria optimo manten dadin (bideragarritasun primala gal ez dadin). Izan ere, itzal-prezioen interpretazioa balio-tarte horien barruan dauden $\mathbf{b}$ bektoreko osagaien aldaketetarako bakarrik egin daiteke. Bideragarritasun primala galtzen den unean, ez du zentzurik izango dualaren soluzioa (itzal-prezioak) interpretatzen saiatzeak, jada ez baita optimoa izango.

Oso erabilgarriak diren funtzio batzuk hauek dira: `get.sensitivity.rhs` funtzioak balio-tarteak kalkulatzen ditu. `set.rhs`, `solve`, `get.variables` eta `get.objective` funtzioak erabil daitezke ereduan $\mathbf{b}$ bektorea aldatzeko, eredua ebazteko eta ebatzi ondoren soluzio optimoa lortzeko.

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
solve(model.example)
get.variables(model.example)
get.objective(model.example) 
dual <- get.sensitivity.rhs(model.example)
dual
dual$duals   
dual$dualsfrom 
dual$dualstill 

set.rhs(model.example, 1100, 1) 
solve(model.example)
get.variables(model.example) 
z_opt_new <- get.objective(model.example)
z_opt_new 
```

### Galderak

* Zein da b bektoreko lehenengo elementuaren (Nitratoa) balio-tartea, oinarri optimoa alda ez dadin?










* Lantegiak 1000 tona Nitrato izan ordez 1100 baditu, zein izango da soluzio optimoa?














## Aldaketak $\mathbf{c}$ bektorean

Paketearen funtzioak erabiliz posible da $\mathbf{c}$ bektorearen aldaketak aztertzea. `get.sensitivity.obj` funtzioaren erabilera azter ezazu honako adibidean eta erantzun itzazu galderak.

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
solve(model.example)
get.variables(model.example) 
get.objective(model.example) 
get.sensitivity.obj(model.example) 
set.objfn(model.example, c(40, 92.5, 115), 1:3) 
solve(model.example)
get.variables(model.example)  
get.objective(model.example) 
```

### Galderak

* Helburu-funtzioaren hirugarren koefizientea ($O_{10-10-10}$ ongarriaren ekoizpenetik lortutako $c_3$ irabazi unitarioa) zein balio-tartetan alda daiteke oinarri optimoan eragin gabe?









 
* Hirugarren ongarri motaren ($O_{10-10-10}$)  ekoizpenetik lortutako irabazi unitarioa $c_3=115$ izan ordez $c_3=180$ bada, zein izango da soluzio optimoa? Eta, irabazi optimoa? Arrazona itzazu zure erantzunak.












# Ariketak

Orain zure txanda da funtzio egokiak erabiliz problema ebatzi eta galdera erantzuteko. Laboratorio-saio honen hasieran aurkeztutako eredu berarekin segituko dugu (Eredu linealak gaiko 12. ariketako eredua).


**1. ariketa** 

$O_{5-10-5}$ ongarriaren eskari altuagoa zerbitzatu behar badu lantegiak (6000 tonako eskaria izan ordez 6001ekoa) irabazi optimoa aldatu egingo al da? Eta, soluzio optimoa? Zure erantzuna justifika ezazu itzal-prezioen interpretazioa eginez. Egin duzun interpretazioa egiaztatzeko, alda ezazu datu hori ereduan, ebatzi eta eman soluzio optimo berria.

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
model.example
#(IDATZI KODEA HEMEN)
set.rhs(model.example, 6001, 4)
solve(model.example)
get.variables(model.example)
get.objective(model.example)




#(IDATZI KODEA HEMEN)
```

Justifikazioa:


















**2. ariketa** 

Demagun biltegian 300 tona baliabide gehiago gordetzeko lekua dagoela. Hiru baliabideen artetik (Nitratoa, Fosfatoa, Potasa), zein baliabideren erabilgarritasuna handituko zenuke? Zergatik?

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
model.example
solve(model.example)
z_op_old = get.objective(model.example)
#(IDATZI KODEA HEMEN)
duals <- get.sensitivity.rhs(model.example)
set.rhs(model.example, 1500, 3)
solve(model.example)
get.objective(model.example)
get.objective(model.example) == z_op_old + (300*duals$duals[3])










#(IDATZI KODEA HEMEN)
```

Justifikazioa:














**3. ariketa** 

Halako batean, denek erosi nahi dute lehenengo motako ongarria ($O_{5-10-5}$). Ondorioz, salmenta-prezioa igo da eta lantegiak lortuko duen unitateko irabazia 100-ekoa da 40-koa izan ordez. Zein da orain ekoizpen optimoa? Eta, irabazi optimoa? Arrazona itzazu lortutako emaitzak, balioen tarteak eta baliabideen erabilera kontuan hartuz.

```{r, eval=FALSE}
rm(list=ls())
model.example <- read.lp(file="eredua_12_ariketa.lp", type="lp", verbose="full")
model.example
#(IDATZI KODEA HEMEN)
set.objfn(model.example, c(110,92.5,115), 1:3)
set.rhs(model.example, 1100, 1)
solve(model.example)
get.variables(model.example)
get.objective(model.example)











#(IDATZI KODEA HEMEN)
```

Justifikazioa:















# Programazio osoa

`lpSolveAPI` paketea erabil daiteke programazio osoko eredu linealak ebazteko ere. Har dezagun problema oso bat adibide moduan (Programazio osoa gaiko 4. ariketa).

## Programazio osoko problema bat

Leku batetik beste batetara $6$ pieza ($P_1, P_2,  P_3, P_4, P_5, P_6$) bidali nahi dira, gehienez $15$ kg eramateko ahalmena duen kutxa batean sartuta. Piezen balioak eurotan neurtuta 4, 2, 1, 7, 3, 6 dira, hurrenez hurren, eta pisuak 5, 8, 8, 6, 1, 5  kg-tan neurtuta. Kutxan gutxienez 3 pieza sartuko direla bermatu nahi da. Helburua kutxan sartutako piezen balioa maximizatzea izanik, 6 pieza horien artean kutxan sartuko direnak zein izango diren aukeratu behar da. Sei erabaki-aldagai bitar definitu dira, pieza bakoitza kutxan sartuko den edo ez erabakitzeko. Problema adierazten duen eredu lineal bitarra hau da:

\begin{eqnarray*}
\max \ z = 4x_1 +2x_2 +x_3 +7x_4 +3x_5 +6x_6 \\
\mbox{hauen mende} \hspace{4.5cm} \\
5x_1 +8x_2 +8x_3 +6x_4 +x_5 +5x_6 \leq 15 \\
x_1 +x_2 +x_3 + x_4 + x_5 + x_6 \geq 3 \\
x_1, x_2, x_3, x_4, x_5, x_6=0 \mbox{ edo } 1
\end{eqnarray*}

Dagoeneko erabili dugu `make.lp` funtzioa eredu berri bat sortzeko, eta `set.column`, `set.objfn`, `set.constr.value`, `set.constr.type` eta `lp.control` funtzioak koefizienteak sartzeko eta murrizketen zentzua eta helburua definitzeko, eta `solve`, `get.objective` eta `get.variables` funtzioak eredua ebazteko eta soluzio optimoa lortzeko. `set.type` funtzioa erabil daiteke aldagaiak osoak edo bitarrak direla adierazteko.

Azter itzazu honako aginduak, begiratu lortutako emaitzak eta erantzun beheko galderak.

```{r, eval=FALSE}
model.binary <- make.lp(nrow=2, ncol=6)
set.column(lprec=model.binary, column=1, x=c(5, 1))
set.column(lprec=model.binary, column=2, x=c(8, 1))
set.column(lprec=model.binary, column=3, x=c(8, 1))
set.column(lprec=model.binary, column=4, x=c(6, 1))
set.column(lprec=model.binary, column=5, x=c(1, 1))
set.column(lprec=model.binary, column=6, x=c(5, 1))
set.constr.value(lprec=model.binary, rhs=c(15, 3), constraints=1:2)
set.constr.type(lprec=model.binary, types=c("<=", ">="), constraints=1:2)
set.type(model.binary, 1, type ="binary")
set.type(model.binary, 2, type ="binary")
set.type(model.binary, 3, type ="binary")
set.type(model.binary, 4, type ="binary")
set.type(model.binary, 5, type ="binary")
set.type(model.binary, 6, type ="binary")
lp.control(model.binary, sense="max")
model.binary
set.objfn(lprec=model.binary, obj=c(4, 2,1,7,3,6), indices=1:6)
model.binary
solve(model.binary)
get.objective(model.binary)
get.variables(model.binary)
get.total.nodes(model.binary)
get.solutioncount(model.binary)
```

### Galderak

* 6 pieza horien artean zeintzuk aukeratuko dira kutxan sartzeko? Zein izango da kutxaren balio maximoa?









* RStudioren laguntza orria edo CRAN-eko eskuliburua aztertuz, `get.total.nodes` eta `get.solutioncount` funtzioei buruzko informazioa lor ezazu. Eredua ebazteko erabili den algoritmoa zein da? Lortutako emaitza interpreta ezazu.  










## Ariketa

Demagun orain pieza mota bakoitzeko unitate batzuk ditugula; 4, 3, 5, 2, 5 eta 1, hurrenez hurren. Zein da orain soluzio optimoa? Eta, kutxaren balio optimoa? Azter ezazu `set.bounds` funtzioa; ondo etor dakizuke galderak erantzuteko. 

```{r, eval=FALSE}
model.integer <- make.lp(nrow=2, ncol=6)
#(IDATZI KODEA HEMEN)














#(IDATZI KODEA HEMEN)
```

Azalpenak:


















