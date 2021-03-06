
function [] = readChar(fname)

close all;
%clear;
%clc;
%fname = '4902';
char = imread([fname,'.png']);
fileID = fopen([fname,'-c.txt'],'w');
fileID2 = fopen([fname,'-d.txt'],'w');
%fileID3 = fopen([fname,'-r.txt'],'w');


%take projection ratio
projectionFeatures(fname);



char = imcomplement(char);
char2 = char;

%figure,imshow(char);
originaldim = size(char);

globalcount = 0;


%figure
%image(char);
%hold on;



% angle = (pi/180)*60;
% rho = [0:1:100];
% theta = zeros(1,size(rho,2))+angle;
% [x,y] = pol2cart(theta,rho);
% x=round(x+round(originaldim(1)/2));
% y=round(y+round(originaldim(2)/2));
% plot(x,y,'r');
% 
% countstarted = false;
% startpx = 0;
% endpx = 0;
% midpx = [];
% 
% %iterate through x,y
% for n = 1:size(x,2)
%         if(n<originaldim(1))
%             val = char(x(1,n),y(1,n));
%             
%             if (val>250 && ~countstarted)
%                 startpx = n;
%                 countstarted = true;
%             end
%             if(val<10 && countstarted)
%                 endpx = n;
%                 countstarted = false;
%                 midpx = [midpx,round((endpx+startpx)/2)];
%                 %polar(angle,round((endpx+startpx)/2),'*r')
%             end
%             
%             disp(val);
%         end
% end
% fprintf('angle %f Cutting points ',angle)
% fprintf('%d ',midpx);
% fprintf('\n');
% return;
cutPoints = [];

%angles from 0 to 90
i = 0;
step = 1;
blurPad = 8;
while i<90
    angle = (pi/180)*i;
    rho = [0:1:round(sqrt(2*(100^2)))];
    theta = zeros(1,size(rho,2))+angle;
    [x,y] = pol2cart(theta,rho);
    x=round(x);%+round(originaldim(1)));
    y=round(y);%+round(originaldim(2)));
    
    %plot(x,y,'r');

    valarray=[];
    %iterate through x,y
    for n = 1:size(x,2)
            if(n<originaldim(1))
                xpos = x(1,n);
                if xpos<=0
                    xpos = 1;
                end
                ypos = y(1,n);
                if ypos<=0
                    ypos = 1;
                end
                val = char(ypos,xpos);
                %change char
                char2(ypos,xpos) = 255-val;
                valarray = [valarray,val];
                %disp(val);
            end
    end
    
    kernel = ones(1,blurPad)/blurPad;
    blurredArray = conv2(double(valarray), double(kernel), 'same');
    
    countstarted = false;
    startpx = 0;
    endpx = 0;
    midpx = [];
    %disp(max(max(blurredArray)));
    if(max(max(blurredArray))==1)
    
    blurredArray = uint8(blurredArray.*255);
    end
    for n=1:size(blurredArray,2)
        val = blurredArray(1,n);
        %disp(val);
        if (val>200 && ~countstarted)
            startpx = n;
            countstarted = true;
             %disp(startpx);
         end
         if(val<100 && countstarted)
              endpx = n;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
          end
    end
    %check if countstarted is false
    %it should be false
    %else the last count is not finished
    if countstarted
              endpx = n-1;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
    
    end
    
    %padding with trailing zeros
    midArray =  padarray(midpx,10-size(midpx,1),0,'post');
    %fprintf('angle %d Cutting points \n',i)
    %fprintf('%d ',midArray);
    if(size(midpx,1)==0)
    midpx = [midpx;0];
    end
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
    fprintf(fileID2,'%d ',min(min(midpx)));
    fprintf(fileID2,'%d ',max(max(midpx)));
    fprintf(fileID2,'%d ',sum(sum((midpx))));
    %globalcount = globalcount+3;
    %disp('<90');
    %disp(globalcount);
    
    %fprintf('%d ',[min(midArray),max(midArray),sum(midArray)]);
    %fprintf('\n');
    fprintf(fileID,'%d ',size(midpx,1));
    cutPoints = [cutPoints,size(midpx,1)];
    %fprintf(fileID,'\n');
    i=i+step;
