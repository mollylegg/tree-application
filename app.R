library(shiny)
library(rpart)
library(partykit)
library(ggplot2)
library(shinyfilter)


all_sec <- read.csv("~/Desktop/Reactive_Trees/sec_cleaned.csv")
all_sec <- all_sec[, -c(1)]
diffshape <- c("success", "diff_fb_speed", "diff_fb_spin", "diff_fb_ivb", "diff_fb_hb")

#user interface (front end)
ui <- fluidPage(
  
  # Application title
  titlePanel("Success Trees"),
  
  #layout -------
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("team1", label = "Team", 
                  choices = sort(unique(all_sec$pitcherteam)), 
                  selected = 1),
      #okay so i just wrote out every name imaginable when doing cmd. 
      selectInput("pitcher1", label = "Pitcher", 
                  choices = sort(unique(all_sec$pitcher)), 
                  selected = 1),
      #once pitcher is chosen ask for pitch type
      
      selectInput("pitchtype1", label = "Pitch Type",
                     choices = unique(all_sec$taggedpitchtype)),
      selectInput("prune1", label = "Prune Tree?",
                  choices = list("No", "Yes")),
      
      
      p(""),
      p("Key:"),
      p("Diff_fb_measurment < negative: greater decrease (i.e. bigger drop)"),
      p("Diff_fb_measurment > negative: lesser decrease (i.e. smaller drop)"),
      p("Diff_fb_measurment < positive: lesser increase (i.e. smaller jump)"),
      p("Diff_fb_measurment > positive: greater increase (i.e. bigger jump)"),
      p(""),
      #define success
      p("Success (S): Strike Called, Strike Swinging, Foul Ball"),
      p("Failure (F): Everything else"),
      
      
      
    ),
    mainPanel(
      #show the tree!
      plotOutput("tree")
    )
  )
)


#back end stuff
server <- function(input, output, session) {
  #reactive stuff ---------
  observe({
    x <- input$team1
    team_pitchers = sort(unique(all_sec[all_sec$pitcherteam == x, c('pitcher')]))
    
    
    updateSelectInput(session, "pitcher1",
                      choices = team_pitchers)
  })
  
  observe({
    x = input$team1
    y = input$pitcher1
    arsenal = unique(all_sec[all_sec$pitcherteam == x & all_sec$pitcher == y, c('taggedpitchtype')])
    
    updateSelectInput(session, 'pitchtype1',
                      choices = arsenal)
  })
  
  
  #functions --------
  make_trees <- function(data_set, columns, pitchtype){
    offspeed = data_set[data_set$taggedpitchtype == pitchtype, columns]
    
    tree1 = rpart(success~., data = offspeed)
    #add inputs for pitcher names
    return(tree1)
  }
  
  
  prune_trees <- function(tree2){
    cptablenew = as.data.frame(tree2$cptable)
    cptablenew = cptablenew[cptablenew$nsplit != 0,]
    if(nrow(cptablenew) >0){
      bestcp = cptablenew[which.min(cptablenew[,"xerror"]),"CP"]
      tree3 = prune(tree2, cp = bestcp )
      return(tree3)
    } else {
      return(tree2)
    }
    
  }
  
  #make the trees!--------
  output$tree <- renderPlot({
    set.seed(1)
    pitcher_name = input$pitcher1
    pitch_type = input$pitchtype1
    prune_it = input$prune1
    pitcher_set = all_sec[all_sec$pitcher == pitcher_name,]
    
    
    just_pitch_type = pitcher_set[pitcher_set$taggedpitchtype == pitch_type,]
    if(nrow(just_pitch_type) > 0){
      blank_tree <- make_trees(pitcher_set, diffshape, pitch_type)
      if(prune_it == "No"){
        plot(as.party(blank_tree), main = pitch_type)
      } else {
        blank_prune = prune_trees(blank_tree)
        plot(as.party(blank_prune), main = pitch_type)
      }
      
    } else {
      #thank you stack overflow
      par(mar = c(0,0,0,0))
      plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
      text(x = 0.5, y = 0.5, paste("No tree"), 
           cex = 1.6, col = "black")
    }
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
