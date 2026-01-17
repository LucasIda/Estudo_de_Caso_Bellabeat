#Packages and library
install.packages("tidyverse")
install.packages("lubridate")
install.packages("naniar")
library(tidyverse)
library(lubridate)
library(janitor)

#Importando o arquivo csv
weightLogInfo <- read_csv("weightLogInfo_merged.csv")

#Ajuste no formato da data
weightLogInfo_clean <- weightLogInfo %>% 
  #Tranformação da data no formato ISO para ingestão no BigQuery
  mutate(Date = mdy_hms(Date)) %>%
  #Remoção de linhas duplicadas (idênticas)
  distinct()
  
#Validar conversão de kg para lbs
df_validation <- weightLogInfo_clean %>% 
  mutate(
    #1 kg aproximado para 2.20462 lbs
    weight_calc = WeightKg * 2.20462,
    #Cálculo da diferença absoluta para evitar problemas com casas decimais
    diff_check = abs(WeightPounds - weight_calc)
  )

conversion_error <- df_validation %>% 
  filter(diff_check > 0.01)

nrow(conversion_error)

#Identificação de outliers
df_outliers <- weightLogInfo_clean %>% 
  summarise(
    max_weight_kg = max(WeightKg),
    min_weight_kg = min(WeightKg),
    max_bmi = max(BMI),
    min_bmi = min(BMI)
  )

head(df_outliers)

#Erro de digitação em IsManualReport
table(weightLogInfo_clean$IsManualReport, useNA = "always")

#Validação de valores nulos
colSums(is.na(weightLogInfo_clean))

#validação do comprimento do Id e LogId
table(nchar(as.character(weightLogInfo_clean$Id)))

table(nchar(as.character(weightLogInfo_clean$LogId)))

#Padronização do nome das colunas para snake_case
weightLogInfo_clean <- weightLogInfo_clean %>% 
  clean_names()

#Exportação do csv limpo
write_csv(weightLogInfo_clean, "weightLogInfo_clean.csv")

#Boxplot
ggplot(weightLogInfo_clean, aes(y = weight_kg)) + 
  geom_boxplot() + 
  labs(title = "Distribuição de Peso")

#Visualização dos dados
head(weightLogInfo_clean)
str(weightLogInfo)

nrow(weightLogInfo)
nrow(weightLogInfo_clean)