library(shiny)
library(readxl)
library(DT)
library(purrr)
library(stringr)

shinyServer(function(input, output, session) {
  
  data_excel <- reactiveValues(data = NULL)
  
  observeEvent(input$xlsx, data_excel$data <- readxl::read_excel(input$filexlsx$datapath))
  observeEvent(input$coordinates, data_excel$data <- data.frame(L = input$L, a = input$a, b = input$b))
  
  output$table1 <- DT::renderDataTable({
    
    data <- data_excel$data
    
    vector_1 <- c()
    for (i in 1:length(data$L)){
      data_2 <- paste0(data$L[i], ' ', data$a[i], ' ', data$b[i])
      vector_1 <- c(vector_1, data_2)
    }
    
    convert_lab2rgb <- function(x){
      x %>% 
        unlist() %>% 
        convertColor(from='Lab', to='sRGB') %>%
        as.vector()
    }
    
    
    convert_rgb2hex <- function(x){
      x %>% 
        unlist() %>% 
        `*`(255) %>% 
        round() %>% 
        as.hexmode() %>% 
        paste(collapse='') %>% 
        paste0('#', ., collapse='')    
    }
    
    
    vector_color <- vector_1 %>% 
      map(~ str_split(., pattern=' ')[[1]]) %>% 
      map(as.numeric) %>%
      map(convert_lab2rgb) %>% 
      map(convert_rgb2hex)
    
    vector_color_1 <- c()
    
    for(j in 1:length(vector_color)){
      vector_color_1 <- c(vector_color_1, vector_color[[j]])
    }
    
    data$Colors <- vector_color_1
    
    DT::datatable(
      data = data,
      filter = 'top', extensions = c('Buttons', 'Scroller'),
      options = list(deferRender = TRUE,
                     paging = TRUE,
                     pageLength = 12,
                     buttons = list('excel',
                                    list(extend = 'colvis', targets = 0, visible = FALSE)),
                     dom = 'lBfrtip',
                     fixedColumns = TRUE), 
      rownames = FALSE)
  })
  
  output$graph <- plotly::renderPlotly({
    
    data <- data_excel$data
    
    vector_1 <- c()
    for (i in 1:length(data$L)){
      data_2 <- paste0(data$L[i], ' ', data$a[i], ' ', data$b[i])
      vector_1 <- c(vector_1, data_2)
    }
    
    convert_lab2rgb <- function(x){
      x %>% 
        unlist() %>% 
        convertColor(from='Lab', to='sRGB') %>%
        as.vector()
    }
    
    
    convert_rgb2hex <- function(x){
      x %>% 
        unlist() %>% 
        `*`(255) %>% 
        round() %>% 
        as.hexmode() %>% 
        paste(collapse='') %>% 
        paste0('#', ., collapse='')    
    }
    
    
    vector_color <- vector_1 %>% 
      map(~ str_split(., pattern=' ')[[1]]) %>% 
      map(as.numeric) %>%
      map(convert_lab2rgb) %>% 
      map(convert_rgb2hex)
    
    vector_color_1 <- c()
    
    for(j in 1:length(vector_color)){
      vector_color_1 <- c(vector_color_1, vector_color[[j]])
    }
    
    data$Colors <- vector_color_1
    
    plotly::plot_ly(
      data = data,
      x = ~a,
      y = ~b,
      z = ~L,
      marker = list(color = data$Colors),
      size = 0.8,
      height = 600
      )
    
  })
  
})
