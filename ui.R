
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shinyWidgets)
library(shiny)
library(ggplot2)
library(markdown)
library(lattice)
library(DT)
library(dplyr)
library(shinyBS)
allPhilsPitchers19 <- read.csv("allPhilsPitchers19.csv")

# Define UI for app ----
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      @import
      url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
               h2{
                 font-family: 'Lobster', cursive;
                 font-weight: 500;
                 line-height: 1.1;
                 color: #a61d00;
               }
        "))
    ), 
  
    tags$div(
      class = "title-app",
      tags$h2("Phillies Suite"),
      tags$h5("by Statburn Alley")
    ),
  
  setBackgroundColor(color = "#aae5ff"),
  
  # App title ----
  #titlePanel("Phillies Suite"),
  
  navbarPage("Menu",
             
  #begin Pitcher Velocity Tab           
  tabPanel(
    "Pitcher Velocity",
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      ,radioButtons(inputId = "pitchers", 
                    label = "Select pitcher:", 
                    choices = unique(allPhilsPitchers19$pitcher_name))
      ,radioButtons(inputId = "pitchType",
                    label = "Select pitch type:",
                    #choices = unique(allPhilsPitchers19$mlbam_pitch_name),
                    choiceNames = list("Changeup","Curveball","Cutter","Fastball",
                      "Two-seam Fastball","Four-seam Fastball","Knuckle-curve","Sinker","Slider"),
                    choiceValues = list("CH","CU","FC","FS","FT","FF","KC","SI","SL")
                    )

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      tabPanel("distPlot",plotOutput("distPlot"))
      
    ) 
  ) #End sidebarLayout  
  ), #End Pitcher Velocity tabPanel
  
  #begin Heat Maps tab
  tabPanel("Heat Maps",
  sidebarLayout(
      sidebarPanel(
        radioButtons(inputId = "pitchersheat", 
                     label = "Select pitcher:", 
                     choices = unique(allPhilsPitchers19$pitcher_name)),
        #selectInput("inSelect", "pick a date:", choices = allPhilsPitchers19$dateStamp)#,
        uiOutput("secondOne"),
        h6("CH-Changeup"),h6("CU-Curveball"),h6("FC-Cutter"),h6("FS-Fastball"),
        h6("FT-Two-seam Fastball"),h6("FF-Four-seam Fastball"),h6("KC-Knuckle-curve"),
        h6("SI-Sinker"),h6("SL-Slider")
      ),
      mainPanel(tabPanel("theHeatMap",plotOutput("theHeatMap")))
    )
  ),
  
  #begin Pitch Progression tab
  tabPanel("Pitch Speed Progression",
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "pitchersProg", 
                  label = "Select pitcher:", 
                  choices = unique(allPhilsPitchers19$pitcher_name)),
      #selectInput("inSelect", "pick a date:", choices = allPhilsPitchers19$dateStamp)#,
      uiOutput("thirdOne"),
      h6("Only reflects fastballs (FF) currently")
      ),
      mainPanel(tabPanel("theProgPlot",plotOutput("theProgPlot")))
    )
  )
  
  ) #End navbarPage
)