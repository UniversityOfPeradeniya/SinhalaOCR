function [ charvector ] = pixelViseCompare( fname )
%pixelViseCompare write the image to vector as a file

char = imread([fname,'.png']);
char = imresize(char,[19,19]);
fileID = fopen([fname,'-p.txt'],'w');
char = imcomplement(char);
char = im2bw(char);
charvector = reshape(char',size(char,1)*size(char,2),1);

%writing pixel values as a vector
fprintf(fileID,'%d ',charvector);
fprintf(fileID,'\n');
fclose(fileID);
return;

end

