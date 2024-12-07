###################
###################dbsub<-subset(database, database$var_mod%in%c("log_N6_mu","log_N9_mu","log_N6_sd","log_N9_sd"))
##################TheMostBeautifulFunction(dbsub,unlog,scale,overlay,uncert)
###################dbsub<-subset(database, database$var_mod%in%c("p_smolt"))
##################TheMostBeautifulFunction(dbsub,unlog,scale,overlay,uncert)
  linetype = rep(c('solid', 'solid','dotted', 'dotted','dashed','dashed'),each=4)
  
mycolors<-c("#1bc253", "#d3fe6c", "#aebd68", "#a4eb94", "#0a681b", "#0ef906", 
              "#ea9cea", "#f90509", "#f06107", "#7b040c","#7b040c", "#fed791", "#e7d20f", "#bd5254",
              "#0af5fd", "#041f55", "#1d86fe", "#bcfffe", "#a6cee3", "#aebaca", "#1d00F8", "#47046c", "#5c38ff", "#c4b7f6", "#7c00d5","grey95","grey25")
 
 colors_age<-c("red","blue","violet","red","red","purple","black","black","lightpink1","red","blue","lightpink1",rgb(235/255,239/255,245/255),rgb(207/255,218/255,233/255),rgb(153/255,176/255,208/255),rgb(96/255,133/255,183/255),rgb(62/255,94/255,136/255),rgb(44/255,65/255,95/255))
  
 order_ages<-c("1SW","2SW","1SW maturing", "1SW not maturing","1SW mature","1SW immature","_","Mixed","eggs","1SW post-return", "2SW post-return","0SW","1FW","2FW","3FW","4FW","5FW","6FW")

