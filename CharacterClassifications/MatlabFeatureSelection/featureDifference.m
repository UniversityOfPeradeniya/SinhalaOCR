function [outputData,outputNames] = featureDifference( dirName,content )
%featureDifference will give difference of features against each other
close all;
clf;
tic;

files = dir(dirName);   %list all *.png files
files = {files.name}';                      % file names

data = cell(numel(files),1);                % store file contents

%files with particular extension
outputNames = [];
outputData = [];



toc;




for i=1:numel(files)
    fname = fullfile(dirName,files{i});     % full path to file
    [pathstr, name, extension] = fileparts(fname);
    disp(fname)
    if(strfind(name,content))
        fpath = [pathstr,'\',name,extension];
        %disp(fpath);
        
        char = importdata(fpath);
        %disp(char);
        outRow = [];
        outRowNames = [];
        %check this array with every other array
        for j=1:numel(files)
            %tic;
            fname = fullfile(dirName,files{j});     % full path to file
            [spathstr, sname, sextension] = fileparts(fname);
            
             if(strfind(sname,content))
                fpath = [spathstr,'\',sname,sextension];
                %disp(fpath);
                tic;
                char2 = importdata(fpath);
                toc;
                %subtract two chars
                V = char2-char;
                S = sqrt(V * V');
                outRow = [outRow,S];
                outRowNames = [outRowNames,' ',sname];
                %fprintf('%s %s %.3f\n',name,sname,S);
                %toc;
             end
        end
        
        outputData = [outputData;outRow];
        outputNames = [outputNames;outRowNames];
    end
   %disp(i);
end

names = strsplit(outputNames(1,:));
names = names(2:end);
A = outputData;
Anorm = (A - min(min(A)))/(max(max(A)) - min(min(A)));
imagesc(Anorm);
colorbar;
set(gca,'XTick',1:size(outputData,1));
set(gca,'YTick',1:size(outputData,1))
set(gca,'XTickLabel',names)
set(gca,'YTickLabel',names)
return;


end

