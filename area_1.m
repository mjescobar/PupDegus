%Elegimos las imágenes
[FileName,PathName] = uigetfile('*.jpg','Select the image file', 'MultiSelect', 'on');

%Leímos las imágenes
file=strcat(PathName, FileName);
imagen=imread(file);
imagen=rgb2gray(imagen);
imagen=histeq(imagen); %ecualizar la imagen

%Elegimos un punto dentro de la pupila
imshow(imagen);
[x,y]=getpts; 
point=[int16(x), int16(y)];

%Seleccionamos los límites superior, inferior, derecho e izquierdo de la
%pupila
%zoom = imagen(point(2)-100:point(2)+100,point(1)-100:point(1)+100);
%imshow(zoom)
%display('Seleccione 4 puntos límites de las pupilas, en el siguiente orden: arriba, abajo, derecha, izquierda');
%[thresholdX, thresholdY] = getpts;
%threshold = [int16(thresholdY), int16(thresholdX)];
%thresholdU= imagen(threshold(1,1),threshold(1,2));
%thresholdD= imagen(threshold(2,1),threshold(2,2));
%thresholdR= imagen(threshold(3,1),threshold(3,2));
%thresholdL= imagen(threshold(4,1), threshold(4,2));
thresholdU= input('Enter color threshold:  ');
thresholdD= thresholdU;
thresholdR= thresholdU;
thresholdL= thresholdU;
initial_maxstrikes= input('Enter initial strike tolerance: ');
maxstrikes=initial_maxstrikes;
maxstrikes_int= input('Enter internal strike tolerance: ');
maxstrikes_ext= input('Enter external strike tolerance: ');

%Calculamos la primera linea horizontal para obtener un punto a la mitad
%horizontal de la pupila
imshow(imagen)
linea_horizontal
linea_vertical
hold on;
plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'w'); 
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'w');
point = [point(1),int16(VERTICAL_LINE(int16(0.7*VERTICAL_LENGTH),1))];
linea_horizontal
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'r');
point = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),point(2)];
linea_horizontal
linea_vertical

%Cálculo de la elipse que delimita la zona interior y exterior 
ellipse_center = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),int16(VERTICAL_LINE(int16(VERTICAL_LENGTH/2),1))];
ellipse_x = HORIZONTAL_LENGTH/2;
ellipse_y = VERTICAL_LENGTH/2;
area_ellipse = pi*ellipse_x*ellipse_y;
elipse_prueba

plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'b'); 
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'b');
lineas
calculo_area