% MAE 207 Assignment 3, Problem 3 TEMPLATE
% Original Author: Allison Okamura, September 20, 2015
% Last Modified By: Tania Morimoto, January 2021
 
% Clear the workspace.
clear all;
clc;
%% Constants
 
% device and human parameters
m = 0.03;       % effective mass at the handle, kg
b = 1;       % viscous damping, Ns/m
kh = 500;    % human hand stiffness, N/m
bh = 10;     % human hand damping, Ns/m
 
% virtual wall parameters
kwall = 500;  % wall stiffness, N/m
xwall = 0.025; % wall position, m
 
% times for dynamic simulation
tstart = 0;    % s
tend = 10;      % s
T = 0.00001;    % s
t = (tstart:T:tend)';   % time vector
 
% human input
omega = 0.04*2*pi; % frequency of user's desired motion, rad/s
A = 0.04;             % amplitude of user's desired motion, m
xd = -A*cos(omega.*t);    % user's desired hand position, in m
vd = A*omega*cos(omega.*t); % user's desired hand velocity, in m/s

% figure(1)
% hold on
% plot(xd,t)
% plot(vd,t)
% hold off
% xline(xwall)
%% State Tracking
 
xh = zeros(length(t),1);    % handle position
vh = zeros(length(t),1);    % handle velocity
ah = zeros(length(t),1);    % handle acceleration
fa = zeros(length(t),1);    % force applied by the actuator
ff = fa;
ffelt = zeros(length(t),1); % force felt by the human
 
%% Dynamic Simulation
P = 100000;
for i = 1:P
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
    if (xh(i) > xwall)
        fa(i) = kwall*(xwall-xh(i));
    else
        fa(i) = 0;
    end
 
    % force between the hand and the handle
    fh = kh*(xd(i)-xh(i));
    
    % force felt by the user
    ffelt(i) = -fh;
    
    % damping force
    ff(i) = 0;
 
    % Compute the sum of forces on the handle: applied force, human force,
    % and friction force. 
    ftotal = fa(i) + fh + ff(i);
 
    % Compute the handle's new acceleration for the next iteration.
    ah(i) = ftotal / m;
    
end
figure(2)
plot(t(1:P),xh(1:P))

% figure(1)
% hold on
% plot(xd,t)
% plot(vd,t)
% hold off
% xline(xwall)
 
% %% Plotting
% 
% figure(1); clf;
% 
% 
% % positions in top subplot
% subplot(2,1,1)
% h = plot(t,xh);
% % hold on
% % xline(xwall);
% % xline(xd);
% % hold off

%h(3) = plot(xh,t);
%set(h(2),'Color',[1 .3 0],'LineWidth',0.5)
% set(h(3),'Color',[.8 0 .8],'LineWidth',1.0)
% xlabel('time (s)')
% ylabel('position (m)')
%legend('virtual surface','x_d: user''s desired position','x_h: handle position')
% axis([tstart tend -xmax xmax])
% title('Dynamic Simulation of a Haptic Interface')
 
% % forces in bottom subplot
% subplot(2,1,2)
% h = plot(?);
% set(h(1),'Color',[0 .8 .2],'LineWidth',0.5)
% set(h(2),'Color',[0 .2 .8],'LineWidth',1.0)
% xlabel('time (s)')
% ylabel('force (N)')
% legend('f_a: force applied by device','f_{felt}: force felt by user')
% axis([tstart tend -fmax fmax])
