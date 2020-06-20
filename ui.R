library(shiny)
library(DT)
library(tidyverse)
library(ggplot2)
library(pastecs)
library(Hmisc)

ui <- pageWithSidebar(
    
    #Header ---
    headerPanel( "Housing Data", "Flowserve"),
    sidebarPanel(
        #File input here ---
        fileInput('file1', 'Select csv file',accept=c('text/csv')
        ),
        # Horizontal line ----
        tags$hr(),
        
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),
        
        # Input: Select separator ----
        radioButtons("sep", "Separator",
                     choices = c(Semicolon = ";",
                                 Comma = ",",
                                 Tab = "\t"),
                     selected = ","),
        
        
        # Horizontal line ----
        tags$hr(),
        
        # Input: Select number of rows to display ----
        radioButtons("disp", "Display",
                     choices = c(All = "all",
                                 Head = "head"),
                     selected = "all"),
        
        # Select variables to display ----
        uiOutput("checkbox"),
        
        tags$hr(),
        
        #select column for histogram ----
        #selectInput("housingcolumn", "Histogram: ",""),
        #select input to describe
        selectInput(label = "Describe the variable", "descvar", "Choose a variable to display",""),
        #select input for plot
        selectInput(label = "Plot the variable", "housingcolumnplot", "Choose a variable to display",""),
        #select column for scatterplot
        selectInput(label = "Scatterplot of variable x", "housingcolumnscatx", "Choose a variable to display",""),
        selectInput(label = "Scatterplot of variable y", "housingcolumnscaty", "Choose a variable to display","")
        #selectInput("housingcolumnscaty", "Scatterplot Y Axis: ",""),
        
        
    ),
    mainPanel(
        #Data frame output ----
        
        tabsetPanel(
            id = "dataset",
            tabPanel("FILE", DT::dataTableOutput("rendered_file"))
            
        ),
        tableOutput('contents'),
        #Describe project output
        textOutput("describe"),
        #Describe column output
        verbatimTextOutput("describecolumn"),
        #plot output
        plotOutput("plot"),
        #scatterplot output
        plotOutput("scat"),
        #plotOutput("catscat"),
        #data analysis output
        textOutput("analysis")
       
    )
)




