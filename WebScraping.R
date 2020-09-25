################################################################################## 
#
# WEB SCRAPING para cotações diárias do preço da @ de Boi Gordo no mercado físico
# de 32 praças brasileiras
#
# V.1 (15/08/2020)                                     Dev.: Thales de Lima Silva  
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
webpage<- read_html("https://www.scotconsultoria.com.br/cotacoes/boi-gordo/?ref=smnb")


# Extraindo a data da cotação
node_data <- webpage %>% html_nodes('.conteudo_centro')
data_suja <- node_data %>% html_node("th") %>% html_text(trim = TRUE)
data_list <- c(strsplit(data_suja[1], "-"))
data      <- as.Date(data_list[[1]][2], format = " %d/%m/%Y ")

# Extraindo os registros
results <- webpage %>% html_nodes('.conteudo')

# Construindo o dataset
records <- vector("list", length = length(results))

for (i in seq_along(results)) {
  date  <- data
  praca <- str_sub(xml_contents(results[i])[1] %>% html_text(trim = TRUE))
  preco <- str_sub(xml_contents(results[i])[3] %>% html_text(trim = TRUE))
  #preco <- str_replace(preco, "\\,", ".")
  records[[i]] <- tibble(Data = date, Praca = praca, Preco = preco)
}

# Dataset final
df <- bind_rows(records)
df

# Criando nome e endereço do arquivo para exportar
nome_data <- as.character(data)
nome_data <- str_replace_all(nome_data, "\\-", "")
nome_arquivo <- str_c(nome_data, " MFBG", ".csv", sep = "")
cotacao <- paste("C:/Users/Thales/Dropbox/Repositories/DataCattle/",
                 nome_arquivo, sep = "")

#==============================================================================
# Exportando para CSV "apenas" se não huver cotação na mesma data             #
#==============================================================================

filenames<-dir(pattern="*.csv")

for (k in filenames) {
  if (k != nome_arquivo) {
    write.table(df[,-1], file = cotacao, row.names = F, col.names = F, 
                quote = FALSE, sep = ";")

    #==========================================================================
    # Enviar email com o resultado da coleta de dados                         #
    #==========================================================================
    
    library(gmailr)
    
    gm_auth_configure(path = "C:/Users/Thales/Dropbox/Repositories/DataCattle/credentials.json")
    gm_auth(email = "medvet21@gmail.com")
    
    email <- gm_mime() %>%
      gm_to("medvet21@gmail.com") %>%
      gm_from("medvet21@gmail.com") %>%
      gm_subject(paste("Cotação do Boi Gordo", data)) %>%
      gm_text_body("Tomada de preços do mercado físico realizada com sucesso!")
    
    # Enviando email
    gm_send_message(email)
    
  }
}


#### Agendar este script para rodar todos os dias
