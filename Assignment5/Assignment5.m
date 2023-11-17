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


%% Constants
% The command "run paremters#.m" initializes all the necerary variables for the simulation.
% Each version of "parameters#.m" is appropriatly modified to satisfy each case.
% Times for dynamic simulation are specified below;

omega = 0.4*2*pi;
tstart = 0;                   % s
tend = 2/(omega/2/pi);      % s
T = 0.01e-3;                  % s
t = (tstart:T:tend)';   % time vector

% Default Parameters
run parameters1.m

% Run the simulation
[xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T); %#ok<*ASGLU>
[xh2,vh,fa2,ffelt2,xe] = hapkitSimulatorNonLin(m,kh,bh,kwall,b,xwall,xd,vd,t,T); %#ok<*ASGLU>
xmax = max(abs(xh))+0.01; %#ok<*NASGU>
fmax = max(abs(ffelt))+0.1;

figtit = "NonLinearFriction";
run hapkitPlotter.m

saveas(gcf,location1+ figtit + ".png")
save(location2+"figtit")


%% Simulate Hapkit Function
function [xh,vh,fa,ffelt] = hapkitSimulator(m,kh,bh,kwall,b,xwall,xd,vd,t,T)

%% State Tracking
xh = zeros(length(t),1);    % handle position
vh = zeros(length(t),1);    % handle velocity
ah = zeros(length(t),1);    % handle acceleration
fa = zeros(length(t),1);    % force applied by the actuator
ffelt = zeros(length(t),1); % force felt by the human

%% Dynamic Symulation
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
    
    % friction force
    ff = -b*vh(i);
    
    % Compute the sum of forces on the handle: applied force, human force,
    % and friction force.
    ftotal = fa(i) + fh + ff;
    
    % Compute the handle's new acceleration for the next iteration.
    ah(i) = ftotal / m;
    
end

end

%% Simulate Hapkit Function
function [xh,vh,fa,ffelt,xe] = hapkitSimulatorNonLin(m,kh,bh,kwall,b,xwall,xd,vd,t,T)

%% State Tracking
xh = zeros(length(t),1);    % handle position
xe = xh;
xs = xh;
vh = zeros(length(t),1);    % handle velocity
ah = zeros(length(t),1);    % handle acceleration
fa = zeros(length(t),1);    % force applied by the actuator
ffelt = zeros(length(t),1); % force felt by the human
t_zoh = 0;

%% Dynamic Symulation
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
        xe(i) = encoder(xe(i-1),xh(i),false); % encoder, set to true to implement nonlinear behavior
        xs(i) = sampled(xs(i-1),xe(i),i,false); % sampling, set to true to implement nonlinear behavior
    end
    
    % force applied by the virtual environment
    if (xs(i) > xwall(i))
        fa(i) = kwall*(xwall(i)-xs(i));
    else
        fa(i) = 0;
    end
    
    fa(i) = sat(fa(i),false); % saturation, set to true to implement nonlinear behavior
    
    if (i~=1)
        [fa(i), t_zoh] = zoh(fa(i-1),fa(i),t_zoh,t(i),false); % zero order hold, set to true to implement nonlinear behavior
    end
    
    % force between the hand and the handle
    fh = kh*(xd(i)-xh(i))+bh*(vd(i)-vh(i));
    
    % force felt by the user
    ffelt(i) = -fh;
    
    % damping force
    ff = -karnop(vh(i),b,true); % nonlinear friction, set to true to implement nonlinear behavior

    
    % Compute the sum of forces on the handle: applied force, human force,
    % and friction force.
    ftotal = fa(i) + fh + ff;
    
    % Compute the handle's new acceleration for the next iteration.
    ah(i) = ftotal / m;
    
end

end

%% Nonlinear Functions 

function ff = karnop(vh,b,nonlin)
if nonlin
    vmax = 0.001;
    fstat = 0.5;
    if abs(vh) < vmax
        ff = sign(vh)*fstat + b*vh;
    else
        ff = b*vh;
    end
else
    ff = 0;
end
end

function xe = encoder(xh1,xh2,nonlin) % Encoder: the measured x-pos as absolute encoder ticks
if(nonlin)
    res = 1/(2^12);                 % encoder resolution in rev/tick
    if abs((xh2-xh1)) < res
    xe = xh1;
    else
    xe = xh1+res*floor((xh2-xh1)/res);
    end 
else
    xe = xh2;
end
end

function fa_s = sat(fa,nonlin)     % Motor Saturation: caps the motor output at fmax
if(nonlin)
    fmax = 1;                      % Maxiumum motor output
    if abs(fa) > fmax
        fa_s = sign(fa)*fmax;
    else
        fa_s = fa;
    end
else 
    fa_s = fa;
end
end

function xs = sampled(xe1,xe2,i,nonlin) % Samped position: sables x-pos at some multible of the simulation time
if(nonlin)
    ts = 2000;                          % sampling period in timesteps
    if(mod(i,ts)==0)
        xs = xe2;
    else
        xs = xe1;
    end
else
    xs = xe2;
end
end

function [fa_zoh, t_zoh] = zoh(fa1,fa2,t1,t2,nonlin) % zero order hold for force output
if(nonlin)
    ts = 0.1;                                       % output sampling time
    if abs((t2-t1)) < ts
        fa_zoh = fa1;
        t_zoh = t1;
    else
        fa_zoh = fa2;
        t_zoh = t2;
    end
else
    fa_zoh = fa2;
    t_zoh = t2;
end
end
