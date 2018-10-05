area_total = 0;
for i = 1:(length(POINTS_EDGE)-1)
    a = POINTS_EDGE(i,2);
    b = POINTS_EDGE(i,4);
    c = POINTS_EDGE(i+1,2);
    d = POINTS_EDGE(i+1,4);
    area_total = area_total + (min(b,d)-max(a,c))*1;
    area_total = area_total + 0.5*(abs(a-c)+abs(b-d));
end
