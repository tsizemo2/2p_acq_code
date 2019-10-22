

test = rollXmat yawZmat * pitchYmat * rollXmatparentDir = 'C:\Users\Wilson Lab\Documents\FicTrac_MM\data'






dataFiles = dir(fullfile(parentDir, '*.dat'));

test = csvread(fullfile(parentDir, dataFiles(e).name));


intHD = test(:, 17);
moveDir = test(:, 18);
fwMove = test(:, 20);
sideMove = test(:, 21);


figure(1);clf;plot(fwMove);
hold on; plot(sideMove);
figure(2);clf;plot(intHD);