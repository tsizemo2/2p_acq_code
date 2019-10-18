function plot_data(src, event)
    persistent tempData
    persistent tempTimeStamps
    
    plotDur = 15;
    smWin = 5;
    
    if isempty(tempData)
        tempData = [];
        tempTimeStamps = [];
    end
    
    tempData = [tempData; event.Data];
    tempTimeStamps = [tempTimeStamps; event.TimeStamps];
    nSamples = numel(tempData);
    if nSamples > src.Rate * plotDur
        tempData = tempData(nSamples - (src.Rate * plotDur):end);
        tempTimeStamps = tempTimeStamps(nSamples - (src.Rate * plotDur):end);
    end
    
    figure(1);
    plot(tempTimeStamps, movmean(tempData, smWin));
    xL = xlim();
    if xL(2) < plotDur
        xlim([xL(1), plotDur]);
    else
        xlim([min(tempTimeStamps), max(tempTimeStamps)])
    end
    
end