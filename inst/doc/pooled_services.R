## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE----------------------------------------------------------
library(ipsar)
data("ipsa")

## ------------------------------------------------------------------------
library(tidyverse)
ipsa$research <- str_detect(ipsa$short_description, " Research*")
ipsa %>% dplyr::filter(research == "TRUE") %>% 
  select(expense_type, short_description, details)

## ------------------------------------------------------------------------
library(tidyverse)
ipsa$clean_description <- ipsa$short_description %>%
  str_replace_all("European Research Group", "ERG") %>%
  str_replace_all("EUROPEAN RESEARCH GROUP", "ERG") %>%
  str_replace_all("European Research Group staff", "ERG") %>%
  str_replace_all("110516 - ERG Membership", "ERG") %>%
  str_replace_all("ERG Fees", "ERG") %>% 
  str_replace_all("ERG Payment", "ERG") %>%
  str_replace_all("ERG Researcher", "ERG") %>%
  str_replace_all("ERG Sub 2011-12", "ERG") %>%
  str_replace_all("ERG subscription", "ERG") %>% 
  str_replace("ERG 2010/2011", "ERG")

## ----eval=FALSE----------------------------------------------------------
#  ipsa %>% count(details) %>% View()

## ------------------------------------------------------------------------
ipsa$clean_details <- ipsa$details %>%
  str_replace_all("\\[([^]]*)]", "") %>% # remove hard brackets and ***
  str_replace_all("[(]|[)]", "") %>% # remove brackets
  str_replace_all("European Research Group", "ERG") %>%
  str_replace_all("EUROPEAN RESEARCH GROUP", "ERG") %>%
  str_replace_all("2010 EUROPEAN RESERCH GROUP", "ERG") %>%
  str_replace_all("Annual subs European Research Group", "ERG") %>%
  str_replace_all("European Research Group for 2010/11", "ERG") %>% 
  str_replace_all("European Research Group Membership", "ERG") %>%
  str_replace_all("European Research Group pooled staff", "ERG") %>%
  str_replace_all("European Research Group Researcher", "ERG") %>%
  str_replace_all("European Research Group Subscription", "ERG") %>% 
  str_replace_all("Membership for the European Research Group", "ERG") %>% 
  str_replace_all("Research Services - European Research Group ", "ERG") %>% 
  str_replace_all("Membership for European Research Group for Committee Purposes", "ERG") %>% 
  str_replace_all("Research Services - European Research Group ", "ERG") %>% 
  str_replace_all("Research services on European issues, in support of Parliamentary functions", "ERG") %>% 
  str_replace_all("ERG Pooled staffing", "ERG") %>% 
  str_replace_all("ERG services from pooled staff member as previous year", "ERG") %>% 
  str_replace_all("ERG subscription", "ERG") %>% 
  str_replace_all("ERG Subscription", "ERG") %>% 
  str_replace_all("ERG subscription ", "ERG") %>% 
  str_replace_all("ERG subscription-", "ERG") %>% 
  str_replace_all("ERG subscriptionIP", "ERG") %>% 
  str_replace_all("ERG for 2010/11", "ERG") %>% 
  str_replace_all("ERG Researcher", "ERG") %>% 
  str_replace_all("Membership for ERG for Committee purposes", "ERG") %>%
  str_replace_all("ERG Membership", "ERG") %>% 
  str_replace_all("ERGservices from pooled staff member as previous year", "ERG") %>% 
  str_replace_all("Annual subs ERG", "ERG") %>% 
  str_replace_all("Annual Sub 2013-14", "ERG") %>% 
  str_replace_all("ERG Membership", "ERG") %>% 
  str_replace_all("PART STAFFING COSTS FOR ERGBACS payment received", "ERG") %>% 
  str_replace_all("PART STAFFING COSTS FOR ERG ", "ERG") %>% 
  str_replace_all("ERGIP", "ERG") %>% 
  str_replace_all("ERG ", "ERG") %>% 
  str_replace_all("ERG-", "ERG") 

## ------------------------------------------------------------------------
# Add a count of the number of subscriptions over the years
ipsa$id <- 1:nrow(ipsa)
erg1 <- ipsa %>% dplyr::filter(clean_description == "ERG")
erg2 <- ipsa %>% dplyr::filter(clean_details  == "ERG")

# bind, identify duplicates and filter to non-duplicated entries. 

erg <- bind_rows(erg1, erg2) %>% 
  mutate(duplicated = duplicated(.$id)) %>%
  dplyr::filter(duplicated == "FALSE")

rm(erg1, erg2)

## ------------------------------------------------------------------------
# test count of subscription levels by year
erg_count <- erg %>% 
  group_by(year, member_id, mps_name, display_as, current_role) %>% 
  tally(amount_claimed, sort = "TRUE")
head(erg_count)

## ------------------------------------------------------------------------
erg <- erg %>%
  dplyr::filter(claim_no != "365591") %>% 
  dplyr::filter(id != "1323443") %>% 
  mutate(subscription_count = rep_len(1, length.out = nrow(.)))

## ----echo=FALSE, eval=FALSE----------------------------------------------
#  save(erg, file = "erg.rda")

## ------------------------------------------------------------------------
erg_subscriptions <- erg %>% 
  group_by(member_id, mps_name, display_as, current_role, mps_constituency) %>%
  summarise_at(c("subscription_count", "amount_claimed"), sum) %>% 
  arrange(desc(subscription_count))

erg_subscriptions %>%
  select(member_id, mps_name, display_as, current_role, subscription_count, amount_claimed)

## ------------------------------------------------------------------------
erg_subscriptions <- ipsa_commons %>%
  select(member_id, member_from, gender, date_of_birth, laying_minister_name, house_start_date) %>%
  right_join(., erg_subscriptions, by = "member_id") %>% 
  select(member_id, display_as, member_from, gender, date_of_birth, laying_minister_name, house_start_date, current_role, amount_claimed, subscription_count)

## ----echo=FALSE, eval=FALSE----------------------------------------------
#  save(erg_subscriptions, file = "erg_subscriptions.rda")

