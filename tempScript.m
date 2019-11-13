



parentDir = 'C:\Users\Wilson Lab\Documents\fictrac-develop\testing';

prefixes = {'mjpg'};%{'xvid', 'mpg4', 'mjpg', 'raw', 'xvid2'};
suffixes = {'avi'};%{'avi', 'mp4', 'avi', 'avi', 'avi'};

% dataFile = 'fictrac-20191111_145129.csv';
% vidFile = 'fictrac-raw-20191111_145129.avi';
% frameLogFile = 'fictrac-vidLogFrames-20191111_145129.txt';

for iPrefix = 1:numel(prefixes)
    currPre = prefixes{iPrefix};
    
    myVid = VideoReader(fullfile(parentDir, [currPre, '.', suffixes{iPrefix}]));
    dataFile = csvread(fullfile(parentDir, [currPre, '.dat']));
    frameLogFile = csvread(fullfile(parentDir, [currPre, '_logFrames.txt']));
   
    frameCount = 0;
    while hasFrame(myVid)
        currFrame = uint16(readFrame(myVid));
        frameCount = frameCount + 1;
    end

    disp(' ')
    disp(currPre)
    disp(['FicTrac frames processed: ', num2str(size(dataFile, 1))])
    disp(['Video frame log entries: ', num2str(numel(frameLogFile))])
    disp(['Frames in actual video: ', num2str(frameCount)])
end


