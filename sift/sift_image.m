function [fea_arr] = sift_image(I,patchSize,gridSpacing,nrml_threshold)
if nargin < 5
   minImSize = 0;
end

if ~exist('nrml_threshold','var')
   nrml_threshold = 0.8;
end
    maxpatchSize = max(patchSize);
    [im_h, im_w] = size(I);
    % make grid sampling SIFT descriptors
    remX = mod(im_w-maxpatchSize,gridSpacing);
    offsetX = floor(remX/2)+1;
    remY = mod(im_h-maxpatchSize,gridSpacing);
    offsetY = floor(remY/2)+1;

    [gridX,gridY] = meshgrid(offsetX:gridSpacing:im_w-maxpatchSize+1, offsetY:gridSpacing:im_h-maxpatchSize+1);
    fea_arr = sp_find_sift_grid_pyramid(I, gridX, gridY, patchSize, nrml_threshold);
              
end