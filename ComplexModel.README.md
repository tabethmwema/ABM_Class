# Overview

The aim of this model is to simulate mosquito movement between two landscapes to understand how insecticide-resistant alleles and diseases such as malaria are impacted by different landscape management (insecticide spray) and parasite frequency. The landscapes will include both urban and forested areas, which have barriers to movement such as roads while mosquito species characteristics will be defined by their susceptibility status to parasites and insecticides and the distance they can fly. The model will use discrete time steps in which mosquitoes will have to decide whether to move between landscapes based on flight distance and road barriers. The model will also analyze how selection (insecticide resistance) affects the survival of mosquitoes.

### Entities and scales

*Mosquito agents*: Mosquitoes will either be susceptible or resistant to parasites and/or insecticides. Their attributes will include species, flight capacity, lifespan, number of eggs laid, days it takes for the eggs to hatch, the number of days between egg laying, number of generations, insecticide spraying interval, mortality rate, number of generations, carrying capacity, the mean starting resistance and age. Different species fly varied distances and some parasites may require a certain period to become infective before they can be transmitted. Therefore, the age of a mosquito can determine whether the parasites
are transmitted or not. The mosquito population size, the frequency of parasites, and resistant alleles will also be set.

*Landscape*: Urban and forested landscapes will be simulated to have barriers such as roads and events of insecticide within one landscape. The size will be set and mosquitoes will be allowed to move in any direction. 

### Initialization 

Two landscapes will be simulated with roads as barriers and different levels of insecticide spray. Additionally, a population of mosquitoes will be initialized in which individuals will either be susceptible to insecticides and/or parasites or not.

*Agent behavior*: Mosquitoes will move in random directions at each time step and will not proceed when they encounter a road barrier. The distance a mosquito can fly will limit how far it can go. Additionally, some mosquitoes will also avoid areas that have been sprayed with insecticides since they have repellent properties.

*Landscape*: The landscapes will be initialized by limiting the presence of road barriers or insecticide spray.

*Code explanation*: First, the code creates a working directory and sets up an output folder so that future simulations can start off with a structured base. With this configuration, the integral *simulate species* function is built to represent the complex dynamics involved in the evolution of mosquito populations. Important parameters like mean resistance, population size, lifespan of both males and females, number of eggs laid, time elapsed before eggs hatch, interval between egg laying, length of each generation, total number of generations, interval between spraying, resistance increase, mortality rate, and carrying capacity are all included in this function. When the two mosquitoes mate, the female produces eggs one day after birth and the eggs are laid every two days. This differs between individuals as they reproduce with a difference of one day. The resistance of the offspring is set such that it is the mean of the parents with a mean of zero and a standard deviation of 0.1. The insecticide spraying event (selection) is varied and only a certain percentage of the mosquitoes are sprayed. The simulation is then adjusted to fit the characteristics of any mosquito, in this case, Culex mosquitoes, with 2000 in the population, male and female lifespans of 12 and 15 days, respectively, 50 eggs laid every cycle, 5 days for hatching, 2 days in between egg laying, and other biologically significant factors. The sim dataframe contains the simulation results. Subsequently, a loop is utilized to methodically examine and assess the simulation results for every generation, advancing a thorough comprehension of the population's attributes across time.

### Observations 

Mosquito movement patterns will be recorded and analyzed over time, considering the impact of road barriers, insecticides' effect on mosquitoes' survival, and flight limitations. Data on how many mosquitoes will be infected with the parasites and how many will become resistant will be collected.

### Model verification and Validation

The need will be verified using real-world data. For this, the age of mosquitoes and the accumulation of parasites will be used. For malaria mosquitoes, the older ones have a high likelihood
of having parasites because they would have had enough time to feed on infected people. Therefore, mosquitoes that have a short lifespan will be less efficient at transmitting diseases. The goal will be to make sure the model closely mirrors real-world data.

### Output

Graphs that will show the presence and location of roads within the landscapes will be created and overlayed with the movement of mosquitoes to show how barriers affect the movement of parasites and insecticide resistance alleles. Heat maps will also be used to visualize the density of mosquitoes in different landscapes.
