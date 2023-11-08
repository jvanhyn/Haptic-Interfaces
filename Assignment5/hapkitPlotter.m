% Hapkit Plotter
figure()
tcl = tiledlayout(2,2);
set(gcf, 'Position',  [100, 100, 2000, 500])

% x-positions in the top subplot
nexttile()
h = plot(t,xwall,t,xd,t,xh);
set(h(2),'Color',[1 .3 0],'LineWidth',0.5)
set(h(3),'Color',[.8 0 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('position (m)')
legend('virtual surface','x_d: user''s desired position','x_h: handle position')
axis([tstart tend -xmax xmax])
title("Without Non-Linear Elements")

nexttile()
h = plot(t,xwall,t,xd,t,xh2);
set(h(2),'Color',[1 .3 0],'LineWidth',0.5)
set(h(3),'Color',[.8 0 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('position (m)')
legend('virtual surface','x_d: user''s desired position','x_h: handle position')
axis([tstart tend -xmax xmax])
title("With Non-Linear Elements")

nexttile()
h = plot(t,fa,t,ffelt);
set(h(1),'Color',[0 .8 .2],'LineWidth',0.5)
set(h(2),'Color',[0 .2 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('Force (N)')
legend('f_a: force applied by device','f_{felt}: force felt by user')
axis([tstart tend -fmax fmax])

nexttile()
h = plot(t,fa2,t,ffelt2);
set(h(1),'Color',[0 .8 .2],'LineWidth',0.5)
set(h(2),'Color',[0 .2 .8],'LineWidth',1.0)
xlabel('time (s)')
ylabel('Force (N)')
legend('f_a: force applied by device','f_{felt}: force felt by user')
axis([tstart tend -fmax fmax])

title(tcl,'Dynamic Simulation of a Haptic Interface')
subtitle(tcl,figtit)

%set(gcf, 'Position',  [100, 100, 1000, 500])