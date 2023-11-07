clc; clear; close all;

warning('off','MATLAB:table:ModifiedAndSavedVarnames');
addpath 'C:\USACE Work\Work Scripts\Spatial Analysis of Hazards - AEF and Profile\Code\Scituate Reach'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% User Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        %%%% AEF DATA %%%%
% Option 1: specify each h5 filename
% in_file_list = ...
%     ["CHS-LA_TS_SimBrfc2_Post_SP03419_Stat_AEF.csv", ...
%     "CHS-LA_TS_SimBrfc2_Post_SP00010_Stat_AEF.csv", ...
%     "CHS-LA_TS_SimBrfc2_Post_SP08005_Stat_AEF.csv", ...
%     "CHS-LA_TS_SimBrfc2_Post_SP15444_Stat_AEF.csv"]; 

% Option 2: find all h5 files in current folder (0 = no, 1 = yes)
find_files = 1;


                      %%%% PROFILE DATA %%%%
% Option 1: load a csv file for the profile
% profile_file = table2array(readtable('system_4405000513_profile.csv'));

% Option 2: load elevation information and shapefile (Specify filename)
[A,R] = readgeoraster('Scituate_bathymetric_viewer.tif');
[boundary_shp,shp_info] = shaperead('Scituate_Reach.shp');



                     %%%% Other Options %%%%
% Units for profile data: 0 = meters, 1 = feet
units = 0;
% specify if output csvs for swl & Hm0 are created: 0 = no, 1 = yes
create_output_csvs = 1;
% Plot raster and shapefile: 0 = no, 1 = yes
plot_raster = 0;
% Downscale raster for viewing
downscale_factor = 0.3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if find_files == 1
    in_file_struct = dir('*AEF.h5');
    in_file_list = {in_file_struct.name};
    if isempty(in_file_struct) == 1
        in_file_struct = dir('*AEP.h5');
        in_file_list = {in_file_struct.name};
        use_aep = 1;
    end
end

if exist('profile_file')
    shp_matrix = profile_file(:,1:2);
    lon_shp = profile_file(:,1);
    lat_shp = profile_file(:,2);
    if units == 1
        profile_file(:,3:4) = profile_file(:,3:4)/3.281;
    end
end

if exist("boundary_shp")
    lon_shp = boundary_shp.X;
    lat_shp = boundary_shp.Y;
    shp_matrix = [lon_shp' lat_shp'];
    shp_matrix = rmmissing(shp_matrix);
end

% create out tables to write data to
Hm0_out_table = table;   
swl_out_table = table;

% read the first AEF file in list to pull AEF markers
if use_aep == 1
    read_first_table = chs_h5_converter(string(in_file_list(1)));
    AEP_values = table(getfield(read_first_table,{1},'Table_StormData','AEP Values',{1:13}));
    AEP_values.Properties.VariableNames{1} = 'AEP Values';
else
    read_first_table = chs_h5_converter(string(in_file_list(1)));
    AEF_values = table(getfield(read_first_table,{1},'Table_StormData','AEF Values',{1:22}));
    AEF_values.Properties.VariableNames{1} = 'AEF Values';
end

% append AEF markers to out tables
if use_aep == 1
    swl_out_table = [swl_out_table AEP_values];
else
    Hm0_out_table = [Hm0_out_table AEF_values];
    swl_out_table = [swl_out_table AEF_values];
end

% create lists that will be needed
sp_name_list = zeros(length(in_file_list),1);
lat = zeros(length(in_file_list),1);
lon = zeros(length(in_file_list),1);

% call the chs h5 converter to create a data structure of h5 data
Data_out = call_chs_h5_converter(in_file_list);

