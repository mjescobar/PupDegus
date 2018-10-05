%threshold= input('Enter color threshold:  ');
PUPDOWN=[]; 
strikes=0;
coordinate=0;


while strikes<maxstrikes
    EVALUATION=imagen((point(2)+ coordinate), point(1));  
    EVPOINT=[(point(2)+coordinate), point(1)];
    PUPDOWN=[PUPDOWN;EVPOINT]; 
    if EVALUATION>thresholdD
        strikes=strikes+1;
        coordinate=coordinate+1; 
    else
        strikes=0;
        coordinate=coordinate+1;
    end
end

Infedge=PUPDOWN(1:(length(PUPDOWN)-maxstrikes),:);

PUPUP=[]; 
strikes=0;
coordinate=0;
while strikes<maxstrikes
    EVALUATION=imagen((point(2)- coordinate), point(1));  
    EVPOINT=[(point(2)-coordinate), point(1)];
    PUPUP=[PUPUP;EVPOINT]; 
    if EVALUATION>thresholdU
        strikes=strikes+1;
        coordinate=coordinate+1; 
    else
        strikes=0;
        coordinate=coordinate+1;
    end
end

Supedge=PUPUP(1:(length(PUPUP)-maxstrikes),:);
VERTICAL_LINE=[flipud(Supedge);Infedge(2:end,:)];
VERTICAL_LENGTH=length(VERTICAL_LINE);
%imshow(imagen); hold on; plot(VERTOTLENGTH(:,2), VERTOTLENGTH(:,1),'w');