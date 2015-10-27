

shinyUI(fluidPage(
  
  titlePanel(h1("BMRB statistics",align="center",style = "color:coral")),
  fluidRow(column(12, plotOutput("plot1",height = 500,#brush=brushOpts(id="plot1_dbclick",resetOnNew=T)))
                                 dblclick = "plot1_dblclick",
                                 brush = brushOpts(
                                   id = "plot1_brush",
                                   resetOnNew = TRUE
                                 )
  )
           #column(6, plotOutput("plot2"))
  )),
  fluidRow(
    column(4,
           checkboxGroupInput("aa",
                       label=h3("Amino acid"),
                       choices = amino_acids,
                       selected = unlist(amino_acids))),
    column(4,
           checkboxGroupInput("atm",
                       label=h3("Atoms"),
                       choices = all_atoms,
                       selected = "CB"))
  )
))

