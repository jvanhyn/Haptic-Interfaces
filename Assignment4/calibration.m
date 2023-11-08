close
clear
clc
C = table2array(readtable('Book1.xlsx'));
C = max((C-888),0);
tmax = 60;

figure(1)
plot(C);


t = linspace(0,tmax,length(C));
theta = [ 0 10 20 30 40 50]';
counts = [888 2155 2565 2851 3535 4212]';

P = polyfit(counts,theta,1);

figure(2)
hold on
plot(counts,theta,'o',"LineWidth",2)
fplot(@(x) P(1)*x+P(2),"LineWidth",2)
ylabel("Degrees")
xlabel("Counts");
legend('Data','Fit')
ylim([-5 60])
xlim([0 4500])
grid on
hold off

cc = P(1)
bc = P(2)
