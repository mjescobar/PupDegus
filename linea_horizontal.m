%threshold= input('Enter color threshold:  ');
PUPRIGHT=[]; 
initial_strikes=0;
coordinate=0;

while initial_strikes<initial_maxstrikes
    EVALUATION=imagen(point(2), (point(1)+coordinate));  
    EVPOINT=[point(2), (point(1)+coordinate)];
    PUPRIGHT=[PUPRIGHT;EVPOINT]; 
    if EVALUATION>thresholdR
        initial_strikes=initial_strikes+1;
        coordinate=coordinate+1; 
    else
        initial_strikes=0;
        coordinate=coordinate+1;
    end
end

Redge=PUPRIGHT(1:(length(PUPRIGHT)-initial_maxstrikes),:);

PUPLEFT=[]; 
initial_strikes=0;
coordinate=0;
while initial_strikes<initial_maxstrikes
    EVALUATION=imagen(point(2), (point(1)-coordinate));  
    EVPOINT=[point(2), (point(1)-coordinate)];
    PUPLEFT=[PUPLEFT;EVPOINT]; 
    if EVALUATION>thresholdL
        initial_strikes=initial_strikes+1;
        coordinate=coordinate+1; 
    else
        initial_strikes=0;
        coordinate=coordinate+1;
    end
end

Ledge=PUPLEFT(1:(length(PUPLEFT)-initial_maxstrikes),:);
HORIZONTAL_LINE=[flipud(Ledge);Redge(2:end,:)];
HORIZONTAL_LENGTH=length(HORIZONTAL_LINE);
%imshow(imagen); hold on; plot(TOTLENGTH(:,2), TOTLENGTH(:,1),'w');