end


%angles from 90 to 180
i = 90;
step = 1;
blurPad = 8;
while i<180
    angle = (pi/180)*i;
    rho = [0:1:round(sqrt(2*(100^2)))];
    theta = zeros(1,size(rho,2))+angle;
    [x,y] = pol2cart(theta,rho);
    x=round(x+round(originaldim(1)));
    y=round(y);%+round(originaldim(2)));
    %plot(x,y,'r');

    valarray=[];
    %iterate through x,y
    for n = 1:size(x,2)
            if(n<originaldim(1))
                xpos = x(1,n);
                if xpos<=0
                    xpos = 1;
                end
                ypos = y(1,n);
                if ypos<=0
                    ypos = 1;
                end
                val = char(ypos,xpos);
                %change char
                char2(ypos,xpos) = 255-val;
                valarray = [valarray,val];
                %disp(val);
            end
    end
    
    kernel = ones(1,blurPad)/blurPad;
    blurredArray = conv2(double(valarray), double(kernel), 'same');
    
    countstarted = false;
    startpx = 0;
    endpx = 0;
    midpx = [];
    %disp(size(blurredArray,2));
    if(max(max(blurredArray))==1)
    
    blurredArray = uint8(blurredArray.*255);
    end
    for n=1:size(blurredArray,2)
        val = blurredArray(1,n);
        if (val>200 && ~countstarted)
            startpx = n;
            countstarted = true;
             %disp(startpx);
         end
         if(val<100 && countstarted)
              endpx = n;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
          end
    end
    %check if countstarted is false
    %it should be false
    %else the last count is not finished
    if countstarted
              endpx = n-1;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
    
    end
    
    %padding with trailing zeros
    midArray =  padarray(midpx,10-size(midpx,1),0,'post');
    %fprintf('angle %d Cutting points ',i)
    %fprintf('%d ',midArray);
    if(size(midpx,1)==0)
    midpx = [midpx;0];
    end
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
    fprintf(fileID2,'%d ',min(min(midpx)));
    fprintf(fileID2,'%d ',max(max(midpx)));
    fprintf(fileID2,'%d ',sum(sum((midpx))));
    %globalcount = globalcount+3;
    %disp('90<180');
    %disp(globalcount);
    
    %fprintf('\n');
    fprintf(fileID,'%d ',size(midpx,1));
    cutPoints = [cutPoints,size(midpx,1)];
    %fprintf(fileID,'\n');
    i=i+step;
end

%angles from 180 to 270
i = 180;
step = 1;
blurPad = 8;
while i<270
    angle = (pi/180)*i;
    rho = [0:1:round(sqrt(2*(100^2)))];
    theta = zeros(1,size(rho,2))+angle;
    [x,y] = pol2cart(theta,rho);
    x=round(x+round(originaldim(1)));
    y=round(y+round(originaldim(2)));
    %plot(x,y,'r');

    valarray=[];
    %iterate through x,y
    for n = 1:size(x,2)
            if(n<originaldim(1))
                xpos = x(1,n);
                if xpos<=0
                    xpos = 1;
                end
                ypos = y(1,n);
                if ypos<=0
                    ypos = 1;
                end
                val = char(ypos,xpos);
                %change char
                char2(ypos,xpos) = 255-val;
                valarray = [valarray,val];
                %disp(val);
            end
    end
    
    kernel = ones(1,blurPad)/blurPad;
    blurredArray = conv2(double(valarray), double(kernel), 'same');
    
    countstarted = false;
    startpx = 0;
    endpx = 0;
    midpx = [];
    %disp(size(blurredArray,2));
    if(max(max(blurredArray))==1)
    
    blurredArray = uint8(blurredArray.*255);
    end
    for n=1:size(blurredArray,2)
        val = blurredArray(1,n);
        if (val>200 && ~countstarted)
            startpx = n;
            countstarted = true;
             %disp(startpx);
         end
         if(val<100 && countstarted)
              endpx = n;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
          end
    end
    %check if countstarted is false
    %it should be false
    %else the last count is not finished
    if countstarted
              endpx = n-1;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
    
    end
    
    %padding with trailing zeros
    midArray =  padarray(midpx,10-size(midpx,1),0,'post');
    %fprintf('angle %d Cutting points ',i)
    %fprintf('%d ',midArray);
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
     if(size(midpx,1)==0)
    midpx = [midpx;0];
    end
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
    fprintf(fileID2,'%d ',min(min(midpx)));
    fprintf(fileID2,'%d ',max(max(midpx)));
    fprintf(fileID2,'%d ',sum(sum((midpx))));
   % globalcount = globalcount+3;
   %  disp('180<270');
   % disp(globalcount);
    %fprintf('\n');
    fprintf(fileID,'%d ',size(midpx,1));
    cutPoints = [cutPoints,size(midpx,1)];
    %fprintf(fileID,'\n');
    i=i+step;