% cycle through the structure and append data to out tables
for i = 1:length(in_file_list)

    % get the savepoint name and lat/long
    sp_name = getfield(Data_out,{i},"Conv_Data",{1},'Table_StormData','Save Point ID',{1});
    sp_lat = getfield(Data_out,{i},"Conv_Data",{1},'Table_StormData','Save Point Latitude',{1});
    sp_lon = getfield(Data_out,{i},"Conv_Data",{1},'Table_StormData','Save Point Longitude',{1});

    % save name and lat/long to lists
    sp_name_list(i) = sp_name;
    lat(i) = sp_lat;
    lon(i) = sp_lon;
    
    % get the AEF/AEP data for Hm0 and swl
    if use_aep == 1
        swl_in_table = table(getfield(Data_out,{i},"Conv_Data",{1},'Table_StormData','Expected Value AEP',{1:13}));
        swl_in_table = renamevars(swl_in_table,"Var1",string(sp_name));
    else
        Hm0_in_table = table(getfield(Data_out,{i},"Conv_Data",{1},'Table_StormData','Expected Value AEP',{1:22}));
        Hm0_in_table = renamevars(Hm0_in_table,"Var1",string(sp_name));
        swl_in_table = table(getfield(Data_out,{i},"Conv_Data",{3},'Table_StormData','Expected Value AEP',{1:22}));
        swl_in_table = renamevars(swl_in_table,"Var1",string(sp_name));
    end

    % append the AEF data to each out table
    if use_aep == 1
        swl_out_table = [swl_out_table swl_in_table];
    else
        Hm0_out_table = [Hm0_out_table Hm0_in_table];
        swl_out_table = [swl_out_table swl_in_table];
    end
end

% convert out tables to arrays
swl_data = table2array(swl_out_table);
Hm0_data = table2array(Hm0_out_table);

% create a matrix for savepoint lat & long
savepoint_matrix = [lon lat];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find nearest point in shapefile to each savepoint
nearest_point_index = dsearchn(shp_matrix,savepoint_matrix);
nearest_points = shp_matrix(nearest_point_index,:);

if exist('boundary_shp')
    % associate raster elevations with shapefile points
    shp_ele = zeros(height(shp_matrix),1);
    for i = 1:height(shp_matrix)
        shp_ele(i) = geointerp(A,R,lat_shp(i),lon_shp(i));
    end

    % correct units if needed
    if units == 1
        shp_ele = shp_ele/3.281;
    end

    % get raster x & y for plotting
    [raster_lat,raster_lon] = geographicGrid(R);
    
    % find distance along points of shapefile - create distance list
    tot_dist_1 = 0;
    tot_dist_list = zeros(height(shp_matrix),1);
    
    for i = 1:height(shp_matrix)-1
        [arc_len,az] = distance(lat_shp(i),lon_shp(i),lat_shp(i+1),lon_shp(i+1));
        dist = deg2km(arc_len)*1000;
        dist = dist + tot_dist_1;
        tot_dist_1 = dist;
        tot_dist_list(i+1) = tot_dist_1;
    end
    
    % create sorted distance list and sorting order
    [xvals,sort_order] = sort(tot_dist_list(nearest_point_index));
    sorted_sp_name_list = sp_name_list(sort_order);
    
    % create single matrix for distance along profile and elevation
    shape_dist_ele_matrix = [tot_dist_list shp_ele];
else
    % create single matrix for distance along profile and elevation
    shape_dist_ele_matrix = profile_file(:,3:4);
    % create array of total distances for sorting point locations
    tot_dist_list = shape_dist_ele_matrix(:,1);
    
    % create sort order
    [xvals,sort_order] = sort(tot_dist_list(nearest_point_index));
    % sort the savepoints/nodes
    sorted_sp_name_list = sp_name_list(sort_order);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot profile of shapefile for swl plot
figure(2)

plot(shape_dist_ele_matrix(:,1),shape_dist_ele_matrix(:,2),'color','#36454F','HandleVisibility','off','LineWidth',0.05,'LineStyle','-');
hold on
datatip_sp_id = dataTipTextRow('SavePoint/Node ID',sorted_sp_name_list);

% plot swl AEF/AEP at superimposed points along distance (along line of shapefile)
for i = 1:height(swl_out_table)
    yvals = swl_data(i,2:width(swl_data));
    yvals_sorted = yvals(sort_order);
    swl_plot = plot(xvals,yvals_sorted,'linestyle','-','Marker','.');
    swl_plot.DataTipTemplate.DataTipRows(3) = datatip_sp_id;
