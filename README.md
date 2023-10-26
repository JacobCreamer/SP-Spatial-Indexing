# SP-Spatial-Organization

## Required Inputs


| Input | Description |
|-------|-------------|
| Elevation Data Option 1: CSV file | Use a CSV file with latitude, longitude, total distance to each point, and elevation at each point alpong the profile. | 
| Elevation Data Option 2: DEM & Shapefile | The elevation data is extracted to each point along the shapefile. An equivalent to the Option 1 CSV is created in the script to perform the same functions. |
| AEF H5 Files | A list of H5 files can be specified or all H5s can be read from the working directory. |
| Units of Elevation Data | Specify if elevation data is in meters of feet. |


Also note: The call_chs_h5_converter.m and chs_h5_converter.m scripts must both be in the directory or a path added to access them. These scripts are required for converting the H5 files into a matlab structure so that the data can be read for each file. 


## Optional Inputs


| Input | Description |
|-------|-------------|
| Enable/Disable CSV Outputs | CSV outputs contain a chart of spatially ordered savepoints and their associated AEF data. Two CSVs are created, one for SWL and one for Hm0. |
| Enable/Disable Raster Plot | If enabled, a raster plot is created using the provided DEM. |
| Raster Scaling Factor | A scaling factor for decreasing the size of the raster before plotting. |


## Example User Input Section


![User_inputs](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/fc9d53b9-31f0-4fbc-8cd6-a5be86b62fc9)


## Example Directory


![folder](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/f3b524a1-180f-49a4-a2df-a319eab9764a)


## Outputs


### Map plot of project 


The savepoints are plotted and labeled according to data extracted from H5s. The shape file is plotted to represent the structure. Shortest distance lines are plotted to show point locations where AEF data is plotted along structure profile. Midpoints between savepoint plot locations are marked with a black 'x'. The beginning point of the shapefile is marked with a red '*'.


![map_plot_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/86992ab5-422a-4fcd-a75c-7a94afbdbec9)


---
### Savepoint SWL AEF Chart


SWL AEF data is plotted for each savepoint. The savepoints have been spatially ordered along the profile of the structure.


![swl_aef_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/0752e066-123b-4ef7-b3b0-deacfd19c57e)


---
### Savepoint Hm0 AEF Chart


Hm0 AEF data is plotted for each savepoint. Once again, the savepoints are spatially ordered along the profile.


![hm0_aef_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/4534f04e-5ff3-44c1-b3ee-9cec6bf3be38)


---
### Savepoint SWL AEF Along Profile


SWL AEF data is plotted along the profile of the structure.


![swl_profile_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/046ec781-d66d-4a35-bb85-de9b45e5083b)


---
### Savepoint Hm0 AEF Along Profile


Hm0 AEF data is plotted along the profile of the structure.


![hm0_profile_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/5d591249-a4ad-4fe3-ae9e-b1043146177b)


### Output CSV Example


Each column is labeled at top row with the savepoint name. Savepoints are spatially ordered and all AEF data is recorded.


![csv_example](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/d8f5735b-2162-4e00-bfcf-02c1a1d23737)

