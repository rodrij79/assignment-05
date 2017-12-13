clear all;
close all;
clc;

Igray = imread('unknown.jpg');

Ithresh = Igray > 185;
BW = ~Ithresh;

SE = strel('disk',2);
BW2 = imdilate(BW,SE);

[labels,number] = bwlabel(BW,8); 
Istats = regionprops(labels,'basic','Centroid'); 
 
Istats([Istats.Area] < 1000) = [];
num = length(Istats);

Ibox = floor([Istats.BoundingBox]);
Ibox = reshape(Ibox,[4 num]);
imshow(BW2);

hold on;
for k = 1:num
    rectangle('position',Ibox(:,k),...
        'edgecolor','r','LineWidth',3);
end

for k =1:num
    col1 = Istats(k).BoundingBox(1); 
    col2 = Istats(k).BoundingBox(1)+Istats(k).BoundingBox(3);
    row1 = Istats(k).BoundingBox(2);
    row2 = Istats(k).BoundingBox(2)+Istats(k).BoundingBox(4);
    subImage = BW2(row1:row2, col1:col2);
    UnknownImage{k} = subImage;
    UnknownImageScaled{k} = ...
    imresize(subImage, [24 12]);
end

figure, imshow(UnknownImage{1});
figure, imshow(UnknownImageScaled{1});

Igray2 = imread('template.jpg');

Ithresh2 = Igray2 > 185;
BW3 = ~Ithresh2;

SE2 = strel('disk',2);
BW4 = imdilate(BW3,SE2);

[labels2,number2] = bwlabel(BW4,8); 
Istats2 = regionprops(labels2,'basic','Centroid'); 
 
Istats2([Istats2.Area] < 1000) = [];
num2 = length(Istats2);

Ibox2 = floor([Istats2.BoundingBox]);
Ibox2 = reshape(Ibox,[4 num]);
imshow(BW4);

hold on;
for k = 1:num
    rectangle('position',Ibox2(:,k),...
        'edgecolor','r','LineWidth',3);
end

for k =1:num
    col1 = Istats2(k).BoundingBox(1); 
    col2 = Istats2(k).BoundingBox(1)+Istats2(k).BoundingBox(3);
    row1 = Istats2(k).BoundingBox(2);
    row2 = Istats2(k).BoundingBox(2)+Istats2(k).BoundingBox(4);
    subImage2 = BW4(row1:row2, col1:col2);
    TempImage{k} = subImage2;
    TempImageScaled{k} = ...
        imresize(subImage2, [24 12]);
end

figure, imshow(TempImage{1});
figure, imshow(TempImageScaled{1});

corr = normxcorr2(UnknownImageScaled{1}, ...
    TempImageScaled{7});

maxCorr(k) = max( corr(:) );

% code was not running properly, it wasnt giving me the correct numbers
% when it runs, but this is what i have so far for this.