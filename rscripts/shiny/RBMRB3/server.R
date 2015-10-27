library(ggplot2)

dat=read.csv('/kbaskaran/bmrb/Atom_chem_shift.csv',header=T)
shinyServer(function(input, output, session) {
  
  # You can access the value of the widget with input$select, e.g.
  output$value <- renderPrint({ input$aa })
 

  
  observe(
    {
      
      updateSelectInput(session,"atm",
                        label = h3("Atoms"),
                        choices = get_list(input$aa),
                        selected = "N"
                        )
      brush <- input$plot1_brush
      if (!is.null(brush)) {
        ranges$x <- c(brush$xmin, brush$xmax)
        ranges$y <- c(brush$ymin, brush$ymax)
        
      } else {
        ranges$x <- NULL
        ranges$y <- NULL
      }
    }
  )
  
  output$value2 <- renderPrint({ input$atm })
  ranges<-reactiveValues(x=NULL,y=NULL)
  output$plot1<-renderPlot({
    ggplot(subset(dat,Comp_ID==input$aa & Atom_ID == input$atm))+
      geom_density(aes(x=Val))
  })
  output$plot2<-renderPlot({
    ggplot(subset(dat,Comp_ID==input$aa & Atom_ID == input$atm))+
      geom_density(aes(x=Val))+
      coord_cartesian(xlim = ranges$x)
  })
 
  
})

