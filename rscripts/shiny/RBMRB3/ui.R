

shinyUI(fluidPage(
  
  titlePanel(h1("BMRB statistics",align="center",style = "color:coral")),
  fluidRow(
    column(6,
           selectInput("aa",
                       label=h3("Amino acid"),
                       choices = amino_acids,
                       selected = "ALA")),
    column(6,
           selectInput("atm",
                       label=h3("Atoms"),
                       choices = ala,
                       selected = "N"))
  ),
  hr(),
  fluidRow(
    column(6, plotOutput("plot1",brush=brushOpts(id="plot1_brush",resetOnNew=T))),
    column(6, plotOutput("plot2")))
))

