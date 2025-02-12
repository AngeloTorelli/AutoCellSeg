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

% Last Modified by GUIDE v2.5 17-Aug-2017 14:50:11

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
%set(handles.figure1 (, 'units','norm','Position',[0 0 1 1]);
handles.maxPics  = 20;
handles.output   = hObject;
handles.pars.vis = false;

% Parameters
handles.pars.bw          = 2000;
handles.pars.sImBorder   = 10;
handles.pars.wsvector    = 0.1:0.01:0.25;
handles.pars.wsvectext   = '0.1:0.01:0.25';
handles.pars.otsuvector  = 0.3:0.1:0.97;
handles.pars.otsuvectext = '0.3:0.1:0.97';
handles.pars.dishextract = true;
handles.pars.adapthist   = false;
handles.pars.apriointen  = false;
handles.pars.gausfltsize = [5 5];
handles.pars.chnnlselect = 2;
handles.pars.avcellecc   = 0.45;
% Control and test names
handles.control          = 'control';
handles.test             = 'light';
handles.pars.Color       = [1 0 0];
handles.ffthresh         = 0.02;
handles.edge             = false;
handles.nfeat            = 4;
% Generation of tooltips
set(handles.addImages,'tooltipString','<html>Add any number of images:<br><i><b>Click </b>to select an individual image.<br><i><b>Shift-click </b>to batch select from selected picture to clicked one.<br><i><b>Ctrl-click </b>to select multiple individual pictures.<br><i><b>Shift-ctrl-click </b>to select multiple batches of pictures.');
set(handles.addDir,'tooltipString','<html>Add all the images of one folder.');
set(handles.radiobutton1,'tooltipString','<html>The process of fully automated segmentation runs over all the selected images.<br><i>The only requirement is the selection of a small and big bacteria colony.<br><i>The type of selection depends on the choice of the a priori selection method.');
set(handles.radiobutton2,'tooltipString','<html>The process of partially automated segmentation runs over each individual image.<br><i>For each individual image the user should select a small and big bacteria colony for optimal segmentation.<br><i>The type of selection depends on the choice of the a priori selection method.');
set(handles.manualradiobutton,'tooltipString','<html>The process of manual segmentation runs over each individual image and consist of selecting each individual bacteria colony.<br><i>The type of selection depends on the choice of the a priori selection method.');
set(handles.radiobutton5,'tooltipString','<html>The selection happens using the fast marching algorithm.<br><i><b>Single click</b> to mark the desired bacteria colony.<br><i><b>Double click</b> to mark the last desired bacteria colonies and start the initial segmentation.<br><i><b>Press Enter</b> to start the initial segmentation.');
set(handles.radiobutton7,'tooltipString','<html>The selection is done by creating ellipses manually.<br><i><b>Click and drag</b> to create an ellipse.<br><i><b>Double click</b> on the ellipse created confirmes the shape. <br><i><b>Press escape</b> to finish.');
set(handles.radiobutton6,'tooltipString','<html>The selection is done by drawing the outline of a bacteria colony manually.<br><i><b>Click and drag</b> to start the drawing until <b>releasing the mouse key</b>. <br><i><b>Double click</b> on the shape created confirmes the shape. <br><i><b>Press escape</b> to finish.');
set(handles.runButton,'tooltipString','<html>The run button activates the process of choice when the requirements are satisfied.');
set(handles.showresultsbutton,'tooltipString','<html>The show results button initiates the generation of the results after a segmentation process has run successfully.');
set(handles.saveButton,'tooltipString','<html>The save results button saves all the results after a segmentation process has run successfully. <br><i> The results consist of a text file containing the name of each image with the accordingly colony count, mean area, mean radius and mean eccentricity.<br><i>It also creates a folder named results containing the masks for each segmented image and the same mask overlayed with the original pictures.<br><i>If the show results button was activated then all the plots created in the process will be saved in the results folder as well.');
set(handles.resetButton,'tooltipString','<html>The reset button sets the program to a clean state again.');
set(handles.optionbutton,'tooltipString','<html>The change parameters button allows the user to change the values of parameters used in AutoCellSeg. <br><i> It is recommended but not necessary to change the parameters according to the experiments. <br><i> The name for control and test should match the images of the experiment.');
set(handles.loadoptions,'tooltipString','<html>The load parameters button allows the user to load the values of the parameters used in a previous run, <br> which was saved in the folder of the results.');
set(handles.instructions,'tooltipString','<html>Welcome to AutoCellSeg! <br><i> For more information read the tooltip of each element, which is activated when hovering over the element. <br><i> Start by loading pictures into the program and following the step by step instructions given in the title. <br><i> When the title bar contains three dots ... then the statement or instructions is too long and it can be found as a tooltip in the title.');
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

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'imgs') == 1
    selection = questdlg('Do you wish to close AutoCellSeg?',...
        'Closing AutoCellSeg',...
        'Yes','No','Yes');
    switch selection
        case 'Yes'
            nof = findall(0,'type','figure');
            if length(nof) > 1
                for i = 1:length(nof)
                    delete(nof(i));
                end
            end
            delete(hObject);
        case 'No'
            return
    end
else
    nof = findall(0,'type','figure');
    if length(nof) > 1
        for i = 1:length(nof)
            delete(nof(i));
        end
    end
    delete(hObject);
end



% --- Executes on button press in addImages.
function addImages_Callback(hObject, eventdata, handles)
% hObject    handle to addImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    try
        set(handles.addImages,'Value', 0);
        if ismac
            [filename, handles.fName] = uigetfile( ...
                {'*.JPEG;*.jpeg;*.JPG;*.jpg;*.PNG;*.png;*.TIF;*.tif;*.BMP;*.bmp',...
                'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
                'MultiSelect', 'on');
        elseif isunix
            [filename, handles.fName] = uigetfile( ...
                {'*.JPEG;*.jpeg;*.JPG;*.jpg;*.PNG;*.png;*.TIF;*.tif;*.BMP;*.bmp',...
                'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
                'MultiSelect', 'on');
        elseif ispc
            [filename, handles.fName] = uigetfile( ...
                {'*.jpeg;*.jpg;*.png;*.tif;*.bmp',...
                'Graphic Files (*.jpg,*.png,*.bmp,*.tif)'}, 'Select an image', ...
                'MultiSelect', 'on');
        else
            disp('Platform not supported')
        end
        if isequal(filename,0)
            disp('User selected Cancel')
        else
            handles = resetGUI(hObject, eventdata, handles);
            set(handles.addImages,'Enable','off')
            set(handles.addDir,'Enable','off')
            if iscellstr(filename) == 0
                filename = cellstr(filename);
            end
            handles.filename = filename;
            handles.data = cell2struct(filename, 'name', 1);
            handles = extractNames(hObject, eventdata, handles);
            handles.featmat  = zeros(length(handles.data), handles.nfeat);
            handles.fullmat  = [];
            handles = visualizeData(hObject, eventdata, handles);

            processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);

            set(handles.addImages,'Enable','on')
            set(handles.addDir,'Enable','on')
            set(handles.resetButton,'Enable','on')
            hObject = handles.output;
            guidata(hObject, handles)
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end

% --- Executes on button press in addDir.
function addDir_Callback(hObject, eventdata, handles)
% hObject    handle to addDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    try
        set(handles.addDir,'Value', 0);
        handles.fName = uigetdir();
        if isequal(handles.fName,0)
            disp('User selected Cancel')
        else
            handles = resetGUI(hObject, eventdata, handles);
            set(handles.addImages,'Enable','off')
            set(handles.addDir,'Enable','off')
            % Specifiying image type and reading directory
            if ismac
                handles.imgtypes = {'JPEG'; 'jpeg'; 'JPG'; 'jpg'; 'PNG'; 'png'; 'TIF'; 'tif'; 'BMP'; 'bmp'};
            elseif isunix
                handles.imgtypes = {'JPEG'; 'jpeg'; 'JPG'; 'jpg'; 'PNG'; 'png'; 'TIF'; 'tif'; 'BMP'; 'bmp'};
            elseif ispc
                handles.imgtypes = {'jpeg';'jpg';'png';'tif';'bmp'};
            else
                disp('Platform not supported')
            end

            data     = [];

            if ~isdeployed
                for di = 1 : size(handles.imgtypes, 1)
                    data     = [data; dir(['*.' handles.imgtypes{di,:}])]; %#ok<AGROW>
                end
            else
                for di = 1 : size(handles.imgtypes, 1)
                    data     = [data; dir([handles.fName '\*.' handles.imgtypes{di,:}])]; %#ok<AGROW>
                end
            end
            if length(data) == 0
                warndlg({'No images were found in this folder.';'Please select a folder with images.';'Allowed formats are: jpg, png, tif and bmp.'}, 'No images found');
            else
                for iii = 1:length(data)
                    filename{iii} = data(iii).name;
                end
                handles.filename = filename;
                handles = extractNames(hObject, eventdata, handles);
                handles.cntrlf   = zeros(handles.ctrlen,1);
                handles.testf    = zeros(handles.lgtlen,1);
                handles.featmat  = zeros(length(data), handles.nfeat);
                handles.fullmat  = [];
                handles.data = data;
                handles = visualizeData(hObject, eventdata, handles);
                processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);
            end
            set(handles.addImages,'Enable','on')
            set(handles.addDir,'Enable','on')
            set(handles.resetButton,'Enable','on')
            hObject = handles.output;
            guidata(hObject, handles)
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end

