jsonFilepath = 'data/train.json';

fileID = fopen(jsonFilepath, 'r');
rawData = fread(fileID, '*char');
fclose(fileID);

data = jsondecode(rawData);

for n = 1:length(data)
    image = bandToImage(data(n).band_1);
    writeAsImage(data(n).id, (image), data(n).is_iceberg);
end

fprintf('finished separating images from iceberg and ships\n');
