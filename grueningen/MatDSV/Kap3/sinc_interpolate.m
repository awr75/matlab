function f = sinc_interpolate(s,fs_in,fs_out) % s = sampled signal, fs_in = sampling frequency of input, fs_out = sampling frequency of output

N = length(s);
length_in_seconds = N / fs_in;
output_length_in_samples = ceil(length_in_seconds * fs_out);

Mat = [];
for n = 1:N
    t = [0:output_length_in_samples-1]/output_length_in_samples*length_in_seconds;
    t = t * fs_in - (n-1);
    Mat = [Mat; s(n)*sinc(t)];
end;

f = sum(Mat);


