MSPS = input('Type the sampling rate (in MSPS):\n')
frequency = input('Type the signal frequency (in kHz):\n')

sample_rate = (MSPS*1000) / (frequency);

t=0:2*pi/sample_rate:2*pi;
stem(t,sin(t))