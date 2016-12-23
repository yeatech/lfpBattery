function dischargeFitTests(fig)
if nargin == 0
    fig = false;
end

import lfpBattery.*

%% Input data
load(fullfile(pwd,'dischargeFitTests','testCurve.mat'))

%% Params
E0 = 3;
Ea = 0.01;
Eb = 0.22;
Aex = 0.1;
Bex = -0.9;
Cex = 0.1;
x0 = -3;
v0 = 1400;
delta = 260;
x0 = [E0; Ea; Eb; Aex; Bex; Cex; x0; v0; delta];

%% Args
Temp = const.T_room;
CRate = 1;

%% Initialize with params
d = dischargeFit(V, C_d, CRate, Temp, 'x0', x0, 'mode', 'lsq');
if fig
    d.plotResults
end
%% Initialize without params
d2 = dischargeFit(V, C_d, CRate, Temp, 'mode', 'lsq');
if fig
    d2.plotResults
end

%% fminsearch options
d3 = dischargeFit(V, C_d, CRate, Temp, 'x0', x0, 'mode', 'fmin');
if fig
    d3.plotResults
end
d4 = dischargeFit(V, C_d, CRate, Temp, 'mode', 'fmin');
if fig
    d4.plotResults
end

%% switch modes
d2.mode = 'fmin';
if fig
   d2.plotResults
end

%% both
dischargeFit(V, C_d, CRate, Temp, 'mode', 'both'); % validate syntax
d = dischargeFit(V, C_d, CRate, Temp); % 'both' should be default
if fig
    d.plotResults
end

% TODO: Create assertion tests
assert(isequal(d.rmse, d2.rmse), 'mode switch or ''both'' mode not functioning as expected')

disp('discharge fit tests passed')

end