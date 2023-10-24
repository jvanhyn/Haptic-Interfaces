% MAE 207 Assignment 3, Problem 3 
% Owner: Jonathan Van Hyning, October 22, 2023
% Template Author: Allison Okamura, September 20, 2015
% Template Last Modified By: Tania Morimoto, January 2021

% Clear the workspace.
close all;
clear;
clc;

% create save paths for figures and data
location1 = pwd + "/figures/";
location2 = pwd + "/data/";

% times for dynamic simulation
omega = 0.4*2*pi;
tstart = 0;     % s
tend = 2.5/(omega/2/pi);      % s
T = 0.01e-3;    % s
t = (tstart:T:tend)';   % time vector

%% Run the simulation for each case specified in problem 3; 
%  The command "run paremters#.m" initializes all the necerary variables for the simulation.
%  Each version of "parameters#.m" is appropriatly modified to satisfy each case. 

% i Default Parameters
disp("1")
run parameters1.m
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T); %#ok<*ASGLU>
xmax = 0.07;
fmax = 1.5;
run hapkitPlotter.m;
saveas(gcf,location1+"hapkitSimulation1.png")
save(location2+"data1")


% ii Free Space
disp("2")
run parameters2.m
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T);
xmax = 0.07;
fmax = 1;
run hapkitPlotter.m;
saveas(gcf,location1+"hapkitSimulation2.png")
save(location2+"data2")


% iii Initiate Inside Wall 
disp("3")
run parameters3.m
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T);
xmax = 0.12;
fmax = 20;
run hapkitPlotter.m;
subplot(2,1,1)
axis([tstart,tend, 0,xmax])
saveas(gcf,location1+"hapkitSimulation3.png")
save(location2+"data3")


% iv Low Kwall model
disp("4")
run parameters4.m
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T);
xmax = 0.07;
fmax = 1;
run hapkitPlotter.m;
saveas(gcf,location1+"hapkitSimulation4.png")
save(location2+"data4")


%v High Kwall model
disp("5")
run parameters5.m
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T);
xmax = 0.07;
fmax = 5;
hapkitPlotter();
saveas(gcf,location1+"hapkitSimulation5.png")
save(location2+"data5")

%% Simulate Hapkit Function
function [xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T)

    xh = zeros(length(t),1);    % handle position
    vh = zeros(length(t),1);    % handle velocity
    ah = zeros(length(t),1);    % handle acceleration
    fa = zeros(length(t),1);    % force applied by the actuator
    ffelt = zeros(length(t),1); % force felt by the human
    for i = 1:length(t)
        % integrate the main state derivatives
        if (i == 1)
            % first time step has no difference between desired and actual
            % handle position
            vh(i) = vd(i);
            xh(i) = xd(i);
        else
            % simple Euler integration (you could use something more accurate!)
            vh(i) = vh(i-1) + ah(i-1) * T;
            xh(i) = xh(i-1) + vh(i-1) * T;
        end

        % force applied by the virtual environment
        if (xh(i) > xwall(i))
            fa(i) = kwall*(xwall(i)-xh(i));
        else
            fa(i) = 0;
        end

        % force between the hand and the handle
        fh = kh*(xd(i)-xh(i))+bh*(vd(i)-vh(i));

        % force felt by the user
        ffelt(i) = -fh;

        % damping force
        ff = -b*vh(i);

        % Compute the sum of forces on the handle: applied force, human force,
        % and friction force.
        ftotal = fa(i) + fh + ff;

        % Compute the handle's new acceleration for the next iteration.
        ah(i) = ftotal / m;
    
    end

end
