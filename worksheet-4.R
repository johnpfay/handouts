## Tidy data concept

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2, 1, 3),
  hare = c(20, 25, 30),
  fox = c(4, 4, 4)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df,
                        key = 'species',
                        value ='count',
                        wolf:fox)

counts_spread <- spread(counts_gather,
                        key = species,
                        value = count,
                        na.rm = TRUE)

## Exercise 1

#Remove record
df1 = counts_gather[-8,]
#Spread
df_spr = spread(df1,
                key=species, 
                value=count,
                fill = 0)
df_spr1 = spread(df1,
                key=species, 
                value=count)
df_spr1 <- drop_na(df_spr1)

## Read comma-separated-value (CSV) files

animals <- ...

animals <- read.csv('data/animals.csv', na.strings='')

library(dplyr)
library(RPostgreSQL)

con <- dbConnect(PostgreSQL(), host = 'localhost', dbname = 'portal')
animals_db <- tbl(con, 'animals')
#Copies all records to local environment
animals <- collect(animals_db)
#Close the connection
dbDisconnect(con)

## Subsetting and sorting

library(dplyr)
#Nab winter 1990 records
animals_1990_winter <- filter(animals,
                              year == 1990,
                              month %in% 1:3)
#Drop year column
animals_1990_winter <- select(animals_1990_winter, -year)

sorted <- arrange(animals_1990_winter,
              desc(species_id), weight)
## Exercise 2

...

## Grouping and aggregation

animals_1990_winter_gb <- group_by(animals_1990_winter, species_id)

counts_1990_winter <- summarize(animals_1990_winter_gb, count = n())

## Exercise 3
#Select animal = DM
dmAll = filter(animals,species_id == 'DM')
#Group by month
dmGroup = group_by(dmAll,month)
#Summarize
dmSummary = summarize(dmGroup, avg_wt=mean(weight, na.rm=TRUE), avg_hf=mean(hindfoot_length,na.rm=TRUE))
View(dmSummary)

## Pivot tables through aggregate and spread

animals_1990_winter_gb <- group_by(animals_1990_winter, ...)
counts_by_month <- ...(animals_1990_winter_gb, ...)
pivot <- ...

## Transformation of variables

prop_1990_winter <- mutate(counts_1990_winter,
                           prop = count/sum(count))
## Exercise 4

...

## Chainning with pipes

prop_1990_winter_piped <- animals %>%
  filter(year == 1990, month %in% 1:3) %>%
  select(-year) %>% 
  group_by(species_id) %>% 
  summarize(count = n()) %>%
  mutate(prop = count/sum()) 

