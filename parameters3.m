%$ Constants
% device and human parameters
m = 0.03;       % effective mass at the handle, kg
b = 1;          % viscous damping, Ns/m
kh = 500;       % human hand stiffness, N/m
bh = 10;        % human hand damping, Ns/m

% virtual wall parameters
kwall = 500;                     % wall stiffness, N/m
xwall = 0.025*ones(length(t),1); % wall position, m

% human input
omega = 0.4*2*pi;              % frequency of user's desired motion, rad/s
A = 0.04;                      % amplitude of user's desired motion, m
xd = -A*cos(omega.*t)+A+xwall;    % user's desired hand position, in m
vd = A*omega*sin(omega.*t);    % user's desired hand velocity, in m/s

