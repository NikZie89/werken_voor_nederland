# clean environment
rm(list = ls())

# Loading functions from the function folder

base::invisible(
  lapply(
    list.files('code/functions', recursive = TRUE, full.names = TRUE, pattern = '.R'),
    FUN = source
  )
)

# Short intro

# In this script I scrape the details of the different job postings. the links where collected in the last script.
# However, the actual pages of the job postings are static, thus, RSelenium is not necessary anymore and
# simply rvest will be enough


# Links naar uitspraken verzammelen --------------------------------------------

# load the results of script 02

overview_links <- readRDS("scraped/vacature_links_20240825.rds")

# create simple error handling for read_html
try_read_html <- purrr::possibly(.f = rvest::read_html, otherwise = NA_character_)


# extract the html of each job posting
html_vacatures <- 
  purrr::map(.x = overview_links$links,
             ~ {sleep <- rnorm(1, 1, 0.5)
             Sys.sleep(if (sleep > 0) sleep else 1)
             try_read_html(.x)},
             .progress = list( format = "Scraped page {cli::pb_current} of {cli::pb_total}: {cli::pb_bar} {cli::pb_percent} | [{cli::pb_elapsed_clock}] | ETA: {cli::pb_eta}"))

# no missings
html_vacatures |> is.na() |> sum() == 0

# apply the scraper function to extract alle the relevant information ----------

save_scraper <- purrr::possibly(scraper, otherwise = NA_character_)

# extract the details
job_postings <- 
  purrr::map(.x = html_vacatures,
             ~ save_scraper(.x),
             .progress = list( format = "Job details extracted from html {cli::pb_current} of {cli::pb_total} gehaald: {cli::pb_bar} {cli::pb_percent} | [{cli::pb_elapsed_clock}] | ETA: {cli::pb_eta}"))

job_postings <- job_postings |> bind_rows()


# store as a list
overview_jobs <- 
  list(job_postings = job_postings,
       time_scraping = overview_links$time_scraping)

# store the links for now in a .txt
saveRDS(overview_jobs, file = paste0("scraped/vacature_tibble_", format(overview_links$time_scraping, "%Y%m%d"), ".rds"))

