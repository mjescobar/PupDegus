POINTS_EDGE = [HORIZONTAL_LINE(1,:), HORIZONTAL_LINE(end,:)];
initial_point = point;
for u=1:1:(initial_point(2)-VERTICAL_LINE(1,1))
    point = [initial_point(1), (initial_point(2)-u)];
    linea_horizontal_3
    POINTS_EDGE = [HORIZONTAL_LINE(1,:), HORIZONTAL_LINE(end,:); POINTS_EDGE];
    if check==15
        plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'y');
    end
end
point = initial_point;
for d=1:1:(VERTICAL_LINE(end,1)-initial_point(2))
    point = [initial_point(1), (initial_point(2)+d)];
    linea_horizontal_3
    POINTS_EDGE = [POINTS_EDGE;HORIZONTAL_LINE(1,:), HORIZONTAL_LINE(end,:)];
    if check==15
        plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'y');
    end
end

    
    