data <- read.csv("taulukko4.csv", header = T, check.names = F)
par(las=2)
par(mar=c(5,16,6,2))
data_rev <- data[,c(13:1)]
barplot(as.matrix(data_rev), horiz=T, xlab="Vastauksia", ylim = c(0, 18), main="Aineistot ja määrät")
legend("topright", legend=c("Ei ole kokoelmissa", "Ei kuvailla Melindaan", "Kuvaillaan Melindaan"), fill=c("gray30", "gray", "white"))
