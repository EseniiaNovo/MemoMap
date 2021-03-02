#РАБОТА С ОТКРЫТЫМИ ДАННЫМИ СПБ

#mon_okn <- read.csv("~/ОКН на тер. СПб.csv")
#нужно сделать поиск по ключевым словам "памятник", "бюст", "стела", "камень", "мемориал"
#не полное соответствие текста, а только "если в тексте есть..."

for (rows in 1:length(mon_okn[,"name_object"])) {
  if (startsWith(mon_okn[rows, "name_object"], "Бюст")) { 
    mon_okn[rows,"type"] <- c("Памятник")
  } else if (startsWith(mon_okn[rows, "name_object"], "Памятник")) {
    mon_okn[rows,"type"] <- c("Памятник")
  } else if (startsWith(mon_okn[rows, "name_object"], "Мемориал")) {
    mon_okn[rows,"type"] <- c("Памятник")
  } else if (startsWith(mon_okn[rows, "name_object"], "Камень")) { 
    mon_okn[rows,"type"] <- c("Памятник")
  } else if (startsWith(mon_okn[rows, "name_object"], "Стела")) {
    mon_okn[rows,"type"] <- c("Памятник")
  } else if (startsWith(mon_okn[rows, "name_object"], "Обелиск")) {
    mon_okn[rows,"type"] <- c("Памятник")
  }
}

mon_okn <- mon_okn[!is.na(mon_okn$type),]
mon_okn <- mon_okn[c("name_object", "date", "address", "author")]
names(mon_okn)[1] <- "name"
names(mon_okn)[4] <- "description"

#mon_dost <- read.csv("~/Достопримечательности.csv")
mon_dost <- mon_dost[mon_dost$obj_type == "Памятники", ]
mon_dost <- mon_dost[c("name", "address_manual", "description", "obj_history")]
names(mon_dost)[2] <- "address"

#mon_add <- read.csv("~/Объектно адресная система.csv")
#appellation = "Памятник"
mon_add <- mon_add[mon_add$appellation == "Памятник", ]
mon_add <- mon_add[c("appellation", "address")]
names(mon_add)[1] <- "name"

#Объединение датасетов в один
library(dplyr)
mon <- full_join(mon_okn, mon_add)
mon <- full_join(mon, mon_dost)
mon <- mon %>% mutate_all(na_if,"")

#получение координат

library(ggmap)
#register_google(key = "~") 

mon_fin <- mon
for(i in 1:nrow(mon_fin))
{
  result <- geocode(mon_fin$address[i], output = "latlona", source = "google")
  mon_fin$lon[i] <- as.numeric(result[1])
  mon_fin$lat[i] <- as.numeric(result[2])
}

#write.csv(mon_fin, "~/Памятники СПб.csv", row.names = FALSE)
