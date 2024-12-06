########################################################
########################################################
############ Timeline for data availability


timeline_plot_type<-function(database, tab_type_object){
  
  
  tab_type_object %>% filter(name_dim1=="Year" | name_dim2== "Year" | name_dim3=="Year") %>%
    filter(nimble %in% c("Const_nimble","Data_nimble")) %>% select(var_mod) -> with_TS
  
  with_TS <- as.vector(unlist(as.vector(c(with_TS))))
  with_TS <- with_TS[-which(grepl("_pr",with_TS))] 
  
  database %>% filter(var_mod %in% with_TS) %>%
    group_by(type,var_mod) %>%
    summarise(maxy=max(year), miny=min(year)) %>%
    group_by(type) %>%
    summarise(maxytype=min(maxy), minytype=max(miny)) %>%
    as.data.frame() -> minmax_type
  
  minmax_type <- melt(minmax_type)
  
  ggplot()+
    geom_line(data=minmax_type, aes(x=type,y=value, color=type), linewidth=1.2)+
    geom_point(data=minmax_type, aes(x=type,y=value, color=type), linewidth=2)+
    #geom_hline(xintercept=c(1971,as.numeric(format(Sys.Date(), "%Y" ))), size=0.25)+
    #scale_linetype_manual(values=c("dotted","solid" ,"twodash"))+
    theme_bw()+
    theme(legend.position="none", axis.text.y = element_text(angle=35, size=6.5), axis.title.x=element_blank(), axis.title.y=element_blank()) + coord_flip() -> allez
  # scale_y_discrete(expand = expand_scale(mult = c(0.2, 0.2)))#+
  #coord_fixed(ratio=20)
  return(allez)
  
}


timeline_plot_typesel<-function(database, typesel, tab_type_object){
  
  tab_type_object %>% filter(name_dim1=="Year" | name_dim2== "Year" | name_dim3=="Year") %>%
    filter(nimble %in% c("Const_nimble","Data_nimble")) %>% select(var_mod) -> with_TS
  
  with_TS <- as.vector(unlist(as.vector(c(with_TS))))
  with_TS <- with_TS[-which(grepl("_pr",with_TS))] 
  
  database %>% filter(var_mod %in% with_TS) %>%
    filter(type==typesel) %>%
    group_by(type,var_mod, metric) %>%
    summarise(maxy=max(year), miny=min(year)) -> minmax_type_sel
  
  minmax_type_sel <- melt(minmax_type_sel)
  
  ggplot(data=minmax_type_sel)+
    geom_line(aes(x=value, y=var_mod, color=type, linetype=metric), linewidth=1.2)+
    geom_point(aes(x=value, y=var_mod, color=type), size=3)+
    geom_vline(xintercept=c(1971,as.numeric(format(Sys.Date(), "%Y" ))-1), linewidth=0.25)+
    scale_linetype_manual(values=c("dotted","solid" ,"twodash"))+
    theme_bw()+
    theme(legend.position="none", axis.text.y = element_text(angle=35), axis.title.x=element_blank(), axis.title.y=element_blank()) -> allez
  
  return(allez)
}


