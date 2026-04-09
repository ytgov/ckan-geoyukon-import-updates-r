source("compare_sources.R")

# Back to geoyukon CKAN resources

# CKAN resources: geoyukon_import_dataset_resources
# Resources to update: resources_to_update

ckan_resources_to_update <- geoyukon_import_dataset_resources |> 
  select(
    title,
    id,
    name,
    url
  ) |> 
  rename(
    dataset_title = "title",
    resource_id = "id",
    resource_title = "name"
  )

ckan_resources_to_update <- resources_to_update |> 
  left_join(
    ckan_resources_to_update,
    by = c("dataset_title", "resource_title")
  ) |> 
  select(! url)
  
ckan_resources_to_update_parameters <- ckan_resources_to_update |> 
  select(
    resource_id,
    dcat_resource_url
  ) |> 
  rename(
    url = dcat_resource_url
  ) |> 
  distinct()


# Loop through and update resources ---------------------------------------

for (i in seq_along(ckan_resources_to_update_parameters$resource_id)) { 
  cat("Updating", ckan_resources_to_update_parameters$resource_id[i], "to", ckan_resources_to_update_parameters$url[i], "\n")
  
  ckan_action(
    "resource_update",
    body = list(
      id = ckan_resources_to_update_parameters$resource_id[i],
      url = ckan_resources_to_update_parameters$url[i]
    )
  )
  
  # Limit to one entry for testing
  # break;
  
  Sys.sleep(0.3)
}


# Add new resources where applicable --------------------------------------

geoyukon_import_datasets_to_add_resources <- geoyukon_import_datasets |> 
  select(title, name) |> 
  rename(
    dataset_name = "name",
    dataset_title = "title"
  )

resources_to_add <- resources_to_add |> 
  left_join(geoyukon_import_datasets_to_add_resources, by = "dataset_title")

# Loop through and add new resources ---------------------------------------

for (i in seq_along(resources_to_add$dcat_resource_url)) { 
  cat("Adding resource ", resources_to_add$resource_title[i], " ", resources_to_add$dcat_resource_url[i], "to", resources_to_add$dataset_title[i], "\n")
  
  # ckan_action(
  #   "resource_update",
  #   body = list(
  #     id = ckan_resources_to_update_parameters$resource_id[i],
  #     url = ckan_resources_to_update_parameters$url[i]
  #   )
  # )
  
  resource_create(
    package_id = resources_to_add$dataset_name[i],
    name = resources_to_add$resource_title[i],
    rcurl = resources_to_add$dcat_resource_url[i],
    format = "HTML"
  )
  
  # Limit to one entry for testing
  # break;
  
  Sys.sleep(0.3)
}
