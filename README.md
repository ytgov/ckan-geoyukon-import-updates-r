# ckan-geoyukon-import-updates-r

This set of R scripts updates metadata and resource links for [GeoYukon geospatial layers](https://mapservices.gov.yk.ca/GeoYukon/) in the [open data catalogue at open.yukon.ca](https://open.yukon.ca/data/?tags=geoyukon-import). 

It uses the [CKAN API](https://docs.ckan.org/en/2.11/api/) and is intended for open.yukon.ca site administrators. It retrieves data [from an ArcGIS Online DCAT feed](https://doc.arcgis.com/en/hub/content/federate-data.htm).

These scripts use the [Tidyverse](https://tidyverse.org/) and several other R packages.

To connect to the CKAN 2.11 API, this requires the development version of [ckanr](https://github.com/ropensci/ckanr) (version 0.8.1 or higher, which as of 2026-02 is not yet available on CRAN).

## Initial setup

1. Install the development version of `ckanr` (typically using `install.packages("remotes")` then `remotes::install_github("ropensci/ckanr")`)
2. Install the other R packages found in `lib/helpers.R`.
3. Duplicate the `.env.example` file as `.env` and add your CKAN API token to the `.env` file (which is not Git-tracked).

## Usage

### Comparing DCAT (ArcGIS Online) and CKAN (open.yukon.ca) GeoYukon entries

Run `compare_sources.R` to determine what geospatial layers or datasets have been changed on ArcGIS Online since the last GeoYukon import took place. 

This will output several CSV files to the `output/` folder, including:

- net new datasets (added on ArcGIS Online but not present on open.yukon.ca yet)
- datasets that have been deleted (or renamed) on ArcGIS Online but not deleted (or renamed) on open.yukon.ca
- resources that have been deleted on ArcGIS Online but not deleted from the relevant dataset on open.yukon.ca

### Updating dataset resource URLs on open.yukon.ca

Run `update_datasets_resources.R` to update the resource URLs for datasets that have been updated on ArcGIS Online (and already exist in open.yukon.ca). This is helpful if the URLs for REST APIs or shapefile downloads on the FTP server have changed.

### Updating dataset metadata on open.yukon.ca

Run `update_datasets_metadata.R` to update the dataset metadata (currently just the dataset/layer description) on open.yukon.ca to match ArcGIS Online. In the future this should support changes to tags and other imported metadata.

Currently this does not support layer name changes. **For a layer name change, after updating the ArcGIS Online layer, update the title of the equivalent dataset entry on open.yukon.ca to exactly match the new layer name.**

### Adding net new datasets

Run `add_net_new_datasets.R` to add net new datasets to open.yukon.ca after they have been created on ArcGIS Online and added to the open data distribution group. This creates new matching entries on open.yukon.ca.

Datasets on open.yukon.ca that have been imported this way have the `geoyukon-import` tag, which is also used by the other scripts above to identify matching datasets to update. 

[See all imported GeoYukon layers on open.yukon.ca](https://open.yukon.ca/data/?tags=geoyukon-import).

## For more information

Email <sean.boots@yukon.ca> or <eservices@yukon.ca>. For geospatial questions email <Geomatics.Help@yukon.ca>.

[Find out more about the Government of Yukon's open government program](https://yukon.ca/en/your-government/open-government/learn-about-open-government).