end
xlabel('Distance (m)')
ylabel('Height (m)')
if use_aep == 0
    title('Savepoints AEF - SWL')
else
    title('Savepoints AEP - SWL')
end
legend(string(swl_data(:,1)))
grid
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot profile of shapefile for Hm0 plot
if use_aep == 0
    figure(3)
    
    plot(shape_dist_ele_matrix(:,1),shape_dist_ele_matrix(:,2),'color','#36454F','HandleVisibility','off','LineWidth',0.05,'LineStyle','-')
    hold on
    datatip_sp_id = dataTipTextRow('SavePoint/Node ID',sorted_sp_name_list);
    
    % plot Hm0 AEF at superimposed points along distance (along line of shapefile)
    for i = 1:height(Hm0_out_table)
        yvals = Hm0_data(i,2:width(Hm0_data));
        yvals_sorted = yvals(sort_order);
        Hm0_plot = plot(xvals,yvals_sorted,'linestyle','-','Marker','.');
        Hm0_plot.DataTipTemplate.DataTipRows(3) = datatip_sp_id;
    end
    xlabel('Distance (m)')
    ylabel('Height (m)')
    title('Savepoints AEF - Hm0')
    legend(string(Hm0_data(:,1)))
    grid
    hold off
end
%%%%%%%%%%%%%%%%%% Plot SWL and Hm0 Data from Table %%%%%%%%%%%%%%%%%%%%%%

% create new sorted output tables based on distance along shapefile
if use_aep == 0
    sorted_swl_out_table = table();
    sorted_swl_out_table = [sorted_swl_out_table AEF_values];
    sorted_Hm0_out_table = table();
    sorted_Hm0_out_table = [sorted_Hm0_out_table AEF_values];
else
    sorted_swl_out_table = table();
    sorted_swl_out_table = [sorted_swl_out_table AEP_values];
end

for i = 1:length(sorted_sp_name_list)
    sorted_sp_name = sorted_sp_name_list(i);
    sorted_swl_out_table = [sorted_swl_out_table swl_out_table(:,string(sorted_sp_name))];
    if use_aep == 0
        sorted_Hm0_out_table = [sorted_Hm0_out_table Hm0_out_table(:,string(sorted_sp_name))];
    end
end

% convert sorted out tables to arrays for plotting
sorted_swl_data = table2array(sorted_swl_out_table);
if use_aep == 0
    sorted_Hm0_data = table2array(sorted_Hm0_out_table);
end

% plot savepoint swl AEF/AEP information from sorted table
figure(4)
for i = 1:height(sorted_swl_out_table)
    plot(sorted_swl_data(i,2:width(sorted_swl_data)),'linestyle','-','Marker','.');
    hold on
end
xticks(1:1:width(swl_data));
xticklabels(sorted_swl_out_table.Properties.VariableNames(2:end));
if use_aep == 0
    title('Savepoints AEF - SWL')
else
    title('Savepoints AEP - SWL')
end
xlabel('Save Points')
ylabel('Height (m)')
legend(string(swl_data(:,1)))
grid

% plot savepoint Hm0 AEF information from sorted table
if use_aep == 0
    figure(5)
    for i = 1:height(sorted_Hm0_out_table)
        plot(sorted_Hm0_data(i,2:width(sorted_Hm0_data)),'linestyle','-','Marker','.');
        hold on
    end
    xticks(1:1:width(Hm0_data));
    xticklabels(sorted_Hm0_out_table.Properties.VariableNames(2:end));
    title('Savepoints AEF - Hm0')
    xlabel('Save Points')
    ylabel('Height (m)')
    legend(string(Hm0_data(:,1)))
    grid
    
    hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%% Crest Statistics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% divide length along profile into representative lengths for each SP
sorted_sp_indexes = nearest_point_index(sort_order);

