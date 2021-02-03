################################################################################## 
#
# WEB SCRAPING do indicador de Boi Gordo CEPEA/B3 e atualização da série histórica
#
# V.1 (27/09/2020)                                     Dev.: Thales de Lima Silva  
#
##################################################################################

# Obs: Caso tenha problemas com a acentuação, consulte este link:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

rm(list=ls())
setwd("C:/Users/Thales/Dropbox/Repositories/DataCattle/")

# Carregando pacotes
library(rvest) 
library(stringr) 
library(dplyr) 


# Leitura da web page - retorna um documento xml
webpage <- read_html("https://www.cepea.esalq.usp.br/br/indicador/boi-gordo.aspx")

# Tabela de indicador do boi gordo CEPEA/B3
table   <- webpage %>% html_nodes('.imagenet-table-responsiva')

# Extraindo dados da página web para uma lista
results <- str_c(table[1] %>% html_nodes("tbody") %>% html_text(trim = TRUE))
dados <- str_replace_all(results, " +", "")
dados <- strsplit(dados, "\r\n") 

# Selecionado dados e formatando a data
Data  <- as.Date(dados[[1]][1], format = " %d/%m/%Y ")
CEPEA <- dados[[1]][2]

# Criando data.frame com dados selecionados
df <- data.frame(Data, CEPEA)

# Lendo arquivo de dados e corrigindo a formatação
cepea <- read.csv("IndBG_CEPEA.csv", header = T,  sep = ";")
cepea$Data  <- as.Date(cepea$Data, format = " %Y-%m-%d ")

# Incluindo dados coletados ao data.frame
lastdate <- max(cepea$Data)

if (df$Data != lastdate) {
  cepea <- rbind(cepea, df)
}

# Salvando base de dados atualizada
write.table(cepea, "IndBG_CEPEA.csv", row.names = F, col.names = T,
            quote = FALSE, sep = ";")

#### Agendar este script para rodar todos os dias às 19:00hs
