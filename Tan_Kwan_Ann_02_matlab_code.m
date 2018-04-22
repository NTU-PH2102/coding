% https://www.youtube.com/watch?v=wtbpifZUt_g
%radius = 5;
%degree = [1:360];
%figure;
axis auto;
hold on;
view(45,45); %we want to have a good view --> view(azimuth,elevation)

for i=1:1800 %i is the time, which is fine if you change it to 't'
 plot3(4*cosd(0.25*(1:i))+0.3*cosd(33*(1:i)), 4*sind(0.25*(1:i))+0.3*sind(33*(1:i)), 3*cosd(8*(1:i)));
 drawnow
end