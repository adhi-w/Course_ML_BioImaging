function [sift_descs,xvals,yvals]=get_descriptors(I,patch_size,step)
    nrml_threshold = 0.8;
    sigma_edge = 1;
    maxpatchSize = patch_size;
    gridSpacing = step;
    
    im_w = size(I,2);
    im_h = size(I,1);
    if ndims(I) == 3,
        Ig = im2double(rgb2gray(I));
    else
        Ig = im2double(I);
    end
    remX = mod(im_w-maxpatchSize,gridSpacing);
    offsetX = floor(remX/2)+1;
    remY = mod(im_h-maxpatchSize,gridSpacing);
    offsetY = floor(remY/2)+1;

    [gridX,gridY] = meshgrid(offsetX:gridSpacing:im_w-maxpatchSize+1, offsetY:gridSpacing:im_h-maxpatchSize+1);

    fea_arr = sp_find_sift_grid_pyramid(Ig, gridX, gridY, patch_size, nrml_threshold, sigma_edge);
    xvals = offsetX:gridSpacing:im_w-maxpatchSize+1;
    yvals = offsetY:gridSpacing:im_h-maxpatchSize+1;   
    sift_descs = cell2mat(fea_arr);
end
