#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that plots linear model and
#predicts the circumference of a tree given the age or viceversa
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Growth of Orange Trees"),
    
    # Sidebar with slider input for age and circumference 
    sidebarLayout(
        sidebarPanel(
            sliderInput("age", 
                        "Age in days", min = 100, max = 1800, value = 900, step=50),
            sliderInput("circ", 
                        "Circumference in mm", min = 20, max = 300, value = 120, step=10)
           ),
        
        #Main Pamel with tabs: in one is the circumference predicted, given the age, 
        # in the other one is the age predicted given the circumference. in the last
        # is the help
        mainPanel( 
            tabsetPanel(type="tabs",
                tabPanel("Predict Circumference", br(), 
                         plotOutput("PlotCirc", brush=brushOpts(id="brushCirc")),
                         h5("Predicted Circumference (mm): "), 
                         textOutput("PredCirc"), 
                         h5("Predicted Circumference (mm) -- Model based on brushed points: "), 
                         textOutput("PredCirc2") ), 
                tabPanel("Predict Age", br(), 
                         plotOutput("PlotAge", brush=brushOpts(id="brushAge")),
                         h5("Predicted Age (days): "), 
                         textOutput("PredAge"),
                         h5("Predicted Age (days) -- Model based on brushed points: "),
                         textOutput("PredAge2") ),
                tabPanel ("Help", br(),
                          h5("We use the Orange datasets to build two linear models."),
                          h5("In the first one (Panel Predict Circumference), the circumference 
                             of the orange tree is predicted on the base of the age. 
                             One can choose an age (in days) from the slider on the left, 
                             and the prediction for the circumference appears below the graphic."), 
                          h5("Moreover it is possible to brush a set of points and then a model 
                             based only on those points will be built. 
                             A second prediction based on this model is also shown."),
                        h5 ("In the second panel (Panel Predict Age) we take the opposite point of view
                            and try to predict the age of the tree based on its circumference. 
                            On the slider on the left it is possible to choose a value for the 
                            circumference (in mm) and the prediction for the age will be 
                            shown below the graphic."),
                         h5("Here it is possible to brush a set of points too and build a model 
                            just based on those points. A second prediction is given."))
                )
            
        )
    )
))
