#Este archivo recibe, procesa y transforma datos que se mandan desde ui.R

shinyServer(function(input, output) {
url <- 'web:4999/'
response <- GET(url) #"https://geeksforgeeks.org"

#obtener base de datos en formato JSON
wine_data <- fromJSON(content(response, as='text'))

#variables tipo factor: calidad y tipo de vino
wine_data$quality <- as.factor(wine_data$quality)
wine_data$type <- as.factor(wine_data$type)

#variables tipo double: características químicas de los vinos
wine_data$density <- as.double(wine_data$density)
wine_data$fixed_acidity <- as.double(wine_data$fixed_acidity)
wine_data$volatile_acidity <- as.double(wine_data$volatile_acidity)
wine_data$citric_acid <- as.double(wine_data$citric_acid)
wine_data$residual_sugar <- as.double(wine_data$residual_sugar)
wine_data$chlorides <- as.double(wine_data$chlorides)
wine_data$free_sulfur_dioxide <- as.double(wine_data$free_sulfur_dioxide)
wine_data$ph <- as.double(wine_data$ph)
wine_data$sulphates <- as.double(wine_data$sulphates)
wine_data$alcohol <- as.double(wine_data$alcohol)
wine_data$total_sulfur_dioxide <- as.double(wine_data$total_sulfur_dioxide)


  #recibe las caracteristicas de un nuevo vino para predecir su calidad:
  observeEvent(input$confirmar,{
        POST('web:4999/predict', body=toJSON(data.frame(
          caract_dummy1=input$acidezfija_c,
          caract_dummy2=input$acidezvolatil_c, 
          caract_dummy3=input$acidcitric_c, 
          caract_dummy4=input$azucarresidual_c,
          caract_dummy5=input$cloruros_c,
          caract_dummy6=input$so4libre_c,
          caract_dummy7=input$so4total_c,
          caract_dummy8=input$densidad_c,
          caract_dummy9=input$PH_c,
          caract_dummy10=input$sulfatos_c,
          caract_dummy11=input$alcohol_c)))
    })

  #RECIBE las caracteristicas de un nuevo vino y las manda a la AṔI para añadirlas a PG:
  observeEvent(input$submit,{
        POST('web:4999/submit', body=toJSON(data.frame(
          caract_dummy0=input$tipo_s,
          caract_dummy1=input$acidezfija_s,
          caract_dummy2=input$acidezvolatil_s, 
          caract_dummy3=input$acidcitric_s, 
          caract_dummy4=input$azucarresidual_s,
          caract_dummy5=input$cloruros_s,
          caract_dummy6=input$so4libre_s,
          caract_dummy7=input$so4total_s,
          caract_dummy8=input$densidad_s,
          caract_dummy9=input$PH_s,
          caract_dummy10=input$sulfatos_s,
          caract_dummy11=input$alcohol_s,
          caract_dummy12=input$calidad_s
          )))
    })

 #recibe el ID de un registro y lo mapea en formato JSON a la ruta /delete
 observeEvent(input$delete,{
  POST('web:4999/delete', body=toJSON(data.frame(
    caract_delid = input$IDreg_delete))
  )
  url <- 'web:4999/'
  response <- GET(url) #"https://geeksforgeeks.org"
  wine_data <- fromJSON(content(response, as='text'))
  #Variables como factor
  wine_data$quality <- as.factor(wine_data$quality)
  wine_data$type <- as.factor(wine_data$type)
  })

 observeEvent(input$update,{
  POST('web:4999/update', body=toJSON(data.frame(
          caract_dummyid=input$IDactualizar_u,
          caract_dummy0=input$tipo_u,
          caract_dummy1=input$acidezfija_u,
          caract_dummy2=input$acidezvolatil_u, 
          caract_dummy3=input$acidcitric_u, 
          caract_dummy4=input$azucarresidual_u,
          caract_dummy5=input$cloruros_u,
          caract_dummy6=input$so4libre_u,
          caract_dummy7=input$so4total_u,
          caract_dummy8=input$densidad_u,
          caract_dummy9=input$PH_u,
          caract_dummy10=input$sulfatos_u,
          caract_dummy11=input$alcohol_u,
          caract_dummy12=input$calidad_u))
  )
  url <- 'web:4999/'
  response <- GET(url) #"https://geeksforgeeks.org"
  wine_data <- fromJSON(content(response, as='text'))
  #Variables como factor
  wine_data$quality <- as.factor(wine_data$quality)
  wine_data$type <- as.factor(wine_data$type)
  })



#RECIBE de la API, el valor predicho para calidad de vino
 observeEvent(input$predecir,{
  prediccion <- GET('web:4999/predict')
  df <- fromJSON(content(prediccion, as='text'))
  output$prediccion_text = renderPrint(df)
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

