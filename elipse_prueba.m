xCenter = double(ellipse_center(1));
yCenter = double(ellipse_center(2));
xRadius = 1.1*double(ellipse_x); %1.1 o 1.2 he ahi el dilema
xRadius_2 = 1.4*double(ellipse_x);
yRadius = 1.12*double(ellipse_y);
area_ellipse_prueba = pi*xRadius*yRadius;
if check==15
    hold on
    theta = 0 : 0.01 : 2*pi;
    x = xRadius * cos(theta) + xCenter;
    y = yRadius * sin(theta) + yCenter;
    plot(x, y, 'LineWidth', 2);
    grid on;
else
end