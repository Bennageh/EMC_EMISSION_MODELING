% Load datas from Spectrum analyser Excel Sheet
datas = readmatrix('datas_2.xlsx'); %  551 rows, 7 columns
awgn_data=readmatrix('awgn_2.xlsx');   %  551 rows, 3 columns

% Frequencies column
frequencies=datas(1:end,2);  

% Received wireless signal Power (Radiated Emission Measurement) 
dB_RE=datas(1:end,3);
mW_RE=10.^(dB_RE/10);       % Conversion to milliWatt

% NLOS signal data computation from experimental data
mW_NLOS=datas(1:end,6);
dB_NLOS=datas(1:end,5);

% Transmitted power density at TX antenna (Conducted Emission Measurement)
dB_CE_TX_antenna=datas(1:end,9);
CE_TX_antenna=10.^(dB_CE_TX_antenna/10)*0.001;    % Conversion to Watt
R_gain_antenna=datas(1:end,13);             % Gain of receiving antenna

% Theoretical Received signal Power without scattering from Conducted
% Emission (Friis)- Large-scale fading
dB_RE_th=datas(1:end,4);
mW_RE_th=10.^(dB_RE_th/10);

% Small-scale fading is reprensted by AWGN Channel and Rician Channel
% AWGN Channel : Noise Open Area measuremenmt
awgn_exp=awgn_data(1:end,4);
SNR_dB=mean(dB_RE(194:326)-awgn_exp(194:326));  % SNR(dB) in transmission bandwidth
SNR=10^(SNR_dB/10);          % SNR(mW) in transmission bandwidth 

% statitical awgn model
A=mean(mW_RE(194:326,1));     % Awgn mean at active transmision band in rows 194:326
Var=var(mW_RE(194:326,1));    % 
dim_awgn=size(awgn_exp);    % dimension (551,1)
M=dim_awgn(1);
noise=sqrt(2*Var)*(randn(M,1)+1i*randn(M,1))+A;
% Apply the Hamming window to the noise since it is non periodic
window = hamming(M);
noise_windowed = noise.*window;
noise_f=fft(noise_windowed.^2)/M;   % for normalization
Noise=abs(noise_f);

% Rician Channel
% K approximated through the bandwidth 2405.376MHz ~ 2477.056MHz 
S2=dB_RE_th(194:326,1);     % Deterministic received power
sig2=dB_NLOS(194:326,1);    % experimental scattered signal power 
K= mean(S2-sig2);           % K-factor in dB
k=10^(K/10);                % k-factor

% Rician Channel response definition h: 
dimension=size(mW_RE);      % (551,1)
N=dimension(1);
h_NLOS=(1/sqrt(2))*(randn(N,1)+1i*randn(N,1));  
h_LOS= (1/sqrt(2))*exp(-1i*2*pi()*rand(N,1));
h=sqrt(k/(k+1))*h_LOS+sqrt(1/(1+k))*h_NLOS;

% Apply the Hamming window to the channel response since h is non periodic
window = hamming(N);
h_windowed = h .* window;

% Compute the FFT
H_f = fft(h_windowed);

% Y_f is the theoretical received power over the Rician Channel in
% Frequency domain
Y_f=((abs((H_f))).^2).*CE_TX_antenna+noise_f.^2+sqrt(2*CE_TX_antenna).*H_f.*noise_f;
Y_abs=abs(Y_f);

% Received signal considering small-scale and large-scale fading
Y_dB=10*log10(Y_abs)+R_gain_antenna+3+20*log10(300./(4*pi()*frequencies*20))-0;
%Y_dB=R_gain_antenna+ 20*log10(3e2./(4*pi()*frequencies*20))+dB_CE_TX_antenna+3;
%   Plot the results comparison between Received emission power and
%   statistic model of received power
figure("Name","Open Area Environment")
plot(frequencies,dB_RE,'r')
hold on 
plot(frequencies,Y_dB,'b')
legend('Experimental radiated emission Power','Theoric radiated emission power', 'Location', 'Best')
grid on
xlabel('frequency');
ylabel('Power in dBm');

% Monte Carlo simulation
% Initializing the number of simulations
numSimulations = 10000;  % Number of Monte Carlo simulations
% Initializing arrays to store MSE and MAE for each simulation
mse_values = zeros(numSimulations, 1);
mae_values = zeros(numSimulations, 1);

% Monte Carlo simulations
for sim = 1:numSimulations
    % statitical awgn model
    noise=sqrt(2*Var)*(randn(M,1)+1i*randn(M,1))+A;
    % Apply the Hamming window to the noise since it is non periodic
    window = hamming(M);
    noise_windowed = noise.*window;
    noise_f=fft(noise_windowed.^2)/M;   % for normalization
    Noise=abs(noise_f);

    % Rician Channel response definition h: 
    h_NLOS=(1/sqrt(2))*(randn(N,1)+1i*randn(N,1));  
    h_LOS= (1/sqrt(2))*exp(-1i*2*pi()*rand(N,1));
    h=sqrt(k/(k+1))*h_LOS+sqrt(1/(1+k))*h_NLOS;

    % Apply the Hamming window to the channel response since h is non periodic
    window = hamming(N);
    h_windowed = h .* window;

    % Compute the FFT
    H_f = fft(h_windowed);
    
    % Y_f is the theoretical received power over the Rician Channel in
    % Frequency domain
    Y_f=((abs((H_f))).^2).*CE_TX_antenna+noise_f.^2+sqrt(2*CE_TX_antenna).*H_f.*noise_f;
    Y_abs=abs(Y_f);

    % Received signal considering small-scale and large-scale fading
    Y_dB=10*log10(Y_abs)+R_gain_antenna+3+20*log10(300./(4*pi()*frequencies*20))-0;
    
    % Compute the errors for each simulation
    error_sim = Y_dB - dB_RE;  % The difference between theoretical and experimental data

    % Calculation of the Mean Squared Error (MSE) for this simulation
    mse_values(sim) = mean(error_sim .^ 2);

    % Calculation of the Mean Absolute Error (MAE) for this simulation
    mae_values(sim) = mean(abs(error_sim));
end

% Calculate the average MSE and MAE over all simulations
mean_mse = mean(mse_values);
mean_mae = mean(mae_values);

% Display the Monte Carlo simulation results
fprintf('The Mean Squared Error (MSE) after Monte Carlo simulations is: %f\n', mean_mse);
fprintf('The Mean Absolute Error (MAE) after Monte Carlo simulations is: %f\n', mean_mae);
