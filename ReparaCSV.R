################################################################################
#
#  Corrigir erros de formatação dos arquivos de cotações diárias
#
################################################################################


rm(list=ls())
# Não deixar o R converter automaticamente caracter em fator
options(stringsAsFactors=F) 

# 1. ARQUIVOS DE COTAÇÕES DA SCOT CONSULTORIA ##################################

# Indicando diretório onde estão os arquivos
setwd('C:/Users/Thales/Dropbox/Repositories/DataCattle')

# listando todos os arquivos com extensão .csv
input <- dir(pattern='.csv')
L <- length(input)

# Definindo onde serão gravadas as correções
grava = 'C:/Users/Thales/Dropbox/Public/AgriBIsiness/DadosMF/'

### Lendo arquivos, corrigindo e salvando
dados <- NULL
for (i in 1:L){
  dados[[i]] <- read.csv(input[i], h = F)
  write.table(dados[[i]], file = paste(grava, input[i]), quote = F, 
              row.names = F, col.names = F, sep=";")
  cat(input[i],'\n')
}


# 2. ARQUIVOS DO INDICADOR BOI GORDO CEPEA/B3 ##################################

# Indicando diretório onde estão os arquivos
setwd('C:/Users/Thales/Dropbox/Repositories/DataCattle')

# Lendo arquivo e visualizando dados
dados <- read.csv("CEPEA.csv", header = FALSE, col.names = c("Data", "Valor"), 
                  sep = ",", dec = ".")
head(dados)
str(dados)

# Corrigindo formatação
dados$Data  <- as.Date(dados$Data, format = " %d/%m/%Y ")
dados$Valor <- as.character(dados$Valor)

dados$Valor <- str_replace(dados$Valor, "\\.", "\\,")
head(dados)
str(dados)

# Salvando arquivo .csv
write.table(dados, file = "IndBG_CEPEA.csv", quote = F, row.names = F, 
            col.names = T, sep=";")