################################################################################## 
#
# WEB SCRAPING para ajustes do pregão de Boi Gordo na B3
#
# V.1 (Jan./2021)                                     Dev.: Thales de Lima Silva  
#
##################################################################################

# Obs: Caso tenha problemas com a acentuação, consulte este link:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

rm(list=ls())
setwd("C:/Users/Thales/Dropbox/Repositories/DataCattle/")

# Carregando pacotes
library(rvest) 
#library(stringr) 
library(dplyr) 


# Inserindo a URL alvo - Austes Derivativos - Pregao
url <- 'http://www2.bmf.com.br/pages/portal/bmfbovespa/lumis/lum-ajustes-do-pregao-ptBR.asp'

# Lendo código HTML da URL indicada
site <- read_html(url)

# Escolhendo os elementos HTML para coletar - resultado em HTML
info_Ajuste_HTML <- html_nodes(site,'table')
date_HTML <- html_nodes(site, 'div.large-9.medium-4.columns')

# Melhorando a visualização e captura dos objetos
lista_tabela <- site %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)

date_txt <- html_text(date_HTML, trim = TRUE)
date_txt <- strsplit(date_txt, "\r\n")

# Atribuições do preço de ajuste e data
ajuste <- lista_tabela[[1]]
bgi <- ajuste[28:38,]
ajuste_atual <- bgi[1,4]

date_list <- c(strsplit(date_txt[[1]], " "))
date_ajt <- as.Date(date_list[[1]][3], format = " %d/%m/%Y ")

# Criando data.frame com dados selecionados
df <- data.frame(date_ajt, ajuste_atual)
df <- df %>% rename(Data = date_ajt) %>% rename(Ajuste = ajuste_atual)

# Lendo arquivo de dados e corrigindo a formataçãoo
bgi_close <- read.csv("BGI_Fut.csv", header = T,  sep = ";",
                      col.names = c("Data", "Ajuste"))
bgi_close1 <- bgi_close %>%
  mutate(Data = as.Date(Data, format = " %Y-%m-%d ")) %>%
  arrange(Data)

# Incluindo dados coletados ao data.frame
lastdate <- max(bgi_close1$Data)
lastdate

if (df$Data != lastdate) {
  bgi_close1 <- rbind(bgi_close1, df)
  # Salvando base de dados atualizada
  write.table(bgi_close1, "BGI_Fut.csv", row.names = F, col.names = T,
              quote = FALSE, sep = ";")
} else {
  print("Nao houve atualizacao")
}


#### Agendar este script para rodar todos os dias
