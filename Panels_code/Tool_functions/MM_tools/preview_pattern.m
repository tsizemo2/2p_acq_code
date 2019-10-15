function preview_pattern(patArr, inds, waitTime)
%===================================================================================================
% Creates a figure and uses imagesc to plot an animation showing all or part of a single dimension 
% of a 3-D array with a specified delay between frames (created for visualizing pattern arrays for 
% visual arena panels)
%
% INPUTS: 
%       patArr      = array with dimensions [Y, X, frame] (e.g. a single dimension of a Pats array)
%
%       inds        = numeric vector containing the indices of the frames to be played (in order)
%
%       waitTime    = time in sec to wait between plotting each frame
%
%===================================================================================================

figure(1);clf;
for iFrame = inds
   imagesc(patArr(:, :, iFrame));
   drawnow()
   pause(waitTime)
end