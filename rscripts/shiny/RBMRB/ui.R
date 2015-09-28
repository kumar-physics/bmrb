
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
    column(12,
           ggvisOutput("plot1"))   
  )
  
))

