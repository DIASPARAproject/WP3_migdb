#------------------------------------------------------------------------------------#
# -----------------------------------------------------------------------------------#
#----------------------------- WGNAS-SalmoGlob ToolBox ------------------------------
# -----------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
########################## Hernvann Pierre-Yves - 07.07.21  ##########################


#------------------------------------------------------------------------------------#
# ------------------ Preliminary #1 Loading the required packages --------------------
#------------------------------------------------------------------------------------#
# stop()
library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(png)
library(shinyjs)
library(DT)
library(DBI)
library(tibble)
library(tidyr)
library(stringr)
library(tidyverse)
library(lubridate)
library(cgwtools)
library(RPostgreSQL)
library(RColorBrewer)
library(reshape)
library(reshape2)
library(openxlsx)

#------------------------------------------------------------------------------------#
# -------------- Preliminary #2 Loading Salmon data from the SIRS Server ------------
#------------------------------------------------------------------------------------#

# We open a connection to the online database to load the first version of each table
# that should be displayed when opening the application
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host = "localhost", user = "postgres", password = "postgres", dbname = "salmoglob_diaspara")
# Load the tables from the database
database_mother <- dbReadTable(con, "database")
database_archive <- dbReadTable(con, "database_archive")
tab_type_object <- dbReadTable(con, "metadata")
tab_labels <- dbReadTable(con, "area_labels")
tab_users <- dbReadTable(con, "users")
# Load the tables from the database
dbDisconnect(con)

#------------------------------------------------------------------------------------#
# ------------ Preliminary #3 Loading the functions called by the application---------
#------------------------------------------------------------------------------------#

# These functions qre used by the SERVER part of the application to plot outputs, updated data etc.
source("R/check_uploaded_data_format_varyingSU.R")
source("R/graph_functions.R")
source("R/manage_database.R")
source("R/formate_upload_data.R")
source("R/sort_upload_data.R")
source("R/function_explo_data.R")
source("R/calculate_updating_status.R")
source("R/functions_building_templates.R")
source("R/time_line_plot_by_type.R")

# Here we just specify a directory that will be used by the SERVER part of the application
outputDir <- "data"


#------------------------------------------------------------------------------------#
# -----------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
# ----------------------- Creating the App User Interface (UI)------------------------
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
# -----------------------------------------------------------------------------------#

# An Shiny App has two main components:
# - the UI, which contains what the user sees on his screen
# - the Server, which contains the functions executing what is requested
# by the user via the UI

#------------------------------------------------------------------------------------#
# ------------ UI #1 Definition of the header (top part of the App)-------------------
#------------------------------------------------------------------------------------#

# The header is in a way the frame of the App. By default, it prints the home page and display the
# navigation bar giving access to all tools available in the ToolBox.
header <-
  dashboardHeader(
    title = "WGNAS-SalmoGlob ToolBox",
    titleWidth = 380,
    tags$li(
      class = "dropdown",
      tags$a(
        sidebarMenu(
          id = "tabs", # hereafter we specify the tabs allowing to navigate among the App's tools
          # "text =" for the name displayed in the tab giving access to a tool, as visible for the user;
          # tabName is the name of the tab in the App vocabulary
          menuItem(text = "About the ToolBox", tabName = "toolbox", icon = icon("book")),
          menuItem(text = "SalmoDataVisu", tabName = "salmodatavizu", icon = icon("chart-bar")),
          menuItem(text = "SalmoHindcast", tabName = "salmoretro", icon = icon("backward")),
          menuItem(text = "SalmoForecast", tabName = "salmopred", icon = icon("forward")),
          menuItem(text = "SalmoDataCollect", tabName = "salmodatacollect", icon = icon("upload")),
          menuItem(text = "SalmoExport", tabName = "datacall", icon = icon("download")),
          menuItem(text = "WGNAS check DB", tabName = "dbchg", icon = icon("gear"))
        ),
        style = "padding-top: 0px;
                                    padding-right: 0px;
                                    padding-bottom: 0px;
                                    padding-left: 0px
                                    background-color:#e1e6ed;
                                    color:#e1e6ed;"
      )
    )
  )

#------------------------------------------------------------------------------------#
# ------------ UI #2 Definition of the sidebar of the UI -----------------------------
#------------------------------------------------------------------------------------#

# In the WGNAS-SalmoGlob ToolBox, we chose to use the sidebar as authentication device.

sidebar <-
  dashboardSidebar(
    width = "300",
    h2("User authentication"),
    p("Please provide your username and password to access to database update functionality."),
    textInput("Biencuits", placeholder = "Username", label = tagList(icon("user"), "Username")), # asks for a username
    passwordInput("Coockies", placeholder = "Password", label = tagList(icon("unlock-alt"), "Password")), # asks for a password
    strong(textOutput("welcome")),
    actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                           padding: 10px 15px; width: 150px; cursor: pointer;
                                        font-size: 18px; font-weight: 600;"), # this actionButton is used to validate the authentification (click to identify)
    uiOutput("logoutbtn"), # logoutbtn is a button to allow the identified user to disconnect. It is coded as un uiOutput so that it is
    # only clickable when a user is already authentified and connected
    p("To request username and personal password, please ", a(href = "mailto:etienne.rivot@agrocampus-ouest.fr", "contact us.")),
    img(src = "salmoglob_logo.png", align = "center", height = "115"),
    img(src = "ices_wgnas.PNG", align = "center", height = "115"),
    br(),
    br(),
    em("The SalmoGlob Team"),
    collapsed = TRUE
  )

#------------------------------------------------------------------------------------#
# ------------ UI #3 Definition of body of the UI (rest of the UI) -------------------
#------------------------------------------------------------------------------------#

# The Body of the UI shapes the whole architecture of the App as visible by the user. In this part of
# the App, we design the visual aspect of each Tool.

