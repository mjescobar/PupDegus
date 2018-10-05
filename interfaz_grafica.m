function varargout = interfaz_grafica(varargin)
% INTERFAZ_GRAFICA MATLAB code for interfaz_grafica.fig
%      INTERFAZ_GRAFICA, by itself, creates a new INTERFAZ_GRAFICA or raises the existing
%      singleton*.
%
%      H = INTERFAZ_GRAFICA returns the handle to a new INTERFAZ_GRAFICA or the handle to
%      the existing singleton*.
%
%      INTERFAZ_GRAFICA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFAZ_GRAFICA.M with the given input arguments.
%
%      INTERFAZ_GRAFICA('Property','Value',...) creates a new INTERFAZ_GRAFICA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interfaz_grafica_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interfaz_grafica_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interfaz_grafica

% Last Modified by GUIDE v2.5 04-Jun-2018 19:39:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interfaz_grafica_OpeningFcn, ...
                   'gui_OutputFcn',  @interfaz_grafica_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interfaz_grafica is made visible.
function interfaz_grafica_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interfaz_grafica (see VARARGIN)
handles.nframes = 100; %N° de frames por default
handles.check = 0; %Para graficar imágenes aleatorias
handles.thresholdU = 30;
handles.thresholdD = 30;
handles.thresholdL = 30;
handles.thresholdR = 30;
handles.maxstrikes_internal = 30;
handles.maxstrikes_external = 1;
handles.initial_maxstrikes = 7;

% Choose default command line output for interfaz_grafica
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interfaz_grafica wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interfaz_grafica_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in sel_vid.
function sel_vid_Callback(hObject, eventdata, handles)
% hObject    handle to sel_vid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%------------Cargamos el video .mp4----------------------
[FileName,PathName] = uigetfile('*.mp4','Select the image file'); %Seleccionamos el video
file=strcat(PathName, FileName); %String con nombre del video (+ path)
vid=VideoReader(file); %Datos del video

