
parentDir = 'C:\Users\Wilson Lab\Desktop\Michael\Data\20191031-1_test';

files = dir(fullfile(parentDir, '*daqData*.mat'));
allData = {}; trialDurs = [];
for iFile = 1:numel(files)
   load(fullfile(parentDir, files(iFile).name))
   allData{iFile} = trialData;    
   load(fullfile(parentDir, regexprep(files(iFile).name, 'daqData', 'metadata')));
   trialDurs(iFile) = mD.trialSettings.trialDuration;
end

figure(1);clf;hold on
relStartSamples = [];
for iTrial = 1:numel(allData)
   relStartSamples(iTrial) = find(allData{iTrial}(:,1) > 0.38, 1);
   plot((1/10000):(1/10000):(size(allData{iTrial}, 1)/10000), allData{iTrial}(:,1)); 
end

figure(2);clf;
relStartSamples = relStartSamples - min(relStartSamples);
subplot(121);plot(trialDurs, relStartSamples/10, 'o');
subplot(122);plot(relStartSamples/10, '-o')


