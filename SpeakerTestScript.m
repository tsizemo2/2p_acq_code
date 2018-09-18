

f = 200;
dur = 2;


s = daq.createSession('ni');
s.addAnalogOutputChannel('Dev3', 0, 'Voltage');
sampRate = 10000;
s.Rate = sampRate;
ts = 1/sampRate;
t = 0:ts:dur;
sineTone = sin(2*pi*f*t) * 10;
sineTone(end) = 0;
queueOutputData(s, sineTone');
s.startForeground();