library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(DT)

shinyUI(
  fluidPage(
    dashboardPage(
      skin = 'red',
      options = list(sidebarExpandOnHover = TRUE),
      header = dashboardHeader(
        title = 'CieLAB'
      ),
      sidebar = dashboardSidebar(
        minified = FALSE, 
        collapsed = FALSE,
        textInput(
          inputId = 'L',
          label = 'L'
        ),
        textInput(
          inputId = 'a',
          label = 'a'
        ),
        textInput(
          inputId = 'b',
          label = 'b'
        ),
        actionButton(
          inputId = 'coordinates',
          label = 'Go with coordinates!'
        ),
        tags$br(),
        fileInput(
          inputId = 'filexlsx',
          label = 'Upload a xlsx file',
          multiple = F,
          width = 300
        ),
        actionButton(
          inputId = 'xlsx',
          label = 'Go with Excel!'
        )
      ),
      body = dashboardBody(
        tagList(
            mainPanel(
              width = 12,
              tabsetPanel(
                type = 'tabs',
                tabPanel(
                  'Graph',
                  tags$hr(),
                  plotly::plotlyOutput('graph')
                ),
                tabPanel(
                  'Data Table',
                  tags$hr(),
                  DT::dataTableOutput('table1')
                )
              )
            )
        ) 
      ),
      controlbar = dashboardControlbar(disable = T),
      title = "CieLAB Graph"
    )
  )
)
