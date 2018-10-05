[FileName,PathName] = uigetfile('*.jpg','Select the image file', 'MultiSelect', 'on');
file=strcat(PathName, FileName);
imagen=imread(file);
imagen=rgb2gray(imagen);

imshow(imagen);
[x,y]=getpts; 

x_inicial = int16(x(1));
y_inicial = int16(y(1));
y_abajo = int16(y(3));
x_derecha = int16(x(2));

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

figure
imshow(imagen)