#Loading Product List and Subset Data to Wine
liquor <- read.csv("C:/Users/KaLok/Desktop/BC_Liquor_Store_Product_Price_List.csv")
liquor$LogPrice <- log(liquor$CURRENT_DISPLAY_PRICE)
wine <- subset(liquor, PRODUCT_SUB_CLASS_NAME == "TABLE WINE")

#Text-Mining Product Long Name of Wine
library(tm)
library(SnowballC)
corpus <- Corpus(VectorSource(wine$PRODUCT_LONG_NAME))
for(i in seq(corpus)){
        corpus[[i]] <- gsub("-"," ", corpus[[i]])
}
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, stripWhitespace)
PTD <- tm_map(corpus, PlainTextDocument)
DTM <- DocumentTermMatrix(PTD)
DTM <- as.data.frame(as.matrix(DTM))

#Creating Grape Variety List
#List created from BC Liquor site
grape <- read.csv("C:/Users/KaLok/Desktop/GrapeList.csv")
grapus <- Corpus(VectorSource(grape))
for(i in seq(grapus)){
        grapus[[i]] <- gsub("/"," ", grapus[[i]])
}
grapus <- tm_map(grapus, removeNumbers)
grapus <- tm_map(grapus, tolower)
grapus <- tm_map(grapus, stripWhitespace)
grapedoc <- tm_map(grapus, PlainTextDocument)
grapedoc <- DocumentTermMatrix(grapedoc)
grapedoc <- as.data.frame(as.matrix(grapedoc))
grapelist <- as.list(colnames(grapedoc))
removing <- c("grape","not", "other", "variety", "applicable")
grapelist[grapelist %in% removing] <- NULL

#Filtering Product Long Names for Grape Variety
grapetrix <- DTM[colnames(DTM) %in% grapelist]

##Loop transforms each term to Tableau normalized format
##Lists Variety and Price
##Note that Price column references to wine df instead of grapetrix
TableauData <- data.frame(Variety=character(0), Price=numeric(0))
i <- 1
while (i <= length(grapetrix)){
        for(x in seq(grapetrix[,i])){
                if(grapetrix[x,i] >0){
                        Variety <- colnames(grapetrix)[i]
                        Price <- wine$CURRENT_DISPLAY_PRICE[x]
                        temp <- data.frame(Variety, Price)
                        TableauData <- rbind(TableauData, temp)    
                }
        }
        i <- i + 1
}
write.csv(grapetrix, "C:/Users/KaLok/Desktop/TableauGrape.csv")