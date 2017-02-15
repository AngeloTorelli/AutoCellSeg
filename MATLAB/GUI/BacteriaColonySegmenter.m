function varargout = BacteriaColonySegmenter(varargin)
% BACTERIACOLONYSEGMENTER MATLAB code for BacteriaColonySegmenter.fig
%      BACTERIACOLONYSEGMENTER, by itself, creates a new BACTERIACOLONYSEGMENTER or raises the existing
%      singleton*.
%
%      H = BACTERIACOLONYSEGMENTER returns the handle to a new BACTERIACOLONYSEGMENTER or the handle to
%      the existing singleton*.
%
%      BACTERIACOLONYSEGMENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACTERIACOLONYSEGMENTER.M with the given input arguments.
%
%      BACTERIACOLONYSEGMENTER('Property','Value',...) creates a new BACTERIACOLONYSEGMENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BacteriaColonySegmenter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BacteriaColonySegmenter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BacteriaColonySegmenter

% Last Modified by GUIDE v2.5 13-Feb-2017 15:06:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BacteriaColonySegmenter_OpeningFcn, ...
                   'gui_OutputFcn',  @BacteriaColonySegmenter_OutputFcn, ...
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

% --- Executes just before BacteriaColonySegmenter is made visible.
function BacteriaColonySegmenter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BacteriaColonySegmenter (see VARARGIN)

% Choose default command line output for BacteriaColonySegmenter
%set(handles.figure1, 'units','norm','Position',[0 0 1 1]);
handles.maxPics = 20;
handles.output = hObject;
handles.pars.vis         = false;

% Parameters
handles.pars.bw          = 2000;
handles.pars.sImBorder   = 10;
handles.pars.wsvector    = 0.1:0.01:0.25;
handles.pars.otsuvector  = 0.3: 0.1: 0.97;
handles.pars.dishextract = true;
handles.pars.adapthist   = false;
handles.pars.gausfltsize = [5 5];
handles.pars.chnnlselect = 2;
handles.pars.avcellecc   = 0.45;
% Control and test names
handles.control = 'control';
handles.test    = 'light';
handles.nfeat    = 4;

set(handles.addImages,'tooltipString','<html>Add any number of images:<br><i><b>Click </b>to select an individual image.<br><i><b>Shift-click </b>to batch select from selected picture to clicked one.<br><i><b>Ctrl-click </b>to select multiple individual pictures.<br><i><b>Shift-ctrl-click </b>to select multiple batches of pictures.');
set(handles.addDir,'tooltipString','<html>Add all the images of one folder.');


set(handles.radiobutton1,'tooltipString','<html>The process of fully automated segmentation runs over all the selected images.<br><i>The only requirement is the selection of a small and big bacteria colony.<br><i>The type of selection depends on the choice of the a priori selection method.');
set(handles.radiobutton2,'tooltipString','<html>The process of partially automated segmentation runs over each individual image.<br><i>For each individual image the user should select a small and big bacteria colony for optimal segmentation.<br><i>The type of selection depends on the choice of the a priori selection method.');
set(handles.manualradiobutton,'tooltipString','<html>The process of manual segmentation runs over each individual image and consist of selecting each individual bacteria colony.<br><i>The type of selection depends on the choice of the a priori selection method.');

set(handles.radiobutton5,'tooltipString','<html>The selection happens using the fast marching algorithm.<br><i><b>Single click</b> to mark the desired bacteria colony.<br><i><b>Double click</b> to mark the last desired bacteria colonies and start the initial segmentation.<br><i><b>Press Enter</b> to start the initial segmentation.');
set(handles.radiobutton7,'tooltipString','<html>The selection is done by creating circles manually.<br><i><b>Click with drag</b> creates a circle.<br><i><b>Double left click on the circle</b> confirmes the shape of the circle.');
set(handles.radiobutton6,'tooltipString','<html>The selection is done by drawing the outline of a bacteria colony manually.<br><i><b>Click with drag</b> starts the drawing until <b>releasing the mouse key</b>. <br><i><b>Double click</b> on the shape created applies the shape.');

set(handles.runButton,'tooltipString','<html>The run button activates the process of choice when the requirements are satisfied.<br><i>To run fully automated please select at least one bacteria colony of any picture.<br><i>Preferably select the smallest and biggest bacteria colony for best results.');
set(handles.runButton,'tooltipString','<html>The run button activates the process of choice when the requirements are satisfied.');
set(handles.showresultsbutton,'tooltipString','<html>The show results button initiates the generation of the results after a segmentation process has run successfully.');
set(handles.showresultsbutton,'tooltipString','<html>The show results button initiates the generation of the results.');
set(handles.saveButton,'tooltipString','<html>The save results button saves all the results after a segmentation process has run successfully. <br><i> The results consist of a text file containing the name of each image with the accordingly colony count, mean area, mean radius and mean eccentricity.<br><i>It also creates a folder named results containing the masks for each segmented image and the same mask overlayed with the original pictures.<br><i>If the show results button was activated then all the plots created in the process will be saved in the results folder as well.');
set(handles.resetButton,'tooltipString','<html>The reset button sets the program to a clean state again.');