end

%angles from 270 to 360
i = 270;
step = 1;
blurPad = 8;
while i<360
    angle = (pi/180)*i;
    rho = [0:1:round(sqrt(2*(100^2)))];
    theta = zeros(1,size(rho,2))+angle;
    [x,y] = pol2cart(theta,rho);
    x=round(x);%+round(originaldim(1)));
    y=round(y+round(originaldim(2)));
    %plot(x,y,'r');

    valarray=[];
    %iterate through x,y
    for n = 1:size(x,2)
            if(n<originaldim(1))
                xpos = x(1,n);
                if xpos<=0
                    xpos = 1;
                end
                ypos = y(1,n);
                if ypos<=0
                    ypos = 1;
                end
                val = char(ypos,xpos);
                %change char
                char2(ypos,xpos) = 255-val;
                valarray = [valarray,val];
                %disp(val);
            end
    end
    
    kernel = ones(1,blurPad)/blurPad;
    blurredArray = conv2(double(valarray), double(kernel), 'same');
    
    countstarted = false;
    startpx = 0;
    endpx = 0;
    midpx = [];
    %disp(size(blurredArray,2));
    if(max(max(blurredArray))==1)
    
    blurredArray = uint8(blurredArray.*255);
    end
    for n=1:size(blurredArray,2)
        val = blurredArray(1,n);
        if (val>200 && ~countstarted)
            startpx = n;
            countstarted = true;
             %disp(startpx);
         end
         if(val<100 && countstarted)
              endpx = n;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
          end
    end
    %check if countstarted is false
    %it should be false
    %else the last count is not finished
    if countstarted
              endpx = n-1;
              %disp(endpx);
              countstarted = false;
              %cutting point atleas should have some width
              if (endpx-startpx)>5
                   midpx = [midpx;round((endpx+startpx)/2)];
                   %polar(angle,round((endpx+startpx)/2),'*g')
              end
    
    end
    
    %padding with trailing zeros
    midArray =  padarray(midpx,10-size(midpx,1),0,'post');
    %fprintf('angle %d Cutting points ',i)
    %fprintf('%d ',midArray);
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
    if(size(midpx,1)==0)
    midpx = [midpx;0];
    end
    %fprintf(fileID2,'%d ',[min(midArray),max(midArray),sum(midArray)]);
    fprintf(fileID2,'%d ',min(min(midpx)));
    fprintf(fileID2,'%d ',max(max(midpx)));
    fprintf(fileID2,'%d ',sum(sum((midpx))));
    %globalcount = globalcount+3;
    %disp(globalcount);
    %fprintf('\n');
    fprintf(fileID,'%d ',size(midpx,1));
    cutPoints = [cutPoints,size(midpx,1)];
    %fprintf(fileID,'\n');
    i=i+step;
end

hold off;

%print the ratio to the file



%figure, imshow(char2);
plot(cutPoints);
fprintf(fileID,'\n');
fprintf(fileID2,'\n');
fclose(fileID);
fclose(fileID2);
return

end
