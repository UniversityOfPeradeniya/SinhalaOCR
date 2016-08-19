function [] = callForMultipleHistograms8vs8(pattern)
%callForMultipleHistograms will call featureDifference function multiple
%times to draw multiple histograms
close all;
[Anorm0,outputData0,inputNames0] = featureDifference('../bindumathi','-d8');
[Anorm1,outputData1,inputNames1] = featureDifference('../bindumathi','-corner12');
%[Anorm2,outputData2,inputNames2] = featureDifference('../bindumathi','-dim180');
% 
% figure;

% h1=histogram(Anorm1,nbins);

% h2=histogram(Anorm2,nbins);
% xlim([0 1]);
% set(gca,'FontWeight','bold','fontsize',12);
% 
% print(['Fig',pattern,'hist.pdf'],'-dpdf');

figure

nbins = size(outputData0,1);
h = histogram(Anorm0,nbins);
set(h,'edgecolor','none');
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','facealpha',0.75);
hold on;

nbins = size(outputData1,1);
h = histogram(Anorm1,nbins);
set(h,'edgecolor','none');
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','facealpha',0.75);
hold on;

% nbins = size(outputData2,1);
% h=histogram(Anorm2,nbins);
% set(h,'edgecolor','none');
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','g','facealpha',0.75);


xlim([0 1]);
legend('8 Distance features','Suggested 8 distance features')
set(gca,'FontWeight','bold','fontsize',12);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
print(['Fig',pattern,'hist.pdf'],'-dpdf');

end

