shinyUI(
    dashboardPage(
    
    #Título dashboard
    dashboardHeader(title = "Vinos Dashboard"),
    
    #Contenidos del sidebar
    dashboardSidebar(
      sidebarMenu(
        menuItem("Información General", tabName = "general", icon = icon("info")),
        menuItem("Datos", tabName = "tabla", icon = icon("table")),
        menuItem("EDA",tabName = "eda",icon = icon("magnifying-glass")),
        menuItem("CRUD",tabName = "crud", icon = icon("recycle"),
          menuSubItem("Model Results",tabName = "resultado", icon = icon("chart-line")),
          menuSubItem("Create",tabName = "añadir", icon = icon("upload")),
          menuSubItem("Update",tabName = "actualizar", icon = icon("arrows-rotate")),
          menuSubItem("Delete",tabName = "borrar", icon = icon("trash-alt"))
        )
      )
    ),
    
    #Body content
    dashboardBody(
      tabItems(
        tabItem(tabName="general",
                fluidPage(
                 titlePanel("Descripción DB"), 
                 div(shiny::includeMarkdown("aboutDB.md"), 
                     align="justify")
                ) #fin fluidPage
              ), #fin tabIem(), general

        tabItem(tabName = "tabla",
                fluidPage(
                  # Titulo del panel
                  titlePanel("Registros de cada vino y sus características"),
                  # Objetos graficos de este panel
                  fluidRow(column(width = 10,
                                  h3("Registros de cada vino y sus características")
                  ),
                  column(width = 2,
                         downloadButton(outputId = 'wine.csv',
                                        label = "Descargar .csv")
                  )
                  ) #fin fluidRow
                ), #fin fluidPage
                  fluidRow(column(width = 12,
                        DT::dataTableOutput("tabla_datos")))
        ), #fin del tab tabla
        
        #Contenido del tab EDA
        tabItem(tabName = "eda",
                fluidRow(
                  #Grafica 1
                  box(plotOutput("caract",height = 250)),
                  
                  #Grafica 2
                  box(plotOutput("scatter",height = 250)),
                  
                  #INPUTS de caracteristicas quimicas del vino

                  #Desplegar carateristicas que el usuario puede comparar
                  box(
                    title = "Características",
                    selectInput("char", label = "Por favor seleccione la característica que desea explorar...",
                                choices = list(
                                  "pH" = 'ph',
                                  "Densidad" = 'density',
                                  "Cantidad de alcohol" = 'alcohol',
                                  "Acidez fija" = 'fixed_acidity',
                                  "Acidez volatil" = 'volatile_acidity',
                                  "Cítricos" = 'citric_acid',
                                  "Azucar residual" = 'residual_sugar',
                                  "Cloruros" = 'chlorides',
                                  "Azufre libre" = 'free_sulfur_dioxide',
                                  "Azufre total" = 'total_sulfur_dioxide',
                                  "Sulfatos" = 'sulphates'
                                ),
                                selected = 'ph')
                  ),
                  
                  #Seleccionar tipo de vino
                  box(
                    title = "Tipo de vino",
                      checkboxGroupInput("tipo", "selecciona el tipo de vino?",
                                   list(
                                     "Rojo"="red",
                                     "Blanco"="white"
                                   ),selected = "red")
                      )
                  )
                ),
        #Contenido del tab Create
        tabItem(tabName = "añadir",
                # Titulo del panel
                titlePanel("Create"),
                fluidRow(

                fluidRow(
                    #Cajas input
                  #acidez-fija
                  box(
                    title = "Característica 1",
                    numericInput(inputId ="acidezfija_s", label = "Acidez fija",value=1)
      
                  ),
                  #acidez-volatil
                  box(
                    title = "Característica 2",
                    numericInput(inputId ="acidezvolatil_s", label = "Acidez volatil",value=2)
      
                  ),
                  #acid-citric
                  box(
                    title = "Característica 3",
                    numericInput(inputId ="acidcitric_s", label = "Citricos",value=3)
      
                  ),
                  #azucar-residual
                  box(
                    title = "Característica 4",
                    numericInput(inputId = "azucarresidual_s", label = "Azucar",value=4)
                    
                  ),

                  #cloruros
                  box(
                    title = "Característica 5",
                    numericInput(inputId = "cloruros_s", label = "CLoruros",value=5)
                    
                  ),

                 #so4 libre 
                  box(
                    title = "Característica 6",
                    numericInput(inputId = "so4libre_s", label = "SO4 libre",value=6)
                    
                  ),
                  #so4-total
                   box(
                    title = "Característica 7",
                    numericInput(inputId = "so4total_s", label = "SO4 total",value=7)
                    
                  ),
                  
                  #densidad
                   box(
                    title = "Característica 8",
                    numericInput(inputId = "densidad_s", label = "Densidad",value=8)
                    
                  ),

                  #PH
                   box(
                    title = "Característica 9",
                    numericInput(inputId = "PH_s", label = "pH",value=9)
                    
                  ),

                  #sulfatos
                   box(
                    title = "Característica 10",
                    numericInput(inputId = "sulfatos_s", label = "Sulfatos",value=10)
                    
                  ),


                  #sulfatos
                   box(
                    title = "Característica 11",
                    numericInput(inputId = "alcohol_s", label = "Alcohol",value=11)
                    
                  ),

                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Caracteristica 12",
                    numericInput("calidad_s", label="Calidad",value=6)
                  ),

                  box(
                    title = "Caracteristica 13",
                      checkboxGroupInput("tipo_s", "Tipo de vino",
                                   list(
                                     "Rojo"="red",
                                     "Blanco"="white"
                                   ),selected = "red")
                      ),
                      
                  column(width = 2,
                         actionButton("submit", "Añadir registro") # boton para submitear nuevos datos
                  )
                ) #end fluidrow de crear

                )
                ),

        tabItem(tabName = "actualizar",
                # Titulo del panel
                titlePanel("Actualizar"),
                fluidRow(

                fluidRow(
                    #Cajas input                

                  #ID
                  box(
                    title = "Introduzca el ID  del registro a Actualizar",
                    numericInput("IDactualizar_u", "ID", value = 0)
                  ),                 

                  #acidez-fija
                  box(
                    title = "Característica 1",
                    numericInput(inputId ="acidezfija_u", label = "Acidez fija",value=0)
      
                  ),
                  #acidez-volatil
                  box(
                    title = "Característica 2",
                    numericInput(inputId ="acidezvolatil_u", label = "Acidez volatil",value=0)
      
                  ),
                  #acid-citric
                  box(
                    title = "Característica 3",
                    numericInput(inputId ="acidcitric_u", label = "Citricos",value=0)
      
                  ),
                  #azucar-residual
                  box(
                    title = "Característica 4",
                    numericInput(inputId = "azucarresidual_u", label = "Azucar",value=0)
                    
                  ),

                  #cloruros
                  box(
                    title = "Característica 5",
                    numericInput(inputId = "cloruros_u", label = "CLoruros",value=0)
                    
                  ),

                 #so4 libre 
                  box(
                    title = "Característica 6",
                    numericInput(inputId = "so4libre_u", label = "SO4 libre",value=0)
                    
                  ),
                  #so4-total
                   box(
                    title = "Característica 7",
                    numericInput(inputId = "so4total_u", label = "SO4 total",value=0)
                    
                  ),
                  
                  #densidad
                   box(
                    title = "Característica 8",
                    numericInput(inputId = "densidad_u", label = "Densidad",value=0)
                    
                  ),

                  #PH
                   box(
                    title = "Característica 9",
                    numericInput(inputId = "PH_u", label = "pH",value=0)
                    
                  ),

                  #sulfatos
                   box(
                    title = "Característica 10",
                    numericInput(inputId = "sulfatos_u", label = "Sulfatos",value=0)
                    
                  ),


                  #sulfatos
                   box(
                    title = "Característica 11",
                    numericInput(inputId = "alcohol_u", label = "Alcohol",value=0)
                    
                  ),

                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Caracteristica 12",
                    numericInput("calidad_u", label="Calidad",value=0)
                  ),

                  box(
                    title = "Caracteristica 13",
                      checkboxGroupInput("tipo_u", "Tipo de vino",
                                   list(
                                     "Rojo"="red",
                                     "Blanco"="white"
                                   ),selected = "red")
                      ),
                      
                  column(width = 2,
                         actionButton("update", "Actualizar registro") # boton para submitear nuevos datos
                  )
                ) #end fluidrow de predecir

                )
                ),

        tabItem(tabName = "resultado",
                # Titulo del panel
                titlePanel("Predecir"),
                fluidRow(
                  #Cajas input
                  #acidez-fija
                  box(
                    title = "Característica 1",
                    numericInput(inputId ="acidezfija_c", label = "Acidez fija",value=7.3)
      
                  ),
                  #acidez-volatil
                  box(
                    title = "Característica 2",
                    numericInput(inputId ="acidezvolatil_c", label = "Acidez volatil",value=0.65)
      
                  ),
                  #acid-citric
                  box(
                    title = "Característica 3",
                    numericInput(inputId ="acidcitric_c", label = "Citricos",value=0)
      
                  ),
                  #azucar-residual
                  box(
                    title = "Característica 4",
                    numericInput(inputId = "azucarresidual_c", label = "Azucar",value=1.2)
                    
                  ),

                  #cloruros
                  box(
                    title = "Característica 5",
                    numericInput(inputId = "cloruros_c", label = "CLoruros",value=0.065)
                    
                  ),

                 #so4 libre 
                  box(
                    title = "Característica 6",
                    numericInput(inputId = "so4libre_c", label = "SO4 libre",value=15)
                    
                  ),
                  #so4-total
                   box(
                    title = "Característica 7",
                    numericInput(inputId = "so4total_c", label = "SO4 total",value=21)
                    
                  ),
                  
                  #densidad
                   box(
                    title = "Característica 8",
                    numericInput(inputId = "densidad_c", label = "Densidad",value=0.9946)
                    
                  ),

                  #PH
                   box(
                    title = "Característica 9",
                    numericInput(inputId = "PH_c", label = "pH",value=3.39)
                    
                  ),

                  #sulfatos
                   box(
                    title = "Característica 10",
                    numericInput(inputId = "sulfatos_c", label = "Sulfatos",value=0.47)
                    
                  ),


                  #sulfatos
                   box(
                    title = "Característica 11",
                    numericInput(inputId = "alcohol_c", label = "Alcohol",value=10)
                    
                  ),

                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Calidad pronósticada",
                    textOutput(outputId = "prediccion_text")
                  ),
                  column(width = 2,
                         actionButton("confirmar", "Confirmar") # boton para submitear nuevos datos
                  ),

                  column(width = 2,
                         actionButton("predecir", "Predecir") # boton para submitear nuevos datos
                  )
                ) #end fluidrow de predecir
        ), # end predecir
        

        tabItem(tabName = "borrar",
                # Titulo del panel
                titlePanel("Delete"),
                fluidRow(
                      #Borrar registros a partir de su ID
                  box(
                    title = "Introduzca el ID  del registro a eliminar",
                    numericInput("IDreg_delete", "ID",value=6)
                  ),
                  column(width = 2,
                         actionButton("delete", "Borrar registro", 
                                      icon= icon("trash-alt") ) # boton para borrar datos
                  )
                        ) #end fluid row
        )#end tab item borrar
      ) # end tab items
    ) #end dashboard body 
  ) #end dashboardpage
) #end shinyapp