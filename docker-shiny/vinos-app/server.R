shinyServer(function(input, output) {
  observeEvent(input$submit,{
        POST('web:4999/predict', body=toJSON(data.frame(
          caract_dummy1=input$acidezfija,
          caract_dummy2=input$acidezvolatil, 
          caract_dummy3=input$acidcitric, 
          caract_dummy4=input$azucarresidual,
          caract_dummy5=input$cloruros,
          caract_dummy6=input$so4libre,
          caract_dummy7=input$so4total,
          caract_dummy8=input$densidad,
          caract_dummy9=input$PH,
          caract_dummy10=input$sulfatos,
          caract_dummy11=input$alcohol)))
    }) 

    
#Tab Datos
    #Tabla
    output$tabla_datos <- renderDataTable(expr = wine_data,
                                            options = list(pageLength = 10)
    )
    
    
    #Boton Descargar 
    output$wine.csv <- downloadHandler(contentType = 'text/csv',
                                                filename = 'winequality-red-raw.csv.csv',
                                                content = function(file) {
                                                  write.csv(wine_data, file, row.names = FALSE)
                                                }
    )
    
    #Tab EDA
    output$plot1 <- renderPlot({
      data <- histdata[seq_len(input$slider)]
      hist(data)
    })
    
    output$plot2 <- renderPlot({
      data <- histdata[seq_len(input$slider)]
      hist(data)
    })
    
    output$caract <- renderPlot({
      req(input$char)
      data <- wine_data %>% 
        filter(type == input$tipo) %>% 
        select(quality, input$char)
      ggplot(data = data)+geom_boxplot(aes_string(x = "quality", y = input$char), 
                                       color="red", fill="orange", alpha=0.2)
    })
    
    output$scatter <- renderPlot({
      req(input$char)
      data <- wine_data %>%
        filter(type == input$tipo) 
        
      ggplot(data = data)+geom_point(aes_string(x = "ph", y = input$char,color='quality'))
    })
  
  })
