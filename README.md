# SP-Spatial-Organization

## Required Inputs


| Input | Description |
|-------|-------------|
| Elevation Data Option 1: CSV file | Use a CSV file with latitude, longitude, total distance to each point, and elevation at each point alpong the profile. | 
| Elevation Data Option 2: DEM & Shapefile | The elevation data is extracted to each point along the shapefile. An equivalent to the Option 1 CSV is created in the script to perform the same functions. |
| AEF H5 Files | A list of H5 files can be specified or all H5s can be read from the working directory. |
| Units of Elevation Data | Specify if elevation data is in meters of feet. |


## Optional Inputs


| Input | Description |
|-------|-------------|
| Enable/Disable CSV Outputs | CSV outputs contain a chart of spatially ordered savepoints and their associated AEF data. Two CSVs are created, one for SWL and one for Hm0. |
| Enable/Disable Raster Plot | If enabled, a raster plot is created using the provided DEM. |
| Raster Scaling Factor | A scaling factor for decreasing the size of the raster before plotting. |


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


![swl_aef_profile](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/26ec3365-f6b6-4627-8d66-2193e3b3e8bd)


---
### Savepoint Hm0 AEF Along Profile


Hm0 AEF data is plotted along the profile of the structure.


![Hm0_aef_profile](https://github.com/JacobCreamer/SP-Spatial-Organization/assets/145397806/f05a9ca8-196f-488f-9777-1f6d6cce1eed)
