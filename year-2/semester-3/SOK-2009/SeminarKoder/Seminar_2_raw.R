# Seminar 2
### Laster inn nødvendig data fra forrige gang:
rm(list = ls())

library(tidyverse)
library(Ecdat)
data(Bwages)


# Ser på korrelasjonstesten fra forrige gang:
cor.test(Bwages$wage, Bwages$educ)

#Sammenligner med en cor.test mellom wage of exper
cor.test(Bwages$wage, Bwages$exper)

# Educ har høyere korrelasjonskoeffisient enn exper, som impliserer at lønn øker mer med 
# høyere utdanning enn med høyere erfaring (Husk: cor.test gir resultat mellom -1 og 1)

# Men det er mange verdier listet, som t, df, p-value, og confidence interval. 
# De er automatisk laget av cor.test kommandoen, men hva er de faktisk?

# Mål for i dag: Replisere resultatene fra cor.test kommandoen

# Først må vi ha på plass et svært viktig konsept: Standardfeil

#################################################
# Standardfeil

# Brukes til å måle usikkerheten av estimat av en sample populasjon. Forteller oss hvor mye 
# "slingringsmonn" det er rundt et punktestimat. Jo lavere standardfeil, jo mindre usikkerhet

# Viktig: Standard feil forklarer usikkerheten rundt utvalget relativt til den fulle
# populasjonen, ikke nødvendigvis om estimatet selv er "riktig"

# Utregning vil variere basert på hva vi ser på. Begynner med standardfeilen til gjennomsnitt
# SEM = sd / sqrt(n)

# Med formel for høy utdanning:
mean(Bwages$wage[Bwages$educ > 3])
sd_high_educ <- sd(Bwages$wage[Bwages$educ > 3])

sd_high_educ/sqrt(nrow(Bwages))

std.error(Bwages)

#Eksisterer ikke en kommando for SE i base, men finnes pakker der ute som gjør det for deg

###########################################
# Standardfeil til korrelasjonskoeffisienten

### Fra forrige seminar: Utregning av korrelasjonskoeffisient:

### Korrelasjonskoeffisienten
sd_wage <- sd(Bwages$wage)
sd_educ <- sd(Bwages$educ)
cov_waed <- cov(Bwages$wage, Bwages$educ)

cor_waed <- cov_waed / (sd_wage * sd_educ)
cor_waed

# Korrelasjonskoeffisienten kalles for "r". Formelen for standardfeilen er:
# SE(r) = sqrt [ (1-r^2) /  (n-2) ]

se_waed <- sqrt((1-cor_waed^2)/ (nrow(Bwages)-2) )
se_waed

#OPPGAVE: Regn ut standardfeilen til korrelasjonen mellom wage og exper

sd_exper <- sd(Bwages$exper)

cov_waexper <- cov(Bwages$wage, Bwages$exper)

cor_waexp <- cov_waexper / (sd_wage * sd_exper)

se_waexper <- sqrt((1-cor_waexp^2)/ (nrow(Bwages)-2) )
se_waexper

##################################################################
# Frihetsgrad/ Degrees of Freedom (df)
### Er antallet uavhengige variabler som er "fri" til å variere ved tilfeldig trekning
### Formel: n - p,  hvor p = antall parametre/forhold. 
d_f <- nrow(Bwages)-2

####################################################################
# t-verdi
### Måler hvor mange standardfeil estimatet er unna verdien til nullhypotesen. Blir brukt
### svært mye i t-tester som sammenligner gjennomsnitt. Nullhypotesen (H0) er utfallet hvis
### effekten man ser på er antatt å være 0 

# Hvis t = 0, så stemmer nullhypotesen (like gjennomsnitt). Legger ut en link i canvas som 
# forklarer konseptet litt mer presist


# Formel for korrelasjonskoeffisient / t-verdien: r / sqrt[ (1 - r^2) / (n - 2) ]

t_waed <- cor_waed/sqrt((1-cor_waed^2)/(nrow(Bwages)-2))
t_waed


#OPPGAVE: Regn ut t-verdien til korrelasjonen mellom wage og exper
#####

t_waexp <- cor_waexp/sqrt((1-cor_waexp^2)/(nrow(Bwages)-2))
t_waexp

#MERK: Forskjellig utregning for korrelasjonskoeffisient enn for gjennomsnitt


###############################################################
# Konfidensintervall

# Gir oss et intervall med rimelige verdier for et populasjonsparameter: (mean, cor.coeff, 
#regresjonskoeffisienter.)

#Hvorfor bruker vi CI? Siden vi kun ser på en andel av den fulle befolkningen (vårt utvalg/
# sample) er det rimelig å tenke at hvis vi sampler igjen vil verdiene være noe annerledes. 
# Konfidensnivået (feks 95% eller 99%) viser til andelen av ganger estimatet ditt vil være
# innenfor konfidensintervallet hvis vi gjentar samplingen mange ganger.

#Eksempel: Hvis vi har et 95% konfidensintervall, og vi trekker 100 tilfeldige samples, så
# kan vi forvente at 95 av intervallene inneholder populasjonsparameteret

#Vi lager konfidensintervaller stegvis

# Steg 1 og 2: Kalkuler korrelasjonskoeffisienten (r) og standardfeil (SE(r))
#Dette har vi allerede gjort

# Steg 3: Velg konfidensnivå

conf_lvl <- 0.95

# Steg 4: Kalkuler den kritiske t-verdien
### Den kritiske t-verdien kvantifiserer konfidensnivået vi har valgt, sparer oss for formel
### og bruker bare qt-funksjonen

t_crit <- qt((1 + conf_lvl) / 2, df = d_f)


#Steg 5: Kalkuler feilmarginen
### Viser til hvor mye estimatet kan variere
error_margin <- se_waed * t_crit

lower_bound <- cor_waed - error_margin
upper_bound <- cor_waed + error_margin

print(upper_bound)
print(lower_bound)

# Printer cor.test for å sammenligne
cor.test(Bwages$wage, Bwages$educ)
# Og her er konfidensintervallet vårt

#OPPGAVE:  Repliser cor.test for wage&exper ved bruk av formlene ovenfor (p-verdi ekskludert)

error_margin_1 <- se_waexper * t_crit

lower_bound <- cor_waexp - error_margin_1
upper_bound <- cor_waexp + error_margin_1

print(upper_bound)
print(lower_bound)

# Printer cor.test for å sammenligne
cor.test(Bwages$wage, Bwages$exper)

########################################################################
# p-verdi

### p-verdien forteller oss hvor sannsynlig det er at estimatet vårt er et resultat av 
### tilfeldighet. Jo lavere verdi, jo "bedre" er det for at estimatet vårt er signifikant

p <- 2 * (1-pt(abs(t_waed), df = d_f))
p
# Og der var alle verdiene fra cor.test på plass

#########################################################################################

# Kjører en t-test for å se om høy og lav utdanning har forskjellig lønn

### Definerer høy og lav utdanning
high_educ <- subset(Bwages, educ %in% c(4,5))
low_educ <- subset(Bwages, educ %in% c(1,2))



# Kjører kode:
t.test(high_educ$wage, low_educ$wage)


# OPPGAVE: Kjør samme type t-test for wage og exper. Tolk output

### Definerer høy og lav erfaring / experience

high_exp <- subset(Bwages, exper > 24)
low_exp <- subset(Bwages, exper < 9)


# Kjører kode:
t.test(high_exp$wage, low_exp$wage)
