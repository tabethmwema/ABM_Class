setwd("C:/Users/tzm0087/OneDrive - Auburn University/Documents/SCHOOL/PhD/CLASSES/THIRD YEAR/AGENT-BASED MODELING")

# Placeholder function to calculate Euclidean distance between two points
#euclidean_distance <- function(x1, y1, x2, y2) {
  #sqrt((x2 - x1)^2 + (y2 - y1)^2)
#}

experiment_name <- "0.1_Culex"

output_folder <- "output"
# make sure the output folder exists
if (!dir.exists(output_folder)) {
  dir.create(paste(output_folder + "/" + experiment_name))
}

# Revised function to simulate resistance evolution for a species
simulate_species <- function(mean_resistance, Pop_size, lifespan_male, lifespan_female, eggs_laid, days_to_hatch, days_between_eggs, num_days_per_generation, num_generations, spraying_interval, resistance_increase, mortality_rate, carrying_capacity) {
  population <- data.frame(
    id = 1:Pop_size,
    resistance = pmax(rnorm(Pop_size, mean_resistance, 0.1), 0),  # Assign initial resistance with some noise, ensuring non-negative values
    gender = sample(c("male", "female"), Pop_size, replace = TRUE),
    days_alive = sample(0:lifespan_female, Pop_size, rep=TRUE)
    
  )
  
  population$last_laid <- sample(0:population$days_alive-1,Pop_size,rep=TRUE)
  
  num_eggs_laid <- rep(0, nrow(population))  # Initialize a vector to track egg-laying for each female
  num_offspring <- 0  # Initialize num_offspring
  
  for (generation in 1:num_generations) {
 
    if (generation %% spraying_interval == 0 ) {
      # Initialize affected_indices outside the loop
      affected_indices <- c()  # Initialize empty vector to store indices of affected individuals
      
      # Loop through each individual in the population
      for (i in 1:nrow(population)) {
        if (population$resistance[i] < 1) {
          spraying_susceptibility <- 0.5  # Example: 50% susceptibility to spraying
          susceptible_mortality <- rbinom(1, 1, spraying_susceptibility * mortality_rate * population$resistance[i])
          
          if (susceptible_mortality == 1) {
            # Individual is affected by spraying - update resistance
            
            # Append the index of affected individual
            affected_indices <- c(affected_indices, i)
          }
        }
      }

      # Update mortality status using the collected affected indices
      for (i in 1:nrow(population)) {
        if (i %in% affected_indices) {
          population$died[i] <- TRUE
        } else {
          population$died[i] <- FALSE
        }
      }

      # Remove deceased individuals from the population
      population <- population[population$died != TRUE, ]
      # Remove the 'died' column
      population$died <- NULL
 
      
    }
  
    for (day in 1:num_days_per_generation) {
      
      num_females <- sum(population$gender == "female")
      num_males <- nrow(population) - num_females
      
      population$last_laid <- population$last_laid + 1

      if (num_females > 0) {
        lay_eggs_indices <- which(population$gender == "female" & population$last_laid > days_between_eggs )
        # set a random selection of 70% of eligible females lay
        
        lay_eggs_indices <- lay_eggs_indices[sample(1:length(lay_eggs_indices), size = round(0.7 * length(lay_eggs_indices)))]
        num_eggs_laid[lay_eggs_indices] <- num_eggs_laid[lay_eggs_indices] + eggs_laid
        #record day of last_laid
        population$last_laid[lay_eggs_indices] <- 0
      }
      
      

hatched_eggs <- num_eggs_laid[((day - days_to_hatch)) & !is.na(num_eggs_laid)]
if (length(hatched_eggs) > 0 && sum(hatched_eggs) > 0) {
  num_hatchlings <- sum(hatched_eggs)

  male_parents <- which(population$gender == "male")
  female_parents <- which(population$gender == "female")

  if (length(male_parents) > 0 && length(female_parents) > 0) {
    selected_male_parents <- sample(male_parents, num_hatchlings * 2, replace = TRUE)
    selected_female_parents <- sample(female_parents, num_hatchlings, replace = TRUE)

    selected_male_parents <- selected_male_parents[seq_len(num_hatchlings)]  # Limit male parents to mate once per female

    parent1_resistance <- population[selected_male_parents, "resistance"]
    parent2_resistance <- population[selected_female_parents, "resistance"]
    
    avg_resistance_parents <- (parent1_resistance + parent2_resistance) / 2  # Average resistance of parents

    gender_choice <- sample(c("male", "female"), num_hatchlings, replace = TRUE)  # Randomly assigning gender to offspring

    noise <- rnorm(num_hatchlings, 0, 0.1)
   
    hatchling_data <- data.frame(
      id = (nrow(population) + 1):(nrow(population) + num_hatchlings),
      resistance = avg_resistance_parents + noise,
      gender = gender_choice,
      last_laid = rep(0, num_hatchlings),  # Track the last laid day for each female
      days_alive = rep(0, num_hatchlings)
    )
    population <- rbind(population, hatchling_data)
  }
}
      
      population$resistance[population$resistance > 1] <- 1
      population$resistance[population$resistance < 0] <- 0
      # Apply carrying capacity and randomly kill excess
      if (nrow(population) > carrying_capacity) {
        excess <- nrow(population) - carrying_capacity
        excess_indices <- sample(1:nrow(population), size = excess, replace = FALSE)
        excess_to_remove <- min(excess, length(excess_indices))  # Adjust excess to be removed
        
        population <- population[-excess_indices[1:excess_to_remove], , drop = FALSE]
      }
      
      # any mosquito that is older than lifespan dies
      
      # output result to data frame
      cat(paste("Generation", generation, ", Day", day, ": Resistance mean", mean(population$resistance), ", Population size", nrow(population), "\n"))
      population$days_alive <- population$days_alive + 1
      # kill mosquitos that are older than lifespan male and female
      
      # get the indices of the male mosquitos older than lifespan
      male_indices_to_remove <- which(population$gender == "male" & population$days_alive > lifespan_male)
      
      if (length(male_indices_to_remove) > 0) {
        population <- population[-male_indices_to_remove, , drop = FALSE]
      }
    
      female_indices_to_remove <- which(population$gender == "female" & population$days_alive > lifespan_female)
      
      if (length(female_indices_to_remove > 0)) {
      population <- population[-female_indices_to_remove, , drop = FALSE]
      }
      
      print(paste("Generation", generation, ", Day", day, ": Resistance mean", mean(population$resistance), ", Population size", nrow(population)))
  
      
      
      }
    
    file_name <- paste0(output_folder, "/generation_", generation, ".csv")
    
    write.csv(population, file_name, row.names = FALSE)
    
    
      }
}

