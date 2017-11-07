setwd("~/Työpöytä/E-aineistokyselyraportti/")
x11()
png("lisensioidut-ei.png", 1500, 1000)
par(las=2)
par(mar=c(5,25,6,5))
data <- read.csv("lisensioidut-ei.csv", header = T, check.names = F)[c(1,3)]
categories = rev(data[,1])
values = rev(data[,2])
barplot(values, xlim = c(0,12), names.arg = categories, horiz = T, 
        main = "Olisiko mielestäsi hyödyllistä, jos lisensoitujen e-aineistojen bibliografiset tietueet olisivat Melindassa?\nEi-vastaukset, perustelut", xlab = "Mainintoja")
dev.off()