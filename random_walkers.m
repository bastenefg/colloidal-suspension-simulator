function [] = random_walkers()

%% This function generates outputs visually similar to which obtained by...
%% observing colloids in suspension in a viscous fluid under a microscope.
%% The user can interact with many physical parameters and observe their...
%% influence on the particles' behavior. Results can be saved to .tiff...
%% stacks for postprocessing (trackpy, ...).
%% Bastien AYMON - January 2022

clear all
close all
clc

%% User settings

param = settingsdlg(...
    'Description', 'Please set up the desired simulation parameters.',...
    'title' , 'Random walk parameters',...
    'separator' , 'Physical parameters',...
    {'Temperature [K]';'T'}, 298,...
    {'Particle radius [m]';'a'}, 0.55e-6,...
    {'Viscosity [mPa s]';'mu'}, 1,...
    {'Number of particles';'Npart'}, 100,...
    'separator' , 'Visualization',...
    {'Save .tiff stack'; 'saveImages'}, false,...
    {'Keep individual .tiff images'; 'saveIndImages'}, false,...
    {'Number of frames';'iter'}, 250,...
    {'Simulation frame rate [fps]';'fps'}, 24);

fileName = 'TiffStackName.tiff';

%% Parameters

k = 1.38064852e-23; % [m^2 kg s^-2 K^-1] Boltzmann constant
D = k*param.T/(6*pi*param.a*param.mu*1e-3); % [m^2 s^-1] Diffusion coefficient
tau = 1/param.fps; % [s] - Time interval between two frames
delta = sqrt(2*tau*D); % [m] - Random walk step

%% Domain setup

xDim = 4e-4; % [m] - FOV dimension (400 microns, typical for a 8x microscope)
yDim = xDim;

N = 1000; % Number of point per spatial dimension

x = linspace(-xDim/2, xDim/2, N); % x dimension
y = linspace(-yDim/2, yDim/2, N); % y dimension

%% Particles initialization

randPos = rand(param.Npart,2);
pos = [-xDim/2 + randPos(:,1)*xDim, -yDim/2 + randPos(:,2)*yDim]; % Random intial position

% Position update funtion
updatePos = @(currPos, delta) currPos + (-1)^(rand(1)<=0.5)*delta;

%% Simulation

figure(1)

for i = 1:param.iter % Iterate through frames
    for j = 1:param.Npart % Iterate through particles
        pos(j,1) = updatePos(pos(j,1), delta); % Update X position
        pos(j,2) = updatePos(pos(j,2), delta); % Update Y position
    end
    plotresults(pos(:,1), pos(:,2), i, param.iter, xDim, yDim) % Plot the results
    if param.saveImages == true
        ax = gca;
        exportgraphics(ax,['frame-', num2str(i), '.tif'])
        disp((['Saving frame ', num2str(i), '/', num2str(param.iter), '...']))
    end
end

%% Generating the .tiff stack

if param.saveImages == true
    disp('Generating stack...')
    for i=1:param.iter
        c{i}=imread(strcat('frame-',num2str(i),'.tif'));
        imwrite(c{i}, fileName, 'writemode', 'append');
    end
    disp('Stack sucessfully saved.')
    if param.saveIndImages == false
        delete frame-*.tif
    end
end

end

%% Plotting function

function [] = plotresults(posX, posY, currIter, totIter, xDim, yDim)

plot(posX, posY, '.w', 'Linewidth', 3)
set(gca,'XColor', 'none','YColor','none')
set(gca,'Color','k')
set(gcf,'color',[1 1 1])
xlim([-xDim/2, xDim/2])
ylim([-yDim/2, yDim/2])
pbaspect([1 1 1])
pause(0.01)

end
