## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  cache = FALSE,
  message = FALSE, 
  warning = FALSE
)

## ----all_members, eval=FALSE---------------------------------------------
#  install.packages("mnis")
#  library(mnis)
#  members <- mnis_all_members()

## ----load_members, echo=FALSE--------------------------------------------
library(tidyverse)
load("members.rda")

## ----filter_members, message=FALSE---------------------------------------
library(tidyverse)
commons <- members %>%
  dplyr::filter(house == "Commons")

## ----commons_mutate------------------------------------------------------
commons <- commons %>%
  mutate(house_end_date = lubridate::ymd(.$house_end_date)) %>%
  mutate(temp_end = house_end_date) %>%
  replace_na(list(temp_end = "2018-06-01")) %>%
  dplyr::filter(temp_end >= "2010-01-01" & temp_end <= "2018-06-01")

# Test that the current status active and the temp_end date counts match. Target is 650

commons %>% dplyr::filter(current_status_is_active == "True") %>% nrow() # 650

commons %>% dplyr::filter(temp_end == "2018-06-01") %>% nrow() # 650

## ----commons_short-------------------------------------------------------
# create commons_short preserving the original commons dp display_as field

commons$commons_short <- commons$display_as

# remove honorifics from commons_short
commons$commons_short <- str_replace(commons$commons_short, "Miss ", "") %>% 
  str_replace(., "Mrs ", "") %>%
  str_replace(., "Ms ", "") %>% 
  str_replace(., "Mr ", "") %>% 
  str_replace(., "Dr ", "") %>% 
  str_replace(., "Sir ", "") %>% 
  str_replace(., "Dame ", "")

commons$commons_short <- trimws(commons$commons_short, which = "both")

# Note that the honorific Lady is not included in the list above to
# avoid reducing Lady Hermon to a non-matching Hermon. Hyphens in names 
# are retained because they are more frequent than versions of names 
# without hyphens. 

## ----wood----------------------------------------------------------------
editrow <- which(commons$member_id == "4384")
# change the short name to match ipsa
commons[editrow,]$commons_short <- "Mike B Wood"

## ----active--------------------------------------------------------------
active <- commons %>%
  dplyr::filter(temp_end == "2018-06-01")

## ----load_ipsa_source, echo=FALSE----------------------------------------
load("ipsa_source.rda")
ipsa <- ipsa_source
rm(ipsa_source)

## ----ipsa_match_field----------------------------------------------------
ipsa$commons_short <- ipsa$mps_name

## ------------------------------------------------------------------------
ipsa <- ipsa %>%
  mutate(commons_short =  str_replace_all(commons_short, "Vincent Cable", "Vince Cable")) %>%
  mutate(commons_short = str_replace_all(commons_short, "Sylvia Hermon", "Lady Hermon")) %>%
  mutate(commons_short = str_replace_all(commons_short, "Suella Fernandes", "Suella Braverman")) %>%
  mutate(commons_short = str_replace_all(commons_short, "Chris Shaun Ruane", "Chris Ruane")) %>%
  mutate(commons_short = str_replace(commons_short, "^Martin Docherty$", "Martin Docherty-Hughes")) %>%
  mutate(commons_short = str_replace(commons_short, "Preet Gill", "Preet Kaur Gill")) %>%
  mutate(commons_short = str_replace(commons_short, "Emma Little-Pengelly", "Emma Little Pengelly"))

## ----test_duplicates-----------------------------------------------------
ipsa_name <- ipsa %>% 
  count(mps_name, mps_constituency, commons_short) %>%
  arrange(commons_short) %>% 
  mutate(duplicate = duplicated(commons_short))

## ----mcvey---------------------------------------------------------------
ipsa_name <- ipsa_name %>% arrange(commons_short)
ipsa_name[290,]$mps_constituency <- "formerly Wirral West, now Tatton"
ipsa_name[291,]$mps_constituency <- "formerly Wirral West, now Tatton"
ipsa_name <- ipsa_name[-291,]

## ----lloyd---------------------------------------------------------------
ipsa_name[924,]$mps_constituency <- "formerly Manchester Central CC, now Rochdale CC"
ipsa_name[925,]$mps_constituency <- "formerly Manchester Central CC, now Rochdale CC"
ipsa_name <- ipsa_name[-925,]

