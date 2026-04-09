source("compare_sources.R")

# Add net new datasets as new publications in CKAN

convert_dcat_keywords_to_tags <- function(keywords, filter_short_tags = TRUE, add_geoyukon_datestamp = TRUE) {
  
  # tags <- tibble(name = net_new_datasets$keyword[[1]])
  tags <- tibble(raw_name = keywords)
  
  tags <- tags |> 
    mutate(
      name = get_name_from_title(raw_name)
    ) |> 
    select(name) |> 
    distinct()
  
  if(filter_short_tags == TRUE) {
    
    tags <- tags |> 
      filter(
        str_length(name) > 2
      )
    
  }
  
  # Add generic geoyukon-import tag to be able to match for updates later
  new_row = tibble_row(
    name = "geoyukon-import"
  )
  
  tags <- tags |>
    bind_rows(
      new_row
    ) |> 
    arrange(name)
  
  if(add_geoyukon_datestamp == TRUE) {
    
    new_row = tibble_row(
      name = str_c("geoyukon-import-", get_date_stamp())
    )
    
    tags <- tags |>
      bind_rows(
        new_row
      ) |> 
      arrange(name)
    
  }
  
  # Avoid any accidental duplicates
  tags <- tags |>
    distinct()
  
  tags
  
}

add_geospatial_layer_ckan_package <- function(title, description, homepage_url, keywords = list()) {
  
  cat("Adding ", title, "to CKAN.\n")
  
  tags <- convert_dcat_keywords_to_tags(keywords)
  
  newly_created_package <- package_create(
    name = get_name_from_title(title),
    title = title,
    notes = description,
    license_id = "OGL-Yukon-2.0",
    type = "data",
    # Geomatics Yukon
    owner_org = "f8301d90-0290-4456-ad98-df79d33b1bd6",
    
    extras = list(
      internal_contact_email = "Geomatics.Help@yukon.ca",
      internal_contact_name = "Geomatics Yukon",
      homepage_url = homepage_url,
      update_frequency = "ad_hoc"
    ),
    
    # REVIEW: Includes the first entry but not subsequent ones??
    # groups = data.frame(
    #   # Nature and environment
    #   id = "46be34d1-443f-4188-9639-692f2bda0e14",
    #   # Science and technology
    #   id = "a8dc4319-ae14-4568-b49e-57334fd3fa31"
    # ),
    # 
    groups = data.frame(
      id = c(
        # Nature and environment
        "46be34d1-443f-4188-9639-692f2bda0e14",
        # Science and technology
        "a8dc4319-ae14-4568-b49e-57334fd3fa31"
      )
    ),
    
    tags = tags
    
    
    
  )
  
  resources_to_add <- dcat_resources |> 
    filter(dataset_title == title)
  
  for (i in seq_along(resources_to_add$resource_url)) { 
    
    cat("Adding resource ", resources_to_add$resource_title[i], "\n")
    
    resource_create(
      package_id = newly_created_package$id,
      rcurl = resources_to_add$resource_url[i],
      name = resources_to_add$resource_title[i],
      format = "HTML"
    )
    
    Sys.sleep(0.1)
    
  }
  
  Sys.sleep(0.3)
  
}

net_new_datasets <- net_new_datasets_dcat |> 
  mutate(
    description = clean_dcat_description_text(description)
  )

# net_new_datasets$description


for (i in seq_along(net_new_datasets$title)) { 
  
  add_geospatial_layer_ckan_package(
    net_new_datasets$title[i],
    net_new_datasets$description[i],
    net_new_datasets$arcgis_url[i],
    # Note syntax for list contents for keyword here
    net_new_datasets$keyword[[i]]
  )
  
  # For testing, just run one item:
  # break;
  
}
