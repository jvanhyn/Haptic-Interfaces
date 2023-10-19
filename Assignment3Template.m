% MAE 207 Assignment 3, Problem 3 TEMPLATE
% Original Author: Allison Okamura, September 20, 2015
% Last Modified By: Tania Morimoto, January 2021
 
% Clear the workspace.
clear all;
 
%% Constants
 
% device and human parameters
m = ?;       % effective mass at the handle, kg
b = ?;       % viscous damping, Ns/m
kh = ?;    % human hand stiffness, N/m
bh = ?;     % human hand damping, Ns/m
 
% virtual wall parameters
kwall = ?;  % wall stiffness, N/m
xwall = ?; % wall position, m
 
% times for dynamic simulation
tstart = 0;    % s
tend = ?;      % s
T = ?;    % s
t = (tstart:T:tend);   % time vector
 
% human input
omega = ?; % frequency of user's desired motion, rad/s
A = ?;             % amplitude of user's desired motion, m
xd = ?;    % user's desired hand position, in m
vd = ?; % user's desired hand velocity, in m/s
 
%% State Tracking
 
xh = zeros(length(?),1);    % handle position
vh = zeros(length(?),1);    % handle velocity
ah = zeros(length(?),1);    % handle acceleration
fa = zeros(length(?),1);    % force applied by the actuator
ffelt = zeros(length(?),1); % force felt by the human
 
%% Dynamic Simulation
 
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
    if (xh(i) > ?)
        fa(i) = ?);
    else
        fa(i) = 0;
    end
 
    % force between the hand and the handle
    fh = ?;
    
    % force felt by the user
    ffelt(i) = ?;
    
    % damping force
    ff = ?;
 
    % Compute the sum of forces on the handle: applied force, human force,
    % and friction force. 
    ftotal = fa(i) + fh + ff;
 
    % Compute the handle's new acceleration for the next iteration.
    ah(i) = ftotal / m;
    
end
 
%% Plotting
 
figure(1); clf;
xmax = ?;
fmax = ?;
 
% positions in top subplot
subplot(2,1,1)
h = plot(?);
set(h(2),'Color',[1 .3 0],'LineWidth',0.5)
set(h(3),'Color',[.8 0 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('position (m)')
legend('virtual surface','x_d: user''s desired position','x_h: handle position')
axis([tstart tend -xmax xmax])
title('Dynamic Simulation of a Haptic Interface')
 
% forces in bottom subplot
subplot(2,1,2)
h = plot(?);
set(h(1),'Color',[0 .8 .2],'LineWidth',0.5)
set(h(2),'Color',[0 .2 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('force (N)')
legend('f_a: force applied by device','f_{felt}: force felt by user')
axis([tstart tend -fmax fmax])
