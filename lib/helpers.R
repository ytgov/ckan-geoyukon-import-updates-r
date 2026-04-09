# Helper functions for the GeoYukon import to CKAN scripts

clean_dcat_description_text <- function(description_text) {
  
  # Pre-emptively add some line breaks.
  # Sometimes these are <p> and sometimes they are <p style="..."
  description_text = str_replace_all(description_text, "<p", "\n\n<p")
  
  # Sometimes they are capitalized! TODO: make this a better regex combined with the above
  description_text = str_replace_all(description_text, "<P", "\n\n<p")
  
  description_text = str_replace_all(description_text, "<br", "\n\n<br")
  description_text = str_replace_all(description_text, "<BR", "\n\n<br")
  
  # Remove all HTML entities.
  # Thanks to https://regex101.com/library/qS0gE2?orderBy=RELEVANCE&search=html
  description_text = str_remove_all(description_text, "<([^>]+)>")
  # description_text = str_replace_all(description_text, "<([^>]+)>", " ")
  
  # Remove multiple spaces between words
  
  # description_text = str_replace_all(description_text, "\\s{2,}", " ")
  
  # Remove many linebreaks to just 2
  description_text = str_replace_all(description_text, "\\n{2,}", "\n\n")
  
  # Remove &nbsp;-linebreak combinations
  # 
  description_text = str_replace_all(description_text, "\\n\\n&nbsp;\\n\\n", "\n\n")
  
  # Remove leading linebreaks at the start of the description
  description_text = str_replace_all(description_text, "^\\n{2,}", "")
  
  # Add Markdown links for the GeoYukon links.
  description_text = str_replace_all(description_text, "Distributed from GeoYukon by the Government of Yukon.", "Distributed from [GeoYukon](https://yukon.ca/geoyukon) by the [Government of Yukon](https://yukon.ca/maps).")
  description_text = str_replace_all(description_text, "Distributed from GeoYukonby the Government of Yukon.", "Distributed from [GeoYukon](https://yukon.ca/geoyukon) by the [Government of Yukon](https://yukon.ca/maps).")
  
  # Add Geomatics emails
  description_text = str_replace_all(description_text, "geomatics.help@yukon.ca", "[geomatics.help@yukon.ca](mailto:geomatics.help@yukon.ca)")
  description_text = str_replace_all(description_text, "geomatics.help@gov.yk.ca", "[geomatics.help@yukon.ca](mailto:geomatics.help@yukon.ca)")
  description_text = str_replace_all(description_text, "Geomatics.Help@gov.yk.ca", "[geomatics.help@yukon.ca](mailto:geomatics.help@yukon.ca)")
  
  # Add Elections Yukon emails
  # TODO: standardize this into a generic email regex
  description_text = str_replace_all(description_text, "info@electionsyukon.ca", "[info@electionsyukon.ca](mailto:info@electionsyukon.ca)")
  
  description_text
  
}

# Thanks, Google
slugify <- function(x) {
  x %>%
    str_to_lower() %>%                        # Convert to lowercase
    iconv(from = 'UTF-8', to = 'ASCII//TRANSLIT') %>% # Convert accented characters to ASCII before removing non-ASCII below
    str_replace_all("[^a-z0-9\\s-]", "") %>%  # Remove non-alphanumeric (except spaces/hyphens)
    str_squish() %>%                          # Remove extra whitespace
    str_replace_all("\\s+", "-") %>%          # Replace spaces with hyphens
    str_replace_all("-{2,}", "-")             # Replace multiple hyphens with singular ones
}

get_name_from_title <- function(title) {
  slugify(title)
}

get_date_stamp <- function() {
  
  date_stamp <- as.character(now())
  
  date_stamp |> 
    str_sub(0L, 10L) |> 
    str_replace_all("-", "")
  
  
}

