%threshold= input('Enter color threshold:  ');
PUPRIGHT=[]; 
strikes_int=0;
strikes_ext=0;
coordinate=0;
EVPOINT = [point(2),point(1)];

while strikes_int<maxstrikes_int && strikes_ext<maxstrikes_ext && ((((double(EVPOINT(2))-double(xCenter))^2)/double(xRadius_2)^2)+(((double(EVPOINT(1))-double(yCenter))^2)/double(yRadius)^2))<=1
    EVALUATION=imagen(point(2), (point(1)+coordinate));  
    EVPOINT=[point(2), (point(1)+coordinate)];
    PUPRIGHT=[PUPRIGHT;EVPOINT]; 
    if EVALUATION>thresholdR
        if ((((double(EVPOINT(2))-double(xCenter))^2)/double(xRadius)^2)+(((double(EVPOINT(1))-double(yCenter))^2)/double(yRadius)^2))<=1
            strikes_int=strikes_int+1;
        else
            strikes_ext=strikes_ext+1;
        end
        coordinate=coordinate+1; 
    else
        strikes_int=0;
        strikes_ext=0;
        coordinate=coordinate+1;
    end
end

Redge=PUPRIGHT(1:(length(PUPRIGHT)-maxstrikes_ext),:);

PUPLEFT=[]; 
strikes_int=0;
strikes_ext=0;
coordinate=0;
EVPOINT = [point(2),point(1)];

while strikes_int<maxstrikes_int && strikes_ext<maxstrikes_ext && ((((double(EVPOINT(2))-double(xCenter))^2)/double(xRadius_2)^2)+(((double(EVPOINT(1))-double(yCenter))^2)/double(yRadius)^2))<=1
    EVALUATION=imagen(point(2), (point(1)-coordinate));  
    EVPOINT=[point(2), (point(1)-coordinate)];
    PUPLEFT=[PUPLEFT;EVPOINT]; 
    if EVALUATION>thresholdL
        if ((((double(EVPOINT(2))-double(xCenter))^2)/double(xRadius)^2)+(((double(EVPOINT(1))-double(yCenter))^2)/double(yRadius)^2))<=1 %(limite_horizontal(1)<=EVPOINT(2)) && (EVPOINT(2)<=limite_horizontal(2))
            strikes_int=strikes_int+1;
        else
            strikes_ext=strikes_ext+1;
        end
        coordinate=coordinate+1; 
    else
        strikes_int=0;
        strikes_ext=0;
        coordinate=coordinate+1;
    end
end

Ledge=PUPLEFT(1:(length(PUPLEFT)-maxstrikes_ext),:);
HORIZONTAL_LINE=[flipud(Ledge);Redge(2:end,:)];
HORIZONTAL_LENGTH=length(HORIZONTAL_LINE);
%imshow(imagen); hold on; plot(TOTLENGTH(:,2), TOTLENGTH(:,1),'w');