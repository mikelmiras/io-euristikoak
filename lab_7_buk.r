rm(list=ls())
setwd("C:/Users/Mikel/Downloads")
getwd()
install.packages("ggplot2", dependencies = TRUE)
install.packages("metaheuR_0.3.tar.gz", repos = NULL, type="source")
library(igraph)
help("metaheuR")

erpinkop = 30

graph <- random.graph.game(erpinkop, p=0.05)
plot(graph)

problem <- misProblem(graph)

sol <- rep(1, 30)

# Guztiak jokatu
problem$evaluate(sol)
problem$plot(sol)

# 15 jokatu
sol <- rep(1, 15)
sol <- c(sol, rep(0,15))

problem$evaluate(sol)
problem$plot(sol)

# Ausaz
c = runif(30, min=0, max=1) > 0.5 
problem$evaluate(sol)
problem$plot(sol)


# Ausaz eta zuzendu
sol <- problem$correct(sol)
problem$evaluate(sol)
problem$plot(sol)

# bit-flip selector

sol <- runif(30) > 0.5
sol
problem$valid(sol)
sol = problem$correct(sol)
problem$valid(sol)

environment <- flipNeighborhood(sol)

r <- cResource(time=10, evaluations = 90000, iterations = 3000)

# Greedy selector

emaitza <- basicLocalSearch(
  evaluate = problem$evaluate, 
  initial.solution = sol,
  neighborhood = environment,
  selector = greedySelector,
  non.valid = 'correct',
  valid=problem$valid,
  resources = r
)

getEvaluation(emaitza)




emaitza <- basicLocalSearch(
  evaluate = problem$evaluate, 
  initial.solution = sol,
  neighborhood = environment,
  selector = firstImprovementSelector,
  non.valid = 'correct',
  valid=problem$valid,
  resources = r
)

getEvaluation(emaitza)


# Estimazioa

iterations = 10
list = rep(1, 10)


for (i in 1:iterations){
  s = runif(30) < 0.5
  sol = problem$correct(s)
  emaitza <- basicLocalSearch(
    evaluate=problem$evaluate, 
    initial.solution=sol, 
    valid=problem$valid, 
    correct=problem$correct, 
    non.valid='correct', 
    neighborhood = flipNeighborhood(sol),
    selector=firstImprovementSelector,
    resources = r)
  list[i] = getEvaluation(emaitza)
}

list
length(unique(list))




list = rep(1, 10)


for (i in 1:iterations){
  s = runif(30) < 0.5
  sol = problem$correct(s)
  emaitza <- basicLocalSearch(
    evaluate=problem$evaluate, 
    initial.solution=sol, 
    valid=problem$valid, 
    correct=problem$correct, 
    non.valid='correct', 
    neighborhood = flipNeighborhood(sol),
    selector=greedySelector,
    resources = r)
  list[i] = getEvaluation(emaitza)
}

list
length(unique(list))
