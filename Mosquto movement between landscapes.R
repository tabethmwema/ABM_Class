# Set Working Directory
setwd("C:/Users/tzm0087/OneDrive - Auburn University/Documents/SCHOOL/PhD/CLASSES/THIRD YEAR/AGENT-BASED MODELING/ABM_Class")

rm(list = ls()) ##Clear the environment

# Load necessary libraries
library(sp)
library(raster)
library(sf)

# Create insecticide resistant mosquitoes/individuals
# R = resistant
# S = susceptible
# Breed = reproduce
Mosquito1 <- data.frame( MosquitoNo = 1,
                         State = "R",
                         Breeding = runif(1,0,1) )

nPop1 <- 1000
# Create a population of parents
for( i in 2:nPop1){
  Mosquito2 <- data.frame( MosquitoNo = i,
                           State = "S",
                           Breeding = runif(1,0,1) )
  Mosquito1 <- rbind( Mosquito1, Mosquito2 )
}

nTime1 <- 10 # How long the model will run 
Out1 <- matrix( 0, ncol = 2, nrow = nTime1) #Print a matrix with susceptible and resistant individuals

# Iterate mosquitoes through time
for(k in 1:nTime1) {
  for( i in 1:nPop1 ){
    # Let the resistant mosquito breed with others
    Breed1 <-Mosquito1$Breeding[ i ]
    
    # Define how individuals will breed with each other
    Meet1 <- round(Breed1*3,0) + 1
    
    # Decide which mosquitoes mosquito1 will breed with
    Meet2 <- sample( 1:nPop1, Meet1, replace = TRUE, 
                     prob = Mosquito1$Breeding )
    for( j in 1:length(Meet2) ){
      # Pick who mosquito1 will breed with
      Meet1a <- Mosquito1[ Meet2[j], ]
      # If exposed, change state (it should be the offspring, how?)
      if( Meet1a$State == "R" ){
        Urand1 <- runif(1,0,1)
        if( Urand1 < 0.2 ) { # 20% chance of resistance mosquito breeding with a susceptible one # I can change the %
        Mosquito1$State[i] <- "R"
        }
      }
    }
  }
  
  # Check how many are susceptible/resistant
  Out1[k,] <-table( Mosquito1$State )
  Mosquito1 [ Mosquito1$State == "S", ] # Replace with "R" to check susceptible
}

Out1 #Check the progression of susceptible/resistant mosquitoes through time

# I managed to set up a resistant population breeding with a susceptible population, but now I need to simulate the reproduction of offspring to show movement of resistant alleles
# Set up parents

# Offspring

# Create a new data frame for the offspring
OffspringMosquito <- data.frame(MosquitoNo = 1:nPop1,  # Unique identifiers for offspring
                                State = "S",  # Initial state for offspring (can be susceptible)
                                Breeding = runif(nPop1, 0, 1))

for (i in 1:nPop1) {
  parent1 <- Mosquito1[sample(1:nPop1, 1), ]  # Randomly select a parent
  parent2 <- Mosquito1[sample(1:nPop1, 1), ]  # Randomly select another parent
  
  # Check if either parent is resistant
  if (parent1$State == "R" || parent2$State == "R") {
    OffspringMosquito$State[i] <- "R"  # Set the offspring's state to resistant
  } else {
    OffspringMosquito$State[i] <- "S"  # Set the offspring's state to susceptible
  }
}









