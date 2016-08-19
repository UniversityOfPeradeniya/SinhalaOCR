function [  ] = characterReadInterface( dirName )
%This will list all the png images in folder
%   And call the readChar function


files = dir( fullfile(dirName,'*.png') );   %list all *.png files
files = {files.name}';                      % file names
count = 1;
data = cell(numel(files),1);                % store file contents
for i=1:numel(files)
    fname = fullfile(dirName,files{i});     % full path to file
    [pathstr, name, ~] = fileparts(fname);
    fpath = [pathstr,'\',name];
    fprintf('%d %s\n',count,fpath);
    %readChar(fpath);
    %pixelViseCompare(fpath);
    %projectionProfiles(fpath);
    %circularFeatures(fpath);
    %circularFeatures360(fpath);
    %circularFeatures360improved(fpath);
    %circularFeatures360FromCorners(fpath);
    %circularFeatures180FromCornersImproved(fpath);
    circularFeaturesFromCornersCuttingPoints(fpath);
    
    count = count+1;
end

close all;


end

