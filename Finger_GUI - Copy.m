function varargout = Finger_GUI(varargin)
% FINGER_GUI MATLAB code for Finger_GUI.fig
%      FINGER_GUI, by itself, creates a new FINGER_GUI or raises the existing
%      singleton*.
%
%      H = FINGER_GUI returns the handle to a new FINGER_GUI or the handle to
%      the existing singleton*.
%
%      FINGER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINGER_GUI.M with the given input arguments.
%
%      FINGER_GUI('Property','Value',...) creates a new FINGER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Finger_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Finger_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Finger_GUI

% Last Modified by GUIDE v2.5 30-Mar-2017 15:39:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Finger_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Finger_GUI_OutputFcn, ...
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


% --- Executes just before Finger_GUI is made visible.
function Finger_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Finger_GUI (see VARARGIN)

% Choose default command line output for Finger_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Finger_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Finger_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick an MRI Image');
if isequal(FileName,0)||isequal(PathName,0)
    warndlg('User Press Cancel');
else
    a = imread([PathName,FileName]);
    a = imresize(a,[200,200]);
   % input =imresize(a,[512 512]); 
  
  axes(handles.axes1)
  imshow(a);title('Finger vein Image');
  
  
   I = double(a);
%figure, imshow(uint8(I));
% f = double(imread(file));
%f = double(imread(Path));
a = imresize(a,[256 256]);

%pixval on 

sigmar = 40;             %sigmar: width of range Gaussian
eps    = 1e-3;           %eps: kernel accuracy

% compute Gaussian bilateral filter
sigmas = 3;              %sigmas: width of spatial Gaussian
[g,Ng] = GPA(I, sigmar, sigmas, eps, 'Gauss');

%Display the input and filtered image
colormap gray,
% figure(1),
% subplot(2,1,1), imshow(uint8(a)),
% title('Input', 'FontSize', 10), axis('image', 'off');
% subplot(2,1,2), imshow(uint8(g)),
% title('Gaussian Bilateral Filter','FontSize', 10),axis('image', 'off');


a1 = a(52:186,72:177);
%imshow(a1);
[r c] = size(a1);
a2 = imresize(a1,1/4);
%imshow(a2);

a2 = imresize(a2,[r c]);
%imshow(a2);

a3 = histeq(a2);


a4 = imresize(a3,1/3);
%imshow(a4);
[ll lh hl hh] =dwt2(a4,'haar');
feature1 = mean(mean(ll));
a5 = im2bw(a4);


 figure(2),
 subplot(2,1,1);
 imshow(a3);
 title('Histogram equalization');
 subplot(2,1,2)
 imshow(a5);
 title('Segmented image');


[row, col] = size(a);
mse = sum(sum((a(1,1) - g(1,1)).^2)) / (row * col);
psnr = 10 * log10(255 * 255 / mse);
disp('Mean Square Error ');
disp(mse);
disp('Peak Signal to Noise Ratio');
disp(psnr);


%ENHANCEMENT
%DILATION
se=strel('disk',7);
idilate = imdilate(I,se);

%HOG FEATURES
% [featureVector, hogVisualization] = extractHOGFeatures(I,[16 16]);


m=mean2(I);%mean
sd=std2(I);%std dev
en=entropy(I);%entropy
v=var(I(:));%variance
skw=skewness(I(:));%skewness
k=kurtosis(I(:));
feat=[m sd en  v skw k ];

disp('<--------------------Extracted Features------------------------>');
disp('Mean=');disp(m);
disp('Standard Deviation=');disp(sd);
disp('Entropy');disp(en);
disp('Variance');disp(v);
disp('Skewness');disp(skw);
disp('Kurtosis');disp(k);
disp('<-------------------------------------------------------------->');

%  Main function for using GSA algorithm.
N=5; 
 max_it=1000; 
 ElitistCheck=1; Rpower=1;
 min_flag=1; % 1: minimization, 0: maximization

 F_index=1
 [Fbest,Lbest,BestChart,MeanChart]=GSA(F_index,N,max_it,ElitistCheck,min_flag,Rpower);Fbest,
%  figure;
%  semilogy(BestChart,'--k');
% 
%  title(['\fontsize{12}\bf F',num2str(F_index)]);
%  xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Best-so-far');
%  legend('\fontsize{10}\bf GSA',1);


load Trainset.mat
 xdata = meas;
 group = label;

 svmStruct1 = svmtrain(xdata,group,'kernel_function', 'linear');

 Result = svmclassify(svmStruct1,feat,'showplot',false)
  helpdlg(Result);
  
  s=serial('COM3', 'BaudRate', 9600);
 
  
  if strcmp(Result, 'Authenticated');
  fopen(s);
  pause(5);
  disp('B');
  fwrite(s,'B');
  pause(1);
  fclose(s);
  end
  if strcmp(Result, 'not Authenticated');
  fopen(s);
  pause(5);
  disp('A');
  fwrite(s,'A');
  pause(1);
  fclose(s);
  end
  
  
 % helpdlg(' Multispectral Image is Selected ');

 % set(handles.edit1,'string',Filename);
 % set(handles.edit2,'string',Pathname);
  handles.ImgData = a;
%  handles.FileName = FileName;

  guidata(hObject,handles);
end