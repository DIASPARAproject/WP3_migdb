dbsub<-subset(database, database$var_mod%in%c("log_C6_mu","log_C9_mu","log_C6_delSp_mu","log_C9_delSp_mu","log_C6_sup_mu","log_C9_sup_mu","CV_hw"))
#dbsub<-subset(database, database$var_mod%in%c("log_N6_mu","l

dbsub <- cbind.data.frame(dbsub, dbsub$value[dbsub$var_mod=="CV_hw"])
colnames(dbsub)[ncol(dbsub)]<-"stdev"
head(dbsub)
dbsub<-subset(dbsub,dbsub$var_mod!="CV_hw")

dbsub %>%
  group_by(year, age, area, varall=substr(var_mod,1,6)) %>%
  summarize(sumval = sum(trans(value), na.rm = TRUE))%>% as.data.frame()->dbsub
exp(min(dbsub$sumval))
    exp(max(dbsub$sumval))

dbsub$area<-as.factor(dbsub$area)

View(dbsub)

ggplot(dbsub)+
  geom_area(aes(x=year,y=sumval,group=area, fill=area), size=0.2)+
  scale_fill_manual(values = mycolors[which(order_areas%in%unique(dbsub$area))]) +
  theme_bw()+
  facet_wrap(~age, scale=scale)
 
#######
dbsub<-subset(database, database$type=="Sea catches")
#dbsub<-subset(database, database$var_mod%in%c("log_N6_mu","l
dbsub <- reshape2::dcast(dbsub, year+ type + age + area +location + gsub("sd","mu",var_mod) ~ metric, value.var = "value")
colnames(dbsub)[(ncol(dbsub)-2):ncol(dbsub)]<-c("var_mod","value","stdev")
dbsub %>%
  group_by(var_mod) %>%
  mutate(m = mean(value)) %>%
  as.data.frame()->dbsub

dbsub %>%
  group_by(year, age, location) %>%
  summarize(sumval = sum(trans(value), na.rm = TRUE))%>% as.data.frame()->dbsub

ggplot(dbsub)+
  geom_area(aes(x=year,y=sumval, group=location, fill=location), size=0.2)+
  scale_fill_manual(values = mycolors) +
  theme_bw()+
  facet_wrap(~age, scale=scale)

############################################################
############################################################

dbsub<-subset(database, database$type=="Origin distribution in sea catches")
unique(dbsub$var_mod)




