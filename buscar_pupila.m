%Elegimos las imágenes
[FileName,PathName] = uigetfile('*.jpg','Select the image file', 'MultiSelect', 'on');

%Leímos las imágenes
file=strcat(PathName, FileName);
imagen=imread(file);
imagen=rgb2gray(imagen);
imshow(imagen)

[centro,radio]=imfindcircles(f,[5,10]);
viscircles(centro, radio,'EdgeColor','r');
centro = int16(centro);
radio = int16(radio);

threshold= input('Enter color threshold:  ');

centro_45 = [(centro(2)-30), (centro(1)+30)];
centro_315 = [(centro(2)+30), (centro(1)+30)];

strikes_45 = 0;
strikes_315 = 0;

for k=1:10
    strikes_45 = strikes_45 + (imagen((centro_45(1)+k),centro_45(2))>threshold) + (imagen((centro_45(1)-k),centro_45(2))>threshold) + (imagen(centro_45(1),(centro_45(2)+k))>threshold) + (imagen(centro_45(1),(centro_45(2)-k))>threshold);
    strikes_315 = strikes_315 + (imagen((centro_315(1)+k),centro_315(2))>threshold) + (imagen((centro_315(1)-k),centro_315(2))>threshold) + (imagen(centro_315(1),(centro_315(2)+k))>threshold) + (imagen(centro_315(1),(centro_315(2)-k))>threshold);
end

if strikes_315 < strikes_45
    point = fliplr(centro_315);
else
    point = fliplr(centro_45);
end
    


thresholdU= threshold;
thresholdD= thresholdU;
thresholdR= thresholdU;
thresholdL= thresholdU;
maxstrikes= input('Enter strike tolerance: ');

%Calculamos la primera linea horizontal para obtener un punto a la mitad
%horizontal de la pupila
linea_horizontal
linea_vertical
hold on;
plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'w'); 
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'w');
point = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),point(2)];
linea_horizontal
linea_vertical
plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'b'); 
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'b');
