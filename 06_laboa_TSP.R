# Ikerketa Operatiboa 
# 6. Laboratorio-saioa: Optimizazio Heuristikoa `metaheuR` erabiliz
# (TSP problema)

# 1. `metaheuR` paketearen instalazioa

getwd() # laneko karpeta zein den jakiteko
# setwd("/home/ana/IO/laboak/06_07_laboak_metaheuR/06_metaheuR_laboa_sarrera_TSP") # zurea jarri
# setwd("C:/Users/ehu/Desktop/IO_laboak/06_metaheuR_laboa_sarrera_TSP") # zurea jarri

# fakultateko laboratorioan ggplot2 instalatuta egon daiteke.
# zure ordenadorean ez badago, exekutatu agindu hau:
# install.packages("ggplot2", dependencies=TRUE) # # Denbora behar du... Minutuak... 

# eGelatik jaitsi duzun metaheuR_0.3.tar.gz fitxategia laneko karpeta berean eduki 
# behar duzu. Berehala instalatzen da agindu honekin:
install.packages("metaheuR_0.3.tar.gz", repos = NULL, type="source")  
library(metaheuR) # paketea kargatzeko

# Paketea instalatu eta kargatu ondoren, RStudioren "Paketeak" atalera joan eta 
# `metaheuR` paketearen izenaren gainean klik egin dezakezu, bertan definitutako 
# funtzio guztien laguntza-orriak ikusteko.


#-----------------------------------
# 2. Saltzailearen problema (TSP, Travelling Salesperson Problem)

## Problemaren definizioa RStudio-n

rm(list=ls())
# Matrize objektua sortu n=20 hiriko distantzien matrize baterako
cost.matrix <- matrix(c(0, 85, 72,  7, 49, 46, 87, 58, 17, 68, 27, 21,  6, 67, 
                        26, 82, 44, 35,  3, 62,
                        85,  0,  8, 51,  1, 91, 39, 87, 72, 45, 96,  7, 87, 68, 33,  3, 21, 90, 45, 47,
                        72,  8,  0, 25, 30, 43, 97, 33, 35, 61, 42, 36, 43,  7, 84,  6,  0,  0, 48, 62,
                        7, 51, 25,  0, 59, 29, 94, 82, 29,  3,  3, 51, 67, 39, 15, 66, 42, 23, 62, 62,
                        49,  1, 30, 59,  0, 28, 76, 66, 82, 98, 35, 15, 17, 77, 44, 26, 76, 86, 60, 62,
                        46, 91, 43, 29, 28,  0, 62, 83, 91, 57, 62, 36,  2,  2, 43, 65, 37, 49, 61,  5,
                        87, 39, 97, 94, 76, 62,  0, 34, 53, 96, 82, 48, 28, 31, 75,  1, 95,  7, 92, 69,
                        58, 87, 33, 82, 66, 83, 34,  0, 62, 32, 97,  5, 39, 50, 82, 93, 71, 35, 14, 20,
                        17, 72, 35, 29, 82, 91, 53, 62,  0, 74, 49, 50, 37, 79, 19, 51, 70, 42, 26, 79,
                        68, 45, 61,  3, 98, 57, 96, 32, 74,  0, 98, 60, 35,  9, 96, 70, 21, 37, 37, 67,
                        27, 96, 42,  3, 35, 62, 82, 97, 49, 98,  0, 93, 93, 39,  2, 52, 26, 90, 26,  1,
                        21,  7, 36, 51, 15, 36, 48,  5, 50, 60, 93,  0, 68, 93,  7, 94, 19, 54, 37,  0,
                        6, 87, 43, 67, 17,  2, 28, 39, 37, 35, 93, 68,  0, 20, 12, 11, 66, 84, 80,  1,
                        67, 68,  7, 39, 77,  2, 31, 50, 79,  9, 39, 93, 20,  0, 55,  9, 21, 12, 65,  7,
                        26, 33, 84, 15, 44, 43, 75, 82, 19, 96,  2,  7, 12, 55,  0, 17, 51, 84, 87,  2,
                        82,  3,  6, 66, 26, 65,  1, 93, 51, 70, 52, 94, 11,  9, 17,  0, 27, 82, 71, 71,
                        44, 21,  0, 42, 76, 37, 95, 71, 70, 21, 26, 19, 66, 21, 51, 27,  0, 40, 93, 27,
                        35, 90,  0, 23, 86, 49,  7, 35, 42, 37, 90, 54, 84, 12, 84, 82, 40,  0, 93, 92,
                        3, 45, 48, 62, 60, 61, 92, 14, 26, 37, 26, 37, 80, 65, 87, 71, 93, 93,  0, 34,
                        62, 47, 62, 62, 62,  5, 69, 20, 79, 67,  1,  0,  1,  7,  2, 71, 27, 92, 34,  0),
                      nrow=20, byrow=TRUE)

city.names<-c("C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13",
              "C14","C15","C16","C17","C18","C19","C20")
colnames(cost.matrix)<-city.names
rownames(cost.matrix)<-city.names
cost.matrix

#-----------------------------------------
# Datuak irakurri ins20a.tsp fitxategitik eta matrize objektua sortu 
# IDATZI HEMEN (3-4 kode-lerro)

fitx = scan("ins20a.tsp")
fitx