# Parameters for Culex mosquitoes
Pop_size_culex <- 2000
lifespan_male_culex <- 12
lifespan_female_culex <- 15
eggs_laid_culex <- 50
days_to_hatch_culex <- 5 # Days for eggs to hatch
days_between_eggs_culex <- 2
num_generations_culex <- 20
spraying_interval_culex <- 3 # Adjust the spraying interval
resistance_increase_culex <- 0.05
mortality_rate <- 0.7
num_days_per_generation <- 9
carrying_capacity_culex <- 8000 # Set the carrying capacity
starting_mean_resistance <- 0.1  
#migration rate<-???


# Simulate Culex mosquitoes with the modified function
sim<- simulate_species(starting_mean_resistance, Pop_size_culex, lifespan_male_culex, lifespan_female_culex,
                       eggs_laid_culex, days_to_hatch_culex, days_between_eggs_culex, num_days_per_generation,
                       num_generations_culex, spraying_interval_culex, resistance_increase_culex,
                       mortality_rate, carrying_capacity_culex)

for (i in 1:num_generations_culex) {
  file_name <- paste0(output_folder, "/generation_", i, ".csv")
  population <- read.csv(file_name)
  
  # calc the mean resistance
  mean_resistance <- mean(population$resistance)
  #count the number of mosquitoes
  
  num_mosquitoes <- nrow(population)
  
  # append results to the data frame
  
  sim <- rbind(sim, data.frame(generation = i, mean_resistance = mean_resistance, num_mosquitoes = num_mosquitoes))
}



# install.packages("ggplot2")  # if not installed
# install.packages("gganimate")
# install.packages("transformr")
# install.packages("gifski")
library(ggplot2)
library(gganimate)
library(transformr)
library(gifski)


p <- ggplot(sim, aes(x = generation, y = mean_resistance)) +
  geom_line(color = "cadetblue1", size = 1.5) +  # Change the color to blue (or any other color)
  geom_point(color = "cadetblue1") +  # Change the color of the points
  scale_x_continuous(breaks = seq(0, num_generations_culex, 1)) +
  labs(x = "Generation", y = "Mean resistance", title = "Mean resistance over time") +
  theme_minimal()  # Add a white background

# Print the plot
print(p)


p_animation <- p +
transition_reveal(generation) +
labs(subtitle = "Generation: {frame_time}")

anim_save(
  "p_animation.gif", 
  p_animation, 
  height = 600, 
  width = 1000,
  renderer = gifski_renderer()
)


p2 <- ggplot(sim, aes(x = generation, y = num_mosquitos)) +
  geom_line(color = "steelblue1", size = 1.5) +
  geom_point(color = "steelblue1") +
  scale_x_continuous(breaks = seq(0, num_generations_culex, 1)) +
  labs(x = "Generation", y = "Number of mosquitos", title = "Number of mosquitos over time")+
  theme_minimal()  # Add a white background

print(p2)

p2_animation <- p2 +
  transition_reveal(generation) +
  labs(subtitle = "Generation: {frame_time}")

anim_save(
  "p2_animation.gif", 
  p2_animation, 
  height = 600, 
  width = 1000,
  renderer = gifski_renderer()
)
