#Packages and library
install.packages("tidyverse")
install.packages("lubridate")
install.packages("naniar")
library(tidyverse)
library(lubridate)
library(janitor)

#Importação do conjunto de dados
hourlySteps <- read_csv("hourlySteps_merged.csv")

#Visualização
head(hourlySteps)
str(hourlySteps)
glimpse(hourlySteps)
head(hourlySteps_clean)
str(hourlySteps_clean)
glimpse(hourlySteps_clean)

#Ajuste no formato da data e duplicatas
hourlySteps_clean <- hourlySteps %>% 
  #Tranformação da data no formato ISO
  mutate(ActivityHour = mdy_hms(ActivityHour)) %>% 
  #Remoção de linhas duplicadas (idênticas)
  distinct()

nrow(hourlySteps)
nrow(hourlySteps_clean)

#Min e Max dos passos
hourlySteps_clean %>% 
  summarize(
    max_steps = max(StepTotal),
    min_steps = min(StepTotal)
  )

#Validação do comprimento de Id
table(nchar(as.character(hourlySteps_clean$Id)))

#Consulta de valores nulos
colSums(is.na(hourlySteps_clean))

#Padronizar para snake_case
hourlySteps_clean <- hourlySteps_clean %>% 
  clean_names()

head(hourlySteps_clean)

#Exportação do csv limpo
write_csv(hourlySteps_clean, "hourlySteps_clean.csv")