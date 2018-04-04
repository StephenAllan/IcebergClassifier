% CSCI-431: Introduction to Computer Vision
% Project - Iceberg Classifier
%
% @author Stephen Allan <swa9846>
% @author Douglas Lee <dxl7697>


function writeAsImage(id, image, isIceberg)
    % WRITEASIMAGE TODO: Summary
    %   TODO: Description

    destFolder = strcat(pwd, 'data\images\ship');
    if(isIceberg)
        destFolder = strcat(pwd, 'data\images\iceberg');
    end

    if ~exist(destFolder, 'dir')
      mkdir(destFolder);
    end
    
    % force binary image
    image=image - min(image(:));
    image=image  /max(image(:));
    
    % png, jpg will throw error
    outputBaseName = [id, '.png'];
    fullDestinationFileName = fullfile(destFolder, outputBaseName);

    imwrite(image, fullDestinationFileName, 'BitDepth', 16);
end
