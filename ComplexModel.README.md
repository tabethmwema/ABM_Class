1. *Overview*
The aims of this model is to simulate mosquito movement between two 
landscapes to understand how insecticide resistant alleles and diseases such
as malaria are impacted by different landscape management (insecticide
spray) and parasite frequency. The landscapes will include both urban and
forested areas, which have barriers to movement such as roads while mosquito 
species characteristics will be defined by their susceptibility status to 
parasites and insecticides and the distance they can fly. The model will use 
discrete time steps in which mosquitoes will have to decide whether to move 
between landscapes based on flight distance and road barriers. 

*Entities and scales*
a.  Mosquito agents: Mosquitoes will either be susceptible or resistant to 
arasites and/or insecticides. Their attributes will include species, flight 
capacity and age. Different species fly varied distances and some parasites
may require a certain period to become infective before they can be 
transmitted. Therefore, the age of a mosquito can determine the parasites
are transmitted or not. The mosquito population size, the frequency of 
parasites and resistant alleles will also be set.

b. Landscape: Urban and forested landscapes will be simulated to have barriers
 such as roads and events of insecticide within one landscape. The size will
be set and mosquitoes will be allowed to moved in any direction. 

2. *Initialization*
Two landscapes will be simulated with roads as barriers and different levels 
of insecticide spray. Additionally, a population of mosquitoes will be 
initialized in which individuals will either be susceptible to insecticides 
and/or parasites or not.

a. Agent behaviour: Mosquitoes will move in random directions at each time 
step and will not proceed when they encounter a road barrier. The distance
a mosquito can fly will limit how far it can go. Additionally, some mosquitoes 
will also avoid areas that have been sprayed with insecticides since they
have repellent properties.

b. Landscape: The landscapes will be initialized by limiting the presence of 
road barriers or insecticide spray.

3. *Observations*: Mosquito movement patterns will be recorded and analyzed 
over time, considering the impact of road barriers, presence of  insecticides
and flight limitations. Data on how many mosquitoes will be infected with
the parasites and how many will become resistant will be collected.

4. *Model verification and Validation*:The need will be verified using real
world data. For this, the age of mosquitoes and accumulation of parasites
will be used. For malaria mosquitoes, the older ones have a high likehood
of having parasites because they would have had enough time to feed on 
infected people. Therefore, mosquitoes that have a short lifespan will be
less efficient at transmitting diseases. The goal will be to make sure the
model closely mirrors real world data.

5. *Output*
Graphs will show the presence and location of roads within the landscapes 
will be overlayed with the movement of mosquitoes will be created to show
how barriers affect movement of parasites and insecticide
resistance alleles. Heat maps will also be used to visualize the density
of mosquitoes in different landscapes.
