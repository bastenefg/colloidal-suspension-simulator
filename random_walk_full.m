%% EMEM3 - Bastien AYMON - January 2022

clear all
close all
clc

%% parameters

k = 1.38064852e-23; %boltzmann constant
T = 273+24; %Kelvin - temperature
a = 1.1e-6; %m - particle diameter
mu = 20e-6; %m^2/s - viscosity

D = 100*k*T/(6*pi*a*mu);

tau = 1e-3; %s - time interval between two frames

delta = sqrt(2*tau*D); %m - random walk step

%% domain setup

mm_per_pix = 2.956830277942046e-04; %mm per px ratio
xDim = 2048*mm_per_pix*1e-3; %m - FOV dimension
yDim = xDim;

N = 1000; %number of point per spatial dimension

x = linspace(-xDim/2, xDim/2, N);
y = linspace(-yDim/2, yDim/2, N);

%% initialize all particles

Npart = 100; %number of particles in the FOV
randPos = rand(Npart,2);
posX = -xDim/2 + randPos(:,1)*xDim;
posY = -yDim/2 + randPos(:,2)*yDim;

pos = [posX, posY];

%% begin simulation

iter = 1000; %number of iterations

figure(1)
% hold on

for i = 1:iter %iterate through frames
    for j = 1:Npart %iterate through particles
        [pos(j,1), pos(j,2)] = updatePos(pos(j,1), pos(j,2), delta);
    end
    plot(pos(:,1), pos(:,2), '.w', 'Linewidth', 2)
    set(gca,'XColor', 'none','YColor','none')
    set(gca,'Color','k')
    xlim([-xDim/2, xDim/2])
    ylim([-yDim/2, yDim/2])
    pause(0.025)
    %     ax = gca;
    %     exportgraphics(ax,['frame-', num2str(i), '.tif'])
end


%% functions

function [nextPosX, nextPosY] = updatePos(currPosX, currPosY, delta)

randX = rand(1);
randY = rand(1);

nextPosX = currPosX + (-1)^(randX<=0.5)*delta;
nextPosY = currPosY + (-1)^(randY<=0.5)*delta;

end

