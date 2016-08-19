function [Anorm,outputData,inputNames] = featureDifference( dirName,pattern)
%featureDifference will give difference of features against each other
close all;
clf;
tic;

files = dir( fullfile(dirName,['*',pattern,'.txt']) );   %list all *.txt files
files = {files.name}';                      % file names
disp(files);
data = cell(numel(files),1);                % store file contents

%files with particular extension
outputData = [];

inputNames = [];
inputData = [];

for i=1:numel(files)
    fname = fullfile(dirName,files{i});     % full path to file
    [pathstr, name, extension] = fileparts(fname);
    disp(fname)
    fpath = [pathstr,'\',name,extension];
    char = importdata(fpath);
    %disp(char);
    name = strsplit(name,pattern);
    name = name(1);
    %disp(name);
    inputNames = [inputNames,name];
    inputData = [inputData;char];
    
end


toc;

for i=1:size(inputData,1)

    char = inputData(i,:);
    %disp(char);
    outRow = [];
    outRowNames = [];
    %check this array with every other array
    for j=1:size(inputData,1)
        %tic;
        %tic;
        char2 = inputData(j,:);
        %toc;
            %subtract two chars
        V = char2-char;
        S = sqrt(V * V');
        outRow = [outRow,S];
            %fprintf('%s %s %.3f\n',name,sname,S);
            %toc;
    end
        
    outputData = [outputData;outRow];
end






names = inputNames;


%this is valid only for english letters
%namestring = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z';
%names = strsplit(namestring,',');

A = outputData;
Anorm = (A - min(min(A)))/(max(max(A)) - min(min(A)));
%subplot(2,1,1)
figure,imagesc(Anorm);
colorb = colorbar;
set(colorb,'fontsize',10,'FontWeight','bold');
set(gca, 'Ticklength', [0 0]);
set(gca,'XTick',1:size(outputData,1));
set(gca,'YTick',1:size(outputData,1));
set(gca,'XTickLabel',names,'FontName','Iskoola Pota','fontsize',0.4,'XTickLabelRotation',90,'xaxisLocation','top');
set(gca,'YTickLabel',names);

%only for english letters
%set(gca,'XTickLabel',names,'FontName','Times','fontsize',8,'xaxisLocation','top');


set(gca, 'LineWidth',0.1);
ax = gca;
ax.Box = 'off';
ax.XRuler.Axle.Visible = 'off';
ax.YRuler.Axle.Visible = 'off';

%set(gcf,'PaperUnits','inches');

%set(gca, 'visible', 'off');
%set(gca,'XTickLabel',a,'FontName','Times','fontsize',1);

print(['Fig',pattern,'.pdf'],'-dpdf');

nbins = size(outputData,1);
%subplot(2,1,2);
figure;
h=histogram(Anorm,nbins);
xlim([0 1]);
set(gca,'FontWeight','bold','fontsize',12);

print(['Fig',pattern,'hist.pdf'],'-dpdf');

counts = h.Values;
counts = [counts,0];
edges = h.BinEdges;
sumofAll = sum(counts.*edges);
sumofchars = sum(counts);
meanis = sumofAll/sumofchars;
fprintf('mean = %d\n',meanis);
hold on;
line([meanis meanis], ylim, 'Color','r','LineWidth',2);

return;


end

