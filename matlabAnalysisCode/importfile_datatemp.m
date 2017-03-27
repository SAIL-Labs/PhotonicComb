function [temp, time] = importfile_datatemp(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   VARNAME1 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   VARNAME1 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   VarName1 = importfile('data-temp.csv',1, 896000);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/03/23 16:51:44
try
    load([filename(1:end-3) 'mat'])
catch err
    
    %% Initialize variables.
    delimiter = ',';
    if nargin<=2
        startRow = 1;
        endRow = inf;
    end
    
    %% Format for each line of text:
    %   column1: double (%f)
    %	column2: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%f%f%[^\n\r]';
    
    %% Open the text file.
    fileID = fopen(filename,'r');
    
    %% Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    
    %% Close the text file.
    fclose(fileID);
    %% Allocate imported array to column variable names
    time = unixtime_in_ms_to_datenum(dataArray{:, 1});
    temp = dataArray{:, 2};
       
    save([filename(1:end-3) 'mat'],'temp','time')
end
isbad=isnan(time+temp);
time(isbad)=[];
temp(isbad)=[];