function handles = extractNames(hObject, eventdata, handles)
    try
        filename = handles.filename;
        handles.ctrlen = 0;
        handles.lgtlen = 0;
        for i = 1:length(filename)
            handles.inds{i} = strfind(filename{i}, ' ');
            if isempty(handles.inds{i})
                handles.inds{i} = strfind(filename{i}, '_');
            end 
            if isempty(handles.inds{i})
                handles.inds{i} = strfind(filename{i}, '-');
            end 
            if isempty(handles.inds{i})
                handles.inds{i} = strfind(filename{i}, '+');
            end 
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
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
% --- Executes on button press in prevPicButton.
function prevPicButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
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
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
% --- Executes on button press in nextPicButton.
function nextPicButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
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
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end


function handles = checkProcessRadioButtons(hObject, eventdata, handles)
    try
        handles.aborted = false;
        processSel = get(handles.processRadioButtons, 'SelectedObject');
        processSel = get(processSel,'String');
        switch processSel
            case 'Fully automated'
                if isfield(handles, 'minArea') == 1
                    handles.running = true;
                    hObject = handles.output;
                    guidata(hObject, handles)
                    set(gcf,'pointer','watch')
                    set(handles.instructions, 'String', ...
                        'Please wait while all the pictures are processed (0%)')
                    currentState = enableDisableFig(handles.figure1, 'off');
                    handles = BacteriaColonySeg(hObject, eventdata, handles);
                    handles = createOverlays(hObject, eventdata, handles);
                    handles.done = true;
                    currentState = enableDisableFig(handles.figure1, 'on');
                    set(gcf,'pointer','arrow')
                    if handles.maxNum == 1
                        handles = showResults(hObject, eventdata, handles);
                        set(handles.instructions, 'String', ...
                            ['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{handles.indexImg})))) ...
                                        '. \rm Left click new segments can be added, with right click segments can be deleted and with a middle click the process ends.'])
                    end
                    handles.running = false;
                    hObject = handles.output;
                    guidata(hObject, handles)
                end
            case 'Partially automated'
                if isfield(handles, 'imgs') == 1
                    for i = 1:length(handles.imgs)
                        handles.running = true;
                        hObject = handles.output;
                        guidata(hObject, handles)
                        pause(0.3);
                        handles.indexImg = i;
                        sizeScreen =get(0,'Screensize');
                        hFigure = figure('name', [handles.data(i).name ' size:' int2str(size(handles.imgs{i},2)) 'x' int2str(size(handles.imgs{i},1))], ...
                            'NumberTitle','off', 'Position', [0.17*sizeScreen(3) 1 0.83*sizeScreen(3) 0.85*sizeScreen(4)]);
                        handles.figure2 = hFigure;
                        hObject = handles.output;
                        guidata(hObject, handles)
                        set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
                        imshow(handles.imgs{i});
                        title('Please select a small and a big colony from the image.');
                        set(hFigure, 'MenuBar', 'none');
                        set(hFigure, 'ToolBar', 'figure');
                        set(hFigure, 'Position', [0.17*sizeScreen(3) 1 0.83*sizeScreen(3) 0.85*sizeScreen(4)]);
                        h = uicontrol('style', 'togglebutton', 'Position', ...
                            [30 30 200 40],'String', ...
                            'Zoom', 'Callback', {@doZoom, handles.figure1});
                        handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                        if handles.aborted
                            break
                        end
                        handles = showResults(hObject, eventdata, handles);
                        title('Please wait while the image is being processed.');
                        handles = BacteriaColonySeg(hObject, eventdata, handles);
                        handles = showResults(hObject, eventdata, handles);
                        h = uicontrol('style', 'togglebutton', 'Position', ...
                            [30 30 200 40],'String', ...
                            'Zoom', 'Callback', {@doZoom, handles.figure1});
                        if handles.maxNum == 1
                            changed = false;
                            while ~changed
                                title(['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{i})))) ...
                                        '. \rm Left click adds cells, right click removes cells and middle click updates.'])
                                I = handles.BW{i};
                                handles = manualAddRem(handles.figure1);
                                I = sum(sum(I-handles.BW{i}));
                                handles = showResults(hObject, eventdata, handles);
                                if I == 0
                                    changed = true;
                                else
                                    changed = false;
                                end
                            end
                        else
                            title(['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{i})))) ...
                                        '. \rm Left click adds cells, right click removes cells and middle click updates.'])
                            handles = manualAddRem(handles.figure1);
                        end
                        handles = guidata(handles.figure1);
                        if ~handles.aborted
                            handles.running = false;
                            hObject = handles.output;
                            guidata(hObject, handles)
                            handles = showResults(hObject, eventdata, handles);
                            set(gcf,'pointer','arrow')

                            title('This is the end result for now. Close the windows to continue.')
                            waitfor(hFigure);
                        else
                            break;
                        end
                    end
                    if ~handles.aborted
                        handles.done = true;
                    end
                end
                hObject = handles.output;
                guidata(hObject, handles);
            case 'Manual selection'
                if isfield(handles, 'imgs') == 1
                    for i = 1:length(handles.imgs)
                        handles.running = true;
                        hObject = handles.output;
                        guidata(hObject, handles)
                        pause(0.3);
                        handles.indexImg = i;
                        sizeScreen = get(0,'Screensize');
                        hFigure = figure('name', [handles.data(i).name ' size:' int2str(size(handles.imgs{i},2)) 'x' int2str(size(handles.imgs{i},1))], ...
                            'NumberTitle','off', 'Position', [0.17*sizeScreen(3) 1 0.83*sizeScreen(3) 0.85*sizeScreen(4)]);
                        handles.figure2 = hFigure;
                        hObject = handles.output;
                        guidata(hObject, handles)
                        set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
                        if isempty(handles.ov{i})
                            imshow(handles.imgs{i});
                        else
                            imshow(handles.ov{i});
                        end
                        set(hFigure, 'MenuBar', 'none');
                        set(hFigure, 'ToolBar', 'figure');
                        h = uicontrol('style', 'togglebutton', 'Position', ...
                            [30 30 200 40],'String', ...
                            'Zoom', 'Callback', {@doZoom, handles.figure1});
                        handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                        if handles.aborted
                            break
                        end
                        handles = showResults(hObject, eventdata, handles);
                        h = uicontrol('style', 'togglebutton', 'Position', ...
                            [30 30 200 40],'String', ...
                            'Zoom', 'Callback', {@doZoom, handles.figure1});
                        handles.pars.maxcelldiam = handles.maxcelldiam;
                        handles.pars.avcellsize  = 1.2*handles.minArea;
                        handles.pars.mincellsize = handles.minArea;
                        handles.pars.areavec     = [0.5*handles.minArea handles.minArea handles.maxArea 2*handles.maxArea];
                        hObject = handles.output;
                        guidata(hObject, handles)
                        if handles.maxNum == 1
                            changed = false;
                            while ~changed
                                title(['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{i})))) ...
                                        '. \rm Left click adds cells, right click removes cells and middle click updates.'])
                                I = handles.BW{i};
                                handles = manualAddRem(handles.figure1);
                                I = sum(sum(I-handles.BW{i}));
                                handles = showResults(hObject, eventdata, handles);
                                if I == 0
                                    changed = true;
                                else
                                    changed = false;
                                end
                            end
                        else
                            title(['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{i})))) ...
                                        '. \rm Left click adds cells, right click removes cells and middle click updates.'])
                            handles = manualAddRem(handles.figure1);
                            handles = showResults(hObject, eventdata, handles);
                        end
                        handles = guidata(handles.figure1);
                        if ~handles.aborted
                            handles = showResults(hObject, eventdata, handles);
                            handles.running = false;
                            hObject = handles.output;
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
                        else
                            break;
                        end
                    
                    end
                    if ~handles.aborted
                        handles.done = true;
                    end
                end
        end
        if handles.aborted
            set(handles.instructions, 'String', ...
                'Process has been aborted. Please run again.')
        else

            handles = visualizeData(hObject, eventdata, handles);
            if handles.maxNum == 1
                set(handles.instructions, 'String', ...
                    ['Completed. After correction ' num2str(handles.seg_count{i}) ' cells were segmented.'])
            else
                set(handles.instructions, 'String', ...
                    'Completed. If you wish to correct the results then click on the image you wish to correct.')
            end
        end
        hObject = handles.output;
        guidata(hObject, handles);
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    

