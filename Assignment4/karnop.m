clear
clc
close

vrange = 20;
V = -vrange:0.1:vrange;
vmin = 5;
bstat = 1;
fstat = 2;
b = 0.1;
f = zeros(length(V),1);

for i = 1:length(V)
v = V(i);
if (-vmin<v) && (v < vmin)
    f = v*bstat;
    if f > fstat
    f = fstat;
    end
    if f < -fstat
    f = -fstat;
    end
else 
    f = v*b;
end
F(i) = f;
end

figure
plot(V,F) 
xline(vmin,"--")
xline(-vmin,"--")
ylabel("Force")
xlabel("Velocity")
ylim([-5,5])