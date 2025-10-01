rm(list=ls())

library(tidyverse)

#Laster inn data
install.packages("Ecdat")
library(Ecdat)
data(Bwages)

#Data inneholder observasjoner om lønn opgitt i Euro (wage), antall år med
#erfaring (exper), og utdanningsnivå fra 1(low) til 5(high) (educ)

#Lager en enkel vektor med 10 observasjoner
x <- c(12, 15, 18, 20, 22, 25, 28, 30, 33, 135)

#Gjennomsnitt########################################################
##Med formel

mean_x_formel <- sum(x)/length(x)
mean_x_formel


##Med kommando

mean(x)


##OPPGAVE: Bruk data Bwages, finn gjennomsnittlig lønn

#####
mean_wages <- mean(Bwages$wage)
mean_wages
#####

##OPPGAVE: Finn gjennomsnittlig utdanningsnivå og erfaring

#####
mean_educ <- mean(Bwages$educ)
mean_educ

mean_exper <- mean(Bwages$exper)
mean_exper
#####

##Hvorfor er det/er det ikke hensiktsmessig å bruke disse målene?

#Median####################################################################
##Ikke hensiktsmessig å bruke formel, men viser den for å illustrere

#Sorter vektoren i økende rekkefølge
sorted_x <- sort(x)

#Formel
n <- length(sorted_x)
if (n %% 2 == 1) {
  median_manual <- sorted_x[(n + 1) / 2]
} else {
  median_manual <- (sorted_x[n / 2] + sorted_x[(n / 2) + 1]) / 2
}

print(median_manual)

#Median for vektor
median(x)

#Median for lønn, utdanning og erfaring

###Individuelt
median(Bwages$wage)
median(Bwages$educ)
median(Bwages$exper)

###Samtidig
mediansx <- sapply(Bwages[, c("wage", "educ", "exper")], median)
print(mediansx)

#Kan gjøre det samme med Mean for å forkorte prosessen
meansx <- sapply(Bwages[, c("wage", "educ", "exper")], mean)
print(meansx)



##############################################################
#Sannsynlighet

### Terning Eksempel

# Mulige utfall for en terning
terning <- 6

# Mulige utfall for to terninger
toterning <- expand.grid(1:terning, 1:terning)

# Summen av hver kombinasjon
sums <- rowSums(toterning)

# Kalkuler sannsynligheten for hver sum
prob <- table(sums) / length(sums)

# Lager en dataframe med summene og sannsynlighetene
prob.dist <- data.frame(sums = as.integer(names(prob)),
                        prob = as.numeric(prob))

# Enkel graf
ggplot(prob.dist, aes(x = sums, y = prob)) +
  geom_col() +
  scale_x_continuous(breaks = seq(2, 12, by = 1), 
                     labels = seq(2, 12, by = 1))


# Sannsynlighet for at terningene blir 7, mer enn 9, og mindre enn 6
prob.dist$prob[prob.dist$sums == 7]

sum(prob.dist$prob[prob.dist$sums > 9])

sum(prob.dist$prob[prob.dist$sums < 6])

# Bruker data
### Sannsynlighet for at lønn er høyere enn 10

sum(Bwages$wage > 10) / nrow(Bwages)

mean(Bwages$wage > 10)
### Sannsynlighet for lønn over 25 gitt utdanning under 3
sum(Bwages$wage > 25 & Bwages$educ < 3) / nrow(Bwages)

sum(Bwages$wage > 25 & Bwages$educ <= 3) / nrow(Bwages)

### Sannsynlighet for lønn under 25 gitt år med erfaring over 10
sum(Bwages$wage < 25 & Bwages$exper > 10) / nrow(Bwages)

mean(Bwages$wage < 25 & Bwages$exper > 10)


### OPPGAVE: kalkuler sannsynligheten for å ha lønn høyere enn gjennomsnittet når 
  # antall år med erfaring er mindre enn 20, og utdanning over 3
#####
mean(Bwages$wage > mean_wages & Bwages$exper < 20 & Bwages$educ > 3)
#####

####################################################
# Forventet verdi
# Forventet verdi E[X] = sum(x * P(X = x))
# 
###Terning
prob.dist <- prob.dist %>% mutate(sumprob = sums*prob)
sum(prob.dist$sumprob)

# Husk denne koden fra tidligere
sum(prob.dist$prob[prob.dist$sums > 9])

# Bruker det "motsatte" for forventning i datasettet vårt
### forventet lønn for utdanningsnivå 3
mean(Bwages$wage[Bwages$educ == 3])

### Forventet lønn når antall år med erfaring er mindre enn 10
mean(Bwages$wage[Bwages$exper < 10])

### Kan brukes til å undersøke andre forhold
  #Forventet antall år med erfaring når utdanningsnivå høyere eller lik 4
mean(Bwages$exper[Bwages$educ >= 4])



#OPPGAVE: Hva er forventet lønn når:
  #1: Utdanningsnivå er mindre enn 3 og erfaring mindre enn 10?

  #2: Utdanning er høyere enn 4, erfaring mindre enn 5?
