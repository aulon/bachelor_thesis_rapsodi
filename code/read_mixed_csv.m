%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'read_mixed_csv' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edited by: Aulon Kuqi github.com/aulon
% This function was taken from stackoverflow.com
% Posted by user "gnovice" on 26.01.2011, source:
% stackoverflow.com/questions/4747834/import-csv-file-with-mixed-data-types

% @parameters:
%   - fileName: file name of a csv file
%   - delimiter: delimiter of a row in the csv file
% @return:
%   - lineArray: cell array with the elements of the csv file

function lineArray = read_mixed_csv(fileName,delimiter)
  fid = fopen(fileName,'r');   %# Open the file
  lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly
                               %#   larger than is needed)
  lineIndex = 1;               %# Index of cell to place the next line in
  nextLine = fgetl(fid);       %# Read the first line from the file

  while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
    lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
    lineIndex = lineIndex+1;          %# Increment the line index
    nextLine = fgetl(fid);            %# Read the next line from the file
  end

  fclose(fid);                 %# Close the file
  lineArray = lineArray(1:lineIndex-1);  %# Remove empty cells, if needed

  for iLine = 1:lineIndex-1              %# Loop over lines
    lineData = textscan(lineArray{iLine},'%s',...  %# Read strings
                        'Delimiter',delimiter);
    lineData = lineData{1};              %# Remove cell encapsulation
    if strcmp(lineArray{iLine}(end),delimiter)  %# Account for when the line
      lineData{end+1} = '';                     %#   ends with a delimiter
    end
    lineArray(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
  end

end