function handles = checkCorrectionRadioButtons(hObject, eventdata, handles)
    try
        correctionSel = get(handles.correctionRadioButtons, 'SelectedObject');
        correctionSel = get(correctionSel,'String');
        if isfield(handles, 'iImg') == 0
            handles.indexImg = 1;
        end
        i = handles.indexImg;
        objinfo.pixrev   = false;
        objinfo.switch   = 0;
        if sum(size(handles.norImg{i})) == 0
            handles.norImg{i}= im_norm(double(mean(handles.imgs{i},3)), ...
                [1 99], 'minmax', objinfo, 0);
        end;
        handles.aborted = false;
        switch correctionSel
            case 'Fast marching'

                processSel = get(handles.processRadioButtons, 'SelectedObject');
                processSel = get(processSel,'String');
                switch processSel
                    case 'Manual selection'
                        title('Please click on the center of each colony. Press enter to continue.')
                    otherwise
                        title('Please click on a small and big cell. Press enter to continue.')
                end
                try
                    [x,y,~]          = impixel;
                    currentState = enableDisableFig(handles.figure1, 'off');
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
            case 'Ellipse'
                processSel = get(handles.processRadioButtons, 'SelectedObject');
                processSel = get(processSel,'String');
                switch processSel
                    case 'Manual selection'
                        title('Please mark each colony. For more information hover over the Ellipse radio button.');
                    otherwise
                        title('Please mark a small and a big colony. For more information hover over the Ellipse radio button.');
                end
                
                while 1
                    try
                        h = imellipse;
                        wait(h);
                    catch
                        continue
                    end
                    if isempty(h) || ~isvalid(h)
                        break
                    else
                        BW = createMask(h);
                        BWempty = isempty(handles.BW{i});
                        if BWempty
                            handles.BW{i} = BW;
                        else
                            handles.BW{i} = BW | handles.BW{i};
                        end
                        hObject = handles.output;
                        guidata(hObject, handles)
                    end
                end
            case 'Freehand'
                processSel = get(handles.processRadioButtons, 'SelectedObject');
                processSel = get(processSel,'String');
                switch processSel
                    case 'Manual selection'
                        title('Please mark each colony. For more information hover over the Freehand radio button.');
                    otherwise
                        title('Please mark a small and a big colony. For more information hover over the Freehand radio button.');
                end

                while 1
                    try
                        h = imfreehand;
                        if isempty(h.getPosition)
                            continue
                        else
                            wait(h);
                        end
                    catch
                        break
                    end
                    if isempty(h) || ~isvalid(h)
                        break
                    else
                        BW = createMask(h);
                        BWempty = isempty(handles.BW{i});
                        if BWempty
                            handles.BW{i} = BW;
                        else
                            handles.BW{i} = BW | handles.BW{i};
                        end
                        hObject = handles.output;
                        guidata(hObject, handles)
                    end
                end
        end
        if ~exist('BW','var')
            handles.aborted = true;
        end

        if ~handles.aborted
            BWempty = isempty(handles.BW{i});
            if BWempty
                handles.BW{i} = BW;
            else
                handles.BW{i} = BW | handles.BW{i};
            end
            hObject = handles.output;
            guidata(hObject, handles)
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end


function updatePageText(hObject, eventdata, handles)
    try
        set(handles.pageText, 'String', ...
            [num2str(handles.iImg+1) '/' num2str(handles.maxiImg)])
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end

function handles = visualizeData(hObject, eventdata, handles)
    try
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
            figure(handles.figure1);
            multipage = false;
            if isfield(handles, 'iImg') == 1
                num_img = handles.maxNum;
                if num_img > 12
                    x = 4;
                    y = 4;
                    titleLength = 13;
                    if num_img > 16
                        y = 5;
                        if num_img > 20
                            multipage = true;
                        end
                    end
                elseif num_img > 6
                    x = 3;
                    y = 3;
                    titleLength = 16;
                    if num_img > 9
                        y = 4;
                    end
                elseif num_img > 2
                    x = 2;
                    y = 2;
                    titleLength = 30;
                    if num_img > 4
                        y = 3;
                        titleLength = 22;
                    end
                else
                    x = 1;
                    y = 1;
                    titleLength = 72;
                    if num_img > 1
                        y = 2;
                        titleLength = 38;
                    end
                end
                
                if ismac
                    separator = '/';
                elseif isunix
                    separator = '/';
                elseif ispc
                    separator = '\';
                else
                    disp('Platform not supported')
                end
                handles.titleLength = titleLength;
                set(handles.nextPicButton, 'Enable', 'Off')
                set(handles.prevPicButton, 'Enable', 'Off')
                currentState = enableDisableFig(handles.figure1, 'off');
                for i  = handles.maxPics*handles.iImg+1 : ...
                        min(num_img, handles.maxPics*(handles.iImg+1))
                    if isempty(handles.imgs{i})
                        if ~isdeployed
                            handles.imgs{i} = imread(handles.data(i).name);
                        else
                            handles.imgs{i} = imread([handles.fName separator handles.data(i).name]);
                        end
                    end
                    ii = i - handles.iImg*handles.maxPics;
                    figure(handles.figure1);
                    if num_img == 1
                        handles.indexImg = 1;
                        if isempty(handles.BW{i})
                            imshow(handles.imgs{i});
                        else
                            imshow(handles.ov{i});
                        end
                    else
                        handles.x = x;
                        handles.y = y;
                        subplot(x,y,ii);
                        if isempty(handles.BW{i})
                            a = subimage(handles.imgs{i});
                        else
                            a = subimage(handles.ov{i});
                        end

                        set(a,'ButtonDownFcn', {@(u,v)singlePicture(u, v, handles.figure1, i)});
                        if multipage && isempty(handles.imgs{handles.maxNum})
                            set(handles.instructions, 'String', ...
                                ['Please wait while all the pictures are loaded (' ...
                                num2str(i/handles.maxNum*100) '%)'])
                        else
                            set(handles.instructions, 'String', ...
                                ['Please wait while all the pictures are loaded (' ...
                                num2str(min(100, ((ii)/min(num_img- handles.iImg*handles.maxPics, handles.maxPics)*100))) '%)'])
                        end
                    end
                    set(gca,'visible','off');
                    titleOfImage =  strrep(handles.data(i).name, '_', '\_');
                    if length(titleOfImage) > titleLength + 4
                        titleOfImage = strcat(titleOfImage(1:titleLength), '...');
                    end
                    title(['\color{white}' titleOfImage]);
                    set(findall(gca, 'type', 'text'), 'visible', 'on')
                    drawnow();
                end
                if multipage && isempty(handles.imgs{handles.maxNum})
                    for i  = 21 : handles.maxNum
                        if isempty(handles.imgs{i})
                            if ~isdeployed
                                handles.imgs{i} = imread(handles.data(i).name);
                            else
                                handles.imgs{i} = imread([handles.fName separator handles.data(i).name]);
                            end
                        end
                        set(handles.instructions, 'String', ...
                            ['Please wait while all the pictures are loaded (' ...
                            num2str(i/handles.maxNum*100) '%)'])
                        drawnow();
                    end
                end
                currentState = enableDisableFig(handles.figure1, 'on');
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
        if isfield(handles, 'done') == 1 && ~handles.done || isfield(handles, 'done') == 0
            set(handles.instructions, 'String', ...
                ['Thank you for waiting. All the pictures are loaded. Continue with a process method of your choice.'])
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME)
    end
    
    
function closeReq(hObject, eventdata, hGui)
    try
        handles = guidata(hGui);
        if isfield(handles, 'running') == 0 || ~handles.running
            delete(handles.figure2)
            set(gcf,'pointer','arrow')
        else
            selection = questdlg('Do you wish to abort a running process?',...
                'Close Window?',...
                'Yes','No','Yes');
            switch selection
                case 'Yes'
                    handles.aborted = true;
                    hObject = handles.output;
                    guidata(hObject, handles)
                    delete(handles.figure2)
                    set(gcf,'pointer','arrow')
                    set(handles.runButton,'Enable','on')
                    set(handles.addImages,'Enable','on')
                    set(handles.addDir,'Enable','on')
                case 'No'
                    return
            end
        end
        if isfield(handles, 'figure2') == 1
            handles = rmfield(handles, 'figure2');
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
% function doScroll(e)
%     disp(e)
%     C = get (gca, 'CurrentPoint');
%     disp(num2str(C(1,1)))
%     value = e.VerticalScrollCount;
%     if value > 0
%         zoom(0.5);
%     else
%         zoom(2);
%     end
    

function doZoom(src, event, hGui)
    try
        handles = guidata(hGui); 
        if strcmp(src.String, 'Zoom')
            set(src, 'String', 'Continue')
            handles.zooming = true;
            hObject = handles.output;
            guidata(hObject, handles)
            zoom('on')
            uiwait(gcf)
        else
            set(src, 'String', 'Zoom')
            handles.zooming = false;
            hObject = handles.output;
            guidata(hObject, handles)
            zoom('off')
            uiresume(gcbf)
            uiresume(gcbf)
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
       
    
    
function closeAndRefresh(hObject, eventdata, hGui)
    try
        handles = guidata(hGui); 
        delete(handles.figure2)
        
        nof = findall(0,'type','figure');
        set(handles.instructions, 'ForegroundColor', [0.984 0.969 0.969]);
        if length(nof) == 1
            if isequal(get(handles.instructions, 'String'), 'Please close the other window before opening a new one.')
                set(handles.instructions, 'String', ...
                    handles.instructionsText);
            end
        end
        if isfield(handles, 'zooming')
            handles.closing = true;
        end
        ii = mod(handles.indexImg, handles.maxPics+1);
        figure(handles.figure1);
        subplot(handles.x,handles.y,ii);
        if isempty(handles.BW{handles.indexImg})
            a = subimage(handles.imgs{handles.indexImg});
        else
            handles = createOverlay(hObject, eventdata, handles);
            a = subimage(handles.ov{handles.indexImg});
        end

        set(a,'ButtonDownFcn', {@(u,v)singlePicture(u, v, handles.figure1, handles.indexImg)});
        set(gca,'visible','off');
        titleLength = handles.titleLength;
        titleOfImage =  strrep(handles.data(handles.indexImg).name, '_', '\_');
        if length(titleOfImage) > titleLength + 4
            titleOfImage = strcat(titleOfImage(1:titleLength), '...');
        end
        title(['\color{white}' titleOfImage]);
        set(findall(gca, 'type', 'text'), 'visible', 'on')
        drawnow();
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
    
    
function closeResults(hObject, eventdata, hGui)
    try
        handles = guidata(hGui); 
        delete(handles.figure2)
        
        nof = findall(0,'type','figure');
        set(handles.instructions, 'ForegroundColor', [0.984 0.969 0.969]);
        if length(nof) == 1
            if isequal(get(handles.instructions, 'String'), 'Please close the other window before opening a new one.')
                set(handles.instructions, 'String', ...
                    handles.instructionsText);
            end
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
    
