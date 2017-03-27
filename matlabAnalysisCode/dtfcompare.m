%filenames=dirFilenames('*.fit');
%filenames(1:12)=[];

%filenames=filenames(1:100);
out=getDFToffsets(filenames,'-2017-03-16T06:11:11.292693.fit');

out(:,5)=(out(:,5) - 2440587.5) + 719529 + 10/24; %JD to matlab
return
%%
%plot((out(:,5)-out(1,5))*24,sqrt(out(:,3).^2+out(:,4).^2))
plot((out(:,5)-out(1,5))*24,sqrt(cumsum(out(:,3)).^2+cumsum(out(:,4)).^2))
%plot((out(:,5)-out(1,5))*24,cumsum(out(:,4)))
%plot(out(:,3))
xlabel('Hours')
ylabel('Pixel Shifts')
%save2pdf('labtest1',1,300)
return
%%
win1=[512 1023];
win2=[828 875];
win1=[1 2048];
win2=[1 2048];

for i=1:100
    imagesc(fitsread(filenames{i},'PixelRegion',{win1, win2}))
    title(num2str(i))
    drawnow
    %pause(1)
end
%%
imagesc(fitsread(filenames{1},'PixelRegion',{win1, win2})-fitsread(filenames{5},'PixelRegion',{win1, win2}))