setwd("~/Työpöytä/E-aineistokyselyraportti/")
png("ei-kaavio_uusi.png", 1500, 1000)
par(las=2)
par(mar=c(5,21,6,2))
data <- read.csv("e-aineistot-ei_tiivis.csv", header = T, check.names = F)[c(1,3)]
categories = rev(data[,1])
values = rev(data[,2])
barplot(values, names.arg = categories, horiz = T, 
        main = "Olisiko mielestäsi hyödyllistä että kirjastojen e-aineistot olisi nykyistä laajemmin kuvailtu Melindaan?\nEi-vastaukset, perustelut ja tarkennukset", xlab = "Mainintoja")
dev.off()