## ----match_commons-------------------------------------------------------
# identify matches
ipsa_name$commons_shortmatch <- ipsa_name$commons_short %in% commons$commons_short

# count matches
ipsa_name %>% filter(commons_shortmatch == TRUE) %>% nrow() # 887 rows


## ----matched-------------------------------------------------------------
matched <- ipsa_name %>% dplyr::filter(commons_shortmatch == "TRUE")
nrow(matched)

## ----missed--------------------------------------------------------------
missed <- ipsa_name %>%
  dplyr::filter(commons_shortmatch == "FALSE")
nrow(missed)

## ----mps_name------------------------------------------------------------
display_as <- data_frame(mps_name = c("Lord Beith",
                                    "Lord Haselhurst",
                                    "Lord Darling of Roulanish",
                                    "Lord Lansley",
                                    "Lord Robathan",
                                    "Lord Stunell",
                                    "Lord Tyrie",
                                    "Andrew Love",
                                    "Angus Brendan MacNeil",
                                    "Baroness McIntosh of Pickering",
                                    "Anne Marie Morris",
                                    "William Cash",
                                    "Robert Neill",
                                    "Brian H. Donohoe",
                                    "Chi Onwurah",
                                    "Christian Matheson",
                                    "Christopher Pincher",
                                    "Chris Elmore",
                                    "Chris Leslie",
                                    "Dan Byles",
                                    "Dan Poulter",
                                    "Lord Watts",
                                    "Lord Blunkett",
                                    "David T. C. Davies",
                                    "Lord Willetts",
                                    "Baroness Primarolo",
                                    "Lord Foster of Bath",
                                    "Lord Garnier",
                                    "Liz McInnes",
                                    "Lord Pickles",
                                    "Lord Maude of Horsham",
                                    "Lord Young of Cookham",
                                    "Ged Killen",
                                    "Graham P Jones",
                                    "Lord Barker of Battle",
                                    "Ian C. Lucas",
                                    "Lord Arbuthnot of Edrom",
                                    "Jeffrey M. Donaldson",
                                    "Joseph Johnson",
                                    "Lord Randall of Uxbridge",
                                    "Viscount Thurso",
                                    "Kenneth Clarke",
                                    "Liz Saville Roberts",
                                    "Baroness Burt of Solihull",
                                    "Baroness Featherstone",
                                    "Lord Bruce of Bennachie",
                                    "Mary Macleod",
                                    "Matt Hancock",
                                    "Lord Campbell of Pittenweem",
                                    "Naz Shah",
                                    "Lord Murphy of Torfaen",
                                    "Lord Hain",
                                    "Lord Lilley",
                                    "Philip Boswell",
                                    "Siân C. James",
                                    "Steve McCabe",
                                    "Stewart Malcolm McDonald",
                                    "Stuart Blair Donaldson",
                                    "Stuart C. McDonald",
                                    "Susan Elan Jones",
                                    "Baroness Jowell",
                                    "Thérèse Coffey",
                                    "Lord Hague of Richmond",
                                    "Lord McCrea of Magherafelt and Cookstown",
                                    "William Bain"))

## ------------------------------------------------------------------------
missed_bind <- bind_cols(missed, display_as) %>%
  mutate(lords = str_detect(mps_name1, "^Lord|^Viscount|^Baroness"))

## ------------------------------------------------------------------------
missed_bind_mps <- missed_bind %>%
  dplyr::filter(lords == "FALSE") %>%
  select(-lords, -commons_shortmatch, -n, -commons_short) %>% # remove existing commons_short. I could be making a mistake here
  rename(commons_short = mps_name1) # 34 mps with variant names

## ------------------------------------------------------------------------
missed_bind_lords <- missed_bind %>%
  dplyr::filter(lords == "TRUE") %>%
  rename(display_as = mps_name1) %>% 
  select(-commons_shortmatch, - n) # 31 lords

## ------------------------------------------------------------------------
found <- bind_rows(missed_bind_mps, missed_bind_lords)

## ------------------------------------------------------------------------
mps_ipsa_commons <- bind_rows(matched, found) %>%
  select(-n, -commons_shortmatch) 

## ------------------------------------------------------------------------
mps_ipsa_commons$active_mp <- mps_ipsa_commons$commons_short %in% active$commons_short

mps_ipsa_commons %>% 
  filter(active_mp == TRUE) %>% nrow() 

