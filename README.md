# tree-application
Reactive tree App
Uses 2023 SEC baseball data to generate tree models predicting the success and failure of pitches.  


# How Its Made
Coding Languages used: R
App Used: R Studio with R Shiny

I used R shiny to create a web app that takes user input to generate a tree that predicts the success or failure of a pitch based on the difference from the average fastball. I have also included the function that cleaned the Trackman Data used. 

# How to use:

Either download the files to host the app locally or go to [https://connect.posit.cloud/mollylegg/content/019aff31-e1d6-4d5c-c05c-5e190676b090](https://019aff31-e1d6-4d5c-c05c-5e190676b090.share.connect.posit.cloud/) to use on the web! Select the desired team, pitcher and pitch type to build a tree, then prune if desired. You can generate as many trees as you'd like. 

Note: Team names are the team's Trackman team tag. So, ALA_CRI are the Alabama Crimson Tide, ARK_RAZ are the Arkansas Razorbacks, AUB_TIG are the Auburn Tigers and so on.

Interpreting the Tree: diff_fb_measurement is calculated by subtracting the average FB measurement from any specific pitch, i.e. Curveball Speed - Fastball Speed = diff_fb_speed. Success is represented by the darker parts of the nodes, whereas failures are the lighter parts of the nodes.

# Optimization
Thank you UpdateSelectInput(), this function was the saving grace of making my app so much more refined. This allowed me to sort by team, then pitcher, and avoid pitch types that the pitcher doesn't throw.
