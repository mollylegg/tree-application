# tree-application
Reactive tree App
Uses 2023 SEC baseball data to generate tree models predicitng the success and failure of pitches.  


# How Its Made
Coding Languages used: R
App Used: R Studio with R Shiny

I used R shiny to create a web app that takes user input to generate a tree that predicts the success or failure of a pitch based on the difference from the average fastball. I have also included the function that cleaned the Trackman Data used. 

# Optimization
Thank you UpdateSelecteInput(), this function was the saving grace of making my app so much more refined. This allowed me to sort by team, then pitcher, and avoid pitch types that the pitcher doesn't throw.
