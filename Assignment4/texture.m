N = 100;
vh = 1;
xh = 0:(N-1);
omega = 0.3;
bt = 1;

for i = 1:N
if (sin(omega * xh(i)) > 0)   % creates a square wave with aplitude a and spatial frequency omega
    force(i) =  bt * vh;         %if square wave == 1, add damping force of bt
else 
    force(i) = 0;                 % else, add no damping force
end
end

plot(force)
ylim([0 1.5])
ylabel("Damping Coefficient")
xlabel("X_{handle}")