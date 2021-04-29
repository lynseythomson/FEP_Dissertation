# R script for the FEP monitoring network study site map
# created April 2021 
# by Lynsey Thomson

# Load necessary libraries
library(tidyverse)
library(sf)
library(ggmap)
library(ggspatial)
library(tmap)
library(tmaptools)

# Load data
locations <- read_csv("station map.csv")

# Create a separate colour category for the first four stations
locations <- add_column(locations, colour_category = 
                          as.factor(c(rep.int(1,times = 4),
                                      rep.int(2, times = nrow(locations)-4))))

# Convert to spatial sf object
locations_sf <- st_as_sf(locations, coords = c("long", "lat"), remove = F, crs = 4326)

# Calculate a bounding box (slightly expanded)
points_bbox <-
  locations_sf %>% 
  st_bbox() %>% 
  tmaptools::bb(ext = 1.2) # expand bounding box a bit so points aren't right at the edge

# Download Stamen map raster for the area
stamen_raster <- get_stamenmap(as.vector(points_bbox), zoom = 14)

# Plot map with ggplot
(stations_map <-
    ggplot(data = locations_sf) +
    inset_ggmap(stamen_raster) + # add ggmap background
    geom_sf(aes(colour = colour_category), size = 4) +
    coord_sf(expand = 1.2) +
    geom_spatial_label_repel(aes(x = long, y = lat, label = name), crs = 4326) +
    scale_colour_manual(values = c("#D81B60","#1E88E5")) + 
    # select custom colours for the two types of station
    labs(title = "Map title",
         subtitle = "Map subtitle",
         caption = paste0("Map tiles by Stamen Design (stamen.com), CC BY 3.0. ",
                          "http://creativecommons.org/licenses/by/3.0\n",
                          "Map data © OpenStreetMap contributors, ODbL. ",
                          "http://www.openstreetmap.org/copyright")) +
    # add various labels
    annotation_scale(location = "br") + # ggspatial scale on bottom left
    annotation_north_arrow(location = "br") + # ggspatial arrow on top right
    theme_void() + # get rid of axis ticks, titles
    theme(legend.position = "none") # get rid of legend
    # theme(legend.title = element_blank(),
    #       legend.position = c(.98, .02),
    #       legend.justification = c("right", "bottom"),
    #       legend.box.just = "right",
    #       legend.box.background = element_rect(fill = "white", colour = "gray"),
    #       legend.margin = margin(6, 6, 6, 6),
    #       # move legend to bottom right and customise
    #       plot.margin = margin(12,12,12,12))
    #       # add margin around plot
)

# Might take a while for the plot to appear! 

# Save as file
ggsave("stations_map.png", stations_map, width = 8, height = 6.5)
