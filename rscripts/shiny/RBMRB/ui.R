
library(ggvis)

shinyUI(fluidPage(
  titlePanel(h1("BMRB data visualization(HSQC) using R",align="center",style = "color:black")),
  fluidRow(
    column(6,
           numericInput("bmrbId",label="BMRB ID",
                        value=15076)),
    column(6,
           actionButton("goButton",
                        label="Update Plot"))
  ),

  fluidRow(
    column(6,
           ggvisOutput("plot1")),
    column(3,
           plotOutput("plot2",
                      brush = brushOpts(
                        id = "plot2_brush",
                        resetOnNew = TRUE
                      )
           )),
    column(3,
           plotOutput("plot3"
           ))
  )
  
))

