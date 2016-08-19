function [ratio] = projectionFeatures( fname )
%projectionFeatures will give the projection data about the image


char = imread([fname,'.png']);
char90 = imrotate(char,90);
fileID = fopen([fname,'-r.txt'],'w');
% fileID2 = fopen([fname,'-p.txt'],'w');
%fileID2 = fopen([fname,'-d.txt'],'w');
char = imcomplement(char);
char90 = imcomplement(char90);

% charvector = reshape(char',size(char,1)*size(char,2),1);

%VP
verticalProjection = sum(char, 1);
horizontalProjection = sum(char90,1);

% set(gcf, 'Name', 'Character sectioning', 'NumberTitle', 'Off'); 
% subplot(2, 2, 1);imshow(char); 
% figure,subplot(2,2,3);
% plot(verticalProjection, 'b-');
% subplot(2,2,2);
% plot(horizontalProjection,'b-');
% view([90 90]);

%get the max of verticalProjection
maxver = max(verticalProjection);
disp(maxver);
lim = maxver*0.1;
verticalStart = 0;
verticalEnd = 0;

%find the vertical start point
i=1;

while(i<=size(verticalProjection,2))
    %disp(verticalProjection(1,i));
    if(verticalProjection(1,i)>=lim)
        verticalStart = i;
        break;
    end
    i=i+1;
end

fprintf('Vertical start = %d\n',verticalStart);

i=size(verticalProjection,2);
while(i>0)
    %disp(verticalProjection(1,i));
    if(verticalProjection(1,i)>=lim)
        verticalEnd = i;
        break;
    end
    i=i-1;
end

fprintf('Vertical end = %d\n',verticalEnd);




%horizontal projection data
%get the max of horizontalProjection
maxhor = max(horizontalProjection);
disp(maxhor);
lim = maxhor*0.1;
horizontalStart = 0;
horizontalEnd = 0;

%find the horizontal start point
i=1;

while(i<=size(horizontalProjection,2))
    %disp(horizontalProjection(1,i));
    if(horizontalProjection(1,i)>=lim)
        horizontalStart = i;
        break;
    end
    i=i+1;
end

fprintf('Horizontal start = %d\n',horizontalStart);

i=size(horizontalProjection,2);
while(i>0)
    %disp(horizontalProjection(1,i));
    if(horizontalProjection(1,i)>=lim)
        horizontalEnd = i;
        break;
    end
    i=i-1;
end

fprintf('Horizontal end = %d\n',horizontalEnd);


ratio = (verticalEnd-verticalStart)/(horizontalEnd-horizontalStart);
fprintf('Ratio is: %f\n',ratio);
verticalDensity = sum(sum(verticalProjection))/(verticalEnd-verticalStart);
horizontalDensity = sum(sum(horizontalProjection))/(horizontalEnd-horizontalStart);

fprintf(fileID,'%f %f\n',verticalDensity/ratio,horizontalDensity/ratio);
fclose(fileID);


%writing pixel values as a vector
% fprintf(fileID2,'%d ',charvector);
% fprintf(fileID2,'\n');
% fclose(fileID2);


return;
end

