%% Include directories
clear; clc; close all;

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 0.2;                             % Duration  
t = 0:T:dur-T;                         % Time vector
len = length(t);                       % Simulation duration

%% Room model
[room,r.ftm] = roomParameters();
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);
        
sourceType = 'string';
switch sourceType
    case 'string'
        T12 = connectModels(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);
    case 'diracString'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K3, s.ftm.Mu, r.ftm.Mu);
end

%% Analyze Transfer Function
plotTransferFunction(T12,s,r,string)


%% SIMULATION - Time domain
%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);
excite = T12*s.ybar;

%% Room - Simulation time domain
[r.ybar,r.y] = simulateTimeDomain(r.state.Az,r.state.C,excite,T);

%% Sound
soundsc(r.y,Fs);

%% Spatial simulation
% String
xi = linspace(0,string.l,50);
stringC = s.state.Cs(xi, 1:s.ftm.Mu).';

% Room
x = linspace(0,room.Lx,100);
y = linspace(0,room.Ly,100);
roomC = r.ftm.primKern1(x, permute(y,[1 3 2]), 1:r.ftm.Mu) ./r.ftm.nmu ;
roomC = permute(roomC, [2,3,1]);

%% Animation
figure(741); hold on;
set(gcf,'position',[808   546   896   391]);
downsample = 1;
wantToRecord = false;


switch sourceType
    case 'string'
        gifName = 'animateSpaceAndTime.gif';
        animate = @animateSpaceAndTime;
    case 'diracString'
        gifName = 'animatePointStringInRoom.gif';
        animate = @animatePointStringInRoom;
end
        
        
if wantToRecord
    gif(gifName,'frame',gcf);
end
animate(x, y, roomC, r.ybar, string, stringC, s.ybar, downsample, wantToRecord)




