#Packages and library
install.packages("tidyverse")
install.packages("lubridate")
install.packages("naniar")
library(tidyverse)
library(lubridate)
library(janitor)

#Importação do conjunto de dados
dailyActivity <- read_csv("dailyActivity_merged.csv")

#Visualização
head(dailyActivity)
str(dailyActivity)
glimpse(dailyActivity)
head(dailyActivity_clean)
str(dailyActivity_clean)
glimpse(dailyActivity_clean)

#Ajuste no formato da data
dailyActivity_clean <- dailyActivity %>% 
  #Tranformaçãod a data no formato ISO
  mutate(ActivityDate = mdy(ActivityDate)) %>% 
  #Remoção de linhas duplicadas (idênticas)
  distinct()

#Validação da distância total
df_validation <- dailyActivity_clean %>% 
  mutate(
    distance_calc = VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance,
    diff_check = abs(TotalDistance - distance_calc)
  )

calculation_error <- df_validation %>% 
  filter(diff_check > 0.1)

nrow(calculation_error)

#Validação do tempo total
df_validation_time <- dailyActivity_clean %>% 
  mutate(
    time_calc = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes,
    diff_time_check = abs(1440 - time_calc)
  )

calculation_time_error <- df_validation_time %>% 
  filter(diff_time_check > 60)

nrow(calculation_time_error)

#Máximo e mínimo de diferença do tempo
df_validation_time %>% 
  summarize(
    max_sum = max(time_calc),
    min_sum = min(time_calc)
  )

#Validação do comprimento de Id
table(nchar(as.character(dailyActivity_clean$Id)))

#Consulta de valores nulos
colSums(is.na(dailyActivity_clean))

#Padronizar para snake_case
dailyActivity_clean <- dailyActivity_clean %>% 
  clean_names()

head(dailyActivity_clean)

#Exportação do csv limpo
write_csv(dailyActivity_clean, "dailyActividy_clean.csv")