%------------Convertimos los frames en .jpg----------------
%(Los .jpg los ponemos en una subcarpeta)
filefram=strcat(PathName,FileName(1:end-4),'_frames'); %String con nombre carpeta (+ path)
mkdir(filefram); %Creamos la carpeta y si ya existe da señal de warning
fileframes=strcat(filefram, '\'); %String con nombre carpeta (+ path) + '\'
%numFrames = vid.NumberOfFrames; %Obtiene el total de frames del video
n = handles.nframes; %Default 100 frames
for i = 1:n
  frames = read(vid,i); %Lee los frames del video
  imwrite(frames,[fileframes, int2str(i), '.jpg']);
end 

%Leemos las imágenes
file=[fileframes, '1', '.jpg']; %Nombre de la primera imagen
imagen=imread(file); %Leemos la primera imagen
imagen=rgb2gray(imagen); %Convertimos a escala de grises
imagen=histeq(imagen); %Ecualizamos la imagen

%Elegimos un punto dentro de la pupila
imshow(imagen);
uiwait(msgbox('Haga click en un punto dentro de la pupila y luego aprete la tecla Enter.','Ayuda','help'));
[x,y]=getpts; 
point=[int16(x), int16(y)];

%Traemos los valores de los threshold y strikes desde el usuario
check = handles.check;
thresholdU= handles.thresholdU;
thresholdD= handles.thresholdD;
thresholdR= handles.thresholdR;
thresholdL= handles.thresholdL;
initial_maxstrikes= handles.initial_maxstrikes;
maxstrikes=initial_maxstrikes;
maxstrikes_int= handles.maxstrikes_internal;
maxstrikes_ext= handles.maxstrikes_external;

%Buscamos un punto medio horizontalmente y desplazado hacia abajo
%verticalmente como punto de inicio
imshow(imagen)
title('1.jpg')
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
AREAS=zeros(n,1);
AREAS_ELLIPSE=zeros(n,1);
AREAS_ELLIPSE_PRUEBA=zeros(n,1);
AREAS(1)=area_total;
AREAS_ELLIPSE(1)=area_ellipse;
AREAS_ELLIPSE_PRUEBA(1)=area_ellipse_prueba;
n_plot = 1;

for j=2:n
   %Leemos las siguientes imágenes
   file=[fileframes, int2str(j), '.jpg'];
   imagen=imread(file);
   imagen=rgb2gray(imagen);
   imagen=histeq(imagen); %ecualizar la imagen

   %Buscamos un punto medio horizontalmente y desplazado hacia abjo
   %verticalmente como punto de inicio
   check = randi(20);
   if check==15
       subplot(2,1,n_plot)
       n_plot = n_plot + 1;
       if n_plot > 2
           n_plot = 2;
       end
       imshow(imagen);
       title([int2str(j), '.jpg'])
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

handles.fileframes = fileframes;
handles.areas = AREAS;
handles.areas_ellipse = AREAS_ELLIPSE;
guidata(hObject, handles);


function nframes_Callback(hObject, eventdata, handles)
% hObject    handle to n_de_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_de_frames as text
%        str2double(get(hObject,'String')) returns contents of n_de_frames as a double
n_frames = int16(str2double(get(hObject,'String')));
handles.nframes = n_frames;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function n_de_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_de_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function nframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdD_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of down as text
%        str2double(get(hObject,'String')) returns contents of down as a double
thresholdD = int16(str2double(get(hObject,'String')));
handles.thresholdD = thresholdD;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdU_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of up as text
%        str2double(get(hObject,'String')) returns contents of up as a double
thresholdU = int16(str2double(get(hObject,'String')));
handles.thresholdU = thresholdU;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdR_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right as text
%        str2double(get(hObject,'String')) returns contents of right as a double
thresholdR = int16(str2double(get(hObject,'String')));
handles.thresholdR = thresholdR;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdL_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of left as text
%        str2double(get(hObject,'String')) returns contents of left as a double
thresholdL = int16(str2double(get(hObject,'String')));
handles.thresholdL = thresholdL;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_maxstrikes_Callback(hObject, eventdata, handles)
% hObject    handle to initial_maxstrikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_maxstrikes as text
%        str2double(get(hObject,'String')) returns contents of initial_maxstrikes as a double
initial_maxstrikes = int16(str2double(get(hObject,'String')));
handles.initial_maxstrikes = initial_maxstrikes;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function initial_maxstrikes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_maxstrikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxstrikes_internal_Callback(hObject, eventdata, handles)
% hObject    handle to maxstrikes_internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxstrikes_internal as text
%        str2double(get(hObject,'String')) returns contents of maxstrikes_internal as a double
maxstrikes_internal = int16(str2double(get(hObject,'String')));
handles.maxstrikes_internal = maxstrikes_internal;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function maxstrikes_internal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxstrikes_internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxstrikes_external_Callback(hObject, eventdata, handles)
% hObject    handle to maxstrikes_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxstrikes_external as text
%        str2double(get(hObject,'String')) returns contents of maxstrikes_external as a double
maxstrikes_external = int16(str2double(get(hObject,'String')));
handles.maxstrikes_external = maxstrikes_external;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function maxstrikes_external_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxstrikes_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in graficos_areas.
function graficos_areas_Callback(hObject, eventdata, handles)
% hObject    handle to graficos_areas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Graficamos las áreas
fileframes = handles.fileframes;
AREAS = handles.areas;
AREAS_ELLIPSE = handles.areas_ellipse;
frames=1:handles.nframes;
subplot(2,2,1)
plot(frames,AREAS);
title('Áreas en [px^2]')
xlabel('Frames')
ylabel('Área [px^2]')
%saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas.png')
saveas(gcf,[fileframes,'areas.png'])
subplot(2,2,2)
plot(frames,(AREAS/mean(AREAS(1:15)))*100);
title('Áreas relativas')
xlabel('Frames')
ylabel('Área relativa [%]')
axis([0 frames(end) 0 120])
%saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_relativas.png')
saveas(gcf,[fileframes,'areas_relativas.png'])
subplot(2,2,3)
plot(frames,AREAS_ELLIPSE);
title('Áreas elipses en [px^2]')
xlabel('Frames')
ylabel('Área elipse [px^2]')
%saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_elipses.png')
saveas(gcf,[fileframes,'areas_elipses.png'])
subplot(2,2,4)
plot(frames,(AREAS_ELLIPSE/mean(AREAS_ELLIPSE(1:15)))*100);
title('Áreas elipses relativas')
xlabel('Frames')
ylabel('Área elipse relativa [%]')
axis([0 frames(end) 0 120])
%saveas(gcf,'D:\Práctica 2018-1\BFFE_505_contra_Ejemplo arturo\areas_elipses_relativas.png')
saveas(gcf,[fileframes,'areas_elipses_relativas.png'])
