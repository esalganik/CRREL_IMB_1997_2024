%% Dataset import (all buoys from 1997-2024)
close all; clear; clc; 
ncvars =  {'time','lat','lon','z','hi','hs','sur','int','bot','T','hi_0','hs_0'}; % Parameters for import
projectdir = 'C:\Users\Evgenii\Documents\MATLAB\SIMB3\All buoys'; % Change the directory to the dataset location
dinfo = dir( fullfile(projectdir, '*.nc') );
num_files = length(dinfo);
filenames = fullfile( projectdir, {dinfo.name} );
label = {dinfo.name};
time = cell(num_files,1); hi = time; hs = time; hi_0 = time; hs_0 = time; T = time; sur = time; int = time;
for K = 1 : num_files
  this_file = filenames{K};
  label{K} = label{K}(1:end-3);
  time{K} = ncread(this_file, ncvars{1}); % days since 1978-09-01
  t_0 = (datetime('01-Sep-1978 00:00')); t{K} = t_0 + days(time{K});
  z{K} = ncread(this_file, ncvars{4});
  hi{K} = ncread(this_file, ncvars{5});
  hs{K} = ncread(this_file, ncvars{6});
  sur{K} = ncread(this_file, ncvars{7});
  int{K} = ncread(this_file, ncvars{8});
  T{K} = ncread(this_file, ncvars{10});
  hi_0{K} = ncread(this_file, ncvars{11});
  hs_0{K} = ncread(this_file, ncvars{12});
end
clearvars ncvars projectdir dinfo filenames num_files this_file K time t_0

%% Figure 1: Validation of initial conditions (all buoys from 1997-2024)
figure
for i = 1:length(t)
    name{i} = label{i};
end
tile = tiledlayout(2,1); tile.TileSpacing = 'compact'; tile.Padding = 'none';
load('batlow100.mat');
nexttile
for i = 1:length(t)
    p = plot(hs{i}(1),hs_0{i}(1),'ko','MarkerSize',4,'color',batlow100(i,:)); set(p,'markerfacecolor',get(p,'color')); hold on
end
plot([0 0.7],[0 0.7],'k--');
leg = legend(name,'box','off'); set(leg,'FontSize',6,'Location','bestoutside','NumColumns',2); leg.ItemTokenSize = [30*0.1,18*0.1];
hXLabel = xlabel('Snow depth, initial, processed (m)'); hYLabel = ylabel('Snow depth, initial, metadata (m)'); set([hXLabel hYLabel gca],'FontSize',8,'FontWeight','normal');
xlim([0 0.7]); ylim([0 0.7]);

nexttile
for i = 1:length(t)
    p = plot(hi{i}(1),hi_0{i}(1),'ko','MarkerSize',4,'color',batlow100(i,:)); set(p,'markerfacecolor',get(p,'color')); hold on
end
plot([0 2.5],[0 2.5],'k--');
hXLabel = xlabel('Ice thickness, initial, processed (m)'); hYLabel = ylabel('Ice thickness, initial, metadata (m)'); set([hXLabel hYLabel gca],'FontSize',8,'FontWeight','normal');
xlim([0 2.5]); ylim([0 2.5]);

%% Figure 2: Quicklook of snow and ice thickness measurements
figure
tile = tiledlayout(2,1); tile.TileSpacing = 'compact'; tile.Padding = 'none';
nexttile
load('batlow100.mat'); 
for i = 1:length(t)
    plot(t{i},hs{i},'color',batlow100(i,:)); hold on
end
hYLabel = ylabel('Snow depth (m)'); set([ hYLabel gca],'FontSize',8,'FontWeight','normal');
leg = legend(label,'box','off','NumColumns',2); set(leg,'FontSize',6,'Location','bestoutside','orientation','horizontal'); leg.ItemTokenSize = [30*0.33,18*0.33];
nexttile
for i = 1:length(t)
    plot(t{i},hi{i},'color',batlow100(i,:)); hold on
end
hYLabel = ylabel('Ice thickness (m)'); set([ hYLabel gca],'FontSize',8,'FontWeight','normal');

