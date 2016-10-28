## Script to plot Nanodrop Data from ndv export
## Original: J. Kabisch 2014
## kabisch@uni-greifswald.de
## Adapted: Yi-Hong Ke 2016
## b00605051@ntu.edu.tw
library(reshape2)
library(ggplot2)
fi=(file.choose())

export=function(){
header <- read.table(fi,nrows = 4, sep="\t",header=F, stringsAsFactors = FALSE)
values <- read.table(fi, skip=4, sep="\t",header=T, dec = ",", comment.char="?")
curve.values <- subset(values, select = c(Sample.ID, X220:X303)) # extract values for plots
amount <- subset(values, select = c(Sample.ID, ng.ul,X260.280,X260.230)) # extract quantity
protein <- subset(values, select = c(X260.280)) # extract protein contamination
md <- melt(curve.values, id=(c("Sample.ID"))) # transform to ggplot format
md$variable<-substring(md$variable,2) # remove X in front of variables
ggplot(md) + geom_line(aes(x=as.numeric(variable), y=as.numeric(value), group=Sample.ID), ) + facet_wrap(~Sample.ID) + lims(y=c(-1,8)) + 
geom_vline(aes(xintercept = 260),col="green") + xlab("Wavelength (nm)") + ylab("10 mm Absorbance")
write.table(amount,file=gsub('.ndv$',".csv",as.character(fi)),quote=F,row.names=F,sep=",", col.names = c("Sample.ID","ng/um","260/280","260/230"))
ggsave(gsub('.ndv$',".png",as.character(fi)))} 

if (grepl('.ndv$',fi)==T){
  export()
  } else{
    warning('extension should be ".ndv"')
  }
  
