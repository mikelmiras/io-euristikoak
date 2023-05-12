
setwd("/Users/ehu/Downloads")
library(metaheuR)
install.packages("igraph")
library(igraph)

# 2. Kirol-eguna informatika fakultatean

## Problemaren definizioa RStudio-n

rm(list=ls())
# Grafoaren erpin kopurua definitu
# IDATZI HEMEN (kode-lerro 1)


n <- 30
# Sortu ausaz grafoa
help("random.graph.game", package="igraph")
# IDATZI HEMEN (kode-lerro 1)
g <- erdos.renyi.game(n, 0.05)
g
plot(g)


# Sortu problemaren objektua
# IDATZI HEMEN (kode-lerro 1)
problem <- misProblem (g)


# Zein kiroletako partidak jokatuko diren adierazten...

# Soluzioa: partida guztiak jokatzea. Sortu soluzioa, ebaluatu eta marraztu
# IDATZI HEMEN (3 kode-lerro)
s = rep(TRUE, n)
problem$evaluate(s)
problem$plot(s)


# Soluzioa: lehen 15 kiroletako partidak jokatu, besteak ez. 
# Sortu soluzioa, ebaluatu eta marraztu
# IDATZI HEMEN (3 kode-lerro)
s = c(rep(TRUE, 15), rep(FALSE, 15))
s
problem$evaluate(s)
problem$plot(s)
problem$valid(s)




# Soluzioa: ausaz aukeratu zein partidu jokatuko diren. 
# Sortu soluzioa, ebaluatu eta marraztu
# IDATZI HEMEN (3 kode-lerro)
s = runif(30)
for (i in 1:length(s)){
  if (s[i] > 0.5) s[i] = TRUE
  else s[i] = FALSE
}
s
problem$evaluate(s)
problem$plot(s)
problem$valid(s)


## Galderak:
# * Zein da soluzioak adierazteko kodeketarik aproposena?
#   
#   [IDATZI HEMEN] 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# * Aukeratu duzun kodeketa horrekin, zenbat soluzio daude bilaketa-espazioan? Nola jakin daiteke soluzio horietako bakoitza bideragarria den?
#   
#   [IDATZI HEMEN] 
# 
# 
# 
# 
# 
# 



# Ikasle batek aldiberean ezin ditu 2 partida jokatu...

# Soluzioa: ausaz aukeratu zein partida jokatuko diren. 
# Egiaztatu soluzioaren bideragarritasuna eta zuzendu
# Ondoren, egiaztatu zuzendutakoaren bideragarritasuna eta ebaluatu 
# IDATZI HEMEN (4 kode-lerro)
s = runif(30) < 0.5
problem$valid(s)
problem$plot(s)
s1 = problem$correct(s)
problem$valid(s1)
problem$plot(s1)










### Galderak

# * Konpara itzazu ausaz sortutako soluzioa eta zuzendu ondoren lortu duzuna. 
# 
# 1) Ausaz sortutako soluzioa. Zein kiroletako partidak jokatzea proposatzen da? 
#   
#   [IDATZI HEMEN] (soluzioa eta jokatzea proposatzen diren partidak zein diren)
# 
# 
# 
# 
# 
# 
# 2) Zuzendutako soluzioa. Zein kiroletako partidak jokatuko dira? Zenbat dira?
#   
#   [IDATZI HEMEN] (soluzioa, jokatuko diren partidak zein diren, partida kopurua)
# 
# 
# 
# 
# 
# 




# 4. Arratsaldeko 5etan zein partida jokatuko dira? Bilaketa lokala

help("basicLocalSearch", package="metaheuR")
help("flipNeighborhood", package="metaheuR")
help("greedySelector", package="metaheuR")
help("firstImprovementSelector", package="metaheuR")
help("cResource", package="metaheuR")

# Hasiera ezazu bideragarria den soluzio bat ausaz
# IDATZI HEMEN  (2 kode-lerro)
s = runif(30) < 0.5
sol = problem$correct(s)