% find loaction of midpoint between first and last savepoints
dist_last_to_first = (tot_dist_list(end)-xvals(end)) + xvals(1);
last_to_first_mp = xvals(end) + dist_last_to_first/2;
if last_to_first_mp > max(tot_dist_list)
    last_to_first_mp = last_to_first_mp - max(tot_dist_list);
end

closestIndex_list = zeros(length(xvals),1);

[~,closestIndex1] = min(abs(last_to_first_mp-tot_dist_list));
closestIndex_list(end) = closestIndex1;

% find location of all other midpoints between savepoints
for i = 1:length(xvals)-1
    midpoint = (xvals(i) + xvals(i+1))/2;
    [~,closestIndex] = min(abs(midpoint-tot_dist_list));
    closestIndex_list(i) = closestIndex;
end

profile_bucket_cell = {};

% get crest statistics for 1st savepoint
profile_bucket_1 = [shape_dist_ele_matrix(closestIndex_list(end):length(tot_dist_list),2); shape_dist_ele_matrix(1:closestIndex_list(1),2)];
profile_bucket_cell{1} = profile_bucket_1;

% get crest statistics for all other savepoints
for i = 1:length(closestIndex_list)-1
     profile_bucket = shape_dist_ele_matrix(closestIndex_list(i):closestIndex_list(i+1),2);
     profile_bucket_cell{i+1} = profile_bucket;
end

%%%%%%%%%%%%%%%%%%%%%%%% Plot Crest Statistics %%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6)

% plot swl AEF/AEP data

for i = 1:height(swl_out_table)
    yvals = swl_data(i,2:width(swl_data));
    yvals_sorted = yvals(sort_order);
    swl_plot = plot(xvals,yvals_sorted,'linestyle','-','Marker','.');
    swl_plot.DataTipTemplate.DataTipRows(3) = datatip_sp_id;
    hold on
end
title('SWL & Crest Statistics')
xlabel('Distance (m)')
ylabel('Height (m)')
legend(string(swl_data(:,1)))
grid

% plot box and whisker for crest statistics

for i = 1:length(xvals)
    xvals_plot = zeros(length(profile_bucket_cell{i}),1)+xvals(i);
    boxchart(xvals_plot,profile_bucket_cell{i},"BoxWidth",max(tot_dist_list)/70,"MarkerSize",4,HandleVisibility="off")
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%% Geoplotting Information %%%%%%%%%%%%%%%%%%%%%%%%%%

% plot the savepoints using lat/long
figure(1)
geoplot(lat,lon,'r.');
text(lat,lon,string(sp_name_list),VerticalAlignment="bottom")
geobasemap streets
hold on

% plot the boundary shape file
geoplot(lat_shp,lon_shp,Color="r")

% mark "beginning/end" point of shapefile
geoplot(lat_shp(1),lon_shp(1),Marker="*",MarkerSize=8,Color='r')

% plot lines between savepoints and nearest point on project boundary
for i = 1:length(nearest_points)
    geoplot([savepoint_matrix(i,2) nearest_points(i,2)],[savepoint_matrix(i,1) nearest_points(i,1)],'Color','k',"LineStyle","-")
    hold on
end

% plot midpoints at nearest shapefile node
geoplot(shp_matrix(closestIndex_list,2),shp_matrix(closestIndex_list,1),Color='k',Marker='x',MarkerSize=8,LineStyle='none')

%%%%%%%%%%%%%%%%%%%%%%%%%% Process Raster Data %%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_raster == 1
    % downscale raster for viewing
    A = double(A);
    [B, RB] = georesize(A,R,downscale_factor);
    
    % plot the raster data for visualization
    figure(7)
    geoshow(B,RB,DisplayType="image")
    hold on
    geoshow(lat_shp,lon_shp,Color="r")
end

%%%%%%%%%%%%%%%%%%%%%%%% Save output CSV files %%%%%%%%%%%%%%%%%%%%%%%%%%%

% create new CSVs for swl and Hm0 using the created out tables
if create_output_csvs == 1
    if use_aep == 0
        writetable(sorted_Hm0_out_table,'Hm0_out.csv');
    end
    writetable(sorted_swl_out_table,'swl_out.csv');
end
