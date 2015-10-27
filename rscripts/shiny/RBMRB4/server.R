library(ggplot2)

dat=read.csv('/kbaskaran/bmrb/Atom_chem_shift.csv',header=T)
shinyServer(function(input, output, session) {
  
  # You can access the value of the widget with input$select, e.g.


  
 
  ranges<-reactiveValues(x=c(min(dat$Val),max(dat$Val)),y=NULL)
  output$plot1<-renderPlot({
    ggplot(subset(dat,Comp_ID %in% input$aa & Atom_ID %in% input$atm &
                    Val < max(ranges$x) & Val > min(ranges$x)))+
      geom_density(aes(x=Val,color=Atom_ID,fill=Comp_ID),alpha=0.5)#+
      #coord_cartesian(xlim = ranges$x)
  })
  observeEvent(input$plot1_dblclick,
               {
                 brush <- input$plot1_brush
                 if (!is.null(brush)) {
                   ranges$x <- c(brush$xmin, brush$xmax)
                   ranges$y <- c(brush$ymin, brush$ymax)
                   
                 } else {
                   ranges$x <- c(min(dat$Val),max(dat$Val))
                   ranges$y <- NULL
                 }
               }
  )
  
  
  
  #output$plot2<-renderPlot({
   # ggplot(subset(dat,Comp_ID %in% input$aa & Atom_ID %in% input$atm & 
    #                Val < max(ranges$x) & Val > min(ranges$x)))+
     # geom_density(aes(x=Val,color=Atom_ID,fill=Comp_ID),alpha=0.5)
  #})
 
  
})

