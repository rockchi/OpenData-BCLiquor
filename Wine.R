liquor <- read.csv("C:/Users/KaLok/Desktop/BC_Liquor_Store_Product_Price_List.csv")
liquor$LogPrice <- log(liquor$CURRENT_DISPLAY_PRICE)
wine <- subset(liquor, PRODUCT_SUB_CLASS_NAME == "TABLE WINE")
#lm
lm1 <- lm(LogPrice~PRODUCT_MINOR_CLASS_NAME+PRODUCT_COUNTRY_ORIGIN_NAME+PRODUCT_ALCOHOL_PERCENT, data=wine)
summary(lm1)
#lm2 - adding in SWEETNESS CODE into regression model
wine1 <- subset(wine, SWEETNESS_CODE != "NA")
lm2 <- lm(LogPrice~SWEETNESS_CODE+PRODUCT_MINOR_CLASS_NAME+PRODUCT_COUNTRY_ORIGIN_NAME+PRODUCT_ALCOHOL_PERCENT, data=wine)
summary(lm2)

#CART - using default cp
CART1 <- part(CURRENT_DISPLAY_PRICE~SWEETNESS_CODE+PRODUCT_MINOR_CLASS_NAME+PRODUCT_COUNTRY_ORIGIN_NAME+PRODUCT_ALCOHOL_PERCENT, method="anova", data=wine, control=rpart.control(cp=0.001))
prp(CART1)

#Text-Mining Product Long Name
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
grapetrix$ID <- wine$PRODUCT_SKU_NO
write.csv(grapetrix, "C:/Users/KaLok/Desktop/GrapeList4.csv")

##Transform Term to Tableau normalized format
##Lists Variety and Price
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
grape <- write.csv(grapetrix, "C:/Users/KaLok/Desktop/GrapeList4.csv")