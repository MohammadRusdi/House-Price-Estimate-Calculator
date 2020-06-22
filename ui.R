#library.list <- c('psych','shiny', 'shinythemes', 'DT', 'tidyverse', 'pastecs', 'ggplot2', 'Hmisc', 'corrplot','GGally', 'scales','mice', 'ggthemes', 'data.table', 'testthat', 'gridExtra', 'egg', 'e1071', 'randomForest')
#install.library <- library.list[!library.list %in% installed.packages()]
#for(libs in install.library) install.packages(libs, dependences = TRUE)
#sapply(library.list, require, character = TRUE)
library(rsconnect)
library(shiny)
library(shinythemes)
library(DT)
library(tidyverse)
library(pastecs)
library(ggplot2)
library(pastecs)
library(Hmisc)
library(corrplot)
library(GGally)
library(scales)
library(mice)
library(ggthemes)
library(data.table)
library(testthat)
library(gridExtra)
library(egg)
library(psych)
library(e1071)
library(randomForest)

ui <- navbarPage('House Prices ',theme = shinytheme("flatly"),
                 #Johan Part
                 tabPanel('Price Checker',
                          titlePanel("Price Estimator for Iowa Houses"),
                          sidebarLayout(
                              sidebarPanel(
                                  # Input: Lot Area ----
                                  selectInput("BldgType", "Building Type",
                                              choices = c("Single Family Detached" = "1Fam",
                                                          "Two Family Conversion" = "2fmCon",
                                                          "Duplex" = "Duplex",
                                                          "Town House End Unit" = "TwnhsE",
                                                          "Town House Inside Unit" = "Twnhs")),
                                  selectInput("HouseStyle", "House Style",
                                              choices = c("1 Story" = "1Story",
                                                          "1.5 Story Finished" = "1.5Fin",
                                                          "1.5 Story Unfinished" = "1.5Unf",
                                                          "2 Story" = "2Story",
                                                          "2.5 Story Finished" = "2.5Fin",
                                                          "2.5 Story Unfinished" = "2.5Unf",
                                                          "Split Level" = "SLvl",
                                                          "Split Foyer" = "SFoyer")),
                                  # Input: Stuff  ----
                                  selectInput("GarageType", "Garage Type",
                                              choices = c("Attached" = "Attchd",
                                                          "Detached" = "Detchd",
                                                          "Built in" = "BuiltIn",
                                                          "Basement" = "Basement",
                                                          "Car Port" = "CarPort",
                                                          "No Garage" = "None")),
                                  radioButtons("PavedDrive", "Paved Driveway",
                                               choices = c("Yes" = "Y",
                                                           "No" = "N")),
                                  radioButtons("CentralAir", "Central Aircond",
                                               choices = c("Yes" = "Y",
                                                           "No" = "N")),
                                  radioButtons("1stFlrSF", "1st Floor Square Feet",
                                               choices = c("> 1000 sf" = "Y",
                                                           "< 1000 sf" = "N")),
                                  # End Johan
                                  # Horizontal line ----
                                  tags$hr()
                              ),
                              mainPanel(
                                  helpText("Select your desired house features on the left"),
                                  helpText("Let's estimate how much it might cost with your features"),
                                  htmlOutput("user_selected"),
                                  htmlOutput("est_price"),
                                  helpText("Here's a breakdown of the % of house prices in Iowa"),
                                  plotOutput("priceBinPie")
                              )
                          )
                 ),
                 
                 #Dilraj Part
                 tabPanel('Explore Data',
                          titlePanel(title = "Insight from data"),
                          sidebarLayout(
                              sidebarPanel(
                                  textOutput("tab2desc"),
                                  br(),
                                  uiOutput('corrcheckbox'),
                              ),
                              
                              mainPanel(
                                  tabsetPanel(
                                      id = "corr",
                                      
                                      tabPanel('Data Correlation',
                                               column(12, h2(textOutput("tab2p1head"))),
                                               br(),
                                               column(12, textOutput("tab2p1desc")),
                                               column(12, plotOutput("relationplot", height = 500)),
                                               
                                      ),   
                                      tabPanel('Individual Correlation',
                                               column(12, h2(textOutput("tab2p2head"))),
                                               column(12, textOutput("tab2p2desc")),
                                               column(12, plotOutput("intrelation", height = 500)),
                                               
                                               
                                      ), 
                                      tabPanel('Importance',
                                               column(12, h2(textOutput("tab2p3head"))),
                                               column(12, textOutput("tab2p3desc")),
                                               column(12, plotOutput("varimp", height = 500))                                 
                                               
                                      )                                 
                                      
                                  ))
                              
                              
                          )
                          
                 ),
                 
                 tabPanel('Dataset Description',
                          titlePanel(title = "Description of Dataset Features"),
                          sidebarLayout(
                            sidebarPanel(
                              #File input here ---
                              #fileInput('file1', 'Select csv file',accept=c('text/csv')),
                              
                              # Input: Checkbox if file has header ----
                              #checkboxInput("header", "Header", TRUE),
                              
                              # Input: Select separator ----
                              #radioButtons("sep", "Separator",
                               #            choices = c(Semicolon = ";",
                                #                       Comma = ",",
                                 #                      Tab = "\t"),
                                  #         selected = ","),
                              
                              
                              # Horizontal line ----
                              #tags$hr(),
                              
                              # Input: Select number of rows to display ----
                              #radioButtons("disp", "Display",
                               #            choices = c(All = "all",
                                #                       Head = "head"),
                                 #          selected = "all"),
                              
                              # Select variables to display ----
                              
                              tags$hr(),
                              
                              #select column for histogram ----
                              #selectInput("housingcolumn", "Histogram: ",""),
                              #select input to describe
                              selectInput(label = "Describe the variable", "descvar", "Choose a variable to display",""),
                              #select input for plot
                              selectInput(label = "Plot the variable", "housingcolumnplot", "Choose a variable to display",""),
                              #select column for scatterplot
                              selectInput(label = "Scatterplot of variable x", "housingcolumnscatx", "Choose a variable to display",""),
                              selectInput(label = "Scatterplot of variable y", "housingcolumnscaty", "Choose a variable to display",""),
                              #selectInput("housingcolumnscaty", "Scatterplot Y Axis: ",""),
                              htmlOutput("checkbox")
                              
                            ),
                            mainPanel(
                              #Data frame output ----
                              
                              #tabsetPanel(
                               # id = "dataset",
                                #tabPanel("FILE", DT::dataTableOutput("rendered_file"))
                                
                              #),
                              tableOutput('contents'),
                              #Describe project output
                              textOutput("describe_title"),
                              #Describe column output
                              verbatimTextOutput("describecolumn", placeholder = FALSE),
                              #plot output
                              textOutput("plot_title"),
                              plotOutput("plot"),
                              #scatterplot output
                              textOutput("scat_title"),
                              plotOutput("scat"),
                              #plotOutput("catscat"),
                              #data analysis output
                              textOutput("analysis")
                            )
                          ))
)

