scraper <- function(html_page){
  
  if (isFALSE(all(class(html_page) %in% c("xml_document", "xml_node")))){
    stop("Input must have class xml_document and xml_node")}
  
  list_job_description <- 
    list(
      title    =  html_page |> 
        rvest::html_elements(".job-header__header") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      employer =  html_page |> 
        rvest::html_elements(".job-header__title__link") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      location =  html_page |> 
        rvest::html_elements(".job-short-info__item-icon .ro_icon-locatiemarker+ .job-short-info__value-icon") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,                                   # Full abstract (collapse multiple paragraphs into one if necessary)
      
      education =  html_page |> 
        rvest::html_elements(".job-short-info__item-icon .ro_icon-baret+ .job-short-info__value-icon") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      hours =  html_page |> 
        rvest::html_elements(".job-short-info__item-icon .ro_icon-klok+ .job-short-info__value-icon span") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      job_scale = html_page |> 
        rvest::html_elements(".lastInCol .job-short-info__value-icon > span:nth-child(1)") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      salary = html_page |> 
        rvest::html_elements(".lastInCol br+ span") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      category = html_page |> 
        rvest::html_elements(".ro_icon-moersleutel-en-pen+ .job-short-info__value-icon") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      application_deadline = html_page |> 
        rvest::html_elements(".vacancy-publication-end") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      contract_type = html_page |> 
        rvest::html_elements(".ro_icon-pijlen-in-cirkel-om-document+ .job-short-info__value-icon") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      id = html_page |> 
        rvest::html_elements(".avoidwrap:nth-child(1)") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      date_placement = html_page |> 
        rvest::html_elements(".avoidwrap+ .avoidwrap") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . , #when was the job posing placed online
      
      job_description = html_page |> 
        rvest::html_elements("#sect_1") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      job_requirements = html_page |> 
        rvest::html_elements("#sect_2") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      working_conditions = html_page |> 
        rvest::html_elements("#sect_3") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . , # probably same as in the header, so maybe I can remove this later
      
      secondary_conditions = html_page |> 
        rvest::html_elements("#sect_4") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      special = html_page |> 
        rvest::html_elements("#sect_5") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else . ,
      
      description_department = html_page |> 
        rvest::html_elements(".job-department--width") |> rvest::html_text(trim = TRUE)%>%
        if(identical(., character(0))) NA_character_ else .
  
  )
  
  # store everything in a tibble
  result <- list_job_description |> as_tibble()
  
  return(result
         )
  # note: The if(identical(., character(0))) NA_character_ else . command at the end of each frase was added in case 
  # not all pages include all necessary html_nodes
  # this lead to a character(0) output, that the tibble wouldn't store, which messed everything up.
  # the expression now explicitly assigns a NA value which the tibble can store  
  
}