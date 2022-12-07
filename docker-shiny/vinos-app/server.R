shinyServer(function(input, output) {
  observeEvent(input$submit,{
        POST('web:4999/predict', body=toJSON(data.frame(
          caract_dummy1=input$PH,
          caract_dummy2=input$densidad, 
          caract_dummy3=input$alcohol, 
          caract_dummy4=input$tipo)))
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