%% Example of temperature measuments
figure
i = 1; % selected buoy
dTdz = diff(T{i},1,2);
range = -100:10:100;
contourf(datenum(t{i}),z{i}(1:end-1),dTdz'*50,range,'-','ShowText','off','LabelSpacing',400,'edgecolor','none'); hold on
plot(datenum(t{i}),sur{i},'b:','LineWidth',3); plot(datenum(t{i}),int{i},'r:','LineWidth',3); % Processed interfaces
plot(datenum(t{i}(1)),hs_0{i},'bo','MarkerSize',5); % Initial snow thicknes from metadata
load('batlow.mat'); colormap(batlow);
hYLabel = ylabel('Depth (m)'); set([hYLabel gca],'FontSize',8,'FontWeight','normal');
hBar1 = colorbar; ylabel(hBar1,'Vertical temp. grad. (°C/m)','FontSize',7);
name=convertStringsToChars(label{i}); title(sprintf('Vert. temp. gradient (°C/m), %s',name),'FontSize',8,'FontWeight','normal');
leg = legend('','Air-snow','Snow-ice','Initial snow thickness','box','on','NumColumns',1); set(leg,'FontSize',6,'Location','southwest','orientation','horizontal'); leg.ItemTokenSize = [30*0.5,18*0.5];
ylim([round(min(int{i}),1)-0.2 round(max(sur{i}),1)+0.1]);
datetick('x','mmm','keepticks','keeplimits'); xtickangle(0);

%% Dataset import (only CRREL IMB 2005-2015 reprocessed after West, 2020)
close all; clear; clc; 
ncvars =  {'time','lat','lon','z','hi','hs','sur','int','bot','T','hi_west','hs_west','sur_west','int_west','bot_west'};
projectdir = 'C:\Users\Evgenii\Documents\MATLAB\SIMB3\All buoys'; % Change the directory to the dataset location
dinfo = dir( fullfile(projectdir, '*updated.nc') );
num_files = length(dinfo);
filenames = fullfile( projectdir, {dinfo.name} );
label = {dinfo.name};
time = cell(num_files,1); hi = time; hs = time; hi_west = time; hs_west = time; T = time;
for K = 1 : num_files
  this_file = filenames{K};
  label{K} = label{K}(1:5);
  time{K} = ncread(this_file, ncvars{1}); % days since 1978-09-01
  t_0 = (datetime('01-Sep-1978 00:00')); t{K} = t_0 + days(time{K});
  z{K} = ncread(this_file, ncvars{4});
  hi{K} = ncread(this_file, ncvars{5});
  hs{K} = ncread(this_file, ncvars{6});
  sur{K} = ncread(this_file, ncvars{7});
  int{K} = ncread(this_file, ncvars{8});
  T{K} = ncread(this_file, ncvars{10});
  hi_west{K} = ncread(this_file, ncvars{11});
  hs_west{K} = ncread(this_file, ncvars{12});
  sur_west{K} = ncread(this_file, ncvars{13});
  int_west{K} = ncread(this_file, ncvars{14});
end
clearvars ncvars projectdir dinfo filenames num_files this_file K time t_0

%% Figure 3: Example of temperature measuments
figure
tile = tiledlayout(1,2); tile.TileSpacing = 'compact'; tile.Padding = 'none';
nexttile
i = 37; % selected buoy
show = 100; % selected time since deployment
plot([min(T{i}(show,:)) max(T{i}(show,:))],[sur_west{i}(show) sur_west{i}(show)],'k--'); hold on
plot([min(T{i}(show,:)) max(T{i}(show,:))],[int_west{i}(show) int_west{i}(show)],'k-.');
plot([min(T{i}(show,:)) max(T{i}(show,:))],[sur{i}(show) sur{i}(show)],'b--'); hold on
plot([min(T{i}(show,:)) max(T{i}(show,:))],[int{i}(show) int{i}(show)],'b-.');
p = plot(T{i}(show,:),z{i},'ko-','MarkerSize',4); set(p,'markerfacecolor',get(p,'color'));
leg = legend('','West (2020)','','Updated','box','off'); set(leg,'FontSize',8,'Location','northeast'); leg.ItemTokenSize = [30*0.66,18*0.66];
ylim([-.3 0.5]); xlim([min(T{i}(show,:)-1) max(T{i}(show,:))]); xlim([-35 -10]);
hXLabel = xlabel('Temperature (°C)'); hYLabel = ylabel('Depth (m)'); set([hXLabel hYLabel gca],'FontSize',8,'FontWeight','normal'); set(gca,'YDir','normal');
name=convertStringsToChars(label{i}); title(sprintf('Temp. profile, %s',name(1:5)),'FontSize',8,'FontWeight','normal');

nexttile
dTdz = diff(T{i},1,2);
range = -20:2:20;
contourf(datenum(t{i}),z{i}(1:end-1),dTdz'*10,range,'-','ShowText','off','LabelSpacing',400,'edgecolor','none'); hold on
plot(datenum(t{i}),sur_west{i},'k:','LineWidth',3); plot(datenum(t{i}),int_west{i},'k:','LineWidth',3); % Interfaces from West (2015)
plot(datenum(t{i}),sur{i},'b:','LineWidth',3); plot(datenum(t{i}),int{i},'b:','LineWidth',3); % Reprocessed interfaces
load('batlow.mat'); colormap(batlow);
hYLabel = ylabel('Depth (m)'); set([hYLabel gca],'FontSize',7,'FontWeight','normal');
hBar1 = colorbar; ylabel(hBar1,'Vertical temp. grad. (°C/m)','FontSize',7);
name=convertStringsToChars(label{i}); title(sprintf('Vert. temp. gradient, %s',name(1:5)),'FontSize',8,'FontWeight','normal');
leg = legend('','West (2020)','','Updated','box','on','NumColumns',1); set(leg,'FontSize',6,'Location','northeast','orientation','horizontal'); leg.ItemTokenSize = [30*0.5,18*0.5];
ylim([round(min(int{i}),1)-0.2 round(max(sur{i}),1)+0.1]);
datetick('x','mmm','keepticks','keeplimits'); xtickangle(0);

%% Figure 4: Comparison of processing with the dataset from West (2020)
figure
tile = tiledlayout(1,2); tile.TileSpacing = 'compact'; tile.Padding = 'none';

nexttile % snow thickness
x = cell2mat(hs);
y = cell2mat(hs_west); y(y < 0) = NaN; y(y > 2) = NaN;
N = hist3([x,y],'Nbins',[1 1]*20);
N_pcolor = N';
N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(x),max(x),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(y),max(y),size(N_pcolor,1)); % Rows of N_pcolor
imagesc(xl,yl,N_pcolor); hold on % contourplot
load('batlowW.mat'); colormap(flipud(batlowW));
ax = gca; ax.ZTick(ax.ZTick < 0) = [];
set(gcf, 'renderer', 'opengl');
plot([-.1 .7],[-.1 .7],'--','color','k','LineWidth',2.5);
xlim([xl(1)-0.5*(xl(2)-xl(1)) 0.7]); ylim([yl(1)-0.5*(yl(2)-yl(1)) 0.7]);
hXLabel = xlabel('Snow depth, reprocessed (m)'); hYLabel = ylabel('Snow depth, West (m)'); set([hXLabel hYLabel gca],'FontSize',8,'FontWeight','normal'); set(gca,'YDir','normal');

nexttile % snow thickness
x = cell2mat(hi);
y = cell2mat(hi_west); y(y < 0) = NaN; y(y > 5) = NaN;
N = hist3([x,y],'Nbins',[1 1]*15);
N_pcolor = N';
N_pcolor(size(N_pcolor,1)+1,size(N_pcolor,2)+1) = 0;
xl = linspace(min(x),max(x),size(N_pcolor,2)); % Columns of N_pcolor
yl = linspace(min(y),max(y),size(N_pcolor,1)); % Rows of N_pcolor
imagesc(xl,yl,N_pcolor); hold on % contourplot
load('batlowW.mat'); colormap(flipud(batlowW));
ax = gca; ax.ZTick(ax.ZTick < 0) = [];
plot([-.1 4],[-.1 4],'--','color','k','LineWidth',2.5);
xlim([0 4]); ylim([0 4]);
hXLabel = xlabel('Ice thickness, reprocessed (m)'); hYLabel = ylabel('Ice thickness, West (m)'); set([hXLabel hYLabel gca],'FontSize',8,'FontWeight','normal'); set(gca,'YDir','normal');
clearvars ax hXLabel hYLabel tile N N_pcolor ax batlowW x y xl yl