function singlePicture(hObject, eventdata, hGui, i)
    try
        switch get(gcf,'SelectionType')
            case 'normal' % Click left mouse button.
                handles = guidata(hGui); % https://de.mathworks.com/matlabcentral/answers/284574-handles-not-being-updated-with-guidata-in-callback
                handles.indexImg = i;
                nof = findall(0,'type','figure');
                if length(nof) > 1
                    if ~isequal(get(handles.instructions, 'String'), 'Please close the other window before opening a new one.')
                        handles.instructionsText = get(handles.instructions, 'String');
                        handles.instructionsColor = get(handles.instructions, 'ForegroundColor');
                    end
                    set(handles.instructions, 'String', ...
                        'Please close the other window before opening a new one.')
                    set(handles.instructions, 'ForegroundColor', [1 0 0])
                    hObject = handles.output;
                    guidata(hObject, handles);
                else        
                    if sum(size(handles.results{1})) == 0
                        hObject = handles.output;
                        guidata(hObject, handles);
                        sizeScreen =get(0,'Screensize');
                        hFigure = figure('name', [handles.data(i).name ' size:' int2str(size(handles.imgs{i},2)) 'x' int2str(size(handles.imgs{i},1))], ...
                            'NumberTitle','off', 'Position', [0.17*sizeScreen(3) 1 0.83*sizeScreen(3) 0.85*sizeScreen(4)]);
                        set(hFigure, 'MenuBar', 'none');
                        set(hFigure, 'ToolBar', 'figure');
                        handles.figure2 = hFigure;
                        hObject = handles.output;
                        guidata(hObject, handles);
                        %             set(hFigure, 'WindowScrollWheelFcn', @(o,e)doScroll(e));
                        %             set(hFigure, 'CloseRequestFcn', @(o,e)closeReq(hObject, eventdata,  handles.figure1));
                        %             set(hFigure, 'WindowButtonDownFcn', @(o,e)clicking(e));
                        if(isempty(handles.results{1}))
                            set(hFigure, 'CloseRequestFcn', @(o,e)closeAndRefresh(hObject, eventdata,  handles.figure1));
                            h = uicontrol('style', 'togglebutton', 'Position', ...
                                [30 30 200 40],'String', ...
                                'Zoom', 'Callback', {@doZoom, handles.figure1});
                        end
        %                 uiwait(gcf)

        %                 if h.Value == 1


                        processSel = get(handles.processRadioButtons, 'SelectedObject');
                        processSel = get(processSel,'String');
                        if isfield(handles, 'done') == 0 && strcmp(processSel, 'Fully automated') == 1 || isfield(handles, 'done') == 1 && handles.done == true
                            while 1
                                BWempty = isempty(handles.BW{i});
                                if BWempty
                                    im = handles.imgs{i};
                                else
                                    im = handles.ov{i};
                                end
                                imshow(im);
                                set(gca,'visible','off');


                                processSel = get(handles.processRadioButtons, 'SelectedObject');
                                processSel = get(processSel,'String');
                                switch processSel
                                    case 'Fully automated'
                                        if isfield(handles, 'minArea') == 0
                                            figure(hFigure);
                                            title('Please select a small and a big colony from all the images.')
                                        end
                                        if isfield(handles, 'done') == 0
                                            handles = checkCorrectionRadioButtons(hObject, eventdata, handles);
                                            if isfield(handles, 'aborted') == 1 && handles.aborted
                                                break
                                            end
                                        end
                                        handles = showResults(hObject, eventdata, handles);
                                        currentState = enableDisableFig(handles.figure1, 'on');
                                    otherwise
                                        if isfield(handles, 'done') == 0 && strcmp(processSel, 'Fully automated') == 1
                                            impixelinfo;                                    
                                        end
                                end
                                if isfield(handles, 'done') == 1 && handles.done && isfield(handles, 'aborted') == 1 && ~handles.aborted
                                    figure(hFigure);
                                    title(['The result is \it n = ' num2str(max(max(bwlabel(handles.BW{i})))) ...
                                        '. \rm Left click adds cells, right click removes cells and middle click updates.'])
     
                                    handles = manualAddRem(handles.figure1);
                                    %                             title(['\it n = ' num2str(max(max(bwlabel(handles.BW{i}))))])
                                    wfig = gcf;
                                    if strcmp(wfig.Name, 'AutoCellSeg') == 1
                                        break
                                    end
                                    handles = showResults(hObject, eventdata, handles);
                                else
                                    break
                                end
                                hObject = handles.output;
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
                            impixelinfo;
                            set(gca,'visible','off');
                            set(findall(gca, 'type', 'text'), 'visible', 'on')
                        end
                    else
                        hObject = handles.output;
                        guidata(hObject, handles);
                        sizeScreen =get(0,'Screensize');
                        hFigure = figure('name', char(handles.resultsName(i)), 'NumberTitle', ... 
                            'off', 'Position', [0.17*sizeScreen(3) 1 0.83*sizeScreen(3) 0.85*sizeScreen(4)]);
                        set(hFigure, 'MenuBar', 'none');
                        set(hFigure, 'ToolBar', 'figure');
                        set(hFigure, 'CloseRequestFcn', @(o,e)closeResults(hObject, eventdata,  handles.figure1));
                        handles.figure2 = hFigure;
                        hObject = handles.output;
                        guidata(hObject, handles);
                        imshow(handles.results{i});
                        set(gca,'visible','off');
                    end
                    if isfield(handles, 'aborted') == 1 && ~handles.aborted
                        hObject = handles.output;
    %                     handles = visualizeData(hObject, eventdata, handles);
                        guidata(hObject, handles);
                    end
                end
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handles = createOverlay(hObject, eventdata, handles)
    try
        pars = handles.pars;
        if isfield(pars, 'feats') == 1
            handles.pars.feats       = {'Area', 'MinorAxisLength', ...
                    'MeanIntensity', 'Eccentricity', 'Radius'};
            handles = process(hObject, eventdata, handles);
        end
        i = handles.indexImg;        
        if isfield(handles, 'strarray') == 0 || length(handles.strarray) < i
            colour = handles.pars.Color;
        elseif strcmp(handles.strarray{i}, handles.test) == 1
            colour = handles.pars.Color;
        elseif strcmp(handles.strarray{i}, handles.control) == 1
            if handles.ctrlen == handles.lgtlen
                colour = [1 1 1] - handles.pars.Color;
            else
                colour = handles.pars.Color;
            end
        else
            colour = handles.pars.Color;
        end
        handles.ov{i} = imoverlay(handles.imgs{i}, ...
            imdilate(bwperim(handles.BW{i}), ones(3)), colour);
        hObject = handles.output;
        guidata(hObject, handles);
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handles = createOverlays(hObject, eventdata, handles)
    try
        i = handles.indexImg;
        for l = 1:handles.maxNum
            handles.indexImg = l;
            handles = createOverlay(hObject, eventdata, handles);
        end
        handles.indexImg = i;
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
        
        
function handles = showResults(hObject, eventdata, handles)
    try
        i                       = handles.indexImg;
        preSelectInfo           = regionprops(handles.BW{i}, handles.norImg{i}, ...
            'Area', 'MajorAxisLength', 'PixelIdxList', 'MeanIntensity');
        if isfield(handles, 'minArea') == 0
            handles.minInten    = min([preSelectInfo.MeanIntensity]);
            handles.minIntenInd = i;
            handles.maxInten    = max([preSelectInfo.MeanIntensity]);
            handles.maxIntenInd = i;
            handles.minArea     = min([preSelectInfo.Area]);
            handles.minAreaInd  = i;
            handles.maxArea     = max([preSelectInfo.Area]);
            handles.maxAreaInd  = i;
            handles.maxcelldiam = max([preSelectInfo.MajorAxisLength]);
            processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles);

            set(handles.runButton,'Enable','on')

        else
            if isequal(i, handles.minIntenInd)
                handles.minInten     = min([preSelectInfo.MeanIntensity]);
            else
                minInten = min([preSelectInfo.MeanIntensity]);
                if minInten < handles.minInten
                    handles.minInten    = minInten;
                    handles.minIntenInd = i;
                end
            end    
            if isequal(i, handles.maxIntenInd)
                handles.maxInten = max([preSelectInfo.MeanIntensity]);
            else
                maxInten = max([preSelectInfo.MeanIntensity]);
                if maxInten > handles.maxInten
                    handles.maxInten    = maxInten;
                    handles.maxIntenInd = i;
                end
            end
            if isequal(i, handles.minAreaInd)
                handles.minArea     = min([preSelectInfo.Area]);
            else
                minArea = min([preSelectInfo.Area]);
                if minArea < handles.minArea
                    handles.minArea    = minArea;
                    handles.minAreaInd = i;
                end
            end            
            if isequal(i, handles.maxAreaInd)
                handles.maxArea     = max([preSelectInfo.Area]);
            else
                maxArea = max([preSelectInfo.Area]);
                if maxArea > handles.maxArea
                    handles.maxArea    = maxArea;
                    handles.maxAreaInd = i;
                end
            end
        end
        if  sum(sum(handles.BW{handles.indexImg})) > 0
            seg_count = max(max(bwlabel(handles.BW{handles.indexImg})));
        else
            seg_count = 0;
        end
        handles.areavec{i}      = [preSelectInfo.Area];
        handles.seg_count{i}    = seg_count;
        handles.Ifeat           = [handles.minInten handles.maxInten];
        handles = createOverlay(hObject, eventdata, handles);
        imshow(handles.ov{i});

        if isfield(handles, 'done') == 0 || isfield(handles, 'done') == 1 && ~handles.done
            if isvalid(handles.figure2)
                figure(handles.figure2);
                title(['Thank you for selecting. The MinArea = ' num2str(handles.minArea) ...
                    ' and MaxArea = ' num2str(handles.maxArea) ' have been calculated.'])
            end
        end
        correctionSel = get(handles.correctionRadioButtons, 'SelectedObject');
        correctionSel = get(correctionSel,'String');
        switch correctionSel
            case 'Fast marching'
                if isfield(handles, 'done') == 0
                    if  isfield(handles, 'running') == 0
                        pause(2);
                        nof = findall(0,'type','figure');
                        if length(nof) > 1
                            close(handles.figure2);
                        end
                        set(gcf,'pointer','arrow')
                    end
                end
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handles = resetGUI(hObject, eventdata, handles)
    try
        handles = resetFigure(hObject, eventdata, handles);
        if isfield(handles, 'wsvectext') == 1
            handles = rmfield(handles, 'wsvectext');
        end
        if isfield(handles, 'otsuvectext') == 1
            handles = rmfield(handles, 'otsuvectext');
        end
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
        if isfield(handles, 'filename') == 1
            handles = rmfield(handles, 'filename');
        end
        if isfield(handles, 'indexImg') == 1
            handles = rmfield(handles, 'indexImg');
        end
        if isfield(handles, 'titleLength') == 1
            handles = rmfield(handles, 'titleLength');
        end
        if isfield(handles, 'x') == 1
            handles = rmfield(handles, 'x');
        end
        if isfield(handles, 'y') == 1
            handles = rmfield(handles, 'y');
        end
        if isfield(handles, 'figure2') == 1
            handles = rmfield(handles, 'figure2');
        end
        if isfield(handles, 'aborted') == 1
            handles = rmfield(handles, 'aborted');
        end
        if isfield(handles, 'minInten') == 1
            handles = rmfield(handles, 'minInten');
        end
        if isfield(handles, 'minIntenInd') == 1
            handles = rmfield(handles, 'minIntenInd');
        end
        if isfield(handles, 'maxInten') == 1
            handles = rmfield(handles, 'maxInten');
        end
        if isfield(handles, 'maxIntenInd') == 1
            handles = rmfield(handles, 'maxIntenInd');
        end
        if isfield(handles, 'minAreaInd') == 1
            handles = rmfield(handles, 'minAreaInd');
        end
        if isfield(handles, 'maxAreaInd') == 1
            handles = rmfield(handles, 'maxAreaInd');
        end
        if isfield(handles, 'Ifeat') == 1
            handles = rmfield(handles, 'Ifeat');
        end
        set(handles.addImages,'Enable','on')
        set(handles.addDir,'Enable','on')
        set(handles.prevPicButton, 'Enable', 'Off')
        set(handles.nextPicButton, 'Enable', 'Off')
        set(handles.showresultsbutton,'Enable','off')
        set(handles.saveButton,'Enable','off')
        set(handles.runButton,'Enable','off')
        set(handles.resetButton,'Enable','off')


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
            %% Datapaths and codepath
            
            if isunix
                addpath(genpath('/home/angelo/Documents/Workspace/AutoSeg/MATLAB/code'))
                addpath(genpath('/home/angelo/Documents/Workspace/AutoSeg/MATLAB/GUI'))
            elseif ispc
                addpath('C:\AutoCellSeg\MATLAB\code')
                addpath('C:\AutoCellSeg\MATLAB\GUI')
            else
                disp('Platform not supported')
            end
            % code path Arif
            % code path Angelo

            % Adding all paths
            cd(datapath)
        end
        hObject = handles.output;
        guidata(hObject, handles);
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handles = resetFigure(hObject, eventdata, handles)
    try
        c = get(handles.figure1, 'Children');
        for i = 1:length(c)
            if strcmp(c(i).Type, 'axes')
                delete(c(i))
            end
        end
        
        set(handles.instructions, 'ForegroundColor', [0.984 0.969 0.969], ...
            'String', 'Welcome to AutoCellseg. ')
        
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
% --- Executes on button press in nextPicButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextPicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    
    try
        set(handles.runButton,'Enable','off')
        set(handles.addImages,'Enable','off')
        set(handles.addDir,'Enable','off')
        handles = checkProcessRadioButtons(hObject, eventdata, handles);
        if ~handles.aborted
            set(handles.runButton,'Enable','on')
            if handles.ctrlen > 0 && handles.lgtlen > 0 && ~isempty(handles.inds{1}) && ...
                    handles.ctrlen == handles.lgtlen && (handles.ctrlen + handles.lgtlen) == handles.maxNum
                set(handles.showresultsbutton,'Enable','on')
            end
            set(handles.addImages,'Enable','on')
            set(handles.addDir,'Enable','on')
            set(handles.saveButton,'Enable','on')
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    try
        handles = resetGUI(hObject, eventdata, handles);
        set(gcf,'pointer','arrow')
        set(handles.figure1, 'HandleVisibility', 'off');
        close all;
        set(handles.figure1, 'HandleVisibility', 'on');
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)    
    try
        npath   = uigetdir(handles.fName,'Please select the folder to save the results');

        if isequal(npath,0)
            disp('User selected Cancel')
            
        else
            set(handles.instructions, 'String', ...
                'Please wait while the results are being saved. ')
            set(gcf,'pointer','watch')
            featmat = handles.featmat;
            pars    = handles.pars;
            data    = handles.data;

            if ismac
                separator = '/';
            elseif isunix
                separator = '/';
            elseif ispc
                separator = '\';
            else
                disp('Platform not supported')
            end

            %% Write segmented images to '\results' directory
            for i = 1:length(handles.imgs)
                imwrite(handles.BW{i}, [npath separator data(i).name(1:end - 4) '_mask.jpg'], 'jpg')
                imwrite(handles.ov{i}, [npath separator data(i).name(1:end - 4) '_seg.jpg'], 'jpg')
            end

            %% Write colony features to text file
            fileID = fopen([npath separator 'BacteriaColonySegSummary.txt'],'wt');
            fprintf  (fileID,'%30s %10s %9s %11s %15s \n', 'Image name', ...
                'Colony count', 'Mean area', 'Mean radius', 'Mean eccentricity');
            for k = 1 : size(featmat,1)
                fprintf(fileID,'\n %30s %3i %5.1f %2.2f %1.2f \n', ...
                    [data(k).name(1:end - 4) ' seg'], ...
                    featmat(k,1), ...
                    featmat(k,2), featmat(k,3), featmat(k,4));
                sumStruct(k).ImageName        = num2str([data(k).name(1:end - 4) ' seg']);
                sumStruct(k).ColonyCount      = featmat(k,1);
                sumStruct(k).MeanArea         = featmat(k,2);
                sumStruct(k).MeanRadius       = featmat(k,3);
                sumStruct(k).MeanEccentricity = featmat(k,4);
            end

            fclose(fileID);

            % write results to '\results' directory
            if sum(size(handles.results{1})) ~= 0                
                for i = 1:length(handles.results)
                    imwrite(handles.results{i}, [npath separator handles.resultsName{i}(1:end - 4) '.jpg'], 'jpg')
                end
            end
            set(gcf,'pointer','arrow')
            set(handles.instructions, 'String', ...
                'Thank you for waiting. All the results have been saved.')

            tableEntries = {'ExperimentNumber', 'ColonyID', 'Size', ...
                'MinorAxisLength', 'Eccentricity', 'MeanIntensity', 'Radius', 'Type'};
            T = array2table(handles.fullmat, 'VariableNames',tableEntries);
            writetable(T,[npath separator 'BacteriaColonySegFull.csv'])
            T1 = struct2table(sumStruct);
            writetable(T1,[npath separator 'BacteriaColonySegSummary.csv'])

            fid = fopen([npath separator 'Parameters.dat'],'wt');
            fprintf(fid, '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n', ...
                ['Border buffer in cropping (in pixels): ' num2str(handles.pars.sImBorder)], ...
                ['Extract petridish? (1 = true / 0 = false): ' num2str(handles.pars.dishextract)], ...
                ['Average circularity (0(circle) - 1(line)): ' num2str(handles.pars.avcellecc)], ...
                ['Gaussian filter size: ' num2str(handles.pars.gausfltsize)], ...
                ['Segmentation (threshold) (min:step:max): ' handles.pars.otsuvectext], ...
                ['Segmentation (watershed) (min:step:max): ' handles.pars.wsvectext], ...
                ['Channel selection (1 = red 2 = green 3 = blue): ' num2str(handles.pars.chnnlselect)], ...
                ['Adapting histogram (1 = true / 0 = false): ' num2str(handles.pars.adapthist)], ...
                ['A-Priori intensity selection (1 = true / 0 = false): ' num2str(handles.pars.apriointen)], ...
                ['Bandwith for the kde plot: ' num2str(handles.pars.bw)], ...
                ['Name for control images: ' handles.control], ...
                ['Name for test images: ' handles.test], ...
                ['Color scheme [R G B]: ' num2str(handles.pars.Color)], ...
                ['Fast marching threshold (0 - 1): ' num2str(handles.ffthresh)], ...
                ['Include edge detection (1 = true / 0 = false): ' num2str(handles.edge)]);
            fclose(fid);
        end
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
    
