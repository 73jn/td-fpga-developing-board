MSPS = input('Type the sampling rate (in MSPS):\n')
frequency = input('Type the signal frequency (in kHz):\n')

sample_rate = (MSPS*1000) / (frequency);

t=0:1/(frequency*sample_rate):1/frequency;
t2 =0:1/(frequency*sample_rate*10):1/frequency;
stem(t,sin(t*frequency*2*pi),'.')
hold on

plot(t2,sin(2*pi*frequency*t2));
legend('Sine 200KHz sampled @ 25MSPS','Sine 200KHz')