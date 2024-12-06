as.character("main_plot_catchprop_NECC5_NEC_1.rds")

kik<-readRDS(paste0("exchange_plateform/Nimble_output/",as.character("main_plot_catchprop_NECC5_NEC_1.rds")))
list.files("exchange_plateform/Nimble_output/", pattern="prop")
grid.arrange(kik)

# returns
datatype_out<-"Sea catches"
agenewout<-"2SW"
locationout<-"Aft. Gld fisheries"
area_out<-"FAR fisheries"

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

metadata<-dbReadTable(con,"metadata")

#test sea catches
metadata %>%
  filter(nimble == "Output") %>%
  filter(type == "Sea catches") %>%
  select(ages) %>%
  unique() 

metadata %>%
  filter(nimble == "Output") %>%
  filter(type ==  "Sea catches") %>%
  filter(ages == "1SW") %>%
  select(fishery) %>%
  unique()

metadata %>%
  filter(nimble == "Output") %>%
  filter(type == "Sea catches") %>%
  filter(ages == "2SW") %>%
  filter(fishery == "FAR fisheries") %>%
  distinct(location)# %>%
  #unique()


head(metadata[metadata$var_mod=="C5_NEC_1",])

























#C8_NEC_3_tot

metadata %>%
      filter(nimble == "Output") %>%
      filter(type == datatype_out) %>%
      filter(ages == agenewout) %>%
      filter(fishery == area_out) %>%
      filter(location == locationout) %>%
  filter(!grepl("tot",var_mod))

unique(metadata$var_mod[metadata$type=="Sea catches"])

metadata %>%
  filter(nimble == "Output") %>%
  filter(type == datatype_out) %>%
  select(ages) %>%
  unique()



dbsub<-subset(database, database$type=="Sea catches")
#View(dbsub)
head(dbsub)

dbsub <- reshape2::dcast(dbsub, year+ type + age + area +location + gsub("sd","mu",var_mod) ~ metric, value.var = "value")
colnames(dbsub)[(ncol(dbsub)-2):ncol(dbsub)]<-c("var_mod","value","stdev")
dbsub %>%
  group_by(var_mod) %>%
  mutate(m = mean(value)) %>%
  as.data.frame()->dbsub

dbsub %>%
  group_by(year, age, area) %>%
  summarize(sumval = sum(trans(value))) -> dbsub2

ggplot(dbsub2)+
  geom_area(aes(x=year,y=sumval, fill=area), size=0.2)+
  scale_fill_manual(values = mycolors) +
  theme_bw()+
  facet_wrap(~age, scale=scale)



dbsub<-subset(database, database$type=="Sea catches")
#View(dbsub)
head(dbsub)

dbsub <- reshape2::dcast(dbsub, year+ type + age + area +location + gsub("sd","mu",var_mod) ~ metric, value.var = "value")
colnames(dbsub)[(ncol(dbsub)-2):ncol(dbsub)]<-c("var_mod","value","stdev")
dbsub %>%
  group_by(var_mod) %>%
  mutate(m = mean(value)) %>%
  as.data.frame()->dbsub

toplot<-ggplot(dbsub,aes(x=year,y=trans(value), group=var_mod, colour=age, fill=age))+
  geom_line(linewidth=0.2)+
  #scale_linetype_manual(values = linetype)+
  theme_bw()+
  scale_colour_manual(values = colors_age[which(order_ages%in%unique(dbsub$age))])

toplot<-toplot+
  geom_ribbon(aes(x=year, ymin=(trans(value)-trans(stdev)), ymax=(trans(value)+trans(stdev))), alpha=0.25)+
  scale_fill_manual(values = c("red","blue","red","blue","red","blue"))


toplot<-toplot+facet_wrap(~area, scale=scale)   




database %>%
  filter(type == "Sea catches") %>%
  filter(age %in% c("1SW","2SW")) %>%
  filter(area %in% c("GLD fisheries","FAR fisheries","NF/LB fisheries","NF/LB/SPM fisheries","NF fisheries",
                    "LB/SPM fisheries out Lb","LB/SPM fisheries in Lb")) %>%
  filter(location %in% c("Gld fisheries","Bef. Gld fisheries","Aft. Gld fisheries"))->dbsub
str(alorsregarde)















