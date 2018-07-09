#install.packages("rvest")

library(rvest)

Leagues <- c("IT1","L1","ES1","GB1","FR1")

Catcher2 <- data.frame(
  Player=character(),
  MarketValue=character(),
  Age=character(),
  Contract=character(),
  CurrentTeam=character(),
  Position=character(),
  Nationality=character(),
  Foot=character(),
  Height=character()
)

for (league in Leagues) {

  print(league)
  
  URL <- paste0("http://www.transfermarkt.com/premier-league/startseite/wettbewerb/", league)
  WS <- read_html(URL)
  URLs <- WS %>% html_nodes(".hide-for-pad .vereinprofil_tooltip") %>% html_attr("href") %>% as.character()
  URLs <- paste0("http://www.transfermarkt.com",URLs)
  
  Catcher1 <- data.frame(Player=character(),P_URL=character())
  for (i in URLs) {
    WS1 <- read_html(i)
    Player <- WS1 %>% html_nodes("#yw1 .spielprofil_tooltip") %>% html_text() %>% as.character()
    P_URL <- WS1 %>% html_nodes("#yw1 .spielprofil_tooltip") %>% html_attr("href") %>% as.character()
    temp <- data.frame(Player,P_URL)
    Catcher1 <- rbind(Catcher1,temp)
    cat("*")
  }
  no.of.rows <- nrow(Catcher1)
  odd_indexes<-seq(1,no.of.rows,2)
  Catcher1 <- data.frame(Catcher1[odd_indexes,])
  
  Catcher1$P_URL <- paste0("http://www.transfermarkt.com",Catcher1$P_URL)

  for (i in Catcher1$P_URL) {
    
    WS2 <- read_html(i)
    Param <- WS2 %>% html_nodes(".auflistung td , .auflistung th") %>% html_text() %>% as.character()
    Age <- ""
    Contract <- ""
    CurrentTeam <- ""
    Position <- ""
    Nationality <- ""
    Foot <- ""
    Height <- "" 
    
    for(x in seq(1,length(Param),2)) {
      if(Param[x]=="Age:"){
        Age <- Param[x+1]
      }
      if(Param[x]=="Contract until:"){
        Contract <- Param[x+1]
      }
      if(grepl("Current club:", Param[x])){
        CurrentTeam <- Param[x+1]
      }
      if(Param[x]=="Position:"){
        Position <- Param[x+1]
      }
      if(Param[x]=="Nationality:"){
        Nationality <- Param[x+1]
      }
      if(Param[x]=="Foot:"){
        Foot<- Param[x+1]
      }
      if(Param[x]=="Height:"){
        Height<- Param[x+1]
      }
    }  
      
    MarketValue <- WS2 %>% html_nodes(".dataMarktwert a") %>% html_text() %>% as.character()
    Player <- WS2 %>% html_nodes("h1") %>% html_text() %>% as.character()
    if (length(MarketValue) > 0) {
      
      temp2 <- data.frame(
        Player,
        MarketValue,
        Age,
        Contract,
        CurrentTeam,
        Position,
        Nationality,
        Foot,
        Height
        )
      Catcher2 <- rbind(Catcher2,temp2)
      
    } else {}
    
    cat("*")
    
  }

}