% --- Executes on button press in showresultsbutton.
function showresultsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to showresultsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    set(handles.instructions, 'String', ...
        'Please wait while the results are being created (0%)')
    
    set(gcf,'pointer','watch')
    featmat = handles.featmat;
    pars    = handles.pars;
    data    = handles.data;
    
    if ~isempty(handles.inds{1})
        fname   = pars.im_name{1}(handles.inds{1}:(end-4));
        namfind = strfind(fname, handles.control);
        endfind = strfind(fname, [handles.control(end) ' ']);
    else
        newi = strfind(pars.im_name{1},'.');
        fname   = pars.im_name{1}(1:newi(end)-1);
    end
    tdata   = length(data);
    bwidth  = pars.bw;
    si1     = 1 ;
    si2     = 1;
    
    %PLOT 1
    cstr = {'-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g', ...
        '-g', '--g', ':g', '-.g', '-g', '--g', ':g', '-.g'};
    lstr = {'-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r', ...
        '-r', '--r', ':r', '-.r', '-r', '--r', ':r', '-.r'};
    figure('Visible','off')
    for i = 1 : tdata
        if strcmp(handles.strarray{i}, handles.control) == 1
            if~isempty(handles.areavec{i})
                [f, xi] = ksdensity(handles.areavec{i}, 'width', bwidth);
                if i < 10
                    t2 = mod(i,handles.lgtlen);
                    if t2 == 0
                        t2 = handles.lgtlen;
                    end
                    plot(xi,f,cstr{t2},'LineWidth',2)
                else
                    plot(xi,f,cstr{handles.lgtlen},'LineWidth',2)
                end
                si1  = si1 + 1;
                a    = trapz(xi);
                A(i) = a/numel(handles.areavec{i});
                b    = trapz(handles.areavec{i});
                B(i) = b/numel(handles.areavec{i});
                hold on
            else
                f = [];
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
            else
                f = [];
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
            else
                f = [];
            end
        end
    end
    set(gca,  'FontSize', 18)
    xlabel('Colony sizes (in pixels)', 'FontSize', 20)
    ylabel('KDE', 'FontSize', 20)
    handles.resultsTitle{1} = [handles.control ' vs. ' handles.test ' (using KDE)'];
    newname = strrep(pars.im_name{1}(handles.inds{1}:(end-4)), '_', '\_');
    title([handles.resultsTitle{1} ' for ' num2str(newname)], 'FontSize', 20)
    
    % Write the strings for control and test
    ctrind = find(cellfun('length',regexp(handles.strarray,handles.control)) == 1);
    tstind = find(cellfun('length',regexp(handles.strarray,handles.test)) == 1);
    for i = 1 : handles.ctrlen
        handles.nstrarray{ctrind(i)} = [handles.strarray{ctrind(i)} ...
            num2str(i)];
    end
    for i = 1 : handles.lgtlen
        handles.nstrarray{tstind(i)} = [handles.strarray{tstind(i)} ...
            num2str(i)];
    end
    
    for i = 1 : length(handles.areavec)
        if ~isempty(handles.areavec{i})
            % MAKE IT 1 to 4
            strar(i) = cellstr([char(handles.nstrarray{i}) ' n = ' num2str(handles.seg_count{i})]);
        else
            strar(i) = cellstr([char(handles.nstrarray{i}) ' n = 0' ]);
        end
    end
    legend(strar, 'Location', 'NorthEast')
    grid on
    
    
    % Save results in handles.results
    screen_size     = get(0, 'ScreenSize');
    fig             = gcf;
    set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
    handles.results{1} = print(fig, '-RGBImage');
    handles.resultsName{1} = 'kde.jpg';
    wfig = gcf;
    if strcmp(wfig.Name, 'AutoCellSeg') == 0
        close(gcf);
    end
    
    if handles.maxNum > 1
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (20%)')
        if ~isempty(f)
            fnew  = f(50:65);
            ff    = linspace(min(fnew), max(fnew),tdata);
        end
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
            'g-x', 'r-x', 'b-x', 'c-x', 'm-x', 'k-x', ...
            'g--x', 'r--x', 'b--x', 'c--x', 'm--x', 'k--x', ...
            'g:x', 'r:x', 'b:x', 'c:x', 'm:x', 'k:x', ...
            'g-x', 'r-x', 'b-x', 'c-x', 'm-x', 'k-x', ...
            'g--x', 'r--x', 'b--x', 'c--x', 'm--x', 'k--x', ...
            'g:x', 'r:x', 'b:x', 'c:x', 'm:x', 'k:x', ...
            'g-x', 'r-x', 'b-x', 'c-x', 'm-x', 'k-x'};
        
        
        %PLOT 2
        strfig = '';
        figure('Visible','off');
        lvec   = [l1 l2];
        lvec(lvec == 0) = [];
        mcct   = zeros(l1,1);
        mcli   = zeros(l2,1);
        
        for k = 1 : min(lvec)
            % Total area from curve plot
            if l1>0 && l2>0
                plot(t,[CtCA(k);LiCA(k)], plst{k} ,'LineWidth',2, ...
                    'MarkerSize',10)
                mcct(k) = numel(handles.areavec{k});
                mcli(k) = numel(handles.areavec{k+l2});
            elseif l1>0 && l2<1
                plot(t(1),CtCA(k), plst{k} ,'LineWidth',2, 'MarkerSize',10)
                mcct(k) = numel(handles.areavec{k});
            elseif l2>0 && l1<1
                plot(t(2),LiCA(k), plst{k} ,'LineWidth',2, 'MarkerSize',10)
                mcli(k) = numel(handles.areavec{k});
            else
                error('No control or test images')
            end
            grid on
            hold on
            strfig{k} = ['Exp ' num2str(k)];
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
        handles.resultsName{5} = 'KDEArea.jpg';
        wfig = gcf;
        if strcmp(wfig.Name, 'AutoCellSeg') == 0
            close(gcf);
        end
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (40%)')
        
        %PLOT 3
        figure('Visible','off');
        if ~isempty(LiAA) && ~isempty(CtAA)
            for k = 1 : min(l1,l2)
                % Total absolute area plot
                plot(t,[CtAA(k);LiAA(k)], plst{k} ,'LineWidth',2, 'MarkerSize',20)
                grid on
                hold on
                strtmp = ['Exp ' num2str(k)];
                strfig{k} = ['Exp ' num2str(k)];
            end
        elseif isempty(LiAA) && ~isempty(CtAA)
            for k = 1 : length(CtAA)
                % Total absolute area plot
                plot(t(1),CtAA(k), plst{k} ,'LineWidth',2, 'MarkerSize',20)
                grid on
                hold on
                strtmp = ['Exp ' num2str(k)];
                strfig{k} = ['Exp ' num2str(k)];
            end
        elseif ~isempty(LiAA) && isempty(CtAA)
            for k = 1 : length(CtAA)
                % Total absolute area plot
                plot(t(2),LiAA(k), plst{k} ,'LineWidth',2, 'MarkerSize',20)
                grid on
                hold on
                strtmp = ['Exp ' num2str(k)];
                strfig{k} = ['Exp ' num2str(k)];
            end
        else
            Error('No control or test images')
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        ylabel('Normalized Colony Size')
        xlim([0 3])
        if ~isempty(LiAA) && ~isempty(CtAA)
            ylim([min(min(CtAA),min(LiAA)) max(max(LiAA),max(CtAA))])
        elseif isempty(LiAA) && ~isempty(CtAA)
            ylim([min(CtAA) max(CtAA)])
        elseif ~isempty(LiAA) && isempty(CtAA)
            ylim([min(LiAA) max(LiAA)])
        else
            error('No test or control images')
        end
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{2} = 'Normalized Absolute Areas';
        title([handles.resultsTitle{2} ' (' newname ')'])
        
        if ~isempty(LiAA) && ~isempty(CtAA)
            text(t(end), 0.95*max(max(CtAA),max(LiAA)), ['A_C_t_r = ' ...
                num2str(floor(median(CtAA)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
            text(t(end), 0.9*max(max(CtAA),max(LiAA)), ['A_L_i = ' ...
                num2str(floor(median(LiAA)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif ~isempty(CtAA) && isempty(LiAA)
            text(t(end), 0.95*max(CtAA), ['A_C_t_r = ' ...
                num2str(floor(median(CtAA)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif isempty(CtAA) && ~isempty(LiAA)
            text(t(end), 0.9*max(max(CtAA),max(LiAA)), ['A_L_i = ' ...
                num2str(floor(median(LiAA)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        else
            Error('No control or test images')
        end
        
        
        legend(strfig, 'Location', 'NorthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{2} = print(fig, '-RGBImage');
        handles.resultsName{2} = 'Absolute Area.jpg';
        wfig = gcf;
        if strcmp(wfig.Name, 'AutoCellSeg') == 0
            close(gcf);
        end
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (60%)')
        
        %PLOT 4
        CtAA  (CtAA == 0)  = [];
        LiAA  (LiAA == -1) = 0;
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
        
        if ~isempty(LiAA) && ~isempty(CtAA)
            ylim([min(LiAA ./ CtAA)-0.1 max(max(LiAA./CtAA)+0.1,1.1)])
        elseif isempty(LiAA) && ~isempty(CtAA)
            ylim([min(CtAA)-0.1 max(max(CtAA)+0.1,1.1)])
        elseif ~isempty(LiAA) && isempty(CtAA)
            ylim([min(LiAA)-0.1 max(max(LiAA)+0.1,1.1)])
        else
            error('No test or control image to plot')
        end
        
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{3} = 'Absolute Areas Normalized to 1';
        title([handles.resultsTitle{3} ' (' newname ')'])
        
        if ~isempty(LiAA) && ~isempty(CtAA)
            text(t(2), 0.6, ['MeanVal  = ' ...
                num2str(mean(LiAA./CtAA),2)], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif isempty(LiAA) && ~isempty(CtAA)
            text(t(2), 0.6, ['MeanVal  = ' ...
                num2str(mean(CtAA),2)], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif ~isempty(LiAA) && isempty(CtAA)
            text(t(2), 0.6, ['MeanVal  = ' ...
                num2str(mean(LiAA),2)], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        else
            error('No test or control image to plot')
        end
        
        legend(strfig, 'Location', 'SouthWest')
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{3} = print(fig, '-RGBImage');
        handles.resultsName{3} = 'Absolute Area To One.jpg';
        wfig = gcf;
        if strcmp(wfig.Name, 'AutoCellSeg') == 0
            close(gcf);
        end
        set(handles.instructions, 'String', ...
            'Please wait while the results are being created (80%)')
        
        %PLOT 5
        if numel(aLic) > 0
            aLic  (aLic == 0) = [];
        end
        aLic(aLic == -1) = 0;
        
        
        if numel(aCtc) > 0
            aCtc  (aCtc == 0) = [];
        end
        aCtc(aCtc == -1) = 0;
        
        plst1 = {'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o', ...
            'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o', ...
            'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o', ...
            'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o', ...
            'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o', ...
            'g-o', 'r-o', 'b-o', 'c-o', 'm-o', 'k-o', 'y-o', ...
            'g--o', 'r--o', 'b--o', 'c--o', 'm--o', 'k--o', 'y--o'};
        
        figure('Visible','off');
        strtmp = '';
        for k = 1 : min(lvec)
            % Total absolute count plot
            if l1>0 && l2>0
                plot(t,[aCtc(k);aLic(k)],plst1{k}, ...
                    'LineWidth',2,'MarkerSize',18)
            elseif l1>0 && l2<1
                plot(t(1),aCtc(k),plst1{k}, 'LineWidth',2,'MarkerSize',18)
            elseif l2>0 && l1<1
                plot(t(2),aLic(k),plst1{k}, 'LineWidth',2,'MarkerSize',18)
            else
                error('No test or control image to plot')
            end
            grid on
            hold on
            strtmp = ['Exp ' num2str(k)];
            strfig{k} = ['Exp ' num2str(k)];
        end
        xlabel(['1: ' handles.control ' , ' ' 2: ' handles.test])
        ylabel('Colony count')
        xlim([0 3])
        
        if ~isempty(aLic) && ~isempty(aCtc)
            ylim([min(min(aLic,aCtc))-1 max(max(aLic,aCtc))+1])
        elseif isempty(aLic) && ~isempty(aCtc)
            ylim([min(min(aCtc))-1 max(max(aCtc))+1])
        elseif ~isempty(aLic) && isempty(aCtc)
            ylim([min(min(aLic))-1 max(max(aLic))+1])
        else
            error('No test or control image to plot')
        end
        
        set(gca,'XTick', [1 2], 'FontWeight', 'bold', 'FontSize', 20)
        handles.resultsTitle{4} = 'Colony Count Comparison';
        title([handles.resultsTitle{4} ' (' newname ')'])
        
        if ~isempty(aLic) && ~isempty(aCtc)
            text(0.1, 0.75*max(max(aCtc),max(aLic)), ['n_C_t_r = ' ...
                num2str(floor(median(mcct)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
            text(0.1, 0.6*max(max(aCtc),max(aLic)), ['n_L_i = ' ...
                num2str(floor(median(mcli)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif isempty(aLic) && ~isempty(aCtc)
            text(0.1, 0.75*max(max(aCtc)), ['n_C_t_r = ' ...
                num2str(floor(median(mcct)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        elseif ~isempty(aLic) && isempty(aCtc)
            text(0.1, 0.6*max(max(aLic)), ['n_L_i = ' ...
                num2str(floor(median(mcli)))], 'Color', [.7 .7 .7], ...
                'FontSize', 20)
        else
            error('No test or control image to plot')
        end
        
        legend(strfig, 'Location', 'NorthWest')
        
        
        % Save results in handles.results
        screen_size     = get(0, 'ScreenSize');
        fig             = gcf;
        set(fig, 'Position', [0 0 screen_size(3) screen_size(4)])
        handles.results{4} = print(fig, '-RGBImage');
        handles.resultsName{4} = 'Count.jpg';
        wfig = gcf;
        if strcmp(wfig.Name, 'AutoCellSeg') == 0
            close(gcf);
        end
    end
    handles = resetFigure(hObject, eventdata, handles);
    handles = visualizeData(hObject, eventdata, handles);
    set(handles.instructions, 'String', ...
        'Completed.')
    set(gcf,'pointer','arrow')
    hObject = handles.output;
    guidata(hObject, handles)
catch ME
        handlesErrors(hObject, eventdata, handles, ME);
end


% --- Executes when selected object is changed in processRadioButtons.
function processRadioButtons_SelectionChangedFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in processRadioButtons
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    try
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
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
        
% --- Executes on button press in optionbutton.
function optionbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to optionbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    try
        color   = handles.pars.Color;
        control = handles.control;
        test    = handles.test;
        pr = {'Border buffer in cropping (in pixels)', ...
            'Extract petridish? (true / false)', ...
            'Average circularity (0(circle) - 1(line))', ...
            'Gaussian filter size', ...
            'Segmentation (threshold) (min:step:max)', ...
            'Segmentation (watershed) (min:step:max)', ...
            'Channel selection (1 = red 2 = green 3 = blue)', ...
            'Adapting histogram (true / false)', ...
            'A-Priori intensity selection (true / false)', ...
            'Bandwith for the kde plot', ...
            'Name for control images', ...
            'Name for test images', ...
            'Color scheme [R G B] - e.g. [1 0 0] is Red', ...
            'Fast marching threshold (0 - 1)', ...
            'Include edge detection (true / false)'};
        dlg_title          = 'Options';
        nline              = 1;
        dflt               = {num2str(handles.pars.sImBorder), ...
            num2str(handles.pars.dishextract), ...
            num2str(handles.pars.avcellecc), ...
            num2str(handles.pars.gausfltsize), ...
            handles.pars.otsuvectext, ...
            handles.pars.wsvectext, ...
            num2str(handles.pars.chnnlselect), ...
            num2str(handles.pars.adapthist), ...
            num2str(handles.pars.apriointen), ...
            num2str(handles.pars.bw), ...
            handles.control, ...
            handles.test, ...
            num2str(handles.pars.Color), ...
            num2str(handles.ffthresh), ...
            num2str(handles.edge)};
        answer             = inputdlg(pr, dlg_title, nline, dflt);
        if ~isempty(answer)
            handles.pars.otsuvectext = answer{5};
            handles.pars.wsvectext = answer{6};

            handles.pars.sImBorder   = str2num(answer{1});
            handles.pars.dishextract = str2num(answer{2});
            handles.pars.avcellecc   = str2num(answer{3});
            handles.pars.gausfltsize = str2num(answer{4});
            handles.pars.otsuvector  = str2num(handles.pars.otsuvectext);
            handles.pars.wsvector    = str2num(handles.pars.wsvectext);
            handles.pars.chnnlselect = str2num(answer{7});
            handles.pars.adapthist   = str2num(answer{8});
            handles.pars.apriointen  = str2num(answer{9});
            handles.pars.bw          = str2num(answer{10});
            handles.control          = answer{11};
            handles.test             = answer{12};
            handles.pars.Color       = str2num(answer{13});
            handles.ffthresh         = str2num(answer{14});
            handles.edge             = str2num(answer{15});
            if isfield(handles, 'filename') == 1
                handles = extractNames(hObject, eventdata, handles);
            end
            if ~isequal(control, handles.control) || ~isequal(test, handles.test)
                handles = createOverlays(hObject, eventdata, handles);
                handles = visualizeData(hObject, eventdata, handles);                
            end
            if handles.ctrlen > 0 && handles.lgtlen > 0 && ...
                    handles.ctrlen == handles.lgtlen && ... 
                    (handles.ctrlen + handles.lgtlen) == handles.maxNum && ...
                    isfield(handles, 'done') == 1 && handles.done
                set(handles.showresultsbutton,'Enable','on')                
            else
                set(handles.showresultsbutton,'Enable','off')                
            end
            if ~isequal(color, handles.pars.Color)
                if isfield(handles, 'BW') == 1
                    test = true;
                    for i = 1 : length(handles.imgs)
                        if isempty(handles.BW{1})
                           test = false; 
                        end
                    end
                    if test
                        handles = createOverlays(hObject, eventdata, handles);
                        handles = visualizeData(hObject, eventdata, handles);
                    end
                end
            end
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end


% --- Executes on button press in loadoptions.
function loadoptions_Callback(hObject, eventdata, handles)
% hObject    handle to loadoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    nof = findall(0,'type','figure');
    if length(nof) > 1
        delete(handles.figure2);
    end
    try
        if ismac
            [filename, folder] = uigetfile( ...
                {'*.DAT;*.dat','Dat File (*.dat)'}, 'Select the parameter dump');
        elseif isunix
            [filename, folder] = uigetfile( ...
                {'*.DAT;*.dat','Dat File (*.dat)'}, 'Select the parameter dump');
        elseif ispc
            [filename, folder] = uigetfile( ...
                {'*.dat','Dat File (*.dat)'}, 'Select the parameter dump');
        else
            disp('Platform not supported')
        end

        if isequal(filename,0)
            disp('User selected Cancel')
        else
            fid = fopen([folder filename]);

            value = strsplit(fgetl(fid),':');
            handles.pars.sImBorder   = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.dishextract = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.avcellecc   = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.gausfltsize = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.otsuvectext = [value{4}(2:end) ':' value{5} ':' value{6}];
            handles.pars.otsuvector  = str2num(handles.pars.otsuvectext);
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.wsvectext   = [value{4}(2:end) ':' value{5} ':' value{6}];
            handles.pars.wsvector    = str2num(handles.pars.wsvectext);
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.chnnlselect = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.adapthist   = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.apriointen  = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.bw          = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.control          = value{2}(2:end);
            value                    = strsplit(fgetl(fid),':');  
            handles.test             = value{2}(2:end);
            value                    = strsplit(fgetl(fid),':');  
            handles.pars.Color       = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');  
            handles.ffthresh         = str2num(value{2});
            value                    = strsplit(fgetl(fid),':');            
            handles.edge             = str2num(value{2});
            
            

            fclose(fid);
        end
        if isfield(handles, 'filename') == 1
            handles = extractNames(hObject, eventdata, handles);
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handles = BacteriaColonySeg(hObject, eventdata, handles)
    try
        if handles.maxNum == 1
            set(handles.instructions, 'String', ...
                'Please wait until the algorithm ends.')
        end
        hObject = handles.output;
        guidata(hObject, handles);
        drawnow();

        pars = handles.pars;
        minArea          = handles.minArea;
        maxArea          = handles.maxArea;
        pars.maxcelldiam = handles.maxcelldiam;
        pars.avcellsize  = 1.2*minArea;
        pars.mincellsize = minArea;
        pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
        pars.Ifeat       = handles.Ifeat;

        processSel = get(handles.processRadioButtons, 'SelectedObject');
        processSel = get(processSel,'String');
        switch processSel
            case 'Fully automated'
                %% Image analysis loop for each image
                for i = 1 : length(handles.imgs)
                    pars.feats       = {'Area', 'MinorAxisLength', ...
                        'MeanIntensity', 'Eccentricity', 'Radius'};

                    handles.indexImg  = i;
                    im                = handles.imgs{i};
                    pars.im_name{i}   = handles.data(i).name;
                    pars.spmask       = false(size(im,1), size(im,2));
                    handles.pars = pars;
                    handles           = CellSeg(handles);
                    preSelectInfo     = regionprops(handles.BW{handles.indexImg}, ...
                        'Area', 'MajorAxisLength', 'PixelIdxList', 'Eccentricity');
                    % Keeping the originally selected segments
                    for newind = 1 : length(preSelectInfo)
                        if length(find(handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList)==1)) ...
                                < 0.1*length(preSelectInfo(newind).PixelIdxList)
                            handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList) = 1;
                        end
                    end
                    if handles.maxNum > 1
                        set(handles.instructions, 'String', ...
                            ['Please wait while all the pictures are processed (' ...
                            num2str(min(100, handles.indexImg/size(handles.imgs, 2)*100)) '%)'])
                        hObject = handles.output;
                        guidata(hObject, handles);
                        drawnow();
                    end
                end
            case 'Partially automated'
                pars.feats       = {'Area', 'MinorAxisLength', ...
                    'MeanIntensity', 'Eccentricity', 'Radius'};
                i                 = handles.indexImg;
                im                = handles.imgs{i};
                pars.im_name{i}   = handles.data(i).name;
                pars.spmask       = false(size(im,1), size(im,2));
                handles.pars = pars;
                handles           = CellSeg(handles);
                preSelectInfo     = regionprops(handles.BW{handles.indexImg}, ...
                    'Area', 'MajorAxisLength', 'PixelIdxList', 'Eccentricity');
                % Keeping the originally selected segments
                for newind = 1 : length(preSelectInfo)
                    if length(find(handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList)==1)) ...
                            < 0.1*length(preSelectInfo(newind).PixelIdxList)
                        handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList) = 1;
                    end
                end
                if handles.maxNum > 1
                    set(handles.instructions, 'String', ...
                        ['Please wait while all the pictures are processed (' ...
                        num2str(min(100, handles.indexImg/size(handles.imgs, 2)*100)) '%)'])
                    hObject = handles.output;
                    guidata(hObject, handles);
                    drawnow();
                end
        end
        hObject = handles.output;
        guidata(hObject, handles);

    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end


function handles = process(hObject, eventdata, handles)
    try
        pars             = handles.pars;
        
        inds             = handles.inds{handles.indexImg};


        if ~isempty(inds)
            handles.typestr      = pars.im_name{handles.indexImg}(1:inds(1)-1);
        else
            handles.typestr      = '';
        end
        
        pars.newfeats     = regionprops(handles.BW{handles.indexImg}, 'Centroid', 'PixelIdxList');

        %% Calculate features
        radiusfeatflag = false;
        stdfeatflag    = false;
        medintfeatflag = false;

        for k = 1 : length(pars.feats)
            if strcmp(pars.feats(k), 'Radius') == 1
                pars.feats = strrep(pars.feats, ...
                    'Radius', 'EquivDiameter');
                radiusfeatflag   = true;
            end
            if strcmp(pars.feats(k), 'StdDeviation') == 1
                pars.feats = strrep(pars.feats, ...
                    'StdDeviation', 'PixelValues');
                stdfeatflag   = true;
            end
            if strcmp(pars.feats(k), 'MedianIntensity') == 1
                pars.feats = strrep(pars.feats, ...
                    'MedianIntensity', 'PixelValues');
                medintfeatflag   = true;
            end
        end


        objinfo.pixrev   = false;
        objinfo.switch   = 0;
        if sum(size(handles.norImg{handles.indexImg})) == 0
            handles.norImg{handles.indexImg}= im_norm(double(mean(handles.imgs{handles.indexImg},3)), [1 99], 'minmax', objinfo, 0);
        end;

        feats = regionprops(handles.BW{handles.indexImg}, handles.norImg{handles.indexImg}, pars.feats);

        if radiusfeatflag == true
            for j = 1:length(feats)
                feats(j).Radius = feats(j).EquivDiameter/2;
            end
            feats = rmfield(feats, 'EquivDiameter');
        end

        if stdfeatflag == true
            for j = 1:length(feats)
                feats(j).StdDeviation = std(feats(j).PixelValues);
            end

            if isfield(feats, 'PixelValues') && medintfeatflag == false
                feats = rmfield(feats, 'PixelValues');
            end
        end

        if medintfeatflag == true
            for j = 1:length(feats)
                feats(j).MedianIntensity = median(feats(j).PixelValues);
            end

            if isfield(feats, 'PixelValues') && stdfeatflag == false
                feats = rmfield(feats, 'PixelValues');
            end
        end

        if isfield(feats, 'PixelValues')
            feats = rmfield(feats, 'PixelValues');
        end

        if  sum(sum(handles.BW{handles.indexImg})) > 0
            seg_count = max(max(bwlabel(handles.BW{handles.indexImg})));
        else
            seg_count = 0;
        end

        if ~isempty(feats)
            mean_area   = mean([feats.Area]);
            mean_radius = mean([feats.Radius]);
            mean_ecc    = mean([feats.Eccentricity]);
        else
            mean_area   = 0;
            mean_radius = 0;
            mean_ecc    = 0;
        end
        handles.featmat(handles.indexImg, :)   = [seg_count mean_area mean_radius mean_ecc];
        handles.areavec{handles.indexImg}      = [feats.Area];

        % Calculate full colony features

        if strcmp(handles.typestr, handles.control) == 1
            type        = 1*ones(length(feats),1);
        elseif strcmp(handles.typestr, handles.test) == 1
            type        = 2*ones(length(feats),1);
        else
            type        = 3*ones(length(feats),1);
        end

        if numel(inds)>1
            handles.labstr = pars.im_name{handles.indexImg}(inds(1)+1:inds(2)-1);
        else
            handles.labstr = pars.im_name{handles.indexImg};
        end
        if ~isempty(feats)
            fullmattmp = [handles.indexImg*ones(length(feats),1) ...
                (1:length(feats))' [feats.Area]' [feats.MinorAxisLength]' ...
                [feats.Eccentricity]' [feats.MeanIntensity]' ...
                [feats.Radius]' type];
        else
            fullmattmp = [];
        end

        handles.inds{handles.indexImg} = inds;
        handles.feats{handles.indexImg} = feats;
        handles.fullmat = [handles.fullmat;fullmattmp]; %#ok<AGROW>
        handles.seg_count{handles.indexImg} = seg_count;
        handles.pars = pars;
        hObject = handles.output;
        guidata(hObject, handles);
        drawnow();

    catch ME
        handlesErrors(hObject, eventdata, handles, ME);
    end
    
function handlesErrors(hObject, eventdata, handles, errorObj)
    if ~strcmp(errorObj.message, 'AutoCellSegError')  
        nof = findall(0,'type','figure');    
        for i = 1:length(nof)
           delete(nof(i));
        end
        clearvars -except errorObj;
        BacteriaColonySegmenter;      
        waitfor(errordlg(getReport(errorObj,'extended','hyperlinks','off'),'Error'));
    end
    error('AutoCellSegError');