% jButton= findjobj(handles.runButton);
% set(jButton,'Enabled',false);
% set(jButton,'ToolTipText','<html>The run button activates the process of choice when the requirements are satisfied.<br><i>To run fully automated please select at least one bacteria colony of any picture.<br><i>Preferably select the smallest and biggest bacteria colony for best results.');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BacteriaColonySegmenter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BacteriaColonySegmenter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in addImages.
function addImages_Callback(hObject, eventdata, handles)
% hObject    handle to addImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.addImages,'Value', 0);
    if ismac
        [filename, handles.fName] = uigetfile( ...
        {'*.JPG;*.jpg;*.PNG;*.png;*.TIF;*.tif;*.BMP;*.bmp',...
         'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
         'MultiSelect', 'on');
    elseif isunix
        [filename, handles.fName] = uigetfile( ...
        {'*.JPG;*.jpg;*.PNG;*.png;*.TIF;*.tif;*.BMP;*.bmp',...
         'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
         'MultiSelect', 'on');
    elseif ispc
        [filename, handles.fName] = uigetfile( ...
        {'*.jpg;*.png;*.tif;*.bmp',...
         'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
         'MultiSelect', 'on');
    else
        disp('Platform not supported')
    end
    if isequal(filename,0)
       disp('User selected Cancel')
    else
        handles = resetGUI(hObject, eventdata, handles);        
        if iscellstr(filename) == 0
            filename = cellstr(filename);
        end
        handles.data = cell2struct(filename, 'name', 1);
        handles.ctrlen = 0;
        handles.lgtlen = 0;
        for i = 1:length(filename)            
            handles.inds{i} = strfind(filename{i}, ' ');
            handles.pars.im_name{i} = filename{i};
            matches = strfind(filename{i}, handles.control);
            if ~isempty(matches)
                handles.ctrlen = handles.ctrlen +1;
                handles.strarray{i} = filename{i}(matches(1):matches(1)+length(handles.control)-1);
            end
            matches = strfind(filename{i}, handles.test);
            if ~isempty(matches)
                handles.lgtlen = handles.lgtlen +1;
                handles.strarray{i} = filename{i}(matches(1):matches(1)+length(handles.test)-1);
            end
        end
        handles.featmat  = zeros(length(handles.data), handles.nfeat);
        handles.fullmat  = [];
        handles = visualizeData(hObject, eventdata, handles);

        processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);
        
        set(handles.resetButton,'Enable','on')    
        guidata(hObject, handles)
    end    
    guidata(hObject, handles)

% --- Executes on button press in addDir.
function addDir_Callback(hObject, eventdata, handles)
% hObject    handle to addDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.addDir,'Value', 0);
    handles.fName = uigetdir();
    if isequal(handles.fName,0)
       disp('User selected Cancel')
    else
        handles = resetGUI(hObject, eventdata, handles);
        % Specifiying image type and reading directory
        if ismac
            disp('BUUUH')
        elseif isunix
            handles.imgtypes = ['JPG'; 'jpg'; 'PNG'; 'png'; 'TIF'; 'tif'; 'BMP'; 'bmp'];
        elseif ispc
            handles.imgtypes = ['jpg';'png';'tif';'bmp'];
        else
            disp('Platform not supported')
        end

        data     = [];
        
        if ~isdeployed
            for di = 1 : size(handles.imgtypes, 1)
                data     = [data; dir(['*.' handles.imgtypes(di,:)])]; %#ok<AGROW>
            end
        else
            for di = 1 : size(handles.imgtypes, 1)
                data     = [data; dir([handles.fName '\*.' handles.imgtypes(di,:)])]; %#ok<AGROW>
            end
        end
        
        handles.ctrlen = 0;
        handles.lgtlen = 0;
        for i = 1:length(data)            
            handles.inds{i} = strfind(data(i).name, ' ');
            handles.pars.im_name{i} = data(i).name;
            matches = strfind(data(i).name, handles.control);
            if ~isempty(matches)
                handles.ctrlen = handles.ctrlen +1;
                handles.strarray{i} = data(i).name(matches(1):matches(1)+length(handles.control)-1);
            end
            matches = strfind(data(i).name, handles.test);
            if ~isempty(matches)
                handles.lgtlen = handles.lgtlen +1;
                handles.strarray{i} = data(i).name(matches(1):matches(1)+length(handles.test)-1);
            end
        end
        handles.cntrlf   = zeros(handles.ctrlen,1);
        handles.testf    = zeros(handles.lgtlen,1);
        handles.featmat  = zeros(length(data), handles.nfeat);
        handles.fullmat  = [];
        handles.data = data;
        handles = visualizeData(hObject, eventdata, handles);
        processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);
        set(handles.resetButton,'Enable','on')
        guidata(hObject, handles)
    end    
    guidata(hObject, handles)

    
% --- Executes on button press in prevPicButton.
function prevPicButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = resetFigure(hObject, eventdata, handles);
    handles.iImg = handles.iImg - 1;
    updatePageText(hObject, eventdata, handles);
    if handles.iImg  == handles.maxiImg-2
        set(handles.nextPicButton, 'Enable', 'On')
    end
    if handles.iImg == 0
        set(handles.prevPicButton, 'Enable', 'Off')
    end
    handles = visualizeData(hObject, eventdata, handles);
    guidata(hObject, handles)
    
% --- Executes on button press in nextPicButton.
function nextPicButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = resetFigure(hObject, eventdata, handles);
    handles.iImg = handles.iImg + 1;  
    updatePageText(hObject, eventdata, handles);
    if handles.iImg  == handles.maxiImg-1
        set(handles.nextPicButton, 'Enable', 'Off')
    end
    if handles.iImg == 1
        set(handles.prevPicButton, 'Enable', 'On')
    end
    handles = visualizeData(hObject, eventdata, handles);
    guidata(hObject, handles)