m = matrix(fitx, ncol=20)
m

tsp.problem = tspProblem(m)

identityPermutation(20)



#----------------------------------
# 3. Optimizazio Heuristikorako elementuen definizioa

## Galderak:

# * "Swap" eragileak osotasuna (integritatea) bermatzen du? Eta, konexutasuna 
# (connectivity)?
# IDATZI HEMEN 
# TSP problemarako soluzioak permutazioen bidez adieraziko ditugu.
# Permutazio honetan swap bat egitea da bi balio trukatzea. Horrekin, ibilaldia pixka bat aldatzen da. Truke posible
# guztiekin adierazi ditzakegu soluzio posible guztiak. 
# 20 hirirekin 20! permutazio posible daude, hau da 20! ibilaldi posible
# Zein eta hiri gehiago izan, truke batek orduan eta gutxiago aldatuko du bidaiaren hibilbidea
# Antzekoak direla ontzat emango dugu eta eragile horren bidez ingurunea sortuko dugu (neighborhood)






# * 20 hiriko TSP problema batean, zenbat soluzio daude bilaketa-espazioan?
# IDATZI HEMEN 










# * "Swap" eragilearen bidez kalkulatutako auzokideak (neighbor solution) antzekoak 
# al dira?
# IDATZI HEMEN 











#------------------------------------
# 4. Problemaren ebazpena metaheuR erabiliz

help("tspProblem", package="metaheuR")

# TSP objektua sortu
# IDATZI HEMEN (kode-lerro 1)
tsp.problem = tspProblem(m)


# Sortu ausaz bi soluzio
# IDATZI HEMEN (2 kode-lerro)
tsp.problem




# Sortu (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) permutazioa
# IDATZI HEMEN (kode-lerro 1)






# Kalkulatu hiru soluzioen kostua
# IDATZI HEMEN (3 kode-lerro)






# Begiratu ebaluaziorako funtzioaren kodea
# IDATZI HEMEN (kode-lerro 1)







# ## Galderak:
# * Zein bi soluzio sortu dira ausaz? Zein dira hiru soluzioen kostuak? Zein da onena?
# IDATZI HEMEN 






# * Posiblea da TSP problema ebaztea simplex algoritmoaren edo adarkatze- eta 
# bornatze-algoritmoaren moduko metodo determinista bat erabiliz?  Erantzuna 
# aurkitzeko, begira ezazu "A Survey on Travelling Salesman Problem" (2010) 
# artikulua https://www.semanticscholar.org/ webgunean bilatuz edo 
# "An Application of the Hungarian Algorithm to Solve Traveling Salesman Problem" 
# artikulua https://www.scirp.org/ webgunea arakatuz edo beste informazio-iturriren bat.
# IDATZI HEMEN 







#-------------------------------------------

# 5. Algoritmo eraikitzaileak ("Greedy" edo "Irenskorrak")

# Ebatzi TSP problema algoritmo eraikitzaile bat erabiliz
# Erakutsi aurkitutako soluzio hurbila eta kalkulatu haren kostua
# IDATZI HEMEN (3 kode-lerro)







# Begiratu funtzioaren inplementazioa
# IDATZI HEMEN (kode-lerro 1)




# Begiratu RStudio-ren laguntza-orria greedySelector funtzioari buruz
# IDATZI HEMEN (kode-lerro 1)





## Galderak:
# * Zein da algoritmo irenskorrak aurkitutako hurbilketa-soluzioa? Zein hiritan hasten da
# ibilbidea?
# IDATZI HEMEN 





# * Exekuta ezazu algoritmo irenskorra behin eta berriz. Soluzio bera lortzen duzu beti? 
# Zergatik? Begira ezazu funtzioaren inplementazioa arrazoia ulertzeko.
# IDATZI HEMEN 







# * Algoritmo irenskorrak aurkitutako soluzioa aurreko atalean aztertu ditugun hirurak 
# baino hobea da? Optimoa dela esan dezakegu?
# IDATZI HEMEN 




#   * `metaheuR` paketean bada algoritmo irenskorrekin erlazionatutako beste funtzio 
# interesgarri bat: `greedySelector`. Begira ezazu RStudio-ren laguntza-orrietan ea 
# zer dioen funtzio horri buruz. 



#-----------------------------------------------

# 6. Bilaketa lokala

# IDATZI HEMEN (2 kode-lerro)







# Erakutsi soluzioa eta helburuaren balioa 
# IDATZI HEMEN (2-3 kode-lerro)








## Galderak:
# * Bidaiariaren probleman zer dira "non valid" edo balio ez duten soluzioak?
# IDATZI HEMEN 







# * Bilaketa lokalerako algoritmoarekin aurkitutako soluzioa aurreko ataletan 
# aztertutakoak baino hobea da?  
# IDATZI HEMEN 





#   * Bilaketarekin segi eta soluzio hobe bat aurkitzea posiblea da? Edo, aurkitu den 
# soluzioa optimo globala da? 
# IDATZI HEMEN 






# * Alda ezazu hasierako soluzioa eta abia ezazu berriz bilaketa lokalerako algoritmoa. 
# Aurreko ataletan lortutako soluzioren bat erabil dezakezu hasierako soluzio moduan, 
# adibidez. Soluzio berberera iristen da algoritmoa? Zergatik?
# IDATZI HEMEN 

