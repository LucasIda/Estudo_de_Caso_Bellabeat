#Packages and library
install.packages("tidyverse")
install.packages("lubridate")
install.packages("naniar")
library(tidyverse)
library(lubridate)
library(janitor)

#Importação do conjunto de dados
sleepDay <- read_csv("sleepDay_merged.csv")

#Visualização
head(sleepDay)
str(sleepDay)
glimpse(sleepDay)
head(sleepDay_clean)
str(sleepDay_clean)
glimpse(sleepDay_clean)

#Ajuste no formato da data e duplicatas
sleepDay_clean <- sleepDay %>% 
  #Tranformaçãod a data no formato ISO
  mutate(SleepDay = mdy_hms(SleepDay)) %>% 
  #Remoção de linhas duplicadas (idênticas)
  distinct()

nrow(sleepDay)
nrow(sleepDay_clean)

#Validar se timeInBed é maior que totalAsleep
df_validation_sleep <- sleepDay_clean %>% 
  mutate(
    sleep_dif = TotalTimeInBed - TotalMinutesAsleep
  )

sleep_time_validation <- df_validation_sleep %>% 
  filter(sleep_dif < 0)

nrow(sleep_time_validation)

#Max e Min do tempo de sono
sleepDay_clean %>% 
  summarize(
    max_sleep = max(TotalMinutesAsleep),
    min_sleep = min(TotalMinutesAsleep),
    max_bed = max(TotalTimeInBed),
    min_bed = min(TotalTimeInBed)
  )

#Validar comprimento do Id
table(nchar(as.character(sleepDay_clean$Id)))

#Consultar valores nulos
colSums(is.na(sleepDay_clean))

#Padronizar para snake_case
sleepDay_clean <- sleepDay_clean %>% 
  clean_names()

head(sleepDay_clean)