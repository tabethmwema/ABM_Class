setwd("C:/Users/tzm0087/OneDrive - Auburn University/Documents/SCHOOL/PhD/CLASSES/THIRD YEAR/AGENT-BASED MODELING/ABM_Class")
rm(list=ls(all=T))

# Define model parameters
num_mosquitoes <- 400     # Number of mosquitoes in the area
num_people <- 100        # Total number of people in the area
area_size <- 100          # Size of the area 10m squared
mosquito_flight_distance <- 3  # Maximum flight distance of mosquitoes (in meters)
road_barrier <- matrix(0, nrow = area_size, ncol = area_size)  # Initialize road barrier matrix, represents a grid of an area where each cell in the grid can be either a road barrier or not (0 means no road barrier)

# Create roads that impede mosquito movement
# let's assume a diagonal road from top-left to bottom-right
for (i in 1:area_size) {
  road_barrier[i, i] <- 1
}

# Create a matrix to represent human availability in the area
human_availability <- matrix(0, nrow = area_size, ncol = area_size)

# Randomly distribute humans in the area
available_cells <- sample(1:(area_size^2), num_people)
for (cell in available_cells) {
  row <- (cell - 1) %/% area_size + 1
  col <- (cell - 1) %% area_size + 1
  human_availability[row, col] <- 1
}

# Initialize mosquito positions randomly
mosquito_positions <- matrix(0, nrow = num_mosquitoes, ncol = 2)
for (i in 1:num_mosquitoes) {
  mosquito_positions[i, 1] <- sample(1:area_size, 1)
  mosquito_positions[i, 2] <- sample(1:area_size, 1)
}

# Create a data frame to store bite counts for each person
bite_data <- data.frame(PersonID = 1:num_people, BiteCount = 0)


# Simulate mosquito movement and biting
for (step in 1:100) {  # Simulate 100 time steps
  for (i in 1:num_mosquitoes) {
    # Randomly choose a direction to move
    direction <- sample(c("up", "down", "left", "right"), 1)
    
    # Calculate the new position
    new_position <- mosquito_positions[i, ]
    if (direction == "up") {
      new_position[1] <- max(1, mosquito_positions[i, 1] - 1)
    } else if (direction == "down") {
      new_position[1] <- min(area_size, mosquito_positions[i, 1] + 1)
    } else if (direction == "left") {
      new_position[2] <- max(1, mosquito_positions[i, 2] - 1)
    } else if (direction == "right") {
      new_position[2] <- min(area_size, mosquito_positions[i, 2] + 1)
    }
    
    # Check for road barriers and adjust position if necessary
    if (road_barrier[new_position[1], new_position[2]] == 1) {
      # Mosquito cannot cross the road, so it stays in the same position
      mosquito_positions[i, ] <- mosquito_positions[i, ]
    } else {
      # Update mosquito's position
      mosquito_positions[i, ] <- new_position
    }
    
    # Check if a mosquito bites a human (assuming random encounters)
    if (human_availability[mosquito_positions[i, 1], mosquito_positions[i, 2]] == 1) {
      # Increase the bite count for the bitten person
      bitten_person <- which(available_cells == ((mosquito_positions[i, 1] - 1) * area_size + mosquito_positions[i, 2]))
      bite_data$BiteCount[bitten_person] <- bite_data$BiteCount[bitten_person] + 1
    }
  }
}

# Run a regression for the number of bites a person receives in a 10 m² area
# use a linear regression model:

# Calculate 'num_people' based on the dimensions of the area
bite_data$num_people <- rep(num_people, nrow(bite_data))

library(raster)
library(sp)

# Create a raster layer for road barriers
road_raster <- raster(matrix(road_barrier, nrow = area_size, ncol = area_size))

# Create a matrix representing human locations
human_matrix <- matrix(human_availability, nrow = area_size, ncol = area_size)

# Find the coordinates of human locations
human_coords <- which(human_matrix == 1, arr.ind = TRUE)

# Convert the coordinates to SpatialPoints
human_points <- SpatialPoints(coords = human_coords)

# Calculate distance from each human point to the nearest road barrier
distance_to_road <- raster::distanceFromPoints(road_raster, human_points)

# Extract distances as a matrix
distance_matrix <- raster::extract(distance_to_road, human_points)

# Convert distances to a vector
distance_vector <- as.vector(distance_matrix)

# Assign distances to individuals (assuming you have individual-level data)
bite_data$distance_to_road <- distance_vector


# Calculate the distance of each person to the nearest road barrier
# Use a spatial analysis library like 'spatialEco' or 'gdistance' to calculate distances


# Create a linear regression model to assess the impact of distance to road barriers
model <- lm(BiteCount ~ num_people + distance_to_road, data = bite_data)

# Summarize the regression results
summary(model) #Not giving the output I want



# Simulation is complete

# Analyze and visualize the results

# I have the following data:
# - mosquito_positions: A matrix of mosquito positions (num_mosquitoes x 2)
# - human_availability: A matrix representing human availability (area_size x area_size)

# Initialize a grid to count human bites in each 10x10 meter square
grid_size <- 10  # Size of each grid square in meters
num_grid_rows <- area_size / grid_size
num_grid_cols <- area_size / grid_size
grid_counts <- matrix(0, nrow = num_grid_rows, ncol = num_grid_cols)

# Iterate through mosquitoes to count bites in each grid square
for (i in 1:num_mosquitoes) {
  row <- mosquito_positions[i, 1]
  col <- mosquito_positions[i, 2]
  
  # Calculate the grid square where the mosquito is located
  grid_row <- ceiling(row / grid_size)
  grid_col <- ceiling(col / grid_size)
  
  # Update the count for that grid square
  grid_counts[grid_row, grid_col] <- grid_counts[grid_row, grid_col] + 1
}

# Load necessary libraries for visualization
library(ggplot2)
library(reshape2)  # For data manipulation

# Convert grid_counts to a data frame for ggplot2
grid_df <- data.frame(
  Row = rep(1:num_grid_rows, each = num_grid_cols),
  Col = rep(1:num_grid_cols, times = num_grid_rows),
  Bites = as.vector(grid_counts)
)

# Create a heatmap
ggplot(data = grid_df, aes(x = Col, y = Row, fill = Bites)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Mosquito Bites in 10x10 Meter Squares", x = "Column", y = "Row") +
  theme_minimal()




