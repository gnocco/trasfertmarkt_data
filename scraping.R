install.packages("rvest")

library(rvest)

URL <- "http://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1"
WS <- read_html(URL)
URLs <- WS %>% html_nodes(".hide-for-pad .vereinprofil_tooltip") %>% html_attr("href") %>% as.character()
URLs <- paste0("http://www.transfermarkt.com",URLs)
