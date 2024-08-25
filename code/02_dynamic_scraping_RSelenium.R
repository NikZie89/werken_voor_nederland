rm(list=ls()); graphics.off()

library(conflicted)
library(RSelenium)
library(rvest)
library(tidyverse)


# werkenvoornederland requires Selenium to scrape the links to the job postings
# as all links are dynamically loaded once you scroll down

# Start RSelenium
remDr <- remoteDriver(
  remoteServerAddr = "localhost",  # Use 'localhost' instead of the IP address
  port = 4445L                     # Use the port you've exposed when starting the Selenium container
)
remDr$open()


#remDr <- rD$client

# Navigate to the web page
path <- "https://www.werkenvoornederland.nl/vacatures?type=vacature%2Cstage"

remDr$navigate(path)  # Replace with your actual URL

# Wait for the page to fully load (adjust the sleep time if needed)
Sys.sleep(5)

# Get the page source after dynamic content has loaded
page_source <- remDr$getPageSource()[[1]]
page_html <- read_html(page_source)

# Determine the total number of job postings
n_vacatures <- page_html |> 
  html_nodes(".vacancy-result-bar__totals-badge") |> 
  html_text() |> 
  str_remove("\\.") |>
  as.numeric()

# now I can load the last page. werkenvoornederland dynamically
# that page contains alle job postings

last_page <- ceiling(n_vacatures/10) # 10 new postings per refresh

path_complete <- paste0(path, "&pagina=", last_page)

# load page with all job postings
remDr$navigate(path_complete)

# wait a bit longer
Sys.sleep(10)

# get the html
page_source <- remDr$getPageSource()[[1]]
page_html <- read_html(page_source)

# extract all links
all_links <- 
  page_html |>
    html_elements("a") |>
    html_attr("href")

# clean, remove duplicates and links that are no job postings

all_links_clean <-
all_links[grepl("/vacatures/", all_links)] |>
  unique()

# remove /vacatures/bewaard
all_links_clean <- all_links_clean[all_links_clean != "/vacatures/bewaard"]

# got them all
n_vacatures == length(all_links_clean)

# complete the links
all_links_clean <- paste0("https://www.werkenvoornederland.nl", all_links_clean)

time_scraped <- Sys.time()

# store as a list

overview_links <- 
  list(links = all_links_clean,
       time_scraping = time_scraped)

# store the links for now in a .txt
saveRDS(overview_links, file = paste0("scraped/vacature_links_", format(time_scraped, "%Y%m%d"), ".rds"))


# Close RSelenium
remDr$close()
rD$server$stop()