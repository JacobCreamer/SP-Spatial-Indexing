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


![User_inputs](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/6f83af99-7512-41d3-b85f-1480c1beda78)


## Example Directory


![](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/00110be8-bee4-4ee3-b5e4-327f4750eff3)


## Outputs


### Map plot of project 


The savepoints are plotted and labeled according to data extracted from H5s. The shape file is plotted to represent the structure. Shortest distance lines are plotted to show point locations where AEF data is plotted along structure profile. Midpoints between savepoint plot locations are marked with a black 'x'. The beginning point of the shapefile is marked with a red '*'.


![Map plot of project.](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/8e442491-1be2-4ed8-bb32-309eab16c48f)


---
### Savepoint SWL AEF Chart


SWL AEF data is plotted for each savepoint. The savepoints have been spatially ordered along the profile of the structure.


![swl_aef_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/d4675973-6319-42a4-87c0-0c21c1fdfb32)


---
### Savepoint Hm0 AEF Chart


Hm0 AEF data is plotted for each savepoint. Once again, the savepoints are spatially ordered along the profile.


![hm0_aef_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/8725293b-17b6-458e-ba7f-a004b5b245ac)


---
### Savepoint SWL AEF Along Profile


SWL AEF data is plotted along the profile of the structure.


![swl_profile_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/3c73dfdb-f21d-42d9-aeaa-b4c5b9bb1aab)


---
### Savepoint Hm0 AEF Along Profile


Hm0 AEF data is plotted along the profile of the structure.


![hm0_profile_3](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/8bd90f43-87f5-4648-9a23-2169a7a31488)


### Output CSV Example


Each column is labeled at top row with the savepoint name. Savepoints are spatially ordered and all AEF data is recorded.


![csv_example](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/8bec6a44-3569-4ff8-9762-8e5762f91a83)
