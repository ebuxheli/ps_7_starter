# attaching libraries
library(tidyverse)
library(dplyr)
library(fs)

# loading in the csv
mt_actual <- read_csv("mt_2_results.csv")


# getting upshot data
download.file(url = "https://goo.gl/ZRCBda",
              destfile = "upshot.zip",
              quiet = TRUE,
              mode = "wb")
unzip("upshot.zip")

# deleting upshot.zip once data loaded
file_delete("upshot.zip")


# listing all of the file names for upshot data
files_names <- dir_ls(path = "2018-live-poll-results-master/data/")

# reading in all the csv files and extracting source info (state, wave, etc. )
upshot <- map_dfr(files_names, read_csv, .id = "source") %>% 
  mutate(source    = str_sub(source, 51, -5),
         state     = toupper(str_sub(source, 1, 2)),
         wave      = str_sub(source, -1, -1),
         district  = paste0(state, "-", parse_number(str_sub(source, 2, 4))),
         office    = case_when(str_sub(source, 3, 3) == "g" ~ "Governor",
                               str_sub(source, 3, 3) == "s" ~ "Senate",
                               str_sub(source, 3, 3) != c("s", "g") ~ "House"))


# filtering the upshot data
upshot %>% 
  filter(str_detect(source, "sen"),
         wave == "3") %>%  View()
