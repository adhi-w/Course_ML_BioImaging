% show_pyramid_sift

% This is a very simple demo that show how 3-level P-SIFT work.
% Click anywhere in the picture to visualize the 3 levels of details
% if you select a large sampling step (say 10 or 8) which is faster a grid 
% will pop up to show where the descriptors have been computed.
% patch_size and step can be modified.
%
close all;clear
ZOOM_FACT=.05;
% For demo use fixed patch size.
patch_size = 32; step=8;
image_query = 'images/synth/ky4.jpg';
Iq = imread(image_query);
im_w = size(Iq,2);
im_h = size(Iq,1);

% The sift/ directory contains the actual SIFT implementation.
addpath('./sift')

% Get the P-SIFT descriptors over dense grid.
[descs_q,xvals_q,yvals_q]=get_descriptors(Iq,patch_size,step);

% The grid of patch locations.
[X,Y]=meshgrid(xvals_q+patch_size/2,yvals_q+patch_size/2);
fig1=1;
fig2=2;
figure(fig1);
figure(fig2);
scnsize = get(0,'ScreenSize');

position = get(fig1,'Position');
outerpos = get(fig1,'OuterPosition');
borders = outerpos - position;
edge = -borders(1)/2;

FIG1_PERC=.60;
FIG2_PERC=1-FIG1_PERC;
pos1 = [edge,...
        scnsize(4) * (2/3),...
        scnsize(3)*(FIG1_PERC) - edge,...
        scnsize(4)];
pos2 = [scnsize(3)*(FIG1_PERC) + edge,...
        pos1(2),...
        scnsize(3)*(FIG2_PERC),...
        pos1(4)];
set(fig1,'OuterPosition',pos1) 

    
% Loop forever, letting user select descriptors to visualize.
while true
    
    % Setup point selector and SIFT visualization for new point.
    figure(1);
    subplot(3,2,1); imshow(Iq); title('Coarse SIFT');
    axis([1 size(Iq,2) 1 size(Iq,1)]);

    subplot(3,2,3); imshow(Iq); title('Medium SIFT');
    axis([1 size(Iq,2) 1 size(Iq,1)]);
    
    subplot(3,2,5); imshow(Iq); title('Fine SIFT');
    
    axis([1 size(Iq,2) 1 size(Iq,1)]);
    figure(2); imshow(Iq);
    set(fig2,'OuterPosition',pos2)
    axis([1 size(Iq,2) 1 size(Iq,1)]);
    title('Click to select the patch center');
    hold on;
    
    % If stepsize is big enough, plot grid.
    if step > 6
        grid_handle = plot(X,Y,'r.');
    end

    % Let user select a point
    [x,y]=ginput(1);
    [temp,idx] = min(abs(x-patch_size/2-xvals_q));
    [temp,idy] = min(abs(y-patch_size/2-yvals_q));
    id = (idx-1)*length(yvals_q)+idy;
    
    % Delete the grid if it was drawn and mark selected point.
    if step > 6
        delete(grid_handle);
    end
    if exist('R','var')
        delete(R);
    end
    p = plot(x,y,'o','MarkerSize',8,'MarkerFace','r','MarkerEdge','b','LineWidth',2);
   
    % Draw a rectangle around selected patch
    figure(2); 
    R = rectangle('Position',[xvals_q(idx) yvals_q(idy) patch_size patch_size],'EdgeColor','y','LineWidth',3);

    % Draw coarse SIFT level.
    figure(1);
    subplot(3,2,1);
    
    hold on;    
    axis([xvals_q(idx)-patch_size*ZOOM_FACT xvals_q(idx)+(1+ZOOM_FACT)*patch_size yvals_q(idy)-patch_size*.1  yvals_q(idy)+(1+ZOOM_FACT)*patch_size])
    scale=patch_size/6;
    frame_handle = vl_plotsiftdescriptor_col(descs_q(1:32,id),[xvals_q(idx)+patch_size/2 yvals_q(idy)+patch_size/2 scale 0]','NumSpatialBins',2);
    set(frame_handle,'color','r');
    set(frame_handle,'linewidth',2);

    % Draw coarse SIFT as histogram.
    figure(1);
    subplot(3,2,2);
    
    %hold on;    
    title('Coarse SIFT');
    bar([1:32],descs_q(1:32,id),'r');
    axis([0 33 0 .05+max(descs_q(1:32,id))])

    % Draw medium SIFT level.
    figure(1);
    subplot(3,2,3);
    

    axis([1 size(Iq,2) 1 size(Iq,1)])
    hold on;    
    axis([xvals_q(idx)-patch_size*ZOOM_FACT xvals_q(idx)+(1+ZOOM_FACT)*patch_size yvals_q(idy)-patch_size*.1  yvals_q(idy)+(1+ZOOM_FACT)*patch_size])
    
    scale = patch_size/12;
    frame_handle = vl_plotsiftdescriptor_col(descs_q(33:33+127,id),[xvals_q(idx)+patch_size/2 yvals_q(idy)+patch_size/2 scale 0]','NumSpatialBins',4);
    set(frame_handle,'color','g');
    set(frame_handle,'linewidth',2);

    % Draw medium SIFT as histogram.
    figure(1);
    subplot(3,2,4);
    
    %hold on;    
    title('Medium SIFT');
    bar(descs_q(33:33+127,id),'g');
    axis([0 129 0 .05+max(descs_q(33:33+127,id))])

    % And finally the fine level.
    figure(1);
    subplot(3,2,5);
    
    hold on;    
    axis([xvals_q(idx)-patch_size*ZOOM_FACT xvals_q(idx)+(1+ZOOM_FACT)*patch_size yvals_q(idy)-patch_size*.1  yvals_q(idy)+(1+ZOOM_FACT)*patch_size])
    
    scale = patch_size/18;
    frame_handle = vl_plotsiftdescriptor_col(descs_q(33+128:end,id),[xvals_q(idx)+patch_size/2 yvals_q(idy)+patch_size/2 scale 0]','NumSpatialBins',6);
    set(frame_handle,'color','b');
    set(frame_handle,'linewidth',2);
    
    % Fine SIFT as histogram.
    figure(1);
    subplot(3,2,6);
    
    %hold on;    
    title('Fine SIFT');
    bar(descs_q(33+128:448,id),'b');
    axis([0 289 0 .05+max(descs_q(33+128:448,id))])
    
    % Wait for a keypress and start again...
    figure(2);
    title('Press any key to select another patch');
    drawnow;
    pause;
end