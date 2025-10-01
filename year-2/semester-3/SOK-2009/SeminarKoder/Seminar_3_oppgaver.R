rm(list = ls())

library(tidyverse)
data(swiss)


#OPPGAVE 1a: Kalkuler gjennomsnitt, median, og standardavviket til "Fertility"
mean(swiss$Fertility)
median(swiss$Fertility)
sd(swiss$Fertility)

#OPPGAVE 1b: Vis fordelingen av observasjonsverdier til "Fertility" (hint: histogram)

library(readr)
library(tidyverse)
data <- read_delim("C:/Users/danie/Downloads/data.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
data %>%
  filter(Landsdel == 4) %>%
ggplot(aes(x=Kartlegging))+
geom_histogram(binwidth=15)

df_data <- data %>%
  filter(Landsdel ==2)

reg <- lm(formula = Studietid ~Landsdel, data = df_data)
reg
df_data %>%
  ggplot()+
  geom_qq(aes(sample = rstandard(reg)))+
  geom_abline(color = "red")



hist(swiss$Fertility, main="Histogram of Fertility", xlab="Fertility", col="lightblue", border="black", breaks = 20, xlim = c(30,100))

#OPPGAVE 1c: Lag et scatterplot med "Fertility" på x-aksen og en valgfri* variabel
#på y-aksen. Kan du innhente noe informasjon fra denne grafiske fremstillingen?
# *(Ikke velg "Education")

swiss %>%
  ggplot(aes(x=Fertility, y= Infant.Mortality))+
  geom_point(size = 2, color ="cornflowerblue")

# Ser ut som at høyere fertilitetsrate betyr at man har høyere barnedødlighet

#####################################################################################


#OPPGAVE 2a: Undersøk forholdet (korrelasjonen) mellom "Fertility" og "Education"
# Forklar kort hva resultatene betyr, hvor mye av variasjonen i "Fertility" som kan
#bli forklart av "Education" (r^2), og hvilke konklusjoner som kan bli trukket
r<-cor(swiss$Fertility, swiss$Education)
cor.test(swiss$Fertility, swiss$Education)
r
r_2<- r^2
r_2
#Koeffisienten av determinasjon r^2 er ca. 0.44. Dette betyr at omtrent 44% av variasjonen i "Fertility" kan forklares av Education.

#OPPGAVE 2b: Gjenta opgave 2a, men bytt ut "Education" med variabelen du valgte i 
#oppgave 1c. Er resultatene likt resonnementet fra den grafiske tolkningen din?
r_igjen <- cor(swiss$Fertility, swiss$Infant.Mortality)
r_igjen
r_2_2 <- r_igjen^2
r_2_2
# 41% av Variasjonen i fertility kan forklares av Infant.Mortality lmao
##############################################################################
#Dere skal nå gjøre en rekke hypotesetester. Test hypotesene, og rapporter 
#hvorvidt resultatet er signifikant eller ikke

#OPPGAVE 3a: Test hypotesen: Det er forskjeller i fødselsraten mellom
#provinser hvor mer enn 70% av befolkningen er katolikker

high_catch <- subset(swiss, Catholic > 70)
low_catch <- subset(swiss, Catholic <= 70)
t.test(high_catch$Fertility, low_catch$Fertility)


#OPPGAVE 3b: Test hypotesen: Provinser med utdanning over gjennomsnittet har
# en lavere andel av befolkningen som jobber med jordbruk enn provinser med
#utdanning under gjennomsnittet (hint: alternative = "less")

#Formuler nullhypotesen med ord

mean_education <- mean(swiss$Education)
above_avg_edu <- swiss[swiss$Education > mean_education, ]
below_avg_edu <- swiss[swiss$Education <= mean_education, ]

t.test(above_avg_edu$Agriculture, below_avg_edu$Agriculture, alternative = "less")

# "Det er ingen statistisk signifikant forskjell i gjennomsnittlig andel av befolkningen som jobber med jordbruk mellom de to gruppene av provinser (de med utdanning over gjennomsnittet og de med utdanning under eller lik gjennomsnittet)."

# Den alternative hypotesen, som ble testet og støttet i det foregående resultatet, er at provinser med utdanning over gjennomsnittet har en lavere andel av befolkningen som jobber med jordbruk enn provinser med utdanning under gjennomsnittet.

#OPPGAVE 3c: Test følgende hypotese: Provinser med høy Education har lavere
# Infant.Mortality 

cor.test(swiss$Education, swiss$Infant.Mortality)

#OPPGAVE 3d: Formuler en hypotese, og test den

#Dunno tror ikke æ orke

################################################################################

#Regresjon

#OPPGAVE 4a: Gjennomfør en enkel lineær regresjon mellom to variabler (du kan 
# variablene du brukte oppgave 1c hvis du vil)

model <- lm(Fertility ~ Infant.Mortality, swiss)
summary(model)


#Oppgave 4b: Lag et scatterplot med verdiene fra regresjonen, legg til en 
# regresjonslinje på grafen (Hint: geom_smooth)

swiss %>%
  ggplot(aes(x=Fertility, y= Infant.Mortality))+
  geom_point(size = 2, color ="cornflowerblue")+
  geom_smooth(method ="lm")
