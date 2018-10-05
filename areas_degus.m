%Elegimos las imágenes
[FileName,PathName] = uigetfile('*.jpg','Select the image file', 'MultiSelect', 'on');

%Leímos las imágenes
file=strcat(PathName, FileName{1});
imagen=imread(file);
imagen=rgb2gray(imagen);
imagen=histeq(imagen); %ecualizar la imagen

%Elegimos un punto dentro de la pupila
imshow(imagen);
[x,y]=getpts; 
point=[int16(x), int16(y)];

%Ingresamos el threshold y los strikes
thresholdU= input('Enter color threshold:  ');
thresholdD= thresholdU;
thresholdR= thresholdU;
thresholdL= thresholdU;
initial_maxstrikes= input('Enter initial strike tolerance: ');
maxstrikes=initial_maxstrikes;
maxstrikes_int= input('Enter internal strike tolerance: ');
maxstrikes_ext= input('Enter external strike tolerance: ');

%Buscamos un punto medio horizontalmente y desplazado hacia abajo
%verticalmente como punto de inicio
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
plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'b'); 
plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'b');

%Cálculo de la elipse que delimita la zona interior y exterior 
ellipse_center = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),int16(VERTICAL_LINE(int16(VERTICAL_LENGTH/2),1))];
ellipse_x = HORIZONTAL_LENGTH/2;
ellipse_y = VERTICAL_LENGTH/2;
area_ellipse = pi*ellipse_x*ellipse_y;
elipse_prueba

%Calculamos el área total de la primera imagen
lineas
calculo_area

%Creamos el vector que contiene las áreas de cada imagen
AREAS=zeros(length(FileName),1);
AREAS_ELLIPSE=zeros(length(FileName),1);
AREAS_ELLIPSE_PRUEBA=zeros(length(FileName),1);
AREAS(1)=area_total;
AREAS_ELLIPSE(1)=area_ellipse;
AREAS_ELLIPSE_PRUEBA(1)=area_ellipse_prueba;

for j=2:length(FileName)
   %Leemos las siguientes imágenes
   figure
   file=strcat(PathName, FileName{j});
   imagen=imread(file);
   imagen=rgb2gray(imagen);
   imagen=histeq(imagen); %ecualizar la imagen

   %Buscamos un punto medio horizontalmente y desplazado hacia abjo
   %verticalmente como punto de inicio
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
   plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'b'); 
   plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'b');

   %Cálculo de la elipse que delimita la zona interior y exterior 
   ellipse_center = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),int16(VERTICAL_LINE(int16(VERTICAL_LENGTH/2),1))];
   ellipse_x = HORIZONTAL_LENGTH/2;
   ellipse_y = VERTICAL_LENGTH/2;
   area_ellipse = pi*ellipse_x*ellipse_y;
   elipse_prueba

   %Calculamos el área total de la primera imagen
   lineas
   calculo_area
   
   %Agregamos las demás áreas a los vectores AREAS
   AREAS(j)=area_total;
   AREAS_ELLIPSE(j)=area_ellipse;
   AREAS_ELLIPSE_PRUEBA(j)=area_ellipse_prueba;
end

%Graficamos las áreas
frames=1:length(FileName);
figure
plot(frames,AREAS);
figure
plot(frames,(AREAS/mean(AREAS))*100);
figure
plot(frames,AREAS_ELLIPSE);
figure
plot(frames,AREAS_ELLIPSE_PRUEBA);
