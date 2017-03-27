function out=getDFToffsets(filenames,reference)
% clc;clear
% filenames=sortFitsFilenames('');z
% reference='flat-0001-reduced.fit';
win1=[1 512];
win2=[1 2048];
%win1=[512 1024];
%win2=[700 955];


try
    mat=load('dftout.mat','out','filenames','reference');
%     if filenames==mat.filenamess
%         out=mat.out;
%     else
%         error('Filenames doesn not match saved filenames in dftout.mat. Overwriting.')
%     end
    out=mat.out;
catch err
    xcorrreference=(fitsread(filenames{1},'PixelRegion',{win1, win2}));
    maxval=max2(xcorrreference);
    xcorrreference_fft2=fft2(xcorrreference/maxval);
    out=zeros(length(filenames),5);
    tic
    for i=1:length(filenames)
        i
        [imdata, header]=(fitsread(filenames{i},'PixelRegion',{win1, win2}));
        %out(i,:)=dftregistration(fft2(imdata/max2(imdata)),xcorrreference_fft2,1000);
        out(i,1:4)=dftregistration(fft2(imdata/maxval),xcorrreference_fft2,1000);
        try
            out(i,5)=header.JD;
        catch err
            out(i,5)=datenum(header.DATEOBS,'yyyy-mm-ddTHH:MM:SS.FFF(UTC)')+2440587.5-719529;
        end
        xcorrreference=imdata;
        maxval=max2(xcorrreference);
        xcorrreference_fft2=fft2(xcorrreference/maxval);
    end
    toc
    save('dftout.mat','out','filenames','reference')
end