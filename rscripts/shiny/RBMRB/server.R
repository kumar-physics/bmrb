library(httr)
library(reshape)
library(ggplot2)
library(ggvis)
library(shiny)

shinyServer(function(input, output) {
  
  # You can access the value of the widget with input$text, e.g.
  #output$value <- renderPrint({ input$bmrbId })
 
  bid<-reactive({
    input$goButton
    bbid<-isolate(input$bmrbId)
    hsqc<-hsqc_HN(bbid)
    m<-as.data.frame(hsqc)
    m
  })
  
  bid_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$resId)) return(NULL)
    
    # Pick out the movie with this ID
    all_bid <- isolate(bid())
    bid <- all_bid[all_bid$resId == x$resId, ]
    
    paste0("Res Id:", bid$resId, 
           "<br> Res Type :",bid$Res.x,
           "<br> H :",bid$H,
           "<br> N :",bid$N
    )
  }
 
  vis <- reactive({
    # Lables for axes
    #xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    #yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    #strokeval <- as.character(as.symbol("BMRBId"))
    xvar <- prop("x", as.symbol("H"))
    yvar <- prop("y", as.symbol("N"))
    shapeval <- as.symbol("Res.x")
    bid %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200, 
    #fillOpacity := 0.2, fillOpacity.hover := 0.5, 
    stroke=shapeval,fill=shapeval,
    #shape=shapeval,
    key := ~resId) %>%
    #mark_rect() %>%
    add_tooltip(bid_tooltip, "hover") #%>%
    #add_axis("x", title = xvar_name) %>%
    #add_axis("y", title = yvar_name) %>%
    #add_legend(scales = "shape", properties = legend_props(legend = list(x = 950))) %>%
    #set_options(width=800, height=800, duration = 0)
    #add_legend("stroke", title = "Won Oscar", values = c("Yes", "No")) %>%
    #scale_nominal("stroke", domain = c("Yes", "No"),
    #range = c("orange", "#aaa")) %>%
    #set_options(width = 1200, height = 1200)
  })
  vis %>% bind_shiny("plot1")
  output$xxx <- renderText({ nrow(bid()) })
  
  
})

