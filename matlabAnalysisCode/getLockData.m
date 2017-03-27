%function [ output_args ] = getLockData(date,datapath)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
date='2017-03-17';
nargint=1;
if nargint<2
    datapath=dropboxPath('github','postdoc_code','PhotonicComb','EtalonRbLock-pyclient','data',date,'rbData');
else
    datapath=fullfile(datapath,date,'rbData');
end

[RB, ET, timeRbEt] = importfile_dataRbEt(fullfile(datapath,'data-RbEt.csv'));
[temp, timetemp] = importfile_datatemp(fullfile(datapath,'data-temp.csv'));

% [time,ia,ib]=intersect(timeRbEt,timetemp);
% RB=RB(ia,:);
% ET=ET(ia);
% temp=temp(ib);
% time=time+10/24;

load('dftout.mat')
out(:,5)=(out(:,5) - 2440587.5) + 719529;

plot(out(:,5), cumsum(out(:,3))*100, timeRbEt, smooth([-ET+mean(RB,2)],100),'.')
datetick
return
%%
rbseries=timeseries([RB ET],datestr(timeRbEt, 'dd-mm-yyyy HH:MM:SS.FFF'));
etseries=timeseries(temp,datestr(timetemp, 'dd-mm-yyyy HH:MM:SS.FFF'));
%%
[ts1 ts2] = synchronize(rbseries,etseries,'Union');
%end

