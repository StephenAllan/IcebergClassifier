% CSCI-431: Introduction to Computer Vision
% Project - Iceberg Classifier
%
% @author Stephen Allan <swa9846>
% @author Douglas Lee <dxl7697>


function result = IcebergClassifier(jsonFilepath)
    % ICEBERGCLASSIFIER TODO: Summary
    %   TODO: Description
    
    %% Parse Arguments
    if ~ischar(jsonFilepath)
        error('IcebergClassifier First parameter must be a character vector <''filepath''>');
    end
    
    fileID = fopen(jsonFilepath, 'r');
    rawData = fread(fileID, '*char');
    fclose(fileID);
    
    data = jsondecode(rawData);
    
    testData = data(3);
    
    %% Visualize Data
    visualizeData(testData);
    
    %% Crop Object out of Image
    subImages = detectObject(testData);
    figure; imshowpair(subImages{1}, subImages{2}, 'montage');

    %% Check if at center of image
%     subImages = detectObject(data(3));

    
    result = data;
end

function visualizeData(data)
    % VISUALIZEDATA TODO: Summary
    %   TODO: Description
    
    band1Image = bandToImage(data.band_1);
    band2Image = bandToImage(data.band_2);
    
    figure; imshowpair(band1Image, band2Image, 'montage');
    
    fprintf('%s: Angle = %f, Iceberg = %d\n', data.id, data.inc_angle, data.is_iceberg);
end

function subImages = detectObject(data)
    % DETECTOBJECT TODO: Summary
    %   TODO: Description
    
    % FIXME: Some images are too bright and this threshold doesn't work.
    brightnessThreshold = 150;
    middle = 75 / 2;
    
    bands = {data.band_1, data.band_2};
    subImages = {length(bands)};
    
    for i = 1:length(bands)
        image = bandToImage(bands{i});
        binaryImage = image > brightnessThreshold;

        figure; imshow(binaryImage);

        imageStats = regionprops(binaryImage, 'BoundingBox', 'Area');
        for j = 1:length(imageStats)
            % Check that the region is the correct size of an object
            if imageStats(j).Area > 15 && imageStats(j).Area < 100
                box = imageStats(j).BoundingBox;  % box = [y, x, width, height]

                % Get a sub-image of just the individual object
                cols = box(1) + 1:box(1) + box(3);
                rows = box(2) + 1:box(2) + box(4);
                
                if ismember(middle, rows) && ismember(middle, cols)
                    rectangle('Position', [box(1), box(2), box(3), box(4)], 'EdgeColor', [1, 0, 0], 'LineWidth', 1);
                    subImages{i} = binaryImage(round(rows) - 1, round(cols) - 1);
                
                    % One object per image
                    break;
                end
            end
        end
    end
end