TheMostBeautifulFunction<-function(dbsub,unlog,scale,overlay,uncert, arealab){

  trans<-get(unlog)
  varname<-unique(dbsub$var_mod)
  order_areas<-arealab$su_ab
  if(unique(dbsub$type)=="Origin distribution in sea catches"){
   # dbsub$area[dbsub$area=="NAC"]<-'NOC'
   # dbsub$area[dbsub$area=="NEC"]<-'NAC'
   # dbsub$area[dbsub$area=="NOC"]<-'NEC'
    order_areas<-c(order_areas, "NAC", "NEC")
    dbsub$area<- factor(dbsub$area, levels = c(order_areas,levels(dbsub$area)[!levels(dbsub$area)%in%order_areas]))  #dbsub<-subset(dbsub, !dbsub$var_mod%in%c("log_C9_sd","log_C6_sd","log_C9_sup_sd","log_C6_sup_sd","log_C9_delSp_sd","log_C6_delSp_sd"))
      }else{
  if(unique(dbsub$type)!="Sea catches"){
      dbsub$area<- factor(dbsub$area, levels = c(order_areas,levels(dbsub$area)[!levels(dbsub$area)%in%order_areas]))  #dbsub<-subset(dbsub, !dbsub$var_mod%in%c("log_C9_sd","log_C6_sd","log_C9_sup_sd","log_C6_sup_sd","log_C9_delSp_sd","log_C6_delSp_sd"))
  }
  }

  if(varname[1]=="p_smolt"){
    toplot<-ggplot(dbsub)+
      geom_area(aes(x=year,y=value, fill=age), color="black", size=0.2)+
      #scale_fill_manual(values = mycolors) +
      scale_fill_manual(values = colors_age[which(order_ages%in%unique(dbsub$age))]) +
      xlab("Years")+
      ylab("Proportions of total smolt number")+
      theme_bw()+
      facet_wrap(~area, scale=scale)
    # if(varname[1]=="p_smolt"){
    #   toplot<-ggplot(dbsub)+
    #     geom_line(aes(x=as.numeric(as.factor(age)),y=value, color=year, group=area), size=0.5)+
    #     scale_colour_gradient2(mid="#FBFEF9",low="#0C6291",high="#A63446", midpoint=floor(median(seq(1971,2018))), limits=c(1971,2018)) +
    #     theme_bw()+
    #     facet_wrap(~area, scale=scale)
    # }
  }else{
    
    if(unique(grepl("delta", varname, fixed = TRUE))==TRUE){
      
      order_ages<-rev(c("1SW", "2SW"))
      order_stages<-rev(c("Bef. Fisheries", "Return aft. First fishery", "Aft. First fisheries", "Aft. Second fisheries","Return aft. Second fishery"))
      dbsub$age<- factor(dbsub$age, levels = c(order_ages,levels(dbsub$age)[!levels(dbsub$age)%in%order_ages]))
      dbsub$location<- factor(dbsub$location, levels = c(order_stages, levels(dbsub$location)[!levels(dbsub$location)%in%order_stages]))
      toplot<-ggplot(dbsub)+
        #geom_bar(aes(x=gsub('NAC',"",gsub('NEAC',"",var_mod)),y=value , fill=age),
        geom_bar(aes(x=age,y=value , fill=location), stat="identity")+
        #scale_fill_manual(values = mycolors) +
        theme_bw()+
        ylab("Cumulated time spent at sea (months)")+
        xlab("Number of sea winters spent at sea")+
        theme(axis.text.x = element_text(angle = 45, hjust=1))+
        facet_wrap(~area, scale=scale)+
        coord_flip()
      
    }else{
      
      if(unique(dbsub$type)%in%c("Proportion of delayed individuals","Survival rate","Natural moratlity rate")){
          dbsub<-subset(dbsub, grepl("_pr",dbsub$var_mod)==F)
          dbsub<-subset(dbsub, grepl("CV",dbsub$var_mod)==F)
          dbsub$age<- factor(dbsub$age, levels = c(order_ages,levels(dbsub$age)[!levels(dbsub$age)%in%order_ages]))
          toplot<-ggplot(dbsub)+
          #geom_line(aes(x=year,y=trans(value),colour=age, linetype=var_mod), size=0.2)+
          geom_line(aes(x=year,y=trans(value),colour=age), linewidth=0.5)+
          scale_colour_manual(values = colors_age[which(order_ages%in%unique(dbsub$age))]) +
          theme_bw()+facet_wrap(~area, scale=scale)+
          xlab("Years")+
          ylab("Proportion of the population (%)")
      }else{
        
        if(unique(dbsub$type)%in%c("Origin distribution in sea catches")){
          #order_locations<-c("FAR - by SU","GLD - by NAC SU","GLD - by NEC SU","GLD - by cplx")
          #dbsub<-subset(dbsub,dbsub$location!="GLD - by cplx")
          #dbsub$location<-factor(dbsub$location, levels = c(order_locations,levels(dbsub$location)[!levels(dbsub$location)%in%order_locations]))
          toplot<-ggplot(dbsub)+
            geom_area(aes(x=year,y=value, fill=area), size=0.2)+
            scale_fill_manual(values = c(mycolors[which(order_areas%in%unique(dbsub$area))],"black","white")) +
            theme_bw()+
            facet_wrap(~paste(location,age,sep=" - "), scale=scale)+
            xlab("Years")+ylab("Proportion of total catches")
        }else{

        # HERE WE SHOULD PERFORM THE FIRST TRANSFO WITH M AND STDEC TO ONLY KEEP MU ON GRAPHS
  #if(overlay=="area" | substr(varname[1], start = 1, stop=1)=="p"){
        
        if(unique(dbsub$type)%in%c("Sea catches","Homewater catches", "Returns")){
          
          if(length(unique(grepl(paste(c("C6","C9","CV_hw"), collapse="|"),unique(dbsub$var_mod))))==1 & unique(grepl(paste(c("C6","C9","CV_hw"), collapse="|"),unique(dbsub$var_mod)))[1]==T){
            dbsub <- cbind.data.frame(dbsub, dbsub$value[dbsub$var_mod=="CV_hw"])
            colnames(dbsub)[ncol(dbsub)]<-"stdev"
            dbsub %>%
              group_by(var_mod) %>%
              mutate(m = mean(value)) %>%
              as.data.frame()->dbsub
            dbsub<-subset(dbsub,dbsub$var_mod!="CV_hw")
            dbsub$stdev <-dbsub$stdev*dbsub$m 
            
          }else{
            dbsub <- reshape2::dcast(dbsub, year+ type + age + area +location + gsub("sd","mu",var_mod) ~ metric, value.var = "value")
            colnames(dbsub)[(ncol(dbsub)-2):ncol(dbsub)]<-c("var_mod","value","stdev")
            dbsub %>%
              group_by(var_mod) %>%
              mutate(m = mean(value)) %>%
              as.data.frame()->dbsub
          }
          
        }
        
       if(overlay=="area"){
         if(unique(dbsub$type%in%c("Sea catches"))){
         #dbsub %>%
         #  group_by(location,year) %>%
         #  mutate(s = sum(value)) %>%
         #  as.data.frame()->dbsub
          dbsub %>%
             group_by(year, age, area) %>%
             summarize(sumval = sum(trans(value))) -> dbsub2 #%>% as.data.frame() -> dbsub
           #toplot<-ggplot
          
         toplot<-ggplot(dbsub2)+
           geom_area(aes(x=year,y=sumval, group=area, fill=area), size=0.2)+
            scale_fill_manual(values = mycolors) +
            theme_bw()+
            facet_wrap(~age, scale=scale)+
           xlab("Years")+
           ylab(paste(ifelse(unlog=="exp","","(log of the number)"), "Number of salmons"))#}
          #if(substr(varname[1], start = 1, stop=1)=="p"){
          #toplot<-toplot+facet_wrap(~paste(location,age,sep="-"), scale=scale)      
          #}else{
          
         }
         if(unique(dbsub$type%in%c("Homewater catches"))){
           dbsub %>%
             group_by(year, age, area, varall=substr(var_mod, 1,6)) %>%
             summarize(sumval = sum(trans(value), na.rm = TRUE))%>% as.data.frame()->dbsub2

           toplot<-ggplot(dbsub2)+
             geom_area(aes(x=year,y=sumval,group=area, fill=area), size=0.2)+
             scale_fill_manual(values = mycolors[which(order_areas%in%unique(dbsub2$area))]) +
             theme_bw()+
             facet_wrap(~age, scale=scale)
         }
         if(unique(dbsub$type%in%c("Returns", "Stocking", "Fecundity rate"))){
           #if(unique(dbsub$type%in%c("Homewater catches"))){
           #  toplot<-ggplot(dbsub)+
           #    geom_area(aes(x=year,y=trans(value), group=var_mod, fill=location), size=0.2,stat ="sum")+
           #    scale_fill_manual(values = mycolors) +
           #    theme_bw()+
           #    facet_wrap(~age, scale=scale)
           #}else{
           
           if(unique(dbsub$type%in%c("Stocking", "Fecundity rate"))){
             trans<-get("identity")
           }
           
           toplot<-ggplot(dbsub)+
             geom_area(aes(x=year,y=trans(value), fill=area), size=0.2)+
             scale_fill_manual(values = mycolors[which(order_areas%in%unique(dbsub$area))]) +
             #scale_fill_manual(values = mycolors)+
             theme_bw()+
             facet_wrap(~age, scale=scale)#}
           #}
         }
         if(unique(dbsub$type%in%c("Fecundity rate"))){
           toplot<-toplot+xlab("Years")+ylab("Number of eggs by spawner") 
         }
         if(unique(dbsub$type%in%c("Stocking"))){
           toplot<-toplot+xlab("Years")+ylab("Number of individuals") 
         }
        }

  if(overlay=="sw_age"){
    
###   toplot<-ggplot(dbsub)+
###     geom_line(aes(x=year,y=trans(value),colour=age, linetype=var_mod), size=0.2)+
###     #scale_colour_manual(values = mycolors) +
###     theme_bw()
    #if(unique(tab_type_object$type[tab_type_object$var_mod%in%varname])%in%c("HWCatches","MixedCatches")){
    
    #toplot<-ggplot(dbsub,aes(x=year,y=trans(value), colour=age, linetype=var_mod, fill=age))+
    dbsub$age<- factor(dbsub$age, levels = c(order_ages,levels(dbsub$age)[!levels(dbsub$age)%in%order_ages]))
      toplot<-ggplot(dbsub,aes(x=year,y=trans(value), group=var_mod, colour=age, fill=age))+
        geom_line(linewidth=0.2)+
        #scale_linetype_manual(values = linetype)+
        theme_bw()+
        scale_colour_manual(values = colors_age[which(order_ages%in%unique(dbsub$age))])

    
    if(unique(dbsub$type)%in%c("Sea catches","Homewater catches", "Returns")){
 #     if(unique(grepl("Sp", varname, fixed = TRUE))==T){toplot<-toplot+facet_wrap(~ZONE, scale=scale)}else{
#        toplot<-toplot+facet_wrap(~gsub('2',"",gsub('1',"",var_mod)), scale=scale)#+facet_wrap(~var_mod+ZONE, scale=scale, nrow = 2)
#      }

#NEED A GRAPH SMWH IF WANT PLOT WITHOUT UNCERT + NEED TO REMOVE SD..!
#      toplot<-ggplot(dbsub)+
#        geom_line(aes(x=year,y=trans(value),colour=var_mod, linetype=var_mod), size=0.2)+
#        scale_linetype_manual(values = linetype)+
#        #scale_colour_manual(values = mycolors) +
#        theme_bw()
####     dbsub %>%
###       group_by(var_mod) %>%
###       mutate(m = mean(value)) %>%
###       as.data.frame()->dbsub
      

      legend.title <- "My title"
      
#      toplot<-ggplot(dbsub)+
#        geom_line(aes(x=year,y=trans(value), colour=age, linetype=var_mod), size=0.2)+
#        scale_linetype_manual(values = linetype)+
#        theme_bw()+
#        scale_colour_manual(legend.title,values = c("red","blue","red","blue","red","blue"))
   #   if(unique(dbsub$type)%in%c("Sea catches", "Returns")){
        
    #   toplot<-ggplot(dbsub,aes(x=year,y=trans(value), colour=age,fill=age))+
    #     geom_line(size=0.2)+
    #     theme_bw()+
    #     scale_colour_manual(values = c("red","blue","red","blue","red","blue"))
 #     }else{

        
#      }
      
      
      if(uncert=="with"){
        
        #      toplot<-toplot+
        #        geom_ribbon(aes(x=year, ymin=(trans(value)-trans(stdev)), ymax=(trans(value)+trans(stdev)), fill=age), alpha=0.25)+
        #        scale_fill_manual(legend.title,values = c("red","blue","red","blue","red","blue"))
        
        toplot<-toplot+
        geom_ribbon(aes(x=year, ymin=(trans(value)-2*trans(stdev)), ymax=(trans(value)+2*trans(stdev))), alpha=0.25)+
        scale_fill_manual(values = colors_age[which(order_ages%in%unique(dbsub$age))])
        
      }
      
      if(unique(dbsub$type)%in%c("Sea catches")){
        toplot<-toplot+
          facet_wrap(~area, scale=scale)          
      }
      
      if(unique(dbsub$type)%in%c("Homewater catches")){
        toplot<-toplot+
         # scale_linetype_manual(values = linetype)+
          facet_wrap(~area, scale=scale)        
      }
      
      if(unique(dbsub$type)%in%c("Returns")){
        toplot<-toplot+facet_wrap(~area, scale=scale)      
      }
      
      toplot<-toplot+
        xlab("Years")+
        ylab(paste(ifelse(unlog=="exp","","(log of the number)"), "Number of salmons"))
      
    }else{
      
      toplot<-toplot+facet_wrap(~area, scale=scale)
      
      if(unique(dbsub$type%in%c("Fecundity rate"))){
        toplot<-toplot+xlab("Years")+ylab("Number of eggs by spawner")        
      }
      if(unique(dbsub$type%in%c("Sex ratio"))){
        toplot<-toplot+xlab("Years")+ylab("Proportion of females")        
      }
      
      if(unique(dbsub$type%in%c("Stocking"))){
        toplot<-toplot+xlab("Years")+ylab("Number of individuals")        
      }
      
    }
      

    
  }
 


        }
        
      }
  }
  }
  
  return(toplot)

}
