# llegim les dades
d <- read.csv("test_file.csv", header=TRUE, sep=",")

# calculs preliminars y parametres editables
m_load <- 1000
y_limit <- 2.9
first_epoch <- min(d$Date) - 1

# calculem els mAh a partir de la columna Date
# la formula es:
# Date - (primer epoch -1)
# /3600 # per hores
# * miliamps de descarrega
mah <- (((d$Date-first_epoch)/3600)*m_load)
# tambe calculem el datetime corresponent al valor de y_limit (V cutout)
max_datetime <- max(d[which(d$Value == y_limit), ]$Date)
x_limit <- ((max_datetime-first_epoch)/3600)*m_load
x_label <- sprintf("mAh - %f", x_limit)
y_label <- sprintf("Volts (cutout at %f)", y_limit)

plot(mah, d$Value, type="l", col="blue", xlab=x_label, ylab=y_label)
abline(h=y_limit)
abline(v=x_limit)
