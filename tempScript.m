
files = dir(fullfile('C:\Users\Wilson Lab\Desktop\Michael\Data\test\20191024-1_testing', '*daqData*.mat'));
allData = {};
for iFile = 1:numel(files)
   load(fullfile('C:\Users\Wilson Lab\Desktop\Michael\Data\test\20191024-1_testing', files(iFile).name))
   allData{iFile} = trialData;    
end

figure(1);clf;hold on
relStartSamples = [];
for iTrial = 1:numel(allData)
   relStartSamples(iTrial) = find(allData{iTrial}(:,1) > 0.38, 1);
   plot((1/10000):(1/10000):(size(allData{iTrial}, 1)/10000), allData{iTrial}(:,1)); 
end

figure(2);clf;subplot(121);plot(relStartSamples/10000, '-o');subplot(122);plot(sort(relStartSamples/10000), '-o')