## ------------------------------------------------------------------------
commons$ipsa_match <- commons$commons_short %in% mps_ipsa_commons$commons_short

## ----eval=FALSE----------------------------------------------------------
#  commons %>%
#    dplyr::filter(ipsa_match == FALSE) %>% View()

## ------------------------------------------------------------------------
commons %>% 
  dplyr::filter(ipsa_match == FALSE) %>%
  arrange(desc(temp_end)) %>% 
  select(temp_end, display_as, commons_short)

## ------------------------------------------------------------------------
mps_ipsa_commons$active_mp <- mps_ipsa_commons$active_mp %>%
  replace_na("FALSE")

mps_ipsa_commons$lords <- mps_ipsa_commons$lords %>%
  replace_na("FALSE")

## ------------------------------------------------------------------------
active$mps_ipsa_commons <-  active$commons_short %in% mps_ipsa_commons$commons_short

# create a new mps table that matches mps_ipsa_commons column names
newmps <- active %>% 
  select(commons_short, mps_ipsa_commons) %>%
  filter(mps_ipsa_commons == FALSE) %>%
  mutate(mps_name = NA) %>%
  mutate(mps_constituency = NA) %>%
  mutate(active_mp = "TRUE") %>%
  mutate(display_as = NA) %>%
  mutate(lords = "FALSE") %>%
  mutate(duplicate = FALSE) %>% 
  select(-mps_ipsa_commons)

# create the table

mps_ipsa_commons <- bind_rows(mps_ipsa_commons, newmps)

## ------------------------------------------------------------------------
ipsa_commons_lords <- mps_ipsa_commons %>%
  filter(lords == TRUE) %>% 
  left_join(., members, by = "display_as") %>% 
  mutate(house_end_date = lubridate::date(house_end_date)) %>% 
  mutate(current_role = "Lords") %>% 
  filter(member_id != "2989" & member_id != "1784")

## ------------------------------------------------------------------------
ipsa_commons_mps <- mps_ipsa_commons %>%
  filter(lords == FALSE) %>%
  left_join(., commons, by = "commons_short") %>%
  select(-`display_as.x`) %>%
  rename(display_as = `display_as.y`) %>%
  mutate(house_end_date = lubridate::date(house_end_date))

ipsa_commons_ex <- ipsa_commons_mps %>%
  filter(temp_end != "2018-06-01") %>%
  mutate(current_role = "Ex") # 271

ipsa_commons_currentmp <- ipsa_commons_mps %>%
  filter(temp_end == "2018-06-01") %>%
  mutate(current_role = "MP")

## ----create_ipsa_commons-------------------------------------------------
ipsa_commons <- bind_rows(ipsa_commons_currentmp, ipsa_commons_lords, ipsa_commons_ex) %>%
  arrange(commons_short) %>%
  mutate(ipsa_name = mps_name) %>%
  mutate(dp_name = display_as)

# replace NA for MPs who appear in IPSA but became Lords
ipsa_commons$ipsa_match <- ipsa_commons$ipsa_match %>% 
  replace_na("TRUE")

## ------------------------------------------------------------------------
ipsa <- ipsa_commons %>%
  select(ipsa_name, mps_name, dp_name, member_id, current_role, commons_short) %>% 
  left_join(., ipsa, by = "mps_name") %>% 
  select(-`commons_short.y`) %>% 
  rename(commons_short = `commons_short.x`)
nrow(ipsa)

## ------------------------------------------------------------------------
ipsa_commons <- ipsa_commons %>% 
  filter(duplicate == FALSE)

## ----write_files, echo=FALSE, eval=FALSE---------------------------------
#  # tidy up prior to save
#  commons <- commons %>% select(-temp_end, - ipsa_match)
#  ipsa_commons <- ipsa_commons %>% select(-temp_end, - ipsa_match)
#  
#  # file locations
#  save(ipsa_commons, file = "ipsa_commons.rda", compress = "xz")
#  save(commons, file = "commons.rda", compress = "xz")
#  save(ipsa, file = "ipsa.rda", compress = "xz")
#  save(members, file = "members.rda", compress = "xz")
#  write_csv(ipsa, "ipsa.csv")

## ----chcek_count, echo=FALSE, eval=FALSE---------------------------------
#  #check count
#  ipsa_commons %>%
#    dplyr::filter(current_role == "MP") %>%
#    nrow() # expect that 650

