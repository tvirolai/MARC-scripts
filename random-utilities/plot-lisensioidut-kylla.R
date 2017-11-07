setwd("~/Työpöytä/E-aineistokyselyraportti/")
x11()
#png("lisensioidut-kylla_uusi.png", 1500, 1000)
par(las=2)
par(mar=c(5,25,6,2))
data <- read.csv("lisensioidut-kylla.csv", header = T, check.names = F)[c(1,3)]
categories = rev(data[,1])
values = rev(data[,2])
barplot(values, names.arg = categories, horiz = T, 
        main = "Olisiko mielestäsi hyödyllistä, jos lisensoitujen e-aineistojen bibliografiset tietueet olisivat Melindassa?\nKyllä-vastaukset, perustelut", xlab = "Mainintoja")
#dev.off()