body <-
  dashboardBody(
    tags$head(
      tags$style(HTML('
                      .main-header .logo {
                      font-family: "Georgia", Times, "Times New Roman", serif;
                      font-weight: bold;
                      font-size: 24px;
                      }
                      '))
    ),
    conditionalPanel(condition = "$('html').hasClass('shiny-busy')", tags$div("In Progress...", id = "loadmessage")), # This simply defines the loading bar when calculations are undergoing
    # This loading bar dissuades the user from clicking everywhere when some graphs are being prepared.

    tabItems( # Here we start defining all the Tool pages

      #-------------------------------------------------------------#
      # ------------ UI toolbox = HOME PAGE -------------------------
      #-------------------------------------------------------------#

      # This tool is pretty simple; it only displays text and gives access to downloadable documents.
      tabItem(
        tabName = "toolbox", # This is the home page

        fluidPage(
          box(
            width = 12, # Gives the main informations on the ToolBox
            img(src = "wgnas.PNG", height = "80", style = "display: block; margin-left: auto; margin-right: auto;"),
            br(),
            h5(
              "The ", strong("WGNAS-SalmoGlob ToolBox"), "supports and promotes Atlantic salmon stock assessment by the",
              a(href = "https://www.ices.dk/Pages/default.aspx", "ICES"), "Working Group on North Atlantic Salmon", a(href = "https://www.ices.dk/community/groups/Pages/WGNAS.aspx", "(WGNAS)."),
              "The ToolBox supports the Bayesian integrated life cycle model developed for the stock assessment and provision of multi-year catch advice."
            ),
            h5("All contents presented are from data and outputs of models from ICES WGNAS 2021 that held 22-31 March 2021, remotely."),
            h5("Time series of data used is 1971-2020."),
            h5(strong(span("Data and outputs presented for Scotland (East and West) are preliminary and non official data that should be updated definitely by the end of May 2021.", style = "color: red;"))),
            br(),
            h5(".	", strong("DataCollect"), "- Upload data as", em(".csv"), "files to update the online salmon database. [restricted access only; now inactive;
                                                accessible via ID and password later]"),
            h5(".	", strong("DataVisu"), "- Visualize all inputs used in the Life Cycle Model. [public access]"),
            h5(".	", strong("Hindcast"), "- Investigate the trends in a selection of variables predicted by the model fitted on the historical series of data (from 1971) and
                                                compare them to corresponding observed values when available."),
            h5(".	", strong("Forecast"), "- Explore the model predictions under different catch options and quantifies the probability to achieve management objectives. [public access]"),
            h5(".	", strong("Export"), "- Download all inputs used in the life cycle model as", em(".xlsx"), "templates for the yearly data call for single stock units or fisheries,
                                                or directly as Nimble objects (i.e. formatted as R-lists of data inputs with model variable names). [public access]")
          ),
          box(
            width = 12, # Gives access the Working Papers presenting the model and the application. In the text are called the download buttons to be displayed ("downloadWP***").
            # mThese buttons are defined in the SERVER.
            p(strong("Documentation")),
            h5(".	", "A Hierarchical Bayesian Life Cycle Model for Atlantic Salmon Stock Assessment at the North Atlantis Basin Scale - ICES WGNAS Working Paper 2021/26"), downloadLink("downloadWPmodel", "Download WP_2021_26"),
            h5(".	", "WGNAS-SalmoGlob ToolBox: A Web Application for Supporting Atlantic Salmon Stock Assessment at the Scale of the North Atlantic Basin Scale - ICES WGNAS Working Paper 2021/27"), downloadLink("downloadWPapp", "Download WP_2021_27")
          ),
          box(
            width = 12, # References and logos. You will note that no path is specified for specifying where to get the logos. It is "explicit": by default, the App will get them from the "www" folder
            p(strong("Support and funding")),
            p(
              "This application was developed as part of the SalmoGlob project, led by Etienne Rivot, Pierre-Yves Hernvann, Maxime Olmos, Rémi Patin Jérôme Guitton",
              a(href = "https://www6.rennes.inrae.fr/ese/", "(ESE,"), "Ecology and Ecosystem Health, Institut Agro, INRAE, France)."
            ),
            p("The SalmoGlob project received support and fundings from the Office Français pour la Biodiversité (MIAME Management of Diadromous Fishes and their Environment) and
                                                 from the", a(href = "https://samarch.org/", "SAMARCH"), "Interreg program."),
            strong("Maintainer: Pierre-Yves Hernvann"),
            strong("Contact:", a(href = "mailto:etienne.rivot@agrocampus-ouest.fr", "Etienne Rivot")),
            br(),
            img(src = "Logo-compose-Agro-SAMARCH-UE.png", align = "center", height = "150"),
            br(),
            img(src = "ia_ao_logo.png", align = "center", height = "80"),
            img(src = "inrae_logo.png", align = "center", height = "80"),
            img(src = "logo-ofb.png", align = "center", height = "110"),
            img(src = "salmoglob_logo.png", align = "center", height = "110")
          )
        )
      ),

      #------------------------------------------------------------------#
      # ------------ UI salmodatacollect = DATA UPADTING------------------
      #------------------------------------------------------------------#

      # This is actually a reactive tabItem

      tabItem(tabName = "salmodatacollect", uiOutput("bodymod")), # This is the Tool to update the database. Since the access is restricted, we call here a result of the SERVER part.
      # The related SERVER part will actually provide an UI-type object that is empty without successful authentication, and which contains a div object codinga functional "tabItem" otherwise.

      #------------------------------------------------------------------#
      #--- UI salmodatavizu = VISUAL EXPLORATION OF THE DATA--------------
      #------------------------------------------------------------------#
      # stop()

      tabItem(
        tabName = "salmodatavizu", # This is the Tool to explore the data currently present in the Salmon database

        # fluidPage is just a function to generate a page of the App (one page per App Tool) that can adapt to different sizes of browser windows.
        fluidPage(
          shinyjs::useShinyjs(),

          # headerPanel is used to set the title of the Tool
          headerPanel("Vizualizing up-to-date data"),

          # fluidRow is a function for organizing the fluidPage. All the elements specified in a fluidRow will be kept together, with no regard
          # to the size of the browser window. If the browser window is too small, the elements could be organized in column while keeping the order of succession
          # specified in fluidRow.
          fluidRow(

            # column function is another function for organizing the page. The default width is 12. The width is the first argument of the column function
            column(
              12, # actually, this first "column(12," should be optional but I kept it I don't remember why

              # Within the main page, on the first row (fluidRow), I decide to create a first column of width = 3/12 = 1/4  = one quarter of the page
              column(
                3,
                headerPanel("Select the data to be vizualized"), # The following Shiny Widgets are used to select what the user wants to visualize

                # "selectInput" allows to select one or several (controlled by "multiple=") items among a list displayed in "choices="
                # The content of one "selectInput" can be modified by updateselectInput; see later in the code.
                selectInput(
                  inputId = "datatype_explo",
                  strong("Select a data type"),
                  choices = c(
                    "", "Returns", "Homewater catches", "Sea catches",
                    "Origin distribution in sea catches", "Fecundity rate",
                    "Fecundity rate", "Sex ratio", "Survival rate",
                    "Proportion of delayed individuals", "Stocking",
                    "Smolt age structure", "Time spent at sea"
                  ),
                  selected = "",
                  multiple = F # One type of datatype only is allowed
                ),
                selectInput(
                  inputId = "age_explo",
                  label = strong(textOutput("typeage")),
                  choices = NULL,
                  multiple = T # allows to choose several ages
                ),
                selectInput(
                  inputId = "area_explo",
                  label = strong("Select the salmon origin area"),
                  choices = NULL,
                  multiple = T # allows to choose several areas
                ),
                selectInput(
                  inputId = "loc_explo",
                  label = strong("Select the location"),
                  choices = NULL,
                  multiple = T # this one is not systematically displayed
                ),

                # "radioButtons" allows to check one or several options. Here we use these buttons for graphical options of the plot
                radioButtons(
                  "unlog",
                  "Choose scale",
                  choices =
                    c(LogScale = "identity", UnlogScale = "exp"),
                  selected = "identity",
                  inline = T
                ),
                radioButtons(
                  "overlay",
                  "Group data by",
                  choices =
                    c("Areas" = "sw_age", "Ages" = "area"),
                  selected = "sw_age",
                  inline = T
                ),
                radioButtons(
                  "uncert",
                  "Uncertainty shade",
                  choices =
                    c(with = "with", without = "without"),
                  selected = "with",
                  inline = T
                ),
                radioButtons(
                  "scale",
                  "Windows scale",
                  choices =
                    c("all same" = "fixed", "auto" = "free"),
                  selected = "fixed",
                  inline = T
                )
              ),

              # Quite logically, I want that my second column has a width of 9/12 = 3/4  = three quarters of the page
              column(
                9,
                plotlyOutput("graph_explo", height = "800")
                # This plot the Graph built by the SERVER based on the selection criteria
                # "graph_explo" is the name of the R plot created in the SERVER that we want to visualize here.
              )
            )
          )
        )
      ),


      #-----------------------------------------------------------------#
      #--- UI salmoretro = EXPLORING THE HINDCAST ------------------------
      #------------------------------------------------------------------#

      # Similarly to the previous one, this interface displays graphs depending on the parameters chosen in the selectInput/radioButtons.
      # Nothing really difficult here except the corresponding SERVER part that will integrate many options to propose plotting options consistent
      # with the type of data that is plotted.

      tabItem(
        tabName = "salmoretro", # This is the Tool to explore model hindcast

        fluidPage(
          shinyjs::useShinyjs(),
          headerPanel("Explore model results (fit)"),
          fluidRow(
            tabBox(
              width = 12,

              # a tabPanel allows to display different contents within the same tabItem depending on the tab name on which you click
              tabPanel(
                "Exploring by variables",
                headerPanel("Select the outputs to be vizualized"), # The following Shiny Widgets are used to select what the user wants to visualize

                column(
                  12,
                  column(
                    3,
                    selectInput(
                      inputId = "datatype_out",
                      strong("Select a data type"),
                      choices =
                        c("Returns", "Sea catches", "Homewater catches"),
                      multiple = F
                    ),
                    selectInput(
                      inputId = "age_out",
                      label = strong("Select the sea winter age"),
                      choices = NULL,
                      multiple = F
                    ),
                    selectInput(
                      inputId = "area_out",
                      label = strong("Select the salmon origin area"),
                      choices = NULL,
                      multiple = F
                    ),
                    selectInput(
                      inputId = "subreg",
                      label = strong("Select the region"),
                      choices = NULL,
                      multiple = T
                    ),
                    radioButtons(
                      "var_hind",
                      "Catch data to plot",
                      choices =
                        c(
                          "Total catch" = "tot",
                          "Origin distribution" = "prop"
                        ),
                      selected = "tot",
                      inline = T
                    ), # This button allows to
                    # specify whether you want to see the catch data summed over all SU of a given complex or if you want to visualize the distribution among SU for this same complex.
                    radioButtons(
                      "propagg",
                      "Plot origin distribution by",
                      choices =
                        c(
                          "By complex" = "prop_bycplx",
                          "By NAC SU" = "prop_NAC",
                          "By NEC SU" = "prop_NEC"
                        ),
                      selected = "prop_bycplx",
                      inline = T
                    ),
                    # The .rds graph file to plot is found by the SERVER part using a combination of prefix/radical/suffix that I wanted to check with the following textOutput
                    # This textOutput can be removed later.
                    textOutput("check_loc_hind")
                  ),
                  column(
                    9,
                    plotlyOutput("plothindcast", height = "800") # This plot the Graph built by the SERVER based on the selection criteria
                  )
                )
              ),
              tabPanel(
                "Summary by area",
                p("... This part of the application is under construction") # In this App Tool, we plot the outputs of the hindcast by type of output. But we originally considered the option
                # of plotting summaries by area. Was first considered, but I did not have the time to develop it
              )
            )
          )
        )
      ),

      #---------------------------------------------------------------------#
      #--- UI salmopred = EXPLORING THE PROJECTIONS -------------------------
      #---------------------------------------------------------------------#

      # Again, similarly to the two prvious tools, this Tool provides a list of criteria to select a graph to plot. In this case, it displayes the forecast graphs.
      # Note that, nonetheless, there is a difference in the way that these graphs are plotted: in the previous version, the plot that is called is not generated by plotly;
      # Consequently, the data is not provided when hovering the mouse on the graph and the size of the plot eleLents does not adapt to the size of the window. This could be improved
      # in the future. It just requires to build the 9-facet graphs (9 key variables) differently (i.e., save each facet as a single graph file to load.)

      tabItem(
        tabName = "salmopred", # This is the Tool to explore model forecast

        fluidPage(
          shinyjs::useShinyjs(),
          headerPanel("Short-term predictions from the life cycle model"),
          mainPanel(
            width = 12,
            fluidRow(
              tabBox(
                width = 12,

                # Here we build 2 tabPanels, one for getting the summary of the forecasts across all areas, and one for plotting the results for a
                # specific area.
                tabPanel(
                  "Diagnosis per area",
                  headerPanel("Explore the results at a specific scale for a specific area"),
                  column(
                    12,
                    column(
                      3, # The following Shiny Widgets are used to select what the user wants to visualize

                      selectInput(
                        inputId = "scale_forecast",
                        label = strong("Select geographic scale"),
                        choices =
                          c("", "Stock Units", "Countries", "Complexes"),
                        multiple = F
                      ),
                      selectInput(
                        inputId = "area_forecast",
                        label = strong("Select an area"),
                        choices = NULL,
                        multiple = F
                      ),
                      selectInput(
                        inputId = "scenar_forecast",
                        label = strong("Select type of scenario"),
                        choices =
                          c(
                            "",
                            "Regulation Faroes",
                            "Regulation Greenland",
                            "Specific scenario"
                          ),
                        multiple = F
                      ),
                      selectInput(
                        inputId = "spe_sc_forecast",
                        label = strong("Select type of a specific scenario"),
                        choices =
                          c(
                            "",
                            "Regulation Faroes",
                            "Regulation Greenland",
                            "Specific scenario"
                          ),
                        multiple = F
                      ),
                      selectInput(
                        inputId = "vartype_forecast",
                        label = strong("Choose the variables to plot"),
                        choices =
                          c("Proba to reach conserv. lim.", "Key stages"),
                        multiple = F
                      ),
                      selectInput(
                        inputId = "graphtype_forecast",
                        label = strong("Choose the type of plot"),
                        choices = NULL,
                        multiple = F
                      )
                    ),
                    column(
                      9,

                      # As said earlier, the R plot we call here hasn't been generated using plotly so the function to use here is not plotlyOutput but plotOutput
                      plotOutput("plotforecast", height = "800")
                      # This plot the Graph built by the SERVER based on the selection criteria
                    )
                  )
                ),
                tabPanel(
                  "General diagnosis",
                  headerPanel(
                    "Compare predictions among areas"
                  ),
                  column(
                    12,
                    column(
                      3, # The following Shiny Widgets are used to select what the user wants to visualize

                      selectInput(
                        inputId = "scale_forecast2",
                        label = strong("Select geographic scale"),
                        choices = c("", "Countries", "Complexes"),
                        multiple = F
                      ),
                      selectInput(
                        inputId = "scenar_forecast2",
                        label = strong("Select type of scenario"),
                        choices =
                          c(
                            "",
                            "Regulation Faroes",
                            "Regulation Greenland"
                          ),
                        multiple = F
                      )
                    ),
                    column(
                      9,
                      plotOutput("plotforecast2", height = "800") # This plot the Graph built by the SERVER based on the selection criteria
                    )
                  )
                )
              )
            )
          )
        )
      ),


      #----------------------------------------------------------------------#
      #------------ UI dbchg = VISUALIZING TABLES OF OLD VS NEW DATA ---------
      #----------------(should be deactivated)-------------------------------#

      # This Tool is only designed for Remi so that he is able to compare the olde and new versions of the database. It only displays two tables,
      # one for the current version of the database, and one for the archive database.

      tabItem(
        tabName = "dbchg", # I only let this part of the application to help Rémi with checking the updates during the WGNAS
        fluidPage(
          headerPanel("Visualize current and new data"),
          mainPanel(
            width = 12,
            fluidRow(
              column(
                6,
                box(
                  width = 12,
                  h2("Archives"),
                  DT::dataTableOutput("archived_data"),
                  style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
                )
              ),
              column(
                6,
                box(
                  width = 12,
                  h2("Up to date data"),
                  DT::dataTableOutput("current_data"), # The dataTableOutput function prints a table
                  style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
                )
              )
            )
          )
        )
      ),


      #-----------------------------------------------------#
      #--- UI datacall = DOWNLOAD RDATA AND DATACALL TEMPLATES --
      #------------------------------------------------------#

      # This Tool is pretty simple as it mainly provide text and allows to download some objects stored in folders in the App.

      tabItem(
        tabName = "datacall", # This is the Tool used to make available the .Rdata files of model inputs and provide templates for the datacall
        fluidPage(
          headerPanel("Data call interface"),
          mainPanel(
            width = 12,
            fluidRow(
              tabBox(
                width = 12,

                # A first tabPanel to the templates to facilitate data collection
                tabPanel(
                  "Data call format", # Templates per fisheries or areas

                  headerPanel(
                    tags$img(
                      "Download data call templates",
                      src = "ices_full_logo_transparent.png",
                      height = "60",
                      align = "right"
                    )
                  ),
                  p("Here you can download the data currently used by the Life Cycle Assessment regarding your specific juridiction.
                                                             This constitutes a template that you may fill with the updated data for the next meeting of the ICES Working Group for North
                                                             Atlantic Salmon Assessment (WGNAS). This template is a .xls file with as many sheets as variables should be informed. Please keep the
                                                             indexes and column names as they are in the template. To be accepted, the data should be provided up to the year appearing at the bottom
                                                               of each sheet."),
                  p("The 'Greenland' file contains all the information relative to the Greenland fisheries on shared stocks, including catch statistics and
                                                               origin reassignation based on molecular analyses."),
                  h2("Download template for a specific SU"),
                  selectInput(
                    inputId = "juri",
                    label = "Select your juridiction",
                    choices = c("", tab_labels$su_name),
                    multiple = F
                  ),
                  downloadButton("TemplateDataCall", "Download SU template"),
                  h2("Download template for a specific high sea fishery"),
                  selectInput(
                    inputId = "fishjuri",
                    label = "Select your fishery",
                    choices =
                      c(
                        "",
                        "GLD fishery",
                        "FAR fishery",
                        "neNF fishery",
                        "LB/SPM/swNF fishery",
                        "LB fishery"
                      ),
                    multiple = F
                  ),
                  downloadButton("TemplateDataCallFishery", "Download SU template")
                ),
                # A second tabPanel to the data_ and const_ nimble objects
                tabPanel(
                  "Model input format", # model input data

                  headerPanel(tags$img("Download the data call template for your juridiction", src = "ices_full_logo_transparent.png", height = "60", align = "right")),
                  p("Here you can download the data currently used by the Life Cycle Assessment in the format required by Nimble.
                                                             The data consists in two objects, one 'Data_nimble' containing the variables entering in the Bayesian Likelyhoods, and one 'Constant_nimble'
                                                               containing other variables including simple fixed parameters and data used in the deterministic processes."),
                  br(),
                  fluidRow(
                    column(
                      12,
                      uiOutput("box_current_nimble_bis")
                    )
                  ),
                  fluidRow(
                    column(
                      12,
                      br(),
                      strong("File 1:"),
                      br(),
                      downloadButton("download_Datanimb", "Download DATA Nimble"),
                      downloadButton("download_Datanimb_old", "Download DATA Nimble (older)"),
                      br(),
                      br(),
                      strong("File 2:"),
                      br(),
                      downloadButton("download_Constnimb", "Download CONST Nimble"),
                      downloadButton("download_Constnimb_old", "Download CONST Nimble (older)"),
                      # h2("Download Nimble objects for a different period?"),
                      checkboxInput("nimble_older", "Nimble objects for a different period", FALSE),
                      selectInput(
                        inputId = "maxyear",
                        label = "Select the final year of the stock assessment model run",
                        choices =
                          seq(2018, as.integer(format(Sys.Date(), "%Y")) - 2),
                        multiple = F
                      ),
                      actionButton(
                        inputId = "generate_old",
                        label = "Generate older Nimble",
                        icon = icon("check-circle"),
                        style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    ),
    useShinyjs(), # useShinyjs() is a function of the shinyjs package. It has to be specified once somewhere (there may be other places in the code where it appears; I think it isn't a problem if they are removed).
    # useShinyjs() enables hidding or showing some buttons when we don't need/need them.

    # This part is for the general design of the application
    tags$head(tags$link(
      rel = "stylesheet", type = "text/css", href = "design.css" # This line call a .css file managing the overall aesthetic of the App. The aesthetics could also be managed within this script but it would
      # add a lot of text. Additionally, the .css file allows to assign specific aesthetics per type/class of objects to represent on the UI (e.g., the color of buttons etc).
    ))
  )

#------------------------------------------------------------------------------------#
# ------------ UI #4 Assembling all the UI parts -----------------------------------
#------------------------------------------------------------------------------------#

# Having seprately defined the different part of the UI, i.e. the navigation bar, the side bar and the body, we can assemble them to create the UI part of the App.

ui <- dashboardPage(header, sidebar, body)

# We can now define the SERVER part of the application! Ultimately, the SERVER and the UI could be built in separate scripts. At the beginning of my work, I found easier to have the two parts on the
# same script and I kept it like this.

#------------------------------------------------------------------------------------#
# -----------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
# ----------------------- Creating the Server part of the App ------------------------
#------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------#
# -----------------------------------------------------------------------------------#

# I will try to be more talkative for this part since the SERVER is much more complex than the UI part.
# You can first see that the SERVER is actually a function that use an input and an output arguments. These two arguments enables the interactive aspect of the application.
# The input is what is the information sent from the UI to the SERVER (e.g., dataype selected by the user in a selectinput).
# The output is the output of the SERVER, since the reactive aspect of the objects in SERVER makes that it is reactive to the same objects that it creates by running a set of functions.

server <- function(input, output, session) {
  #------------------------------------------------------------------------------------#
  # ------------ SERVER #1 Creating basic variables and reactive objects ---------------
  #------------------------------------------------------------------------------------#

  # These objects will be called in following sections of the Server.

  # I don't remember what is that; I will try to remove it and see if it changes anything - but I think it is not used anymore
  cdata <- session$clientData

  # We here define reactive objects with reactiveVal function. It means that they will "contain"/"take the value of" what is specified between brackets, and that their content
  # can then be modified in the SERVER function.
  # For example, if we want to visualize the up-to-date database table in the UI, we need to create an object that will correspond to the content of table the at the time of the connection. But if we update the online database,
  # then it has to display the values of the table after updating. When some functions of SERVER use somewhere an object defined using "reactiveVal", this function will be run everytime that this object is modified.

  # So we define the database object as a reactive object, i.e. an object that can be modified, reflecting the values of the database_mother which is loaded before launching the App. (see the code above the UI definition)
  database <- reactiveVal(database_mother)
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host = "localhost", user = "atlas", password = "atlas", dbname = "salmoglob")
  database_check_update <- dbReadTable(con, "database")
  database_archive_check_update <- dbReadTable(con, "database_archive")
  database(database_check_update)
  database_arch_upt_dbcheck <- reactiveVal(database_archive_check_update)
  dbDisconnect(con)
  # switcher is an object taking potentially two values: 0 most of the time and 1 when the "Update" button is clicked on to update the online database. When the value is 1, the salmodatacollect page is refreshed (e.g., the selectinput
  # are reset) and the objects built in the SERVER from the uploaded table used for the update are cleared.
  # Once the value of switcher is 1, the clearing procedure is launched and switcher come back to its initial value, 0.
  switcher <- reactiveVal(0)
  # cleaning is also a switcher type object. It is used to reset the boxes to fill when the user changes the value of the selectinput for "datatype" in salmodatacollect. It is null here and becomes "ok" if the dataype "selectinput"
  # is modified.
  cleaning <- reactiveValues(data = NULL)
  # reset_navig is also a switcher type object. It is used in the function allowing to navigate between the plots representing the table uploaded in salmodatacollect; you know, when you have one graph per area and you change
  # the area by clicking right or left. When a new table is uploaded, reset_navig change its value so that the counter of clicks to the right or left is reset to 0.
  reset_navig <- reactiveVal(0)


  # login will be TRUE or FALSE depending on whether the user successfully identified or not
  login <- FALSE
  # The USER object takes the value of login - by defining it as follows, we will need to call "USER$login" to get its content.
  USER <- reactiveValues(login = login)


  #------------------------------------------------------------------------------------#
  # ------------ SERVER #2 Definition of the server par for all the App's Tools --------
  #------------------------------------------------------------------------------------#

  # I tried to organize the SERVER code so that it mirrors the structure of the UI part.

  #-------------------------------------------------------------#
  #--- SERVER toolbox = HOME PAGE  -----------------------------
  #-------------------------------------------------------------#

  # This is the part of the SERVER that interacts with home page. The only interactive aspect of the home page is used to download the WP papers when clicking on the links in the text.

  # downloadHandler function returns the automatic download of the file which name is indicated in "filename"
  output$downloadWPmodel <- downloadHandler(
    filename = "WGNAS_2021_WP26.pdf",
    content = function(file) {
      file.copy("doc_repository/WGNAS_2021_WP26_LifeCycleModel.pdf", file)
    }
  )

  output$downloadWPapp <- downloadHandler(
    filename = "WGNAS_2021_WP27.pdf",
    content = function(file) {
      file.copy("doc_repository/WGNAS_2021_WP27_SalmoGlobToolBox.pdf", file)
    }
  )

  #-------------------------------------------------------------#
  #--- SERVER salmodatacollect = DATA UPDATING---------------------
  #-------------------------------------------------------------#

  # This is the part of the SERVER that interacts with home page. The only interactive aspect of the home page is used to download the WP papers when clicking on the links in the text.

  # The salmodatacollect Tool allows to navigate between graphs of the areas (one graph per area) when the data is uploaded or the datatype is selected.
  # The thing is that we have to check that the user don't click on right/left (next/previous) navigation buttons that it is actually possible: if there are 3 graphs that can be explored,
  # the user can't click more than 3 successive times on the right button; can't click on the left button if the graph displayed is the one of the first area; can't click more times on the left button than on the right button etc.
  # To control that, we use the "lengthy" variable and inactivate or activate the buttons "Next or "Previous" depending on lengthy value.
  observe({
    req(lengthy())
    shinyjs::toggleState(id = "next_st", condition = calcdiff() < lengthy())
  })

  observe({
    req(lengthy())
    shinyjs::toggleState(id = "previous_st", condition = calcdiff() > 1)
  })

  # In salmodatacollect, for a same variable can be informed its mean value or its CV or sd. The "metric_type" menu is here to specify this. However, it is
  # can beBy default, the selection of metric_type is hidden

  shinyjs::hide(id = "metric_type")

  # Here we define when the metric_type is hidden or shown and we update its name dependeing on the variable selected by the user

  observe({
    if (req(input$datatype) %in% c("Sea catches", "Returns")) {
      updateRadioButtons(
        session,
        "metric_type",
        "Mean / Stand. Dev.",
        choices =
          c("mean" = "Mean", "sd" = "Standard deviation"),
        selected = "Mean",
        inline = T
      )
      shinyjs::show(id = "metric_type")
      # } else if (req(input$datatype) %in% c("Natural mortality rate","Survival rate")){ # remove deprecated cv value for natural mortality rate (CV_M)
    } else if (req(input$datatype) %in% c("Survival rate")) {
      updateRadioButtons(
        session,
        "metric_type",
        "Mean / Coef. of var.",
        choices =
          c("mean" = "Mean", "cv" = "Coefficient of variation"),
        selected = "Mean",
        inline = T
      )
      shinyjs::show(id = "metric_type")
    } else if (req(input$datatype) %in% c("Homewater catches")) {
      # updateRadioButtons(session,"metric_type", "Mean / Coef. of var. / Stand. Dev.", "", choices = c("mean" = "Mean", "cv" = "Coefficient of variation", "sd" = "Standard deviation"), selected = 'Mean', inline=T)
      # remove deprecated cv value for Homewater catches (CV_hw)
      updateRadioButtons(
        session,
        "metric_type",
        "Mean / Stand. Dev.",
        choices =
          c("mean" = "Mean", "sd" = "Standard deviation"),
        selected = "Mean",
        inline = T
      )
      shinyjs::show(id = "metric_type")
    } else {
      shinyjs::hide(id = "metric_type")
    }
  })

  # everytime the user modfifies the data type to update, the field for the name of the variable is reset

  observeEvent(input$datatype, {
    if (req(input$datatype) != " ") {
      cleaning$op <- "ok"
    }
    if (req(input$datatype) %in% c("Homewater catches", "Natural mortality rate", "Survival rate", "Sea catches", "Returns")) {
      newcodes <- unique(database()$var_mod[which(database()$type == input$datatype & database()$metric == input$metric_type)])
      newcodes <- newcodes[!is.na(newcodes)]
    } else {
      newcodes <- unique(database()$var_mod[which(database()$type == input$datatype)])
      newcodes <- newcodes[!is.na(newcodes)]
    }

    # selectInput(inputId ="datatype", label = strong("Filter by Data Type"), choices = c(' ',
    #                                                                                    unique(database()[order(match(unique(database()$var_mod), unique(tab_type_object$var_mod))),]$type)), multiple=F)
    newcodes <- newcodes[order(match(newcodes, unique(tab_type_object$var_mod)))]
    # remove deprecated variables
    newcodes <- newcodes[which(!newcodes %in% c("log_C6_sup_mu", "log_C9_sup_mu", "log_C6_sup_sd", "log_C9_sup_sd"))]

    updateSelectInput(session, "varcode", "Select the variable", choices = c(newcodes))
  })

  # everytime the user modfifies the metric_type to update, the field for the name of the variable is reset

  observeEvent(input$metric_type, {
    newcodes <- unique(database()$var_mod[which(database()$type == input$datatype & database()$metric == input$metric_type)])
    newcodes <- newcodes[!is.na(newcodes)]

    newcodes <- newcodes[order(match(newcodes, unique(tab_type_object$var_mod)))]
    newcodes <- newcodes[which(!newcodes %in% c("log_C6_sup_mu", "log_C9_sup_mu", "log_C6_sup_sd", "log_C9_sup_sd"))]

    updateSelectInput(session, "varcode", "Select the variable", choices = c(newcodes))
  })


  # The tab is a reactive object corresponding to the subset of the database table corresponding to the variable selected via the dropdown menus

  tab <- reactive({
    database() %>%
      dplyr::filter(var_mod %in% req(input$varcode)) -> sloubi

    # validate(
    #  need(check_input_data_set(data_to_update(),database()[,2:9])=='data is valid', check_input_data_set(data_to_update(),database()[,2:9]))
    # )
    if (!is.null(data_to_update())) {
      if (check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid") {
        sloubi %>%
          dplyr::filter(area %in% unique(data_to_update()$area)) -> sloubi
      }
    }

    return(sloubi)
  })


  # the next_trans and previous_trans buttons

  next_trans <- reactive({
    as.numeric(input$next_st)
  })
  previous_trans <- reactive({
    as.numeric(input$previous_st)
  })

  observeEvent(req(input$datatype), {
    reset_navig(next_trans() - previous_trans())
  })

  ## Add validate
  observeEvent(
    {
      req(input$file1)
      req(input$sep)
      req(input$quote)
      req(input$header)
    },
    {
      validate(
        need(check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid", check_input_data_set(data_to_update(), database()[, 2:9]))
      )
      reset_navig(next_trans() - previous_trans())
    }
  )


  calcdiff <- reactive({
    (next_trans() - previous_trans() + 1) - reset_navig()
  })


  lengthy <- eventReactive(
    {
      req(input$varcode)
      data_to_update()
    },
    {
      length(unique(tab()$area))
    }
  )


  type <- reactive({
    subset(tab_type_object, tab_type_object$var_mod %in% req(input$varcode))
  })


  # Here is the code allowing to upload the database

  output$downloadData <- downloadHandler(
    filename = function() {
      paste(req(input$varcode), ".csv", sep = "")
    },
    content = function(file) {
      database_export <- database() %>%
        dplyr::filter(var_mod == req(input$varcode))

      if (check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid") {
        database_export <- database() %>%
          dplyr::filter(var_mod == req(input$varcode)) %>%
          dplyr::filter(area == req(newdata()$area))
      }

      database_export <- database_export[, 2:9]
      write.csv(database_export, file, row.names = FALSE)
    }
  )

  observe({
    toggleState(id = "file1", condition = input$varcode != "")
  })

  observeEvent(input$file1, {
    switcher(0)
  })


  observeEvent(input$varcode, {
    switcher(1)
    # reset(input$file1)
  })


  uploaded <- reactive({
    if (is.null(cleaning$op)) {
      return()
    }
    if (is.null(input$file1)) {
      return(NULL)
    } else {
      upload <- read.csv(input$file1$datapath, header = input$header, sep = input$sep, quote = input$quote)
      return(upload)
    }
    # req(input$file1)
  })

  color_warning <- reactive({
    if (check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid") {
      "green"
    } else {
      "red"
    }
  })

  output$warning_upload <- renderText({
    req(input$file1)

    paste('<span style=\"color:', color_warning(),
      '\">', check_input_data_set(data_to_update(), database()[, 2:9]),
      "</span>",
      sep = ""
    )
  })

  data_to_update <- reactiveVal(0)

  observe({
    # alor<-isolate(switcher())
    if (switcher() == 0) {
      data_to_update(uploaded())
    } else if (switcher() == 1) {
      data_to_update(NULL)
    }
  })




  output$contents <- renderDataTable({
    ## WILL BE TO UPDATE TO INCLUDE COL 9 FOR CHECKING VAR!

    validate(
      need(check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid", check_input_data_set(data_to_update(), database()[, 2:9]))
    )

    if (input$disp == "head") {
      return(head(data_to_update()))
    } else {
      return(data_to_update())
    }
  })


  newdata <- reactive({
    # if(is.null(cleaning$op)){
    #  return()
    # }

    ## WILL BE TO UPDATE TO INCLUDE COL 9 FOR CHECKING VAR!
    validate(
      need(check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid", check_input_data_set(data_to_update(), database()[, 2:9]))
    )

    ladateetlheure <- Sys.time()

    ## v<-as.character(as.numeric(as.character(unique(tab()$version)))+1)
    #### " THERE COULD BE A PROBLEM RELATED TO THE ORDER OF THE LINES!!! + LINKED TO THE LENGTH, WHICH WILL DEFINITELY NOT BE THE SAME
    # v<-unique(tab()$version)+1

    tab() %>%
      dplyr::select(version, var_mod, area) %>%
      unique() -> sortind

    data_to_update <- formate_upload_data(data_to_update())
    data_to_update <- merge(sortind, data_to_update) ####
    data_to_update <- sort_upload_data(data_to_update, tab_labels)

    data_to_update <- data_to_update[, colnames(database_archive)[1:9]] ####
    data_to_update$version <- as.numeric(data_to_update$version) + 1

    oups <- cbind.data.frame(
      data_to_update, as.character(input$Name), as.character(input$Firstname), ####
      as.character(input$Institute), as.character(input$email), as.POSIXct(ladateetlheure, format = "%Y/%m/%d %H:%M:%OS")
    )

    colnames(oups) <- colnames(database_archive)

    oups$version <- as.numeric(oups$version)

    return(oups)
  })


  tabplot <- reactive({
    if (is.null(input$file1)) {
      tab()
    } else {
      if (check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid") {
        rbind.data.frame(tab(), newdata()[, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 14)])
      } else {
        tab()
      }
    }
  })



  observeEvent(input$valid, {
    cleaning$op <- NULL
  })

  observe({
    toggleState(id = "valid", condition = !input$Name %in% c("", "Enter text...") &
      !input$Firstname %in% c("", "Enter text...") &
      !input$Institute %in% c("", "Enter text...") &
      !input$email %in% c("", "Enter text...") &
      check_input_data_set(data_to_update(), database()[, 2:9]) == "data is valid")
  })


  #  output$zizi <- renderDataTable({
  #
  #    if(is.null(cleaning$op)){
  #      return()
  #    }
  #
  #    return(tabplot())
  #
  #  })


  database_ready_update <- reactive({
    ########### without_updated_data <- subset(database(), database()$var_mod!=input$varcode) #### PYmodif
    ########### without_updated_data <- subset(database(), database()$var_mod!=input$varcode & database()$area%in%unique(tab()$area))#### PYmodif WHAT WAS THE INTEREST??
    without_updated_data <- subset(database(), database()$var_mod != input$varcode | !database()$area %in% unique(tab()$area))
    rbind.data.frame(without_updated_data, newdata()[, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 14)])
  })


  observeEvent(input$valid, {
    drv <- dbDriver("PostgreSQL")
    con <- dbConnect(drv, host = "localhost", user = "atlas", password = "atlas", dbname = "salmoglob")

    # Update the database and the dcatabase_archive tables
    DBI::dbWriteTable(con, "database", sort_upload_data(isolate(database_ready_update()), tab_labels), overwrite = TRUE, row.names = F)
    # DBI::dbWriteTable(con, "database", isolate(database_ready_update()), overwrite = TRUE, row.names=F)
    DBI::dbWriteTable(con, "database_archive", isolate(newdata()), append = TRUE, overwrite = FALSE, row.names = F)

    databasenewval <- dbReadTable(con, "database")
    database(databasenewval)
    database_archivenewval <- dbReadTable(con, "database_archive")
    database_arch_upt_dbcheck(database_archivenewval)

    # Update the metadata table
    if (tab_type_object$name_dim1[tab_type_object$var_mod == req(input$varcode)] == "Year" | tab_type_object$name_dim2[tab_type_object$var_mod == req(input$varcode)] == "Year" | tab_type_object$name_dim3[tab_type_object$var_mod == req(input$varcode)] == "Year") {
      update_meta <- tab_type_object
      col_id <-
        grep(
          "Year",
          c(
            tab_type_object$name_dim1[tab_type_object$var_mod == req(input$varcode)],
            tab_type_object$name_dim2[tab_type_object$var_mod == req(input$varcode)],
            tab_type_object$name_dim3[tab_type_object$var_mod == req(input$varcode)]
          )
        )
      update_meta[update_meta$var_mod == req(input$varcode), 2 + col_id] <-
        length(unique(isolate(newdata())$year))
      DBI::dbWriteTable(con, "metadata", update_meta, overwrite = TRUE, row.names = F)
    }

    shinyjs::reset("datatype")
    shinyjs::reset("dataname")
    shinyjs::reset("metric_type")
    shinyjs::reset("file1")
    shinyjs::reset("activ_emerg")
    switcher(1)

    showNotification("DATABASE SUCCESSFULLY UPDATE!", duration = NULL, type = "message")

    # for the moment, we store the nimble objects on the Application folder
    ####### TO REACTIVATE FOR DATA / CONST GENERATION
    # Let's first assess if all the variables with a temporal component cover the same period. If yes, generate_nimble will be set to 1.


    #----------JEROME MON ANGE debut----------   appelle le code
    source("R/check_time_cov_bef_nimble.R", local = TRUE)
    #----------JEROME MON ANGE fin---------


    #----------JEROME MON ANGE debut----------   version alternative, colle directement le code dans le server
    #   # Here we define the variable generate_nimble that will control whether the generation of the Nimble objects can be launched.
    #   # If generate_nimble is 0, the generation is blocked. If it set to 1, the generation will be enabled.
    #   generate_nimble <- 0
    #
    #   # Let's identify all the variables for which a time-series exists
    #   tab_type_object %>%
    #     dplyr::filter(name_dim1=="Year" | name_dim2== "Year" | name_dim3=="Year") %>%
    #     dplyr::filter(nimble %in% c("Const_nimble","Data_nimble")) %>%
    #     dplyr::select(var_mod) -> with_TS
    #   with_TS <- as.vector(unlist(as.vector(c(with_TS))))
    #   # We remove the initialization values with the "_pr" suffix
    #   with_TS <- with_TS[-which(grepl("_pr",with_TS))]
    #
    #   # We retrieve the maximum Year for each variable.
    #   databasenewval %>%
    #     dplyr::filter(var_mod %in% with_TS) %>%
    #     # Now that the variables can be updated for specific areas, the updating procedure can be at be complete
    #     #for some but not all areas. So I replace the following lines by new ones.
    #     #dplyr::group_by(var_mod) %>%
    #     #dplyr::summarise(maxy=max(year)) %>%
    #     dplyr::group_by(var_mod, area) %>%
    #     dplyr::summarise(maxy_area=max(year)) %>%
    #     dplyr::group_by(var_mod) %>%
    #     dplyr::summarise(maxy=min(maxy_area)) %>%
    #     as.data.frame() -> all_y
    #
    #   # If all the variables have the same temporal coverage, we consider that the Nimble object can be generated.
    #   if(length(unique(all_y$maxy))==1){
    #     generate_nimble <- 1
    #   }else{generate_nimble <- 0}
    #----------JEROME MON ANGE fin---------



    if (generate_nimble == 1) {
      # If the condition is verified, the procedure for the generation of the Nimble objects can be launched.
      source("R/store_Nimble_objects.R", local = T)
    }
    dbDisconnect(con)
  })

  observeEvent(input$emergency, {
    toggle("before_emerg")
    toggle("activ_emerg")
  })

  observeEvent(input$activ_emerg, {
    if (input$activ_emerg == T) {
      source("R/check_uploaded_data_format_emergency_procedure.R", local = T)
    } else {
      source("R/check_uploaded_data_format_varyingSU.R", local = T)
    }
    updateRadioButtons(session, "sep",
      label = "Separator", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"),
      selected = "", inline = T
    )
    delay(1000, updateRadioButtons(session, "sep",
      label = "Separator", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"),
      selected = ",", inline = T
    ))
    # updateRadioButtons(session, "sep", label = "Separator", choices = c(Comma = ",",Semicolon = ";",Tab = "\t"),
    #                   selected = ",", inline=T)
  })

  # observeEvent(input$activ_emerg, {
  #   shinyjs::show('warning_emergency', condition=T)
  # })

  observe({
    toggle(id = "warning_emergency", condition = input$activ_emerg)
  })

  stock_plots <- reactiveVal()

  output$graph <- renderPlotly({
    if (is.null(cleaning$op)) {
      return()
    } else if (type()$type_object[1] == "matrix") {
      if (type()$name_dim1[1] == "Year" | type()$name_dim2[1] == "Year") {
        allplots <- plot_for_matrices(tabplot(), c("red", "blue"))
        stock_plots(allplots)

        ggplotly(allplots[[calcdiff()]])
      }
    } else if (type()$type_object[1] == "vector") {
      if (type()$name_dim1[1] == "Year") {
        allplots <- plot_for_vectors(tabplot(), c("red", "blue"))
        stock_plots(allplots)
        ggplotly(allplots)
      } else if (type()$name_dim1[1] %in% c("Stock unit", "Countries")) {
        allplots <- plot_for_SU(tabplot(), c("red", "blue"))
        stock_plots(allplots)
        ggplotly(allplots)
      }
    } else if (type()$type_object[1] == "array") {
      if (!type()$type[1] %in% c("Fecundity rate", "Sex ratio")) {
        allplots <-
          plot_for_proportions(
            tabplot(),
            c("red", "green", "blue", "pink", "purple", "yellow", "orange")
          )
        stock_plots(allplots)
        ggplotly(allplots[[calcdiff()]])
      } else {
        allplots <-
          plot_for_timearray(
            tabplot(),
            c("red", "blue")
          )
        stock_plots(allplots)
        ggplotly(allplots[[calcdiff()]])
      }
    } else if (type()$type_object[1] == "single_value") {
      allplots <- plot_for_SU(tabplot(), c("red", "blue"))
      stock_plots(allplots)
      ggplotly(allplots)
    }
  })


  output$stockplots <- downloadHandler(
    filename = function() {
      paste("compare_plots_", req(input$varcode), ".pdf", sep = "")
    },
    content = function(file) {
      pdf(file)
      print(isolate(stock_plots()))
      dev.off()
    }
  )


  #---------------------------------------------------------------------#
  #--- SERVER datacheck = CHECKING NEW VS OLD VERSIONS OF THE DATABASE -
  #---------------------------------------------------------------------#

  # Here we define output objects that reflect the content of database and database_archive tables
  # We use the package DT that so that an interactive table is displayed in the UI.

  output$current_data <- DT::renderDataTable({
    d <- database()
    #    d <- database_upt_dbcheck()
    return(d)
  })

  output$archived_data <- DT::renderDataTable({
    # d <- database_archive
    d <- database_arch_upt_dbcheck()
    return(d)
  })


  #--------------------------------------------------------------------#
  #--- SERVER salmodataexplo = EXPLORING THE UP-TO-DATE DATABASE -------
  #--------------------------------------------------------------------#

  # salmodataexplo displays graphs based on a series of selected criteria. Thus, in the corresponding part of the SERVER,
  # we need a bunch of conditions that will updated the selectinput or the radiobuttons depending on the values selected in the other fields.
  # It is not a complicated part but we have to think to all the possibilities, to all events to which we want the fields to react.
  # If the database is updated with new datatypes, if may be reauired to updated this part of the SERVER: some conditions for the plots depend on the dataype selected

  # When the user want to visualize eggs-related info, it is not linked to any ages. So if it is the case, we show to hide the "age_explo button".
  # The function observeEvent will be run everytime the value of the object in eventExpr is updated.
  observeEvent(eventExpr = input$datatype_explo, handlerExpr = {
    if (input$datatype_explo != "Egg survival") {
      shinyjs::show(id = "age_explo")
    } else {
      shinyjs::hide(id = "age_explo")
    }
  })

  agetype <- reactive({
    if (input$datatype_explo == "Smolt age structure") {
      tt <- "Select smolt freshwater ages"
    } else {
      tt <- "Select salmon sea winter ages"
    }
    return(tt)
  })
  output$typeage <- renderText(as.character(agetype()))

  observe({
    agenew <- unique(database()$age[database()$type == req(input$datatype_explo)])
    ageproposal <- agenew[!is.na(agenew)]
    if (req(input$datatype_explo) == "Homewater catches") {
      ageproposal <- ageproposal[ageproposal != "Mixed"]
    }
    updateSelectInput(session, "age_explo", choices = ageproposal, selected = ageproposal)
  })


  observe({
    areanew <- as.character(unique(database()$area[database()$type == req(input$datatype_explo)]))
    areaproposal <- areanew[!is.na(areanew)]
    if (req(input$datatype_explo) == "Homewater catches") {
      areaproposal <- areaproposal[areaproposal != "Atlantic"]
    }
    updateSelectInput(session, "area_explo", "Select salmon origin area", choices = areaproposal, selected = areaproposal)
  })


  observeEvent(eventExpr = input$datatype_explo, handlerExpr = {
    if (input$datatype_explo %in% c("Sea catches", "Origin distribution in sea catches", "Time spent at sea", "Homewater catches")) {
      shinyjs::show(id = "loc_explo")
    } else {
      shinyjs::hide(id = "loc_explo")
    }
  })

  observe({
    locationnew <- as.character(unique(database()$location[database()$type == req(input$datatype_explo)]))
    locationproposal <- locationnew[!is.na(locationnew)]
    if (req(input$datatype_explo) == "Homewater catches") {
      locationproposal <- locationproposal[locationproposal != "_"]
    }
    updateSelectInput(session, "loc_explo", "Select the location", choices = locationproposal, selected = locationproposal)
  })

  subset_data_new <- reactive({
    if (input$datatype_explo != "Homewater catches") {
      database() %>%
        dplyr::filter(type == req(input$datatype_explo)) %>%
        dplyr::filter(age %in% req(input$age_explo)) %>%
        dplyr::filter(area %in% req(input$area_explo)) %>%
        dplyr::filter(location %in% req(input$loc_explo))
    } else {
      database() %>%
        dplyr::filter(type == req(input$datatype_explo)) %>%
        dplyr::filter(age %in% c(req(input$age_explo), "Mixed")) %>%
        dplyr::filter(area %in% c(req(input$area_explo), "Atlantic")) %>%
        dplyr::filter(location %in% c(req(input$loc_explo), "_"))
    }
  })

  observeEvent(eventExpr = input$datatype_explo, handlerExpr = {
    if (input$datatype_explo %in% c("Returns", "Homewater catches", "Sea catches")) {
      shinyjs::show(id = "unlog")
    } else {
      shinyjs::hide(id = "unlog")
    }
  })

  observeEvent(eventExpr = input$datatype_explo, handlerExpr = {
    if (!input$datatype_explo %in% c(
      "Time spent at sea", "Survival rate", "Origin distribution in sea catches",
      "Proportion of delayed individuals", "Smolt age structure", "Sex ratio"
    )) {
      shinyjs::show(id = "overlay")
    } else {
      shinyjs::hide(id = "overlay")
    }
  })

  observeEvent(eventExpr = input$datatype_explo, handlerExpr = {
    if (input$datatype_explo %in% c("Returns", "Homewater catches", "Sea catches") & input$overlay != "area") {
      shinyjs::show(id = "uncert")
    } else {
      shinyjs::hide(id = "uncert")
    }
  })
  observeEvent(eventExpr = input$overlay, handlerExpr = {
    if (input$overlay != "area" & input$datatype_explo %in% c("Returns", "Homewater catches", "Sea catches")) {
      shinyjs::show(id = "uncert")
    } else {
      shinyjs::hide(id = "uncert")
    }
  })

  output$graph_tab <- DT::renderDataTable({
    d <- subset_data_new()
    return(d)
  })


  # radioButtons("unlog", "Choose scale", choices = c(LogScale = "identity", UnlogScale = "exp"),selected = "identity", inline=T)

  output$graph_explo <- renderPlotly({
    plot_explo <- TheMostBeautifulFunction(subset_data_new(), input$unlog, input$scale, input$overlay, input$uncert, tab_labels)
    # ggplotly(plot_explo)
  })

  #-------------------------------------------------------------#
  #--- SERVER salmoretro = EXPLORING THE UP TO DATA DATA
  #-------------------------------------------------------------#

  reg_selec <- reactive({
    # etiq<-""
    etiq2 <- ""

    if (req(input$datatype_out) == "Returns") {
      etiq2 <- tab_labels$su_ab
    } else if (req(input$datatype_out) == "Homewater catches") {
      etiq2 <- tab_labels$su_ab
      if (req(input$area_out) == "additional") {
        etiq2 <- c("SC_W", "SC_E")
      } else if (req(input$area_out) == "delayed spawners") {
        etiq2 <- c("RU_KW")
      }
    } else if (req(input$datatype_out) == "Sea catches") {
      etiq2 <- ""
      if (
        req(input$datatype_out) %in% c("Sea catches") &
          req(input$area_out) == "FAR fishery" &
          req(input$var_hind) == "prop"
      ) {
        etiq2 <- tab_labels$su_ab[seq((database()$value[database()$var_mod == "N_NAC"] + 1), database()$value[database()$var_mod == "N"])]
      } else if (
        req(input$datatype_out) == "Sea catches" &
          req(input$area_out) == "GLD fishery" &
          req(input$var_hind) == "prop" &
          req(input$propagg) == "prop_NEC"
      ) {
        etiq2 <- tab_labels$su_ab[seq((database()$value[database()$var_mod == "N_NAC"] + 1), database()$value[database()$var_mod == "N"])]
      } else if (
        req(input$datatype_out) %in% c("Sea catches") &
          req(input$area_out) == "GLD fishery" &
          req(input$var_hind) == "prop" &
          req(input$propagg) == "prop_NAC"
      ) {
        etiq2 <- tab_labels$su_ab[seq(1, database()$value[database()$var_mod == "N_NAC"])]
      } else if (
        req(input$datatype_out) %in% c("Sea catches") &
          req(input$area_out) == "GLD fishery" &
          req(input$var_hind) == "prop" &
          req(input$propagg) == "prop_bycplx"
      ) {
        etiq2 <- "NEC"
      }
    } else {
      etiq2 <- "cul"
    }
    # debug only
    # write.csv(etiq2,"etiq2.csv", row.names = FALSE)

    etiq <- etiq2

    return(etiq)
  })

  observe({
    tab_type_object %>%
      dplyr::filter(nimble == "Output") %>%
      dplyr::filter(type == req(input$datatype_out)) %>%
      dplyr::select(ages) %>%
      unique() -> agenewout


    agenewout <- unique(agenewout[!is.na(agenewout)])
    updateSelectInput(session, "age_out", "Select the sea winter age", choices = agenewout)
  })

  observeEvent(eventExpr = input$datatype_out, handlerExpr = {
    if (input$datatype_out %in% c("Sea catches", "Homewater catches", "High seas harvest rates", "River harvest rates")) {
      shinyjs::show(id = "area_out")
    } else {
      shinyjs::hide(id = "area_out")
    }
  })
  observe({
    if (input$datatype_out %in% c("Sea catches", "Homewater catches", "High seas harvest rates", "River harvest rates")) {
      tab_type_object %>%
        dplyr::filter(nimble %in% "Output") %>%
        dplyr::filter(type %in% req(input$datatype_out)) %>%
        dplyr::filter(ages %in% req(input$age_out)) %>%
        # filter(fishery != "LB-LB/SPM/swNF fishery")
        dplyr::select(fishery) -> areaout
      # debug only
      # write.csv(areaout,"areaout.csv", row.names = FALSE)
      areaout2 <- unique(areaout[!is.na(areaout) & areaout != "LB-LB/SPM/swNF fishery"])
      updateSelectInput(session, "area_out", "Select the area", choices = areaout2)
    }
  })


  observeEvent(eventExpr = input$area_out, handlerExpr = {
    if (input$datatype_out %in% c("Sea catches") & input$area_out %in% c("GLD fishery", "FAR fishery")) {
      shinyjs::show(id = "var_hind")
    } else {
      updateRadioButtons(session, "var_hind",
        label = "Catch data to plot", choices = c("Total catch" = "tot", "SU proportions" = "prop"),
        selected = "tot", inline = T
      )
      shinyjs::hide(id = "var_hind")
    }
  })


  observe({
    if (input$datatype_out %in% c("Sea catches") & input$area_out %in% c("GLD fishery", "FAR fishery") & input$var_hind == "prop") {
      shinyjs::show(id = "subreg")
      # updateSelectInput(session,"subreg","Select the area",choices = reg_selec(), selected=reg_selec())
    }
    if (input$datatype_out %in% c("Returns", "Homewater catches")) {
      shinyjs::show(id = "subreg")
      # updateSelectInput(session,"subreg","Select the area",choices = reg_selec(), selected=reg_selec())
    }
    if (
      (
        input$datatype_out %in% c("Returns", "Homewater catches")
      ) == FALSE &
        (
          input$datatype_out %in% c("Sea catches") &
            input$area_out %in% c("GLD fishery", "FAR fishery") &
            input$var_hind == "prop"
        ) == FALSE
    ) {
      shinyjs::hide(id = "subreg")
    }
  })

  observeEvent(eventExpr = input$datatype_out, handlerExpr = {
    if (
      input$datatype_out %in% c("Returns", "Homewater catches")
    ) {
      updateSelectInput(
        session,
        "subreg",
        "Select the area",
        choices  = reg_selec(),
        selected = reg_selec()
      )
    }
  })


  observeEvent(eventExpr = input$area_out, handlerExpr = {
    if (input$datatype_out %in% c("Sea catches") & input$area_out %in% c("GLD fishery")) {
      if (input$var_hind != "tot") {
        shinyjs::show(id = "propagg")
        updateRadioButtons(
          session,
          "propagg",
          label = "Plot origin distribution by",
          choices =
            c(
              "By complex" = "prop_bycplx",
              "By NAC SU" = "prop_NAC",
              "By NEC SU" = "prop_NEC"
            ),
          selected = "prop_bycplx",
          inline = TRUE
        )
        updateSelectInput(
          session,
          "subreg",
          "Select the area",
          choices = reg_selec(),
          selected = reg_selec()
        )
      }
    } else if (input$datatype_out %in% c("Returns", "Homewater catches")) {
      updateSelectInput(
        session,
        "subreg",
        "Select the area",
        choices = reg_selec(),
        selected = reg_selec()
      )
      shinyjs::hide(id = "propagg")
    } else {
      shinyjs::hide(id = "propagg")
    }
  })

  ################# NOT ASKED TO CHANGE THE REGION WHEN FISHERY MODIFIED

  observeEvent(eventExpr = input$var_hind, handlerExpr = {
    if (
      input$datatype_out %in% c("Sea catches") &
        input$area_out %in% c("GLD fishery") &
        input$var_hind != "tot"
    ) {
      shinyjs::show(id = "propagg")
      updateRadioButtons(
        session,
        "propagg",
        label = "Plot origin distribution by",
        choices = c(
          "By complex" = "prop_bycplx",
          "By NAC SU" = "prop_NAC",
          "By NEC SU" = "prop_NEC"
        ),
        selected = "prop_bycplx",
        inline = TRUE
      )
      updateSelectInput(
        session,
        "subreg",
        "Select the area",
        choices = reg_selec(),
        selected = reg_selec()
      )
    } else {
      # changes by RP ; 17/08/2022
      # NULL -> reg_selec() for choices and selected
      # else problems with FAR fisheries in prop. mode
      updateRadioButtons(
        session,
        "propagg",
        label = "Plot origin distribution by",
        choices = reg_selec(), # old version "choices = NULL"
        selected = reg_selec(), # old version "selected = NULL"
        inline = TRUE
      )
      shinyjs::hide(id = "propagg")
    }
  })

  observeEvent(eventExpr = input$propagg, handlerExpr = {
    if (
      input$datatype_out %in% c("Sea catches") &
        input$area_out %in% c("GLD fishery") &
        input$var_hind != "tot"
    ) {
      updateSelectInput(
        session,
        "subreg",
        "Select the area",
        choices  = reg_selec(),
        selected = reg_selec()
      )
    } # else{
    # updateRadioButtons(session, "propagg", label = "Plot origin distribution by", choices = NULL,
    #                  selected = NULL, inline=T)
    # shinyjs::hide(id = "propagg")
    # }
  })


  loc_hind <- reactive({
    if (
      input$datatype_out %in%
        c(
          "Homewater catches",
          "Sea catches",
          "High seas harvest rates",
          "River harvest rates"
        )
    ) {
      tab_type_object %>%
        dplyr::filter(nimble %in% "Output") %>%
        dplyr::filter(type %in% req(input$datatype_out)) %>%
        dplyr::filter(ages %in% req(input$age_out)) %>%
        dplyr::filter(fishery %in% req(input$area_out)) %>%
        dplyr::filter(grepl("comp", var_mod) == FALSE) %>%
        dplyr::filter(grepl("tot", var_mod) == FALSE) -> submeta
    }
    if (input$datatype_out == "Returns") {
      tab_type_object %>%
        dplyr::filter(nimble %in% "Output") %>%
        dplyr::filter(type %in% req(input$datatype_out)) %>%
        dplyr::filter(ages %in% req(input$age_out)) -> submeta # %>%
      # filter(grepl("comp", var_mod)==F) -> submeta #%>%
      # filter(grepl("tot", var_mod)==F)-> submeta
    }

    hind_to_plot <- unique(submeta$var_mod)
    hind_to_plot <- gsub("_other", "", hind_to_plot)
    hind_to_plot <- gsub("_lab", "", hind_to_plot)

    file_id1 <- list.files("exchange_plateform/Nimble_output/", pattern = hind_to_plot)
    if (req(input$datatype_out) == "Homewater catches") {
      if (req(input$area_out) == "main") {
        file_id1 <- file_id1[grepl("main", file_id1) == TRUE]
      }
    }
    file_id2 <- file_id1[grepl("png", file_id1) == FALSE]
    file_id3 <- file_id2[!grepl("median", file_id2)]
    file_id4 <- file_id3[!grepl("tot_by_complex", file_id3)]


    if (input$datatype_out %in% c("Sea catches")) {
      file_id5 <-
        file_id4[
          grepl(
            as.character(input$var_hind),
            file_id4
          )
        ]

      if (
        input$var_hind == "prop" &
          input$area_out == "GLD fishery"
      ) {
        file_id5 <-
          file_id5[
            grepl(
              input$propagg,
              file_id5
            )
          ]
      }
    } else {
      file_id5 <- file_id4
    }

    return(file_id5)
  })


  output$check_loc_hind <- renderText(as.character(loc_hind()))

  output$plothindcast <- renderPlotly({
    if (req(input$datatype_out) %in% c("Returns", "Homewater catches")) {
      graphhind1 <- readRDS(paste0("exchange_plateform/Nimble_output/", as.character(loc_hind())))
      # substract <- gsub("_",".",input$subreg)
      substract <- input$subreg

      # debug only
      write.csv(substract, "substract.csv", row.names = FALSE)
      write.csv(graphhind1$data$SU, "graphhind1.csv", row.names = FALSE)

      subplot1 <- graphhind1
      subplot1$data <-
        subset(subplot1$data, subplot1$data$SU %in% substract)
      plot <-
        subplot1 +
        scale_y_continuous(
          labels = scales::label_scientific(digits = 1)
        ) +
        facet_wrap(
          ~ subplot1$data$SU,
          scales = "free_y"
        ) +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
        theme(panel.spacing.x = unit(0.01, "lines"))

      # IMBRICATE WITH GLD OR FAR CONDITION. THEN WITH VARHIND
    } else if (req(input$datatype_out) == "Sea catches") {
      plot <-
        readRDS(
          paste0(
            "exchange_plateform/Nimble_output/", as.character(loc_hind())
          )
        )
      if (
        req(input$area_out) == "GLD fishery" &
          req(input$var_hind) == "prop"
      ) {
        graphhind2 <-
          readRDS(
            paste0(
              "exchange_plateform/Nimble_output/", as.character(loc_hind())
            )
          )
        # substract2<-tab_labels$su_nb[which(tab_labels$su_ab%in%input$subreg)]
        # substract2 <- gsub("_",".",input$subreg)
        substract2 <- input$subreg

        # debug only
        write.csv(substract2, "substract2.csv", row.names = FALSE)
        write.csv(graphhind2$data$SU, "graphhind2.csv", row.names = FALSE)

        subplot2 <- graphhind2
        # plot<-subplot2
        if (req(input$propagg) != "prop_bycplx") {
          subplot2$data <-
            subset(
              subplot2$data,
              subplot2$data$SU %in% substract2
            )
          plot <- subplot2
        } else {
          # graphhind2 <- readRDS("exchange_plateform/Nimble_output/hindcast_tot_C8_2.rds")
          # subplot2$data<-subset(subplot2$data,subplot2$data$SU%in%c("us"))
          plot <- subplot2
        } # else{subplot2$data<-subplot2$data}
      } else if (
        req(input$area_out) == "FAR fishery" &
          req(input$var_hind) == "prop"
      ) {
        graphhind3 <-
          readRDS(
            paste0(
              "exchange_plateform/Nimble_output/", as.character(loc_hind())
            )
          )
        # substract3<-tab_labels$su_nb[which(tab_labels$su_ab%in%input$subreg)]
        # substract3 <- gsub("_",".",input$subreg)
        substract3 <- input$subreg

        # debug only
        write.csv(substract3, "substract3.csv", row.names = FALSE)
        write.csv(graphhind3$data$SU, "graphhind3.csv", row.names = FALSE)

        subplot3 <- graphhind3
        subplot3$data <-
          subset(
            subplot3$data,
            subplot3$data$SU %in% substract3
          )
        plot <- subplot3
      }
    } else {
      plot <-
        readRDS(
          paste0(
            "exchange_plateform/Nimble_output/", as.character(loc_hind())
          )
        )
    }
    # (req(input$datatype_out)=="Sea catches" & req(input$area_out)=="FAR fishery" & req(input$var_hind)=="prop")
    # plot<-readRDS("exchange_plateform/Nimble_output/zizi")
    ggplotly(plot)
  })


  #-------------------------------------------------------------#
  #--- SERVER salmopred = EXPLORING THE FORECAST
  #-------------------------------------------------------------#


  observeEvent(eventExpr = input$scale_forecast, handlerExpr = {
    if (input$scale_forecast == "Complexes") {
      updateSelectInput(session, "area_forecast", "Select an area", choices = c("North America", "Northern Europe", "Southern Europe"))
      updateSelectInput(session, "vartype_forecast", "Choose the variables to plot", choices = c("Proba to reach conserv. lim.", "Key stages"))
    }
    if (input$scale_forecast == "Stock Units") {
      updateSelectInput(
        session,
        "area_forecast",
        "Select an area",
        # Note from Remi 21/07/2022
        # choices should not be in clear here
        # some values were false since we changed naming system
        # I updated them manually but in the end it should refer
        # to a variable with all names (e.g. regions25)
        choices = c(
          "LB", "NF", "QC", "GF", "SF", "US",
          "FR", "EW", "IR", "NI_FO", "NI_FB", "SC_W", "SC_E", "IC_SW",
          "IC_NE", "SW", "NO_SE", "NO_SW", "NO_MI", "NO_NO", "FI", "RU_KB", "RU_KW", "RU_AK", "RU_RP"
        )
      )
      updateSelectInput(
        session,
        "vartype_forecast",
        "Choose the variables to plot",
        choices = c("Key stages"),
        selected = "Key stages"
      )
    }
    if (input$scale_forecast == "Countries") {
      updateSelectInput(
        session,
        "area_forecast",
        "Select an area",
        choices =
          c(
            "Labrador", "Newfoundland", "Quebec", "Gulf", "Scotia-Fundy", "US",
            "France", "EnglandWales", "Ireland", "Ireland.N", "Scotland", "Iceland.SW",
            "Iceland.NE", "Sweden", "Norway", "Finland", "Russia"
          )
      )
      updateSelectInput(
        session,
        "vartype_forecast",
        label = "Choose the variables to plot",
        choices =
          c(
            "Proba to reach conserv. lim.",
            "Key stages"
          )
      )
    }
  })


  observeEvent(eventExpr = input$scenar_forecast, handlerExpr = {
    if (input$scenar_forecast != "Specific scenario") {
      updateSelectInput(session, "spe_sc_forecast", "Choose specific scenario", choices = c(""))
      shinyjs::hide(id = "spe_sc_forecast")
      shinyjs::show(id = "vartype_forecast")
    } else {
      updateSelectInput(session, "spe_sc_forecast", "Choose specific scenario", choices = c("Faroe0-Greenland0"))
      shinyjs::show(id = "spe_sc_forecast")
      shinyjs::hide(id = "vartype_forecast")
    }
  })


  observeEvent(eventExpr = input$vartype_forecast, handlerExpr = {
    if (input$vartype_forecast != "Key stages") {
      updateSelectInput(session, "graphtype_forecast", "Choose the type of graph", choices = c(""))
      shinyjs::hide(id = "graphtype_forecast")
    } else {
      updateSelectInput(session, "graphtype_forecast", "Choose the type of graph", choices = c("Time-series"))
      # updateSelectInput(session,"graphtype_forecast","Choose the type of graph",choices = c("","Time-series","Final year"))
      shinyjs::show(id = "graphtype_forecast")
    }
  })


  fileloc <- reactive({
    rad4 <- ""
    rad1 <- "reg"

    if (req(input$scale_forecast) == "Stock Units") {
      rad2 <- "su"
    }
    if (req(input$scale_forecast) == "Complexes") {
      rad2 <- "com"
    }
    if (req(input$scale_forecast) == "Countries") {
      rad2 <- "cou"
    }

    if (req(input$scenar_forecast) == "Regulation Faroes") {
      rad3 <- "far"
    }
    if (req(input$scenar_forecast) == "Regulation Greenland") {
      rad3 <- "wg"
    }
    if (req(input$scenar_forecast) == "Specific scenario") {
      rad3 <- "sc"
    }

    if (input$graphtype_forecast == "Final year") {
      rad4 <- "ly"
    }
    if (input$graphtype_forecast == "Time-series") {
      rad4 <- "ts"
    }
    if (input$graphtype_forecast == "") {
      rad4 <- ""
    }
    if (input$vartype_forecast == "Proba to reach conserv. lim.") {
      rad4 <- "cl"
    }
    if (input$vartype_forecast == "") {
      rad4 <- ""
    }

    x <- gsub("__", "_", paste(rad1, rad2, rad3, rad4, sep = "_"))

    if (substring(x, nchar(x), nchar(x)) == "_") {
      x <- substring(x, 1, nchar(x) - 1)
    }
    if (grepl("sc", x)) {
      x <- gsub("_ts", "", x)
    }
    if (grepl("sc", x)) {
      x <- gsub("_cl", "", x)
    }

    return(x)
    #
    # "tik"
  })

  output$verif <-
    renderText(
      paste0(
        "exchange_plateform/Nimble_output/forecast_",
        as.character(fileloc()),
        "_",
        as.character(input$area_forecast),
        ".rds"
      )
    )


  output$plotforecast <- renderPlot({
    file_out_lcm <-
      readRDS(
        paste0(
          "exchange_plateform/Nimble_output/forecast_",
          as.character(fileloc()),
          "_",
          as.character(input$area_forecast),
          ".rds"
        )
      )

    plot(file_out_lcm)
  })


  fileloc2 <- reactive({
    radi1 <- "glob"

    if (req(input$scale_forecast2) == "Complexes") {
      radi2 <- "com"
    }
    if (req(input$scale_forecast2) == "Countries") {
      radi2 <- "cou"
    }

    if (req(input$scenar_forecast2) == "Regulation Faroes") {
      radi3 <- "far"
    }
    if (req(input$scenar_forecast2) == "Regulation Greenland") {
      radi3 <- "wg"
    }

    x <- gsub("__", "_", paste(radi1, radi2, radi3, sep = "_"))

    if (substring(x, nchar(x), nchar(x)) == "_") {
      x <- substring(x, 1, nchar(x) - 1)
    }


    return(x)
  })

  output$verif2 <- renderText(paste0("exchange_plateform/Nimble_output/forecast_", as.character(fileloc2()), ".rds"))


  output$plotforecast2 <- renderPlot({
    file_out_lcm2 <- readRDS(paste0("exchange_plateform/Nimble_output/forecast_", as.character(fileloc2()), ".rds"))
    # plot.new()
    # grid::grid.raster(pngs2)
    plot(file_out_lcm2)
  })


  #-------------------------------------------------------------#
  #--- SERVER salmodatacollect - DB status -------------------------------
  #-------------------------------------------------------------#


  output$box_max <- renderUI({
    infoBox(
      "Updated data", paste(pc_updated(database(), tab_type_object)[1], "%"),
      icon = icon("fish"),
      color = "orange", fill = TRUE, width = 6
    )
  })

  output$box_current_nimble <- renderUI({
    infoBox(
      "Model ready for", pc_updated(database(), tab_type_object)[2],
      icon = icon("calendar-check"),
      color = "green", fill = TRUE, width = 6
    )
  })

  output$box_current_nimble_bis <- renderUI({
    infoBox(
      "Model ready for", pc_updated(database(), tab_type_object)[2],
      icon = icon("calendar-check"),
      color = "olive", fill = TRUE, width = 6
    )
  })

  output$graph_status <- renderPlotly({
    summary_by_type <- timeline_plot_type(database(), tab_type_object)
    ggplotly(summary_by_type)
  })

  output$graph_status_typesel <- renderPlotly({
    summary_given_type <- timeline_plot_typesel(database(), input$seltype_status, tab_type_object)
    ggplotly(summary_given_type)
  })


  #-------------------------------------------------------------#
  #--- SERVER datacall ------------------------------------------
  #-------------------------------------------------------------#


  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host = "localhost", user = "atlas", password = "atlas", dbname = "salmoglob")
  data_for_template <- dbReadTable(con, "database")
  metadata <- dbReadTable(con, "metadata")
  dbDisconnect(con)

  source("R/functions_building_templates_db_formate.R", local = T)

  output$TemplateDataCall <- downloadHandler(
    filename = function() {
      paste("datacall.xlsx", sep = "")
    },
    content = function(file) {
      Const_nimble <- readRDS("exchange_plateform/Nimble_input/Const_nimble.rds")

      SU_id <- tab_labels[which(tab_labels$su_name == input$juri), "su_ab"]
      SU_template <- createWorkbook()

      slice_db <- subset(
        data_for_template,
        data_for_template$area == SU_id &
          data_for_template$var_mod != "cons_lim" &
          data_for_template$var_mod != "log_C6_sup_mu" &
          data_for_template$var_mod != "log_C6_sup_sd" &
          data_for_template$var_mod != "log_C9_sup_mu" &
          data_for_template$var_mod != "log_C9_sup_sd"
      )


      var_data_call <- unique(slice_db$var_mod)

      for (i in var_data_call) {
        produce_template_db_SU_it(slice_db, SU_id, SU_template, i, 1970 + as.numeric(Const_nimble["date_end_hindcast"]))
      }


      worksheetOrder(SU_template) <- order(sheets(SU_template))
      worksheetOrder(SU_template) <- order(sapply(sheets(SU_template), function(x) metadata$type[which(metadata$var_mod == x)]))

      defpage <- metadata[metadata$var_mod %in% sheets(SU_template), c("var_mod", "definition")]
      colnames(defpage) <- c("variable to update", "definition")
      nb_sheets <- length(sheets(SU_template))
      addWorksheet(wb = SU_template, sheetName = "metadata table")
      writeData(SU_template, sheet = (nb_sheets + 1), defpage, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)

      saveWorkbook(SU_template, file = file, overwrite = T)
    }
  )

  output$TemplateDataCallFishery <- downloadHandler(
    filename = function() {
      paste("datacallfishery.xlsx", sep = "")
    },
    content = function(file) {
      Const_nimble <- readRDS("exchange_plateform/Nimble_input/Const_nimble.rds")

      var_fish <- metadata$var_mod[which(metadata$fishery == input$fishjuri)]
      fish_template <- createWorkbook()

      slice_fish_db <- subset(data_for_template, data_for_template$var_mod %in% var_fish)
      var_data_call_fish <- unique(slice_fish_db$var_mod)

      for (i in var_data_call_fish) {
        produce_template_db_fishery_it(slice_fish_db, fish_template, i, 1970 + as.numeric(Const_nimble["date_end_hindcast"]))
      }

      worksheetOrder(fish_template) <- order(sheets(fish_template))
      worksheetOrder(fish_template) <- order(sapply(sheets(fish_template), function(x) metadata$type[which(metadata$var_mod == x)]))

      defpage <- metadata[metadata$var_mod %in% sheets(fish_template), c("var_mod", "definition")]
      colnames(defpage) <- c("variable to update", "definition")
      nb_sheets <- length(sheets(fish_template))
      addWorksheet(wb = fish_template, sheetName = "metadata table")
      writeData(fish_template, sheet = (nb_sheets + 1), defpage, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)

      saveWorkbook(fish_template, file = file, overwrite = T)
    }
  )

  shinyjs::hide(id = "download_Datanimb_old")
  shinyjs::hide(id = "download_Constnimb_old")
  shinyjs::hide(id = "generate_old")

  output$download_Datanimb <- downloadHandler(
    filename = function() {
      paste("Data_nimble.rds", sep = "")
    },
    content = function(file) {
      Data_nimble <- readRDS("exchange_plateform/Nimble_input/Data_nimble.rds")
      saveRDS(Data_nimble, file = file)
    }
  )

  output$download_Constnimb <- downloadHandler(
    filename = function() {
      paste("Const_nimble.rds", sep = "")
    },
    content = function(file) {
      Const_nimble <- readRDS("exchange_plateform/Nimble_input/Const_nimble.rds")
      saveRDS(Const_nimble, file = file)
    }
  )

  observeEvent(eventExpr = input$nimble_older, {
    if (input$nimble_older == TRUE) {
      shinyjs::show(id = "maxyear")
      # shinyjs::show(id = "download_Datanimb_old")
      # shinyjs::show(id = "download_Constnimb_old")
      shinyjs::show(id = "generate_old")
      shinyjs::hide(id = "download_Datanimb")
      shinyjs::hide(id = "download_Constnimb")
    } else {
      shinyjs::hide(id = "maxyear")
      shinyjs::hide(id = "download_Datanimb_old")
      shinyjs::hide(id = "download_Constnimb_old")
      shinyjs::hide(id = "generate_old")
      shinyjs::show(id = "download_Datanimb")
      shinyjs::show(id = "download_Constnimb")
    }
  })

  observeEvent(eventExpr = input$generate_old, {
    source("R/store_Nimble_objects_older.R", local = T)

    if (input$nimble_older == TRUE) {
      shinyjs::show(id = "download_Datanimb_old")
      shinyjs::show(id = "download_Constnimb_old")
    } else {
      shinyjs::hide(id = "download_Datanimb_old")
      shinyjs::hide(id = "download_Constnimb_old")
    }
  })


  output$download_Datanimb_old <- downloadHandler(
    filename = function() {
      paste("Data_nimble_old.rds", sep = "")
    },
    content = function(file) {
      Data_nimble_old <- readRDS("exchange_plateform/Nimble_input/Data_nimble_old.rds")
      saveRDS(Data_nimble_old, file = file)
    }
  )

  output$download_Constnimb_old <- downloadHandler(
    filename = function() {
      paste("Const_nimble_old.rds", sep = "")
    },
    content = function(file) {
      Const_nimble_old <- readRDS("exchange_plateform/Nimble_input/Const_nimble_old.rds")
      saveRDS(Const_nimble_old, file = file)
    }
  )

  #-------------------------------------------------------------#
  #--- SERVER salmodatacollect ------------------------------------
  #-------------------------------------------------------------#

  observe({
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$Biencuits)
          Password <- isolate(input$Coockies)
          if (length(which(tab_users$username == Username)) == 1) {
            pasmatch <- tab_users[which(tab_users$username == Username), "password"]

            if (pasmatch == Password) {
              USER$login <- TRUE

              shinyjs::hide(id = "login")
              shinyjs::hide(id = "Biencuits")
              shinyjs::hide(id = "Coockies")
            } else {
              shinyjs::show(id = "login")
              showNotification("Oops..! Wrong Username and/or Password", duration = 4.5, type = "warning")
            }
          } else {
            shinyjs::show(id = "login")
            showNotification("Oops..! Wrong Username and/or Password", duration = 4.5, type = "warning")
          }
        }
      }
    }
  })

  welcom_mess <- reactive({
    welcoming <- ""
    if (USER$login == FALSE) {
      welcoming <- ""
    } else if (USER$login == TRUE) {
      welcoming <- as.character(paste("Welcome onboard,", tab_users[which(tab_users$username == isolate(input$Biencuits)), "firstname"],
        tab_users[which(tab_users$username == isolate(input$Biencuits)), "lastname"], "!",
        sep = " "
      ))
    }
    return(welcoming)
  })


  output$welcome <- renderText(as.character(welcom_mess()))


  output$logoutbtn <- renderUI({
    req(USER$login) # ,
    actionButton("logout", "Logout", style = "color: white;background-color:#800000;
                  padding: 10px 15px; width: 150px; cursor: pointer;
                 font-size: 18px; font-weight: 600;")
  })

  observeEvent(input$logout, {
    shinyjs::refresh()
  })


  output$bodymod <- renderUI({
    if (USER$login == TRUE) {
      div(
        fluidPage(
          shinyjs::useShinyjs(),
          headerPanel("Updating the Salmon database"),
          # titlePanel(h3("title for category 1")),

          # mainPanel(

          fluidRow(
            tabBox(
              width = 12,
              tabPanel(
                "Uploading interface",
                column(
                  12,

                  # fluidRow(width=12,

                  ######
                  column(
                    3,
                    headerPanel("1. Select the data to update"),
                    # DEACTIVATED FOR DIFFUSION


                    # selectInput(inputId ="datatype", label = strong("Filter by Data Type"), choices = c(' ', unique(database()$type)), multiple=F),
                    # Proposing the datatypes following the order in the metadata table + removing deprecated variables
                    selectInput(
                      inputId = "datatype",
                      label = strong("Filter by Data Type"),
                      choices =
                        c(
                          " ",
                          unique(
                            unique(
                              database()[
                                -which(
                                  database()$var_mod %in% c("CV_dummy")
                                ),
                                c("var_mod", "type")
                              ]
                            )[
                              order(
                                match(
                                  unique(
                                    database()$var_mod[
                                      !database()$var_mod %in% c("CV_dummy")
                                    ]
                                  ),
                                  unique(
                                    tab_type_object$var_mod
                                  )
                                )
                              ),
                            ]$type
                          )
                        ),
                      multiple = F
                    ),
                    radioButtons(
                      "metric_type",
                      "Mean / Stand. Dev.",
                      choices =
                        c("mean" = "Mean", "sd" = "Standard deviation"),
                      selected = "Mean",
                      inline = T
                    ),
                    selectInput(
                      inputId = "varcode",
                      label = strong("Select the variable"),
                      choices = NULL,
                      multiple = F
                    ),
                    downloadButton(
                      "downloadData", "Download current data at right format"
                    ),
                    tags$hr(),
                    headerPanel("2. Upload new data"),
                    checkboxInput("header", "Header", TRUE),
                    radioButtons(
                      "sep",
                      "Separator",
                      choices =
                        c(Comma = ",", Semicolon = ";", Tab = "\t"),
                      selected = ",",
                      inline = T
                    ),
                    radioButtons(
                      "quote",
                      "Quote",
                      choices =
                        c(None = "", "Double Quote" = '"', "Single Quote" = "'"),
                      selected = '"',
                      inline = T
                    ),
                    radioButtons(
                      "disp",
                      "Display",
                      choices =
                        c(Head = "head", All = "all"),
                      selected = "head",
                      inline = T
                    ),
                    fileInput(
                      "file1",
                      paste("Select a .csv file to upload the data", sep = ""),
                      multiple = TRUE,
                      accept =
                        c("text/csv", "text/comma-separated-values,text/plain", ".csv")
                    )
                  ),
                  column(
                    6,
                    useShinyjs(),
                    h1("3. Visualize current and new data"),
                    plotlyOutput("graph"),
                    actionButton("previous_st", label = "Previous"),
                    actionButton("next_st", label = "Following"),
                    downloadButton("stockplots", "Download all graph comparisons"),
                    fluidRow(
                      fluidRow(
                        column(
                          width = 12,
                          box(
                            width = 12,
                            # strong(span(textOutput("warning_upload"), style=verbatimTextOutput("color_warning"))),
                            strong(htmlOutput("warning_upload")),
                            hidden(div(id = "warning_emergency", strong(span("The emergency procedure is activated!", style = "color:red")))),
                            DT::dataTableOutput("contents"),
                            # DT::dataTableOutput("archived_data2"),
                            style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
                          )
                        )
                      )
                    )
                  ),
                  column(
                    3,
                    h1("4. Personal info & Validation"),
                    p("Please enter your name, the institute you work for and your mail so that you can track modifications."),
                    textInput(
                      inputId = "Firstname",
                      label = h3("Firstname"),
                      value =
                        tab_users[
                          which(
                            tab_users$username == isolate(input$Biencuits)
                          ),
                          "firstname"
                        ]
                    ), # ),

                    textInput(
                      inputId = "Name",
                      label = h3("Name"),
                      value =
                        tab_users[
                          which(
                            tab_users$username == isolate(input$Biencuits)
                          ),
                          "lastname"
                        ]
                    ), # ),

                    textInput(
                      inputId = "Institute",
                      label = h3("Intitute"),
                      value =
                        tab_users[
                          which(
                            tab_users$username == isolate(input$Biencuits)
                          ),
                          "affiliation"
                        ]
                    ), # ),

                    textInput(
                      inputId = "email",
                      label = h3("em@il"),
                      value =
                        tab_users[
                          which(
                            tab_users$username == isolate(input$Biencuits)
                          ), "contact"
                        ]
                    ), # ),

                    actionButton(
                      inputId = "valid",
                      label = "Validate",
                      icon = icon("check-circle"),
                      style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
                    ), # )


                    br(),
                    br(),
                    br(),
                    br(),
                    br(),
                    p("In case of problem with the importation procedure:"),
                    actionButton(
                      inputId = "emergency",
                      label = "Emergency procedure",
                      icon = icon("ambulance"),
                      style = "color: #fff; background-color: #ff5739; border-color: #ff0800"
                    ),
                    hidden(
                      div(
                        id = "before_emerg",
                        h5(
                          "In some cases, and because all eventualities cannot be anticipated, the check procedure of
                                                                                    the application could prevent the user from uploading a correct file. In case of emergency (e.g. during WGNAS),
                                                                                    you can deactivate the tests relative to the uploaded table content and force the update of the database.",
                          strong("AFTER CAREFULLY CHECKING YOUR DATA AND NOTIFYING THE APP MAINTAINER,"), "check the following box:"
                        )
                      )
                    ),
                    hidden(checkboxInput("activ_emerg", "Activate emergency", FALSE)),
                    textOutput("zizounette")
                  )
                  # )
                )
              ),
              tabPanel(
                "Database status",
                column(
                  12,

                  # fluidRow(
                  column(
                    6,
                    # headerPanel("General status"),
                    h1("General status"),
                    uiOutput("box_max"),
                    uiOutput("box_current_nimble"),
                    box(plotlyOutput("graph_status"), width = 12)
                  ),
                  column(
                    6,
                    # headerPanel("Specific variable type"),
                    h1("Specific variable type"),
                    radioButtons(
                      "seltype_status",
                      "Choose a variable type",
                      choices =
                        c(
                          "Fecundity" = "Fecundity rate",
                          "HW catches" = "Homewater catches",
                          "% sea catches" = "Origin distribution in sea catches",
                          "Hyperparam" = "Prior hyperparameter",
                          "% delayed spw" = "Proportion of delayed individuals",
                          "% female" = "Sex ratio",
                          "Returns" = "Returns",
                          "Sea catches" = "Sea catches",
                          "Smolt %" = "Smolt age structure",
                          "Stocking" = "Stocking",
                          "Survival" = "Survival rate"
                        ),
                      selected = "Returns",
                      inline = T
                    ),
                    # plotlyOutput("graph_status_typesel"))
                    box(plotlyOutput("graph_status_typesel"), width = 12)
                  )
                  # box(plotlyOutput("graph_status")

                  # )
                )
              )
            )
          )
          # )
        )
      )
    } else if (USER$login == FALSE) {
      div(
        headerPanel("Updating the Salmon database"),
        p("Please authenticate to access to this part of the ToolBox.")
      )
    }
  })
}

shinyApp(ui, server)
