
# This is the server logic for a Shiny web application.
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

### Pitcher Velocity Page ###

server <- function(input, output, session) {
  output$distPlot <- renderPlot({
    
  showPitcher    <- reactive({input$pitchers})
  showPitch      <- reactive({input$pitchType})
  
    
    x3   <- allPhilsPitchers19[which(allPhilsPitchers19$pitcher_name==showPitcher()),]
    x2   <- x3[which(x3$mlbam_pitch_name==showPitch()),]
    x    <- x2$start_speed
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Pitch Speed",
         main = "Distribution of Pitch Speeds")
    
  })

### Heat Map Page ####
  
  output$secondOne <- renderUI({
  
    z <- input$pitchersheat
    z2 <- allPhilsPitchers19[which(allPhilsPitchers19$pitcher_name==z),]
    z3 <- unique(z2$dateStamp,1,10)
    selectInput(inputId = "pitchDates",
                label = "Select Game Date:",
                choices = z3
                ) 
  
  })
  
  
     #below will output to proper place on Heat Map page *thumbs up*
  output$theHeatMap <- renderPlot({
    
    showPitcher2    <- reactive({input$pitchersheat})
    showDate      <- reactive({input$pitchDates})
    
    
    x3x   <- allPhilsPitchers19[which(allPhilsPitchers19$pitcher_name==showPitcher2()),]
    pitcherGamesByDate   <- x3x[which(x3x$dateStamp==showDate()),]
    
    myKey <- list(space="right",
                  border=TRUE,
                  cex.title=.8,
                  superpose.symbol=list(pch=19),
                  title="pitch type",
                  #text=pitchnames,
                  padding.text=4)
    
    #assign top, bottom and sides of strike zone
    topKzone <- 3.5
    botKzone <- 1.6
    inKzone <- -.95
    outKzone <- 0.95
    
    #plot the heat map
    xyplot(pz ~ px | stand, data=pitcherGamesByDate, groups=mlbam_pitch_name,
           strip=strip.custom(factor.levels=c("Left-handed hitter","Right-handed hitter")),
           auto.key=myKey,
           par.settings = myKey,
           aspect="iso",
           xlim=c(-2.2, 2.2),
           ylim=c(0, 5),
           xlab="horizontal location\n(ft. from middle of plate)",
           ylab="vertical location\n(ft. from ground)",
           panel=function(...){
             panel.xyplot(...)
             panel.rect(inKzone, botKzone, outKzone, topKzone,
                        border="black", lty=3)
           })
  })
  
### Pitch Progression Page #### 
  
  output$thirdOne <- renderUI({
    
    zed <- input$pitchersProg
    zed2 <- allPhilsPitchers19[which(allPhilsPitchers19$pitcher_name==zed),]
    zed3 <- unique(zed2$dateStamp)
    selectInput(inputId = "pitchDatesII",
                label = "Select Game Date:",
                choices = zed3
    ) 
    
  })
  
  output$theProgPlot <- renderPlot({
    
    showPitcher3    <- reactive({input$pitchersProg})
    showDate2      <- reactive({input$pitchDatesII})
    
    x3y   <- allPhilsPitchers19[which(allPhilsPitchers19$pitcher_name==showPitcher3()),]
    pitcherGamesByDateProg   <- x3y[which(x3y$dateStamp==showDate2()),]
    
    F4fastballs <- subset(pitcherGamesByDateProg, mlbam_pitch_name == "FF")
    avgSpeed <- aggregate(start_speed ~ mlbam_pitch_name + pitchStamp + pitcher_name +
                          dateStamp, data=F4fastballs, FUN=mean) 
    
    xyplot(start_speed ~ pitchStamp | factor(substr(dateStamp,1,10)),
           data=avgSpeed,
           type = c("p","r"),
           xlab="n Pitch of Game",
           ylab="Pitch Speed",
           panel=function(...){
             panel.xyplot(...)
             panel.abline(v=75, lty="dotted")
           })
    
  })
}

#deploy 