#####
mean(Bwages$wage[Bwages$educ < 3 & Bwages$exper < 10])

mean(Bwages$wage[Bwages$educ > 4 & Bwages$exper < 5])
#####

# Varians (var)
###Forklarer spredningen i datasettet, altså hvor mye observasjonene unnviker fra gjennomsnitt

###Formel
sum((Bwages$wage - mean(Bwages$wage))^2) / (length(Bwages$wage) - 1)

### Med kode
var(Bwages$wage)

#Gjør det samme for exper og educ
var(Bwages$educ)
var(Bwages$exper)


# Kovarians (cov)
### Lar oss se om verdiene til en variabel øker/faller når en annen variabel øker/faller.
#Kan derfor brukes til å sjekke forholdet mellom to variabler. Dersom cov > 0 så "beveger"
#variablene seg i samme retning. Dersom negativ => motsatt retning. Dersom = 0, ingen* 
#forhold mellom variablene      *(ingen lineære forhold)

### Formel
sum((Bwages$wage - mean(Bwages$wage)) * (Bwages$educ - mean(Bwages$educ)))/(
  length(Bwages$wage-1))

### Med kode
cov(Bwages$wage, Bwages$educ)

#Små forskjeller siden cov() koden er mer komplisert/korrekt, generelt sett bedre å bruke


# OPPGAVE: Sjekke kovarians til wage-exper og educ-exper. Forklar hva resultatene kan bety
#####

cov(Bwages$wage, Bwages$exper)
#Positiv kovarians, lønn øker med mer erfaring

cov(Bwages$exper, Bwages$educ)
# Negativ kovarians, men hvorfor?
#####

#Kan røpe, utdanning spiller større rolle enn erfaring for lønn. Hvorfor blir ikke dette 
#gjenspeilet av kovariansen?

#Svar: Skala (størrelse) på verdiene påvirker svaret, massevis av ting å ta hensyn til


# Standardavvik 
### Kvadratroten av variansen, viser avvik fra gjennomsnitt i sin originale enhet. Hvis vi
# måler med meter, og får sd = 5, så er da de fleste* observasjonene innenfor 5 meter fra
#gjennomsnittet

### Med formel
sqrt(sum((Bwages$wage - mean(Bwages$wage))^2) / (length(Bwages$wage) - 1))

### Med kode
sd(Bwages$wage)

#Standardavvik for exper og educ

sd(Bwages$educ)

sd(Bwages$exper)

# Akkurat som varians, sensitiv for høye ekstremverdier, men til mindre grad pga kvd.rot

#Grafisk illustrasjon

mean_value <- mean(prob.dist$sums)
std_dev <- sd(prob.dist$sums)


p <- ggplot(prob.dist, aes(x = sums, y = prob)) +
  geom_smooth(method = "loess", se = FALSE, color = "blue", size = 1) +
  geom_vline(xintercept = mean_value, color = "red", linetype = "solid", size = 1) +
  geom_vline(xintercept = mean_value + std_dev, color = "black", linetype = "dotted", size = 1) +
  geom_vline(xintercept = mean_value - std_dev, color = "black", linetype = "dotted", size = 1) +
  labs(x = "Sum", y = "Probability", title = "Probability Distribution of Two Dice Rolls") +
  theme_minimal() + scale_x_continuous(breaks = seq(2, 12, by = 1), 
                                       labels = seq(2, 12, by = 1))

p

p + geom_col(aes(x = sums, y = prob), fill = "blue", alpha = 0.4)


# Gjør det samme for lønnsnivåer
mean_wage <- mean(Bwages$wage)
std_dev_wage <- sd(Bwages$wage)
std_dev_wage
p <- ggplot(Bwages, aes(x = wage)) +
  geom_density(fill = "blue", alpha = 0.6) +
  geom_vline(xintercept = mean_wage, color = "red", linetype = "solid", size = 1) +
  geom_vline(xintercept = mean_wage + std_dev_wage, color = "black", linetype = "dotted", size = 1) +
  geom_vline(xintercept = mean_wage - std_dev_wage, color = "black", linetype = "dotted", size = 1) +
  labs(x = "Wage", y = "Density", title = "Wage Distribution") +
  theme_minimal()

print(p)


# Korrelasjon
### Veldig likt kovarians, men med noen viktige forskjeller. Fra -1 til 1, standardisert
#så er veldig greit å sammenligne. Ikke påvirket av skala-forskjeller (til samme grad). 

# Gjør det med formel
### Korrelasjonskoeffisienten
sdwage <- sd(Bwages$wage)
sdeduc <- sd(Bwages$educ)
covwaed <- cov(Bwages$wage, Bwages$educ)

corwaed <- covwaed / (sdwage * sdeduc)
corwaed

# Med kode
cor.test(Bwages$wage, Bwages$educ)


# Neste gang: Standardfeil, t-verdi, p-verdi, konfidensintervaller, hypotesetesting, hva
# nå enn annet som passer inn

#Basic regresjon for de som er interessert, hvordan wage blir påvirket av både exper
#og educ
reg <- lm(data = Bwages, wage ~ exper + educ)
summary(reg)







