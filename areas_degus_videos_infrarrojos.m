%------------Cargar una pelicula mp4----------------------
[FileName,PathName] = uigetfile('*.mp4','Select the image file');
file=strcat(PathName, FileName);
vid=VideoReader(file);
%--------------------------------------------------------
%-------Convierte los frames en *jpg--------------------------------------------------
%los *jpg los pone en una subcarpeta
filefram=strcat(PathName,FileName(1:end-4),'_frames');
%crea la carpeta y si ya existe  da señal de warning
mkdir(filefram);

%------y pone los jpg dentro numerados de 1 al numFrames------------------------------ 
fileframes=strcat(filefram, '\');
%numFrames = vid.NumberOfFrames;
n = uint16(input('Ingrese el rango de frames a analizar: ')); % ???????? n=10 provisional demo por n=numFrames
for i = 1:n% 
  frames = read(vid,i);%lee del video
  imwrite(frames,[fileframes, int2str(i), '.jpg']);
end 

clear all;

%Elegimos las imágenes
[FileName,PathName] = uigetfile('*.jpg','Select the image file', 'MultiSelect', 'on');

%Leímos las imágenes
file=strcat(PathName, FileName{1});
imagen=imread(file);
imagen=rgb2gray(imagen);
%imagen=histeq(imagen); %ecualizar la imagen
imshow(imagen)
[x,y]=getpts; 

x_inicial = int16(x(1));
y_inicial = int16(y(1));
y_abajo = int16(y(3));
x_derecha = int16(x(2));

check=0;

%Elegimos un punto dentro de la pupila
i = y_inicial;
j = x_inicial;


while (y_inicial <= i) && (i <= y_abajo)
    j = x_inicial;
    while (x_inicial <= j) && (j <= x_derecha)
        if imagen(i,j) >= 90
            imagen(i,j) = 0;
        end
        j = j + 1;
    end
    i = i + 1;
end

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
title(sprintf(cell2mat(FileName(1))))
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
   file=strcat(PathName, FileName{j});
   imagen=imread(file);
   imagen=rgb2gray(imagen);
   %imagen=histeq(imagen); %ecualizar la imagen
   i = y_inicial;
   c = x_inicial;


   while (y_inicial <= i) && (i <= y_abajo)
       c = x_inicial;
       while (x_inicial <= c) && (c <= x_derecha)
           if imagen(i,c) >= 90
               imagen(i,c) = 0;
           end
           c = c + 1;
       end
       i = i + 1;
   end
 
   %Buscamos un punto medio horizontalmente y desplazado hacia abjo
   %verticalmente como punto de inicio
   check = randi(300);
   if check==15
       figure;
       imshow(imagen);
       title(sprintf(cell2mat(FileName(j))))
       hold on;
   end
   linea_horizontal
   linea_vertical
   if check==15
       plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'w'); 
       plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'w');
   end   
   point = [point(1),int16(VERTICAL_LINE(int16(0.7*VERTICAL_LENGTH),1))];
   linea_horizontal
   if check==15
       plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'r');
   end
   point = [int16(HORIZONTAL_LINE(int16(HORIZONTAL_LENGTH/2),2)),point(2)];
   linea_horizontal
   linea_vertical
   if check==15
       plot(VERTICAL_LINE(:,2), VERTICAL_LINE(:,1),'b'); 
       plot(HORIZONTAL_LINE(:,2), HORIZONTAL_LINE(:,1),'b');
   end

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
title('Áreas en [px^2]')
xlabel('Frames')
ylabel('Área [px^2]')
saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas.png')
figure
plot(frames,(AREAS/mean(AREAS(1:15)))*100);
title('Áreas relativas')
xlabel('Frames')
ylabel('Área relativa [%]')
axis([0 frames(end) 0 120])
saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_relativas.png')
figure
plot(frames,AREAS_ELLIPSE);
title('Áreas elipses en [px^2]')
xlabel('Frames')
ylabel('Área elipse [px^2]')
saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_elipses.png')
figure
plot(frames,(AREAS_ELLIPSE/mean(AREAS_ELLIPSE(1:15)))*100);
title('Áreas elipses relativas')
xlabel('Frames')
ylabel('Área elipse relativa [%]')
axis([0 frames(end) 0 120])
saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_elipses_relativas.png')