function handles = checkProcessRadioButtons(hObject, eventdata, handles)
    handles.aborted = false;
    processSel = get(handles.processRadioButtons, 'SelectedObject');
    processSel = get(processSel,'String');
    switch processSel
        case 'Fully automated'
            if isfield(handles, 'minArea') == 1
                handles.running = true;
                guidata(hObject, handles)
                handles.fully = true;
                set(gcf,'pointer','watch')
                handles = BacteriaColonySeg(hObject, eventdata, handles);
                handles.done = true;
                set(gcf,'pointer','arrow')
                if handles.maxNum == 1
                    handles = showResults(hObject, eventdata, handles);
                    set(handles.instructions, 'String', ...
                        'This is the result. With the left click new segments can be added, with right click segments can be deleted and with a middle click the process ends.')
                end
                handles.running = false;
                guidata(hObject, handles)
            end
        case 'Partially automated'
            if isfield(handles, 'imgs') == 1
                handles.fully = false;
                for i = 1:length(handles.imgs)
                    handles.running = true;
                    guidata(hObject, handles)
                    pause(0.3);
                    handles.indexImg = i;
                    hFigure = figure('Name',handles.data(i).name,'NumberTitle','off');
                    set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
                    imshow(handles.imgs{i});
                    title('Please select a small and a big colony from the image.');
                    set(hFigure, 'MenuBar', 'none');
                    set(hFigure, 'ToolBar', 'figure');
                    set(hFigure, 'Resize', 'off');
                    handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                    if handles.aborted
                        break
                    end
                    handles = showResults(hObject, eventdata, handles);
                    title('Please wait while the image is being processed.');
                    handles = BacteriaColonySeg(hObject, eventdata, handles);
                    handles = showResults(hObject, eventdata, handles);
                    title('This is the result. Add segments with a left click, remove segments with a right click and end the process with a middle click.')
                    handles.BW{i} = manualAddRem(handles.BW{i}, handles.imgs{i}, handles.pars);
                    handles.running = false;
                    guidata(hObject, handles)
                    handles = showResults(hObject, eventdata, handles);
                    set(gcf,'pointer','arrow')
                    
                    title('This is the end result for now. Close the windows to continue.')
                    waitfor(hFigure);
                end                                
                handles.done = true;
            end       
            guidata(hObject, handles);     
        case 'Manual selection'
            if isfield(handles, 'imgs') == 1
                handles.fully = false;
                for i = 1:length(handles.imgs)
                    handles.running = true;
                    guidata(hObject, handles)
                    pause(0.3);
                    handles.indexImg = i;
                    hFigure = figure('Name',handles.data(i).name,'NumberTitle','off');
                    set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
                    imshow(handles.imgs{i});
                    title('Please select all the colonies from the image.');
                    set(hFigure, 'MenuBar', 'none');
                    set(hFigure, 'ToolBar', 'figure');
                    set(hFigure, 'Resize', 'off');
                    handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                    if handles.aborted
                        break
                    end
                    handles = showResults(hObject, eventdata, handles);
                    handles.pars.maxcelldiam = handles.maxcelldiam;
                    handles.pars.avcellsize  = 1.2*handles.minArea;
                    handles.pars.mincellsize = handles.minArea;
                    handles.pars.areavec     = [0.5*handles.minArea handles.minArea handles.maxArea 2*handles.maxArea];
                    title('This is the result. Add segments with a left click, remove segments with a right click and end the process with a middle click.')
                    handles.BW{i} = manualAddRem(handles.BW{i}, handles.imgs{i}, handles.pars);
                    handles = showResults(hObject, eventdata, handles);
                    handles.running = false;
                    guidata(hObject, handles)
                    set(gcf,'pointer','arrow')
                    feats = regionprops(handles.BW{i}, handles.norImg{i}, {'Area'});
                    handles.areavec{i} = [feats.Area];
                    if  sum(sum(handles.BW{handles.indexImg})) > 0
                        handles.seg_count{i} = max(max(bwlabel(handles.BW{i})));
                    else
                        handles.seg_count{i} = 0;
                    end
                    title('This is the end result for now. Close the windows to continue.')
                    waitfor(hFigure);
                end                                
                handles.done = true;
            end
    end
    if handles.aborted
         set(handles.instructions, 'String', ...
            'Process has been aborted. Please run again.')
    else
        set(handles.instructions, 'String', ...
            'Completed. If you wish to correct the results then click on the image you wish to correct.')
    end
    %TODO: set(handles.correctionRadioButtons, 'Visible', 'Off')
    guidata(hObject, handles);
    

function handles = checkCorrectionRadioButtons(hObject, eventdata, handles)
    correctionSel = get(handles.correctionRadioButtons, 'SelectedObject');
    correctionSel = get(correctionSel,'String');
    if isfield(handles, 'iImg') == 0
        handles.indexImg = 1;
    end          
    i = handles.indexImg;
    handles.aborted = false;
    switch correctionSel
        case 'Fast marching'
            objinfo.pixrev   = false;
            objinfo.switch   = 0;
            if sum(size(handles.norImg{i})) == 0
                handles.norImg{i}= im_norm(double(mean(handles.imgs{i},3)), ...
                                [1 99], 'minmax', objinfo, 0);
            end;
            try

                [x,y,~]          = impixel;
                set(gcf,'pointer','watch')
                title('Please wait until the process is finished.');
                drawnow();
                x                = floor(x);
                y                = floor(y);
                mask             = false(size(handles.norImg{i}));

                %% Fast marching over the selected bacteria colonies
                for ii = 1:length(x)
                    mask(y(ii),x(ii)) = true;
                end
                W                   = graydiffweight(handles.norImg{i}, mask);
                [BW, ~]  = imsegfmm(W, mask, 0.001);
            catch
                handles.aborted = true;
            end
        case 'Circle segmentation'
            h = imellipse;
            wait(h);
            BW = createMask(h);
        case 'Manual segmentation'
            h = imfreehand;            
            wait(h);
            BW = createMask(h);
    end
    
    if handles.aborted == false
        BWempty = isempty(handles.BW{i}); 
        if BWempty
            handles.BW{i} = BW;
        else                
            handles.BW{i} = BW | handles.BW{i};
        end
    end
    guidata(hObject, handles)


function updatePageText(hObject, eventdata, handles)
    set(handles.pageText, 'String', ...
        [num2str(handles.iImg+1) '/' num2str(handles.maxiImg)])    
    guidata(hObject, handles)

