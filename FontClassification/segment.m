function[]= segment(a,lineNumber)

folder = 'sa/';

%a = imread('sample.png');
%imshow(a);
widthofSpace = 50; %50px space between spaces
padlength = 20; %length of padding of two sides
imagesize = 200; %what is the box that you need the image
%a = imcrop(a);
threshold = 0;
%level = graythresh (a);
%b = im2bw (a, level);

% Complement %
%c = imcomplement (b);


%define pad
i=padarray(a,[0 padlength]);


%VP
verticalProjection = sum(i, 1);
set(gcf, 'Name', 'Character sectioning', 'NumberTitle', 'Off') 
subplot(2, 2, 1);imshow(i); 
subplot(2,2,3);
plot(verticalProjection, 'b-');

%process vertical projection

windows = zeros(1,padlength);
arrayLen = numel(verticalProjection);
idx = padlength;
start = false;
while idx < arrayLen-padlength
    
    element = verticalProjection(idx);
    %disp(element);
    sumofElements = sum(verticalProjection(idx-floor(padlength/2):idx+floor(padlength/2)));
    %disp(sumofElements);
    windows = [windows,sumofElements];
    idx=idx+1;
end
plot(windows, 'g-');
hold off;
%analyze windows array

idx = 1;
characters = [];
image = [];
started = false;
while idx<length(windows)
    
    if(windows(idx)>threshold && ~started)
        image = [image,idx];
        started = true;
    end
    if(windows(idx)<=threshold && started)
         image=[image,idx];
         started = false;
         disp(image);
         characters = [characters;image];
         %figure,imshow(i(:,image(1):image(2)));
         image = [];
         
    end
    idx = idx+1;
end
disp('Character locations');
disp(characters);

%now adjest character height

idx = 1;
iterations = size(characters,1);
while idx<=iterations
    char = i(:,characters(idx,1):characters(idx,2));
    %figure,imshow(char);
    rotated = imrotate(char,90);
    %figure,imshow(rotated);
    
    %crop the character again
    disp('Going to crop image');
    result = giveProjectedImage(rotated);
    originalImage = imrotate(result,-90);
    disp('Image crop done, displaying');
    %figure('Name','giveProjectedResult'),imshow(originalImage);
    
    %center image in a box;
    
    %first resize it to image size
    factor = imagesize/max(size(originalImage));
    disp('factor');
    disp(factor);
    resizedImage = imresize(originalImage,factor);
    
    resizedSize = size(resizedImage);
    disp('resizedSize');
    disp(resizedSize);
    %handle resize errors
    if(resizedSize(1)>imagesize)
    resizedImage = imresize(resizedImage,[imagesize,resizedSize(2)]);
    end
    if(resizedSize(2)>imagesize)
    resizedImage = imresize(resizedImage,[resizedSize(1),imagesize]);
    end
    
    disp(size(resizedImage));
    %figure,imshow(resizedImage);
    
    %now center one side
    finalImage = zeros(imagesize);
    [rowsBig, columnsBig] = size(finalImage);
    [rowsSmall, columnsSmall] = size(resizedImage);
    fprintf('rowsBig %d\n',rowsBig);
    fprintf('rowsSmall %d\n',rowsSmall);
    fprintf('columnsBig %d\n',columnsBig);
    fprintf('columnsSmall %d\n',columnsSmall);
    if(rowsSmall<rowsBig && columnsBig==columnsSmall)
        startRow = (rowsBig-rowsSmall)/2;
        finalImage(startRow:startRow+rowsSmall-1,:) = resizedImage;
        
        
    end
    if(columnsSmall<columnsBig && rowsBig==rowsSmall )
        startColumn = (columnsBig-columnsSmall)/2;
        finalImage(:,startColumn:startColumn+columnsSmall-1) = resizedImage;
        
        
    end
    
    %check if sum of final image is zero, if then there is some error,
    %return original image as final image
    if(sum(sum(finalImage))==0)
    finalImage = resizedImage;
    end
    
    %figure,imshow(finalImage);
    
    %Check whether this is an all black image
    cropedImage = finalImage(size(finalImage,1)/2-50:size(finalImage,1)/2+50,:);
    blackPixels = sum(sum(cropedImage));
    disp('black pixesl');
    disp(blackPixels);
    
    %save image
    if blackPixels<16000
        %if this is a complete black one I wont save
        name = [folder,lineNumber,int2str(idx-1),'.png'];
        imwrite(imcomplement(finalImage),name);
        disp(name);
    end
    idx = idx+1;
    %disp('idx');
    %disp(idx);
    %disp('characters length');
    %disp(size(characters));
end


end

