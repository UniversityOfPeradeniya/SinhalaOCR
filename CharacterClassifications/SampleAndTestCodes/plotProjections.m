function [] = plotProjections(imageName)
%This will plot the projection of an image
close all;
power = 1.5;
char = imread([imageName,'.png']);
char = im2bw(char);
char90 = imrotate(char,90);

char = imcomplement(char);
char90 = imcomplement(char90);


verticalProjection = sum(char, 1);
horizontalProjection = sum(char90,1);

verticalProjectionsum = sum(verticalProjection);
horizontalProjectionsum = sum(horizontalProjection);

verticalProjection = verticalProjection .* (verticalProjectionsum^power);
horizontalProjection = horizontalProjection .* (horizontalProjectionsum^power);
% 
% subplot(2, 2, 1);imshow(char); 
% subplot(2,2,3);plot(verticalProjection, 'b-');
% subplot(2,2,2);plot(horizontalProjection, 'b-');
% subplot('Position',[100 100 200 200])
% view([-90 90])
h=figure;
set(h, 'Position', [100, 100, 200, 200]);       % <— ‘Height’ Increased
subplot(2,2,1);
imshow(char)
title('Character');
hsp1 = get(gca, 'Position');                     % Get 'Position' for (2,1,1)
set(gca,'FontWeight','bold','FontSize',12);
subplot(2,2,3);
plot(verticalProjection,'b-');
axis([0 200 0 inf]);
title('Vertical Projection');



hsp2 = get(gca, 'Position');                     % Get 'Position' for (2,1,2)
set(gca, 'Position', [hsp2(1:3)  hsp1(4)])    % Use 2*(2,1,1) Height for (2,1,2)
hsp1 = get(gca, 'Position');                     % Get 'Position' for (2,1,1)
set(gca,'FontWeight','bold','FontSize',12);



subplot(2,2,2);
plot(horizontalProjection, 'b-');
title('Horizontal Projection');
hsp2 = get(gca, 'Position') ;                    % Get 'Position' for (2,1,2)
set(gca, 'Position', [hsp2(1:3)  hsp1(4)])    % Use 2*(2,1,1) Height for (2,1,2)
axis([0 200 0 inf]);
view([-90 90]);
set(gca,'FontWeight','bold','FontSize',12);
print(['Fig',imageName,'.pdf'],'-dpdf');


end

