# ABM_Class

## Simple model

### To create and ABM that simulates weather an ecosystem with the highest food quality will support a large stable species population compared to the one with a lower food quality.

Purpose: The purpose of this model will be to compare whether two ecosystems that differ in their food quality (high or low) will support an equal number of individuals of the same species. 

Entities, state variables and scales: The model will have two entities which are the landscapes and the individuals. The landscapes will include foriage quality and quantity and area size while the attributes of the individuals will be sex ratio, population size, age structure and a unique identification. The landscapes will have patches of food that will be placed randomly.

Process overview: The individuals will be simulated to move, mate and foriage randomly for a specified amount of distance and time. An individual that passes through the foriage patch will be considered to have foriaged and will be sampled for that landscape.

Initialization: the landscape will contain grids that will have individuals and foriage/sampling areas. Random movement will then be permitted. 

Subroutines/functions/actions: This model will involve functions of sampling and movement. The individuals will move randomly to different foriaging/sampling sites.