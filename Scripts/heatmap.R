# R script for the FEP monitoring network study site map
# created April 2021 
# by Lynsey Thomson

# Load necessary packages
library(tidyverse)
library(viridis)


# Import data for both the tall and ground flare
tall_undetected_spikes <- read_csv("~/Downloads/tall_undetected spikes.csv")
ground_undetected <- read_csv("~/Downloads/ground_undetected.csv")


# Data must be converted to ordered factors, because it is categorical and not
# continuous data.

# CONVERTING TO ORDERED FACTORS: tall flare
tall_undetected_spikes$source_strength <- factor(tall_undetected_spikes$source_strength, levels = c("350", "2000"))

tall_undetected_spikes$heat_output <-factor(tall_undetected_spikes$heat_output, levels = c("0", "3", "5", "10", "15", "20"))

tall_undetected_spikes$time_period <- factor(tall_undetected_spikes$time_period, levels = c("April_19", 
                                                                                  "August_19", 
                                                                                  "January_20", 
                                                                                  "March_20", 
                                                                                  "August_20",
                                                                                  "October_20"))

tall_undetected_spikes$detected <- factor(tall_undetected_spikes$detected,
                                     levels = seq(min(tall_undetected_spikes$detected),
                                                  max(tall_undetected_spikes$detected)))


#  CONVERTING TO ORDERED FACTORS: ground flare
ground_undetected$source_strength <- factor(ground_undetected$source_strength, levels = c("350", "2000"))

ground_undetected$heat_output <-factor(ground_undetected$heat_output, levels = c("0", "3", "5", "10", "15", "20"))

ground_undetected$time_period <- factor(ground_undetected$time_period, levels = c("April_19", 
                                                      "August_19", 
                                                      "January_20", 
                                                      "March_20", 
                                                      "August_20",
                                                      "October_20"))

ground_undetected$detected <- factor(ground_undetected$detected,
                                        levels = seq(min(ground_undetected$detected),
                                                   max(ground_undetected$detected)))



# Now to create the heatmap

# ground flare
ggplot(ground_undetected, aes(x = time_period,  y = heat_output, fill = detected)) + 
  geom_tile() +
  facet_wrap(vars(source_strength)) +
  scale_fill_viridis_d(option = "D") +
  theme_classic() +
  xlab("Time Period") +
  ylab("Heat Output (MW)")


# tall flare
ggplot(tall_undetected_spikes, aes(x = time_period,  y = heat_output, fill = detected)) + 
  geom_tile() +
  facet_wrap(vars(source_strength)) +
  scale_fill_viridis_d(option = "D") +
  theme_classic() +
  xlab("Time Period") +
  ylab("Heat Output (MW)")

# DONE !


