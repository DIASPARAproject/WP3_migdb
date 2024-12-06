############################################
### Graph functions used by the appication
############################################


plot_for_matrices<-function(data,colpal){
  
  listplots<-list()
  
  for (ar in unique(data$area)){
    
    datasub<-subset(data, data$area==ar)
    
    thegraph <- ggplot(datasub, aes(x = year, y = value, color=as.character(date_time)))+
      ggtitle(paste("Time changes in", data$var_mod[1], "-", ar))+
      # geom_line(size = 1, color=colpal) +
      # scale_color_manual(values = colpal) +
      geom_line(linewidth = 1, aes(linetype=as.character(date_time))) +
      scale_colour_manual(values = colpal) +
      #facet_wrap(~ ZONE + Data_Name, scales = "free_y", ncol = 2)+
      theme_bw()+
      theme(legend.text=element_text(size=6))+
      labs(color = "Recording data", linetype="Recording data")
    
    if(datasub$type=="Survival rate" | datasub$type=="Proportion of delayed individuals"){  thegraph <- thegraph + ylim(0, 1) }
    
    listplots[[which(unique(data$area)==ar)]] <- thegraph
    
  }
  
  return(listplots)
  
  }

plot_for_vectors<-function(data,colpal){
  ggplot(data, aes(x = year, y = value, color=as.character(date_time)))+
    ggtitle(paste("Time changes in", data$var_mod[1], "for", data$area))+
    geom_line(linewidth = 1) +
    scale_colour_manual(values = colpal) +
    #facet_wrap(~ Data_Name, scales = "free_y", ncol = 2)+
    theme_bw()
  }

plot_for_SU<-function(data,colpal){
  ggplot(data, aes(x = area, y = value, fill=as.character(date_time)))+
    ggtitle(paste("Value of", data$var_mod[1], "for the stock unit"))+
    geom_bar(stat="identity", width = 0.25, position = "dodge") +
    #facet_wrap(~ as.character(date_time), scales = "free_y", ncol = 2)+
    #coord_flip()+
    theme_bw()+
    theme(axis.text.x = element_text(angle=45, hjust=0.5),
          legend.text=element_text(size=6))
  }


plot_for_proportions<-function(data,colpal){
  
  listplots<-list()
  
  for (ar in unique(data$area)){
    
    datasub<-subset(data, data$area==ar)

    listplots[[which(unique(data$area)==ar)]] <- ggplot(datasub, aes(x=year,y = value, fill=age)) +
    ggtitle(paste("Proportion of", datasub$var_mod[1], "-", ar))+
    geom_bar(stat="identity",position = "fill") +
    #coord_flip()+
    scale_fill_manual(values=colpal)+
    facet_wrap(~ as.character(date_time), scales = "free_y", ncol = 2)+
    theme_bw()
    
  }
  return(listplots)
}

plot_for_timearray<-function(data,colpal){
  
  listplots<-list()
  
  for (ar in unique(data$area)){
    
    datasub<-subset(data, data$area==ar)
  
    the_graph <- listplots[[which(unique(data$area)==ar)]] <- ggplot(datasub, aes(x=year,y = value,  color=as.character(date_time))) +
      #ggtitle(paste("Eggs by adult", datasub$var_mod[1], "-", ar)) +
      geom_line(linewidth = 1, aes(linetype=age)) +
      #coord_flip()+
      scale_colour_manual(values = c("blue","red"))+
      theme_bw()+
      theme(legend.text=element_text(size=6))
    
    #if(datasub$var_mod=="eggs"){
    # the_graph <- the_graph +
    #    ggtitle(paste("Eggs by adult", datasub$var_mod[1], "-", ar)) +
    #    facet_wrap(~ as.character(date_time), scales = "free_y", ncol = 2)
    #}else{
    #  the_graph <- the_graph +
    #    ggtitle(paste("Proportion of females", datasub$var_mod[1], "-", ar)) +
    #    ylim(0,1)+
    #    facet_wrap(~ as.character(date_time), ncol = 2)
     # }
    
    listplots[[which(unique(data$area)==ar)]] <- the_graph
  
  }
  return(listplots)
}








