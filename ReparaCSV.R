################################################################################
#
#  Corrigir erros de formatação dos arquivos de cotações diárias
#
################################################################################

# Indicando diretório onde estão os arquivos
setwd('C:/Users/Thales/Dropbox/Public/AgriBIsiness/DadosMF/2020')

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