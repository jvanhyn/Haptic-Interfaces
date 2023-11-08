
close all
clear
clc

N = 10000;

h = 0.001;
kwall = 1000;
kmass = 500;
bmass = 10;


xh = zeros(1,N);
vh = zeros(1,N);
a = zeros(1,N);
x = zeros(1,N);
v = zeros(1,N);

xh(1) = 0;
vh(1) = -0.1;
x(1) = 0;
v(1) = 0;


for i = 1:N
    a(i) = -kmass*x(i) - bmass*v(i);

    if(x(i)-xh(i)>0)
        a(i) = a(i) - kwall*(x(i)-xh(i));
    end

    
    v(i+1) = v(i) + h*a(i);
    x(i+1) = x(i) + h*v(i);
    vh(i+1) = vh(i) - h*a(i);
    xh(i+1) = xh(i) + h*vh(i);
end

close
figure(1)
hold on
plot(x)   
plot(xh,'o')
legend()