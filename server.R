#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    #linear model to predict circumference
    modelCirc<-lm(circumference~age, data=Orange)
    #linear model to predict age
    modelAge<-lm(age~circumference, data=Orange)
    #linear model to predict circumference only with the brushed points
    modelCirc2<-reactive({
        brushed_circ<-brushedPoints(Orange, input$brushCirc, 
                                    xvar="age", yvar="circumference")
        if (nrow(brushed_circ)<2){return(NULL)}
        lm(circumference~age, data=brushed_circ)
        })
    #linear model to predict age only with the brushed points
    modelAge2<-reactive({
        brushed_age<-brushedPoints(Orange, input$brushAge, 
                                   yvar="age", xvar="circumference")
        if (nrow(brushed_age)<2){return(NULL)}
        lm(age~circumference, data=brushed_age)
         })
    #predicted circumference with first model
    PredCirc<-reactive({ 
          A<-input$age
          predict(modelCirc, data.frame(age=A))
          })
    output$PredCirc<-renderText(PredCirc())
    #predicted circumference with second model
    PredCirc2<-reactive({ 
        if(!is.null(modelCirc2())){
        A<-input$age
        predict(modelCirc2(), data.frame(age=A))}
        else return(NULL)
    })
    output$PredCirc2<-renderText(PredCirc2())
    #Predicted Age with first model
    PredAge<-reactive({ 
          C<-input$circ
          predict(modelAge, data.frame(circumference=C))
            })
    output$PredAge<-renderText(PredAge())
    #predicted age with second model
    PredAge2<-reactive({ 
        if(!is.null(modelAge2())){
            C<-input$circ
            predict(modelAge2(), data.frame(circumference=C))}
        else return(NULL)
    })
    output$PredAge2<-renderText(PredAge2())
    #plot model where circumference is predicted
    output$PlotCirc <- renderPlot({
            g<-ggplot(Orange, aes(x=age, y=circumference))+
                geom_point(size=3, shape=21, aes(fill=Tree))+
                scale_fill_manual(
                   values=c("goldenrod1","chartreuse2", "chartreuse3", "dodgerblue2", "deepskyblue4"))+
                geom_line(aes(x=age, y=circumference, color=model),data=data.frame(age=Orange$age, circumference=predict(modelCirc, data.frame(age=Orange$age)), model="All Points"), size=0.8)+
                scale_color_manual("Model", values=c("firebrick1", "navy"))+                
                geom_point(data=data.frame(age=input$age, circumference=PredCirc()), size=5, color="firebrick1")+
                labs(x="Age (days)", y="Circumference (mm)")
            if(!is.null(modelCirc2()))
                g<-g+
                geom_line(aes(x=age, y=circumference, color=model),data=data.frame(age=Orange$age, circumference=predict(modelCirc2(), data.frame(age=Orange$age)), model="Brushed Points"),   size=0.8)+
                geom_point(data=data.frame(age=input$age, circumference=PredCirc2()), size=5, color="navy")
    g
    })
    #plot model where age is predicted
    output$PlotAge<-renderPlot({
          g<-ggplot(Orange, aes(x=circumference, y=age))+
              geom_point(size=3,shape=21, aes(fill=Tree))+
              scale_fill_manual(
                  values=c("goldenrod1","chartreuse2", "chartreuse3", "dodgerblue2", "deepskyblue4"))+
              geom_line(aes(y=age,x=circumference, color=model),data=data.frame(circumference=Orange$circumference, age=predict(modelAge, data.frame(circumference=Orange$circumference)), model="All Points"),   size=0.8)+
              scale_color_manual("Model", values=c("firebrick1", "navy"))+   
              geom_point(data=data.frame(age=PredAge(), circumference=input$circ), size=5, color="firebrick1")+
              labs(y="Age (days)", x="Circumference (mm)")
     if(!is.null(modelAge2()))
              g<-g+
              geom_line(aes(y=age, x=circumference, color=model),data=data.frame(circumference=Orange$circumference, age=predict(modelAge2(), data.frame(circumference=Orange$circumference)), model="Brushed Points"),  size=0.8)+
              geom_point(data=data.frame(age=PredAge2(), circumference=input$circ), size=5, color="navy")
     g
     })
  
})