function handles = visualizeData(hObject, eventdata, handles)

    if isfield(handles, 'results') == 0 | sum(size(handles.results{1})) == 0
        if isfield(handles, 'iImg') == 0        
            set(handles.instructions, 'String', ...
                'Please wait while all the pictures are loaded (0%)') 
            handles.iImg  = 0;
            handles.indexImg = 1;
            handles.maxNum = size(handles.data,1);
            handles.imgs{handles.maxNum}   = [];
            handles.BW{handles.maxNum}     = [];
            handles.norImg{handles.maxNum} = [];
            handles.ov{handles.maxNum}     = [];
            handles.results{5}             = [];
            handles.maxiImg = round(handles.maxNum / handles.maxPics);
            if handles.maxNum / handles.maxPics > handles.maxiImg
                handles.maxiImg = handles.maxiImg + 1;
            end
            if  handles.maxNum > handles.maxPics
                set(handles.nextPicButton, 'Enable', 'On')
            end
            updatePageText(hObject, eventdata, handles);
        end
        if isfield(handles, 'iImg') == 1
            num_img = handles.maxNum;
            if num_img > 12
                x = 4;
                y = 4;
                if num_img > 16
                    y = 5;
                end
            elseif num_img > 6
                x = 3;
                y = 3;
                if num_img > 9
                    y = 4;
                end
            elseif num_img > 2
                x = 2;
                y = 2;
                if num_img > 4
                    y = 3;
                end
            else
                x = 1;
                y = 1;
                if num_img > 1
                    y = 2;
                end
            end
            set(handles.nextPicButton, 'Enable', 'Off')
            set(handles.prevPicButton, 'Enable', 'Off')
            for i  = handles.maxPics*handles.iImg+1 : ...
                     min(num_img, handles.maxPics*(handles.iImg+1))
                if isempty(handles.imgs{i})
                    if ~isdeployed
                        handles.imgs{i} = imread(handles.data(i).name);
                    else
                        handles.imgs{i} = imread([handles.fName '\' handles.data(i).name]);
                    end
                end
                ii = i - handles.iImg*handles.maxPics;
                if num_img == 1
                    handles.indexImg = 1;
                    imshow(handles.imgs{i});  
                else        
                    subplot(x,y,ii);
                    a = subimage(handles.imgs{i}); 
                    set(a,'ButtonDownFcn', {@(u,v)singlePicture(u, v, handles.figure1, i)});   
                    set(handles.instructions, 'String', ...
                        ['Please wait while all the pictures are loaded (' ...
                          num2str(min(100, ((ii+1)/min(num_img, handles.maxPics)*100))) '%)'])
                end
                set(gca,'visible','off');
                title(['\color{white}' handles.data(i).name]);
                set(findall(gca, 'type', 'text'), 'visible', 'on')
                drawnow();    
            end           
            if handles.iImg == 0
                set(handles.prevPicButton, 'Enable', 'Off')
            else
                set(handles.prevPicButton, 'Enable', 'On') 
            end
            if handles.iImg == handles.maxiImg-1
                set(handles.nextPicButton, 'Enable', 'Off')
            else
                set(handles.nextPicButton, 'Enable', 'On')
            end
        end
    else
        if handles.maxNum == 1
            a = imshow(handles.results{1});
            set(a,'ButtonDownFcn', {@(u,v)singlePicture(u, v, handles.figure1, 1)});
            set(gca,'visible','off');
            title(['\color{white}' handles.resultsTitle{1}]);
            set(findall(gca, 'type', 'text'), 'visible', 'on')
            drawnow();
        else
            x = 2;
            y = 2;
            for i  = 1:4
                subplot(x,y,i);
                a = subimage(handles.results{i});
                set(a,'ButtonDownFcn', {@(u,v)singlePicture(u, v, handles.figure1, i)});
                set(handles.instructions, 'String', ...
                    ['Please wait while all the pictures are loaded (' ...
                    num2str((i/4)*100) '%)'])
                set(gca,'visible','off');
                title(['\color{white}' handles.resultsTitle{i}]);
                set(findall(gca, 'type', 'text'), 'visible', 'on')
                drawnow();
            end
        end
    end
    set(handles.instructions, 'String', ...
        ['Thank you for waiting. All the pictures are loaded. Continue with a process method of your choice.'])
    guidata(hObject, handles)
    
% function doScroll(e)
%     disp(e)
%     value = e.VerticalScrollCount;
%     if value > 0
%         zoom(0.5);
%     else
%         zoom(2);
%     end
%     
%     
function closeReq(hObject, eventdata, hGui)
    handles = guidata(hGui);
    if isfield(handles, 'running') == 0 || ~handles.running
        delete(gcf)
        set(gcf,'pointer','arrow')        
    else
        selection = questdlg('Do you wish to abort a running process?',...
            'Close Window?',...
            'Yes','No','Yes');
        switch selection
            case 'Yes'
                delete(gcf)
                set(gcf,'pointer','arrow')
            case 'No'
                return
        end
    end
    
    guidata(hObject, handles)
%     
% function clicking(e)
%     disp(e)
%     impixelinfo
%     [himage,axHandles,hFig] = imhandles(gcf);
%     axesCurPt = get(axHandles,{'CurrentPoint'});
%     indexInAxesArray = [];
% 
%     % determine which image the cursor is over.
%     for k = 1:length(axHandles)
%         pt = axesCurPt{k};
%         x = pt(1,1)
%         y = pt(1,2)
%         xlim = get(axHandles(k),'Xlim')
%         ylim = get(axHandles(k),'Ylim')
% 
%         if x >= xlim(1) && x <= xlim(2) && y >= ylim(1) && y <= ylim(2)
%            indexInAxesArray = k
%            break;
%         end
%     end
%     zoom2cursor
    
function singlePicture(hObject, eventdata, hGui, i)
    switch get(gcf,'SelectionType')
        case 'normal' % Click left mouse button.
            handles = guidata(hGui); % https://de.mathworks.com/matlabcentral/answers/284574-handles-not-being-updated-with-guidata-in-callback
            handles.indexImg = i;
            hFigure = figure();
            set(hFigure, 'MenuBar', 'none');
            set(hFigure, 'ToolBar', 'figure');
%             set(hFigure, 'WindowScrollWheelFcn', @(o,e)doScroll(e));
%             set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
%             set(hFigure, 'WindowButtonDownFcn', @(o,e)clicking(e));


            
            if sum(size(handles.results{1})) == 0
                
                processSel = get(handles.processRadioButtons, 'SelectedObject');
                processSel = get(processSel,'String');
                if isfield(handles, 'done') == 0 && strcmp(processSel, 'Fully automated') == 1 || isfield(handles, 'done') == 1 && handles.done == true
                    while 1
                        BWempty = isempty(handles.BW{i});
                        if BWempty
                            im = handles.imgs{i};
                        else
                            overlay  = imoverlay(handles.imgs{i}, ...
                                imdilate(bwperim(handles.BW{i}), ...
                                ones(3)), [.9 .4 .3]);
                            im = overlay;
                        end
                        imshow(im);
                        set(gca,'visible','off');
                        
                        
                        processSel = get(handles.processRadioButtons, 'SelectedObject');
                        processSel = get(processSel,'String');
                        switch processSel
                            case 'Fully automated'
                                if isfield(handles, 'minArea') == 0
                                    title('Please select a small and a big colony from all the images.')
                                end
                                if isfield(handles, 'done') == 0
                                    handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                                    if handles.aborted
                                        break
                                    end
                                end
                                
                                handles = showResults(hObject, eventdata, handles);
                        end
                        if isfield(handles, 'done') == 1 && handles.done == true
                            title('This is the result. Add segments with a left click, remove segments with a right click and end the process with a middle click.')
                            handles.BW{i} = manualAddRem(handles.BW{i}, handles.imgs{i}, handles.pars);
                            wfig = gcf;
                            if strcmp(wfig.Name, 'AutoSeg') == 1
                                break
                            end
                        end
                        
                        guidata(hObject, handles);
                        
                        correctionSel = get(handles.correctionRadioButtons, 'SelectedObject');
                        correctionSel = get(correctionSel,'String');
                        switch correctionSel
                            case 'Fast marching'
                                if isfield(handles, 'done') == 0
                                    break
                                end
                        end
                    end
                else                    
                    BWempty = isempty(handles.BW{i});
                    if BWempty
                        im = handles.imgs{i};
                    else
                        overlay  = imoverlay(handles.imgs{i}, ...
                            imdilate(bwperim(handles.BW{i}), ...
                            ones(3)), [.9 .4 .3]);
                        im = overlay;
                    end
                    imshow(im);
                    set(gca,'visible','off');
                end
            else
                imshow(handles.results{i});
                set(gca,'visible','off');
            end
            guidata(hObject, handles);
    end
    
function handles = showResults(hObject, eventdata, handles)
    i                       = handles.indexImg;
    preSelectInfo           = regionprops(handles.BW{i}, 'Area', ...
                                'MajorAxisLength', 'PixelIdxList');
    if isfield(handles, 'minArea') == 0
        handles.minArea     = min([preSelectInfo.Area]);
        handles.maxArea     = max([preSelectInfo.Area]);
        handles.maxcelldiam = max([preSelectInfo.MajorAxisLength]);
        processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);
        
        set(handles.runButton,'Enable','on')
        
    else
        handles.minArea = min(handles.minArea, min([preSelectInfo.Area]));
        handles.maxArea = max(handles.maxArea, max([preSelectInfo.Area]));
    end                 
    
    %% Display results
    if isfield(handles, 'strarray') == 0
        colour = [.9 .4 .3];
    elseif strcmp(handles.strarray{i}, handles.test) == 1
        colour = [1 0 0];
    elseif strcmp(handles.strarray{i}, handles.control) == 1
        colour = [0 1 0];
    else
        colour = [0 0 1];
    end
    overlay         = imoverlay(handles.imgs{i}, ...
                        imdilate(bwperim(handles.BW{i}), ...
                        ones(3)), colour);
    handles.ov{i}   = overlay;
    imshow(overlay)
    title(['Thank you for selecting. The MinArea = ' num2str(handles.minArea) ...
        ' and MaxArea = ' num2str(handles.maxArea) ' have been calculated.'])
    
    correctionSel = get(handles.correctionRadioButtons, 'SelectedObject');
    correctionSel = get(correctionSel,'String');
    switch correctionSel
        case 'Fast marching'
            if isfield(handles, 'done') == 0
                if  isfield(handles, 'running') == 0
                    pause(2);
                    wfig = gcf;
                    if strcmp(wfig.Name, 'AutoSeg') == 0
                        close(gcf);
                    end
                    set(gcf,'pointer','arrow')
                end
            end
    end
    
function handles = resetGUI(hObject, eventdata, handles)
    handles = resetFigure(hObject, eventdata, handles);        
    if isfield(handles, 'iImg') == 1
        handles = rmfield(handles, 'iImg');
    end               
    if isfield(handles, 'imgs') == 1
        handles = rmfield(handles, 'imgs');
    end        
    if isfield(handles, 'running') == 1
        handles = rmfield(handles, 'running');
    end        
    if isfield(handles, 'done') == 1
        handles = rmfield(handles, 'done');
    end        
    if isfield(handles, 'maxcelldiam') == 1
        handles = rmfield(handles, 'maxcelldiam');
    end        
    if isfield(handles, 'maxArea') == 1
        handles = rmfield(handles, 'maxArea');
    end        
    if isfield(handles, 'ov') == 1
        handles = rmfield(handles, 'ov');
    end        
    if isfield(handles, 'minArea') == 1
        handles = rmfield(handles, 'minArea');
    end        
    if isfield(handles, 'maxiImg') == 1
        handles = rmfield(handles, 'maxiImg');
    end        
    if isfield(handles, 'norImg') == 1
        handles = rmfield(handles, 'norImg');
    end        
    if isfield(handles, 'BW') == 1
        handles = rmfield(handles, 'BW');
    end        
    if isfield(handles, 'maxNum') == 1
        handles = rmfield(handles, 'maxNum');
    end        
    if isfield(handles, 'data') == 1
        handles = rmfield(handles, 'data');
    end        
    if isfield(handles, 'imgtypes') == 1
        handles = rmfield(handles, 'imgtypes');
    end        
    if isfield(handles, 'ctrlen') == 1
        handles = rmfield(handles, 'ctrlen');
    end        
    if isfield(handles, 'lgtlen') == 1
        handles = rmfield(handles, 'lgtlen');
    end        
    if isfield(handles, 'cntrlf') == 1
        handles = rmfield(handles, 'cntrlf');
    end        
    if isfield(handles, 'testf') == 1
        handles = rmfield(handles, 'testf');
    end          
    if isfield(handles, 'featmat') == 1
        handles = rmfield(handles, 'featmat');
    end          
    if isfield(handles, 'fullmat') == 1
        handles = rmfield(handles, 'fullmat');
    end          
    if isfield(handles, 'results') == 1
        handles = rmfield(handles, 'results');
    end          
    if isfield(handles, 'resultsName') == 1
        handles = rmfield(handles, 'resultsName');
    end          
    if isfield(handles, 'fully') == 1
        handles = rmfield(handles, 'fully');
    end          
    if isfield(handles, 'typestr') == 1
        handles = rmfield(handles, 'typestr');
    end          
    if isfield(handles, 'areavec') == 1
        handles = rmfield(handles, 'areavec');
    end          
    if isfield(handles, 'labstr') == 1
        handles = rmfield(handles, 'labstr');
    end          
    if isfield(handles, 'strarray') == 1
        handles = rmfield(handles, 'strarray');
    end          
    if isfield(handles, 'inds') == 1
        handles = rmfield(handles, 'inds');
    end          
    if isfield(handles, 'feats') == 1
        handles = rmfield(handles, 'feats');
    end          
    if isfield(handles, 'seg_count') == 1
        handles = rmfield(handles, 'seg_count');
    end        
    set(handles.prevPicButton, 'Enable', 'Off')
    set(handles.nextPicButton, 'Enable', 'Off')
    
    
    if ~isdeployed
        % data paths
        if (exist(handles.fName, 'dir') == 7)
            datapath = handles.fName;
        else
            clearvars
            close all
            clc
            datapath  = pwd;
        end
        %% Datapaths & codepath
        % code path Arif
        codepath  = 'C:\micseg\MATLAB\code';
        guipath  = 'C:\micseg\MATLAB\GUI';
        % code path Angelo
    %     codepath  = '/home/at8/Documents/micseg/MATLAB/code';
    %     guipath  = '/home/at8/Documents/micseg/MATLAB/GUI';

        % Adding all paths
        addpath(guipath)
        addpath(datapath)
        addpath(codepath)
        cd(datapath)
    end
    guidata(hObject, handles);
    
function handles = resetFigure(hObject, eventdata, handles)
    c = get(handles.figure1, 'Children');
    for i = 1:length(c)
        if strcmp(c(i).Type, 'axes')
            delete(c(i))
        end
    end
    set(handles.instructions, 'String', ...
        'Welcome to Autoseg. ')
    guidata(hObject, handles)
    
% --- Executes on button press in nextPicButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = checkProcessRadioButtons(hObject, eventdata, handles);
    if ~handles.aborted
        set(handles.runButton,'Enable','off')
        set(handles.showresultsbutton,'Enable','on')
        set(handles.saveButton,'Enable','on') 
    end
    guidata(hObject, handles)
    

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = resetGUI(hObject, eventdata, handles);
    set(gcf,'pointer','arrow')
    set(handles.showresultsbutton,'Enable','off')
    set(handles.saveButton,'Enable','off')
    set(handles.runButton,'Enable','off')
    set(handles.resetButton,'Enable','off')     
    guidata(hObject, handles)

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %TODO: CHECK IF IT WORKS ON WINDOWS AND DEPLOYMENT
    set(handles.instructions, 'String', ...
        'Please wait while the results are being saved. ')
    set(gcf,'pointer','watch')
    featmat = handles.featmat;
    pars    = handles.pars;
    data    = handles.data;
    npath   = [handles.fName '\results'];
    if exist(npath, 'dir') ~= 7
        mkdir(npath)
    end
    %% Write segmented images to '\results' directory
    for i = 1:length(handles.imgs)
        imwrite(handles.BW{i}, [handles.fName '\results\' data(i).name(1:end - 4) '_mask.jpg'], 'jpg')
        imwrite(handles.ov{i}, [handles.fName '\results\' data(i).name(1:end - 4) '_seg.jpg'], 'jpg')
    end
    
    %% Write colony features to text file
    fileID = fopen([handles.fName '\results\' 'BacteriaColonySegSummary.txt'],'wt');
    fprintf  (fileID,'%30s %10s %9s %11s %15s \n', 'Image name', ...
        'Colony count', 'Mean area', 'Mean radius', 'Mean eccentricity');
    for k = 1 : size(featmat,1)
        fprintf(fileID,'\n %30s %3i %5.1f %2.2f %1.2f \n', ...
            [data(k).name(1:end - 4) ' seg'], ...
            featmat(k,1), ...
            featmat(k,2), featmat(k,3), featmat(k,4));
    end

    fclose(fileID); 
    
    % write results to '\results' directory
    if sum(size(handles.results{1})) ~= 0
        fname    = pars.im_name{1}(handles.inds{1}(2):(end-4));
        indices         = strfind(fname, '\');
        fname(indices)  = [];
        imwrite(handles.results{1}, [handles.fName '\results\' handles.resultsName{1}], 'jpg')
        imwrite(handles.results{2}, [handles.fName '\results\' handles.resultsName{2}], 'jpg')
        imwrite(handles.results{3}, [handles.fName '\results\' handles.resultsName{3}], 'jpg')
        imwrite(handles.results{4}, [handles.fName '\results\' handles.resultsName{4}], 'jpg')
        imwrite(handles.results{5}, [handles.fName '\results\' handles.resultsName{5}], 'jpg')
    end
    set(gcf,'pointer','arrow')
    set(handles.instructions, 'String', ...
        'Thank you for waiting. All the results have been saved.')


% --- Executes on button press in showresultsbutton.
function showresultsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to showresultsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.instructions, 'String', ...
            'Please wait while the results are being created (0%)')
        
    set(gcf,'pointer','watch')
    featmat = handles.featmat;
    pars    = handles.pars;
    data    = handles.data;
    
    fname   = pars.im_name{1}(handles.inds{1}(2):(end-4));
    namfind = strfind(fname, handles.control);
    endfind = strfind(fname, [handles.control(end) ' ']);
    tdata   = length(data);
    bwidth  = pars.bw;
    si1     = 1 ;
    si2     = 1;
    
    %PLOT 1
    cstr = {'-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g'};
    lstr = {'-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r'};
    figure('Visible','off')
    for i = 1 : tdata
        if strcmp(handles.strarray{i}, handles.control) == 1
            if~isempty(handles.areavec{i})
                [f, xi] = ksdensity(handles.areavec{i}, 'width', bwidth);
                if i < 10
                    plot(xi,f,cstr{i},'LineWidth',2)
                else
                    plot(xi,f,cstr{i},'LineWidth',2)
                end
                si1  = si1 + 1;
                a    = trapz(xi);
                A(i) = a/numel(handles.areavec{i});
                b    = trapz(handles.areavec{i});
                B(i) = b/numel(handles.areavec{i});
                hold on
            end
        elseif strcmp(handles.strarray{i}, handles.test) == 1 || ...
                strcmp(handles.strarray{i}, 'constant') == 1
            if~isempty(handles.areavec{i})
                [f, xi] = ksdensity(handles.areavec{i}, 'width', bwidth);
                if i < 20
                    if mod(i,handles.ctrlen) > 0
                        plot(xi,f,lstr{mod(i,handles.ctrlen)},'LineWidth',2)
                    else
                        plot(xi,f,lstr{handles.ctrlen},'LineWidth',2)
                    end
                else
                    plot(xi,f,lstr{max(mod(i,handles.ctrlen),1)}, ...
                        'LineWidth',2)
                end
                si2  = si2 + 1;
                a    = trapz(xi);
                A(i) = a/numel(handles.areavec{i});
                b    = trapz(handles.areavec{i});
                B(i) = max(1,b/numel(handles.areavec{i}));
                hold on
            end
        elseif strcmp(handles.strarray{i}, 'pulsed') == 1
            if~isempty(handles.areavec{i})
                [f, xi] = ksdensity(handles.areavec{i}, 'width', bwidth);
                if i < 20
                    if mod(i,handles.ctrlen) > 0
                        plot(xi,f,lstr{mod(i,handles.ctrlen)},'LineWidth',2)
                    else
                        plot(xi,f,lstr{handles.ctrlen},'LineWidth',2)
                    end
                else
                    plot(xi,f,lstr{max(mod(i,handles.ctrlen),1)},...
                        'LineWidth',2)
                end
                si2  = si2 + 1;
                a    = trapz(xi);
                A(i) = a/numel(handles.areavec{i});
                b    = trapz(handles.areavec{i});
                B(i) = max(1,b/numel(handles.areavec{i}));
                hold on
            end
        end
    end
    set(gca,  'FontSize', 18)
    xlabel('Colony sizes (in pixels)', 'FontSize', 20)
    ylabel('KDE', 'FontSize', 20)
    handles.resultsTitle{1} = [handles.control ' vs. ' handles.test ' (using KDE)'];
    title([handles.resultsTitle{1} ' for ' num2str(pars.im_name{1}(handles.inds{1}(2):(end-4)))], 'FontSize', 20)
    for i = 1 : length(handles.areavec)
        if ~isempty(handles.areavec{i})
            % MAKE IT 1 to 4
            strar(i) = cellstr([char(handles.strarray{i}) num2str(i) ' n = ' num2str(handles.seg_count{i})]);
        end
    end
    legend(strar, 'Location', 'NorthEast')
    grid on
    
    % Save results in handles.results
    screen_size     = get(0, 'ScreenSize');
    fig             = gcf;
    set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
    handles.results{1} = print(fig, '-RGBImage');
    handles.resultsName{1} = [fname ' kde.jpg'];
    close(gcf);
    
    if handles.maxNum > 1   
    set(handles.instructions, 'String', ...
        'Please wait while the results are being created (20%)')     
        fnew  = f(50:65);
        ff    = linspace(min(fnew), max(fnew),tdata);
        si1   = 1 ;
        si2   = 1;
        
        tmpind = -1*ones(length(handles.areavec),1);
        
        for i = 1 : length(handles.areavec)
            if ~isempty(handles.areavec{i})
                tmpind(i) = max(max(handles.areavec{i}));
            else
                tmpind(i) = 0;
            end
        end
        
        xval = ceil(max(tmpind));
        
        LiCA = 0;
        LiAA = 0;
        aLic = 0;
        aCtc = 0;
        for i = 1 : length(data)
            if strcmp(handles.strarray{i}, handles.control) == 1
                if ~isempty(handles.areavec{i})
                    CtCA(i) = A(i);
                    CtAA(i) = B(i);
                    aCtc(i) = numel(handles.areavec{i});
                else
                    CtCA(i) = -1;
                    CtAA(i) = -1;
                    aCtc(i) = -1;
                end
                si1   = si1 + 1;
            elseif strcmp(handles.strarray{i}, handles.test) == 1 || ...
                    strcmp(handles.strarray{i}, 'constant') == 1
                if ~isempty(handles.areavec{i})
                    LiCA(i) = A(i);
                    LiAA(i) = B(i);
                    aLic(i) = numel(handles.areavec{i});
                else
                    LiCA(i) = -1;
                    LiAA(i) = -1;
                    aLic(i) = -1;
                end
                si2 = si2 + 1;
            end
        end
        
        if numel(LiCA) > 1
            LiCA  (LiCA == 0) = [];
        end
        
        if numel(LiAA) > 0
            LiAA  (LiAA == 0) = [];
        end
        
        ab   = strfind(handles.strarray, handles.control);
        l1   = numel(cell2mat(ab));
        bc   = strfind(handles.strarray, handles.test);
        l2   = numel(cell2mat(bc));
        t    = [1;2];
        plst = {'g--x', 'r--x', 'b--x', 'c--x', 'm--x', 'k--x', ...
            'g:x', 'r:x', 'b:x', 'c:x', 'm:x', 'k:x', ...
            'g-x', 'r-x', 'b-x', 'c-x', 'm-x', 'k-x'};
        
        
        %PLOT 2
        strfig = '';
        mcct   = 0;
        mcli   = 0;
        figure('Visible','off');
        for k = 1 : min(l1,l2)
            % Total area from curve plot
            plot(t,[CtCA(k);LiCA(k)], plst{k} ,'LineWidth',2, 'MarkerSize',10)
            grid on
            hold on
            strfig{k} = ['Exp ' num2str(k)];
            mcct(k)   = numel(handles.areavec{k});
            mcli(k)   = numel(handles.areavec{k+l2});
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        xlim([0 3])
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 18)
        ylabel('Normalized Colony Size')
        handles.resultsTitle{5} = 'Normalized Areas from Curve';
        title([handles.resultsTitle{5} ' (' fname ')'])
        text(t(end), 0.75*max(max(CtCA),max(LiCA)), ['A_C_t_r = ' ...
            num2str(floor(median(CtCA)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        text(t(end), 0.7*max(max(CtCA),max(LiCA)), ['A_L_i = ' ...
            num2str(floor(median(LiCA)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        legend(strfig, 'Location', 'NorthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{5} = print(fig, '-RGBImage');
        handles.resultsName{5} = [fname ' KDEArea.jpg'];
        close(gcf);
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (40%)')
        
        %PLOT 3
        figure('Visible','off');
        for k = 1 : min(l1,l2)
            % Total absolute area plot
            plot(t,[CtAA(k);LiAA(k)], plst{k} ,'LineWidth',2, 'MarkerSize',20)
            grid on
            hold on
            strtmp = ['Exp ' num2str(k)];
            strfig{k} = ['Exp ' num2str(k)];
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        ylabel('Normalized Colony Size')
        xlim([0 3])
        ylim([1500 5000])
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{2} = 'Normalized Absolute Areas';
        title([handles.resultsTitle{2} ' (' fname ')'])
        text(t(end), 0.95*max(max(CtAA),max(LiAA)), ['A_C_t_r = ' ...
            num2str(floor(median(CtAA)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        text(t(end), 0.9*max(max(CtAA),max(LiAA)), ['A_L_i = ' ...
            num2str(floor(median(LiAA)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        legend(strfig, 'Location', 'NorthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{2} = print(fig, '-RGBImage');
        handles.resultsName{2} = [fname ' AbsArea.jpg'];
        close(gcf);
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (60%)')
        
        %PLOT 4
        CtAA  (CtAA == 0) = [];
        figure('Visible','off');
        for k = 1 : min(l1,l2)
            % Total absolute area normalized to 1 plot
            plot(t,[1; LiAA(k)/CtAA(k)], plst{k} , ...
                'LineWidth',2, 'MarkerSize',18)
            grid on
            hold on
            strtmp = ['Exp ' num2str(k)];
            strfig{k} = ['Exp ' num2str(k) ' ,  ' ...
                num2str(LiAA(k)/CtAA(k),4)];
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        ylabel('Normalized Colony Size')
        xlim([0 3])
        ylim([min(LiAA ./ CtAA)-0.1 max(max(LiAA./CtAA)+0.1,1.1)])
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{3} = 'Absolute Areas Normalized to 1';
        title([handles.resultsTitle{3} ' (' fname ')'])
        text(t(2), 0.6, ['MeanVal  = ' ...
            num2str(mean(LiAA./CtAA),2)], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        legend(strfig, 'Location', 'SouthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{3} = print(fig, '-RGBImage');
        handles.resultsName{3} = [fname ' AbsAreaTo1.jpg'];
        close(gcf);
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (80%)')
        
        %PLOT 5
        if numel(aLic) > 0
            aLic  (aLic == 0) = [];
        end
        
        if numel(aCtc) > 0
            aCtc  (aCtc == 0) = [];
        end
        
        plst1 = {'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o'};
        
        figure('Visible','off');
        strtmp = '';
        for k = 1 : min(l1,l2)
            % Total absolute count plot
            plot(t,[aCtc(k);aLic(k)],plst1{k},'LineWidth',2,'MarkerSize',18)
            grid on
            hold on
            strtmp = ['Exp ' num2str(k)];
            strfig{k} = ['Exp ' num2str(k)];
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        ylabel('Colony count')
        xlim([0 3])
        ylim([min(min(aLic,aCtc))-1 max(max(aLic,aCtc))+1])
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{4} = 'Colony Count Comparison';
        title([handles.resultsTitle{4} ' (' fname ')'])
        text(0.1, 0.75*max(max(aCtc),max(aLic)), ['n_C_t_r = ' ...
            num2str(floor(median(mcct)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        text(0.1, 0.6*max(max(aCtc),max(aLic)), ['n_L_i = ' ...
            num2str(floor(median(mcli)))], 'Color', [.7 .7 .7], ...
            'FontSize', 20)
        legend(strfig, 'Location', 'NorthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{4} = print(fig, '-RGBImage');
        handles.resultsName{4} = [fname ' Count.jpg'];
        close(gcf);
    end
    handles = resetFigure(hObject, eventdata, handles);
    handles = visualizeData(hObject, eventdata, handles);
    set(handles.instructions, 'String', ...
        'Completed.')
    set(gcf,'pointer','arrow')
    guidata(hObject, handles)


% --- Executes when selected object is changed in processRadioButtons.
function processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in processRadioButtons 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isfield(handles, 'maxNum') == 1 
        if handles.maxNum > 1        
            set(handles.radiobutton1, 'Enable', 'on');
        elseif handles.maxNum == 1
            set(handles.radiobutton1, 'Enable', 'inactive');
            set(handles.runButton, 'Enable', 'on');
            processSel = get(handles.processRadioButtons, 'SelectedObject');
            processSel = get(processSel,'String');
            switch processSel
                case 'Fully automated'
                    set(handles.radiobutton2, 'Value', 1.0);
            end
        end        
        processSel = get(handles.processRadioButtons, 'SelectedObject');
        processSel = get(processSel,'String');
        switch processSel
            case 'Fully automated'
                if isfield(handles, 'minArea') == 0
                    set(handles.instructions, 'String', ...
                        'Please select a small and a big colony from all the images.')
                    set(handles.runButton,'Enable','off')

                else
                    set(handles.instructions, 'String', ...
                        'The minimum requirement is achieved. Click on the Run button or continue to select.')
                    set(handles.runButton,'Enable','on')
                end            
            case 'Partially automated'
                set(handles.instructions, 'String', ...
                    'No requirement is needed. Please click on the Run button.')
                set(handles.runButton,'Enable','on')
            case 'Manual selection'
                set(handles.instructions, 'String', ...
                    'No requirement is needed. Please click on the Run button.')
                set(handles.runButton,'Enable','on')
        end
    else
        set(handles.instructions, 'String', ...
            'Please select at least one image or a image directory first.')        
    end

% --- Executes on button press in optionbutton.
function optionbutton_Callback(hObject, eventdata, handles)
% hObject    handle to optionbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    pr                 = {'Border buffer in cropping (in pixels)', ...
        'Extract petridish? (true / false)', ...
        'Average circularity (0(circle) - 1(line))', ...
        'Gaussian filter size ( )', ...
        'Segmentation (threshold) (min:step:max)', ...
        'Segmentation (watershed) (min:step:max)', ...
        'Channel selection (1 = red 2 = green 3 = blue)', ...
        'Adapting histogram (true / false)', ...
        'Bandwith for the kde plot', ...
        'Name for control images', ...
        'Name for test images'};
    dlg_title          = 'Options';
    nline              = 1;
    dflt               = {'10', 'true', '0.45', ...
        '[5 5]', '0.3: 0.1: 0.97', '0.1:0.01:0.25', ...
        '2', 'false', '2000', 'control','light'};
    answer             = inputdlg(pr, dlg_title, nline, dflt);    
    if ~isempty(answer)
        handles.pars.sImBorder   = str2num(answer{1});
        handles.pars.dishextract = str2num(answer{2});
        handles.pars.avcellecc   = str2num(answer{3});
        handles.pars.gausfltsize = str2num(answer{4});
        handles.pars.otsuvector  = str2num(answer{5});
        handles.pars.wsvector    = str2num(answer{6});
        handles.pars.chnnlselect = str2num(answer{7});
        handles.pars.adapthist   = str2num(answer{8});
        handles.pars.bw          = str2num(answer{9});        
        handles.control = answer{10};
        handles.test    = answer{11};
    end
    guidata(hObject, handles)
