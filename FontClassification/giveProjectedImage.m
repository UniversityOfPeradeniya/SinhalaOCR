function [ result ] = giveProjectedImage(image)
%giveProjectedImage will return the processed image

%displaying in give projected
disp('inside giveprojected')
%figure,imtool(image)
padlength = 20; %length of padding of two sides
threshold = 0;
i=padarray(image,[0 padlength]);
verticalProjection = sum(i, 1);

arrayLen = numel(verticalProjection);
idx = floor(padlength/2)+1;
started = false;
image = [];
while idx < arrayLen-padlength
    
    element = verticalProjection(idx);
    
    sumofElements = sum(verticalProjection(idx-floor(padlength/2):idx+floor(padlength/2)));
    
    %fprintf('sumofElements %d\n',sumofElements);
    if(sumofElements>threshold && ~started)
        image = [image,idx];
        started = true;
        disp('tracking started at');
        disp(idx);
    end
    if(sumofElements<=threshold && started)
         image=[image,idx];
         started = false;
         
         result = i(:,image(1):image(2));
         %figure,imshow(result);
         disp('tracking finished at');
         disp(idx);
         disp('exit from giveprojected')
         return;
    end
    
    idx=idx+1;
end
%if started and not finished yet, I am going to take whole thing as the
%character

if(started )
result = i(:,image(1):idx-1);
return
end

%else there is no character
result = [];
disp('tracking not finished');
disp('empty result from giveprojected')
return;

end

