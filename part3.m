clc
clear all
close all

r_0 = 4.22e7;
omega_0 = 7.29e-5;


A = [0              1                   0       0               ;
     3*omega_0^2    0                   0       2*r_0*omega_0   ;
     0              0                   0       1               ;
     0              -2*omega_0/r_0      0       0               ;
    ];

B = [ 0             0     ;
      1             0     ;
      0             0     ;
      0             1/r_0 ; 
    ];

C = [1/r_0      0       0       0;
     0          0       1       0
    ];

D = [0 0;
     0 0];

sys = ss(A, B, C, D);
  
T0 = 86400;
Tf = T0*5; % seconds in a day * 5
fn = 1/T0 * 2; % nyquist rate
dt = 0.5;

%% Step Response
t = 0:dt:Tf;
u = ones(size(t));
xo = [0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Zero-state Step Response')
plotStates(t, x1, x2, 'Zero-state Step States')

%% Ramp Response
t = 0:dt:Tf;
u = t/T0;
xo = [0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Zero-state Ramp Response')
plotStates(t, x1, x2, 'Zero-state Ramp States')

%% Impulse Response
t = 0:dt:Tf;
u = zeros(size(t));
u(1) = 1;% create impulse
xo = [0 0 0 omega_0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Zero-state Impulse Response')
plotStates(t, x1, x2, 'Zero-state Impulse States')

%% Sinusoidal Repsonse
t = 0:dt:Tf;
f = 1/(2*pi);
u = sin(2*pi*f*t);
xo = [0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Zero-state Sinusoidal Response')
plotStates(t, x1, x2, 'Zero-state Sinusoidal States')

%% Resonant Sinusoidal Repsonse
t = 0:dt:Tf;
f = 1/T0;
u = sin(2*pi*f*t);
xo = [0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Zero-state Resonant Sinusoidal Response')
plotStates(t, x1, x2, 'Zero-state Resonant Sinusoidal States')

%% Non-zero State Step Response
t = 0:dt:Tf;
u = ones(size(t));
xo = [r_0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Non-Zero State Step Response')
plotStates(t, x1, x2, 'Non-Zero State Step States')

%% Non-zero State Resonant Sinusoidal Repsonse
t = 0:dt:Tf;
f = 1/T0;
u = sin(2*pi*f*t);
xo = [r_0 0 0 0];

[y1, x1, y2, x2] = getResponse(sys, u, t, xo);
plotResponse(t, y1, y2, 'Non-Zero State Resonant Sinusoidal Response')
plotStates(t, x1, x2, 'Non-Zero State Resonant Sinusoidal States')

function [y1, x1, y2, x2] = getResponse(sys, u, t, xo)
    u1 = [u; zeros(size(t))];
    [y1, t1, x1] = lsim(sys, u1, t, xo);

    u2 = [zeros(size(t)); u];
    [y2, t2, x2] = lsim(sys, u2, t, xo);
end

function plotResponse(t, y1, y2, title)
    figure;
    
    sgtitle(title);

    % 11
    subplot(2,2,1);
    plot(t, y1(:,1));
    xlabel('time (s)');
    ylabel('normalized radial position');
    legend('h11')

    % 12
    subplot(2,2,3);
    plot(t, y1(:,2));
    xlabel('time (s)');
    ylabel('angular position (rad)');
    legend('h21')

    % 21
    subplot(2,2,2);
    plot(t, y2(:,1));
    xlabel('time (s)');
    ylabel('normalized radial position');
    legend('h12')

    % 22
    subplot(2,2,4);
    plot(t, y2(:,2));
    xlabel('time (s)');
    ylabel('angular position (rad)');
    legend('h22')

end

function plotStates(t, x1, x2, title)
    figure;
    
    sgtitle(title);

    % radial position
    subplot(4, 2, 1)
    plot(t, x1(:, 1));
    xlabel('time (s)');
    ylabel('radial position (m)');
    legend('$r_1$', 'Interpreter', 'latex');
    
    subplot(4, 2, 2)
    plot(t, x2(:, 1));
    xlabel('time (s)');
    ylabel('radial position (m)');
    legend('$r_2$', 'Interpreter', 'latex');
    
    % radial velocity
    subplot(4, 2, 3)
    plot(t, x1(:, 2));
    xlabel('time (s)');
    ylabel('radial velocity (m/s)');
    legend('$\dot{r_1}$', 'Interpreter', 'latex');
    
    subplot(4, 2, 4)
    plot(t, x2(:, 2));
    xlabel('time (s)');
    ylabel('radial velocity (m/s)');
    legend('$\dot{r_2}$', 'Interpreter', 'latex');
    
    % angular position
    subplot(4, 2, 5)
    plot(t, x1(:, 3));
    xlabel('time (s)');
    ylabel('angular position (rad)');
    legend('$\phi_1$', 'Interpreter', 'latex');
    
    subplot(4, 2, 6)
    plot(t, x2(:, 3));
    xlabel('time (s)');
    ylabel('angular position (rad)');
    legend('$\phi_2$', 'Interpreter', 'latex');
    
    % angular velocity
    subplot(4, 2, 7)
    plot(t, x1(:, 4));
    xlabel('time (s)');
    ylabel('angular velocity (rad/s)');
    legend('$\omega_1$', 'Interpreter', 'latex');
    
    subplot(4, 2, 8)
    plot(t, x2(:, 4));
    xlabel('time (s)');
    ylabel('angular velocity (rad/s)');
    legend('$\omega_2$', 'Interpreter', 'latex');
   
   
end


