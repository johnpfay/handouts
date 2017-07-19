## Getting started

library(dplyr)
library(ggplot2)

#open an filter out null values
animals <- read.csv('data/animals.csv', na.strings = '') %>%
  filter(!is.na(species_id), !is.na(sex), !is.na(weight))

## Constructing layered graphics in ggplot

#scatter plot of wt x spp
ggplot(animals, #The data frame
       aes( x =species_id, y = weight)) + #Aesthetics
       geom_point() # what to show on the plot

#box plot of same data; just change the "geom" object
ggplot(data = animals,
       aes(x = species_id, y = weight)) +
       geom_boxplot()
  

#Combining multiple geometries
#Use points layer to show aggregate stat 
ggplot(data = animals,
       aes(x = species_id, y = weight)) +
  geom_boxplot() +
  geom_point(stat = "summary",
             fun.y = "mean",
             color = "red")

#Other aesthetics: color each species differently
ggplot(data = animals,
       aes(x = species_id, y = weight, color=species_id)) +
  geom_boxplot() +
  geom_point(stat = 'summary',
             fun.y = 'mean')

## Exercise 1
dfDM = filter(animals, species_id == 'DM')
ggplot(data = dfDM,
       aes(x = year, y = weight, color=sex)) +
       geom_line(stat = 'summary',
                 fun.y = 'mean')

## Adding a regression line
#Reassings F and M in sex to these values
levels(animals$sex) <- c('Female', 'Male')
animals_dm <- filter(animals, species_id == 'DM')

ggplot(animals_dm,
       aes(x = year, y = weight)) +
  geom_point(aes(shape = sex, color = sex), #Construct an aesthetic to the points themselves
             size = 3,
             stat = 'summary',
             fun.y = 'mean') +
  geom_smooth(aes(group = sex, color = sex), method='lm')    #Adds a regression line for each sex
  #Alternatively, set the color = sex to the overall aes object

ggplot(data = animals_dm,
       aes(x = year, y = weight)) + 
  geom_point(aes(shape = sex),
             size = 3,
             stat = 'summary',
             fun.y = 'mean') +
  geom_smooth(...)



# Storing and re-plotting

year_wgt <- ggplot(data = animals_dm,
                   aes(x = year,
                       y = weight,
                       color = sex)) +
  geom_point(aes(shape = sex),
             size = 3,
             stat = 'summary',
             fun.y = 'mean') +
  geom_smooth(method = 'lm')

#Modify colors on existing plot object
year_wgt +
  scale_color_manual(values=c('darkblue','orange'))
                     
year_wgt <- year_wgt +
  scale_color_manual(values=c('black','red'))
year_wgt

## Exercise 2
ggplot(data = animals_dm, aes(weight, fill = sex)) +
  geom_histogram(binwidth = 5)



## Axes, labels and themes

histo <- ggplot(data = animals_dm,
                aes(x = weight, fill = sex)) +
  geom_histogram(binwidth = 0.75)
histo

#labs = labels object
histo <- histo +
  labs(title = 'Dipodomys merriami weight distribution',
       x = 'Weight (g)',
       y = 'Count') +
  scale_x_continuous(limits = c(20, 60),
                     breaks = c(20, 30, 40, 50, 60))
histo

#Use a theme function
histo <- histo +
  theme_bw() +
  theme(legend.position = c(0.2, 0.5),
        plot.title = element_text(face='bold',vjust=2), #Not the plot title; instead 
        axis.title.y = element_text(size = 13, vjust = 1),
        axis.title.x = element_text(size = 13, vjust = 0))
histo



## Facets
#allow panels of different subsets: here we do on 3 species
animals_common <- filter(animals, species_id %in% c('DM','DO','PP'))
ggplot(data = animals_common,
       aes(x=weight)) +
  geom_histogram() +
  facet_wrap(~ species_id)
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")

#Add histogram layer of all the panels
ggplot(data = animals_common,
       aes(x = weight)) +
  geom_histogram(data=dplyr::select(animals_common, -species_id), alpha=0.2) + #Remove species id to show all
  geom_histogram() +
  facet_wrap( ~ species_id) +
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")

ggplot(data = animals_common,
       aes(x = weight, ...)) +
  geom_histogram(...) +
  facet_wrap( ~ species_id) +
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)") +
  guides(fill = FALSE)		

## Exercise 3
ggplot(data = animals_common,
       aes(x = weight)) +
  geom_histogram(data=dplyr::select(animals_common, -species_id), alpha=0.2) + #Remove species id to show all
  geom_histogram() +
  facet_grid(sex ~ species_id) +
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")

ggplot(data = animals_common,
       aes(x = weight)) +
  geom_histogram(data=dplyr::select(animals_common, -species_id), alpha=0.2) + #Remove species id to show all
  geom_histogram() +
  facet_grid(species_id ~ sex) +
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")