# Sortu soluzio horren ingurunea "bit-flip" edo "irauli" eragilearekin
# IDATZI HEMEN  (Kode-lerro 1)
env <- flipNeighborhood(sol)





# Auzokidea hautatzeko estrategia: irenskorra
# Abiatu bilaketa lokalerako algoritmoa, baliabideak mugatuz
# Erakutsi soluzioa eta helburuaren balioa 
# IDATZI HEMEN (3-4 kode-lerro)
r <- cResource(time=3, evaluations=100, iterations=30)
emaitza <- basicLocalSearch(
  evaluate=problem$evaluate, 
  initial.solution=sol, 
  valid=problem$valid, 
  correct=problem$correct, 
  non.valid='correct', 
  neighborhood = env,
  selector=greedySelector,
  resources=r
 )
getEvaluation(emaitza)



# Auzokidea hautatzeko estrategia: hobetzen duen lehena
# Abiatu bilaketa lokalerako algoritmoa, baliabideak mugatuz
# Erakutsi soluzioa eta helburuaren balioa 
# IDATZI HEMEN (3-4 kode-lerro)
r <- cResource(time=3, evaluations=100, iterations=15)
emaitza <- basicLocalSearch(
  evaluate=problem$evaluate, 
  initial.solution=sol, 
  valid=problem$valid, 
  correct=problem$correct, 
  non.valid='correct', 
  neighborhood = flipNeighborhood(sol),
  selector=firstImprovementSelector,
  resources = r)
getEvaluation(emaitza)






## Galderak:
# * Azal ezazu zertarako diren 'non.valid', 'valid' eta 'correct' parametroak, `basicLocalSearch` funtzioaren laguntza-orria aztertuz. 
# 
# [IDATZI HEMEN] 
# 
# 
# 
# 
# 
# 
# 
# 
# * Inguruneko auzokideak aukeratzeko estrategia desberdinetarako, zein dira lortu dituzun soluzioak? Zein da haien balioa? Konparatu eta esan zein den hoberena (ez ahaztu helburua minimizatzen duela `metaheuR`-ek). 
# 
# [IDATZI HEMEN] 
# 
# 1) Auzokideak aukeratzeko estrategia irenskorra erabiliz:
#   
#  
#   
#   
#   
#   
# 
# 2) Hobetzen duen lehen auzokidea aukeratuz:
#   
#  
#   
#   
#   
#   
#   
# * Orain, bilaketa-prozesurako baliabideak handitzen saia zaitezke. Emaitza hobeak lortzen ditu?
#   
#   [IDATZI HEMEN] 
# 
# 
# 
# 




# 5.- Optimo lokal kopuruaren estimazioa

# "Hobetzen duen lehen auzokidea" estrategiarekin: firstImprovementSelector
# IDATZI HEMEN (kode-lerroak)









# "Estrategia irenskorrarekin": greedySelector
# IDATZI HEMEN (kode-lerroak)






## Galderak:

# * Zein da estimatutako optimo lokal kopurua? Erantzun probatu dituzun bi estrategien kasurako.
# 
# -- Hobetzen duen lehen auzokidea hautatzearen estrategia erabiliz
# 
# [IDATZI HEMEN]
# 
# 
# 
# 
# 
# 
# 
# -- Estrategia irenskorra erabiliz 
# 
# [IDATZI HEMEN]
# 
# 
# 
# 
# 
# 
# 
# 
# * Zure ustez zein da egokiena kasu honetan?
#   
#   [IDATZI HEMEN]
# 
# 
# 
# 
# 
# 
# 
# * Errepika ezazu prozesua hasierako soluzioen kopuru desberdinetarako, $k=10, 15, 20$. Balio oso handiak ez eman $k$-ri, estimazioa egiteko denbora dezente hartzen baitu. Alderik ikusten da?
#   
#   [IDATZI HEMEN] 
# 
# 
