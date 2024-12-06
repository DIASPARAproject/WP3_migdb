########################################################
########################################################
################### Timeline for data availability

timeline_plot<-function(database){

data_availability<-subset(database, !database$type%in% c("Number of years","Prior hyperparameter","Number of SU",
                                   "Natural mortality rate","Demographic transitions"))

data_availability<-subset(database, database$year!="_")

ggplot()+
  geom_line(data=data_availability, aes(x=year,y=var_mod, color=type, linetype=metric ), linewidth=1.2)+
  geom_vline(xintercept=c(1971,as.numeric(format(Sys.Date(), "%Y" ))), linewidth=0.25)+
  scale_linetype_manual(values=c("dotted","solid" ,"twodash"))+
  theme_bw()+
  theme(axis.text.y=element_text(angle = 35, vjust = 1))


}
