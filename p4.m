clc
close all

%% ss model
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

%% controllability matrix
Co = ctrb(A,B);
Co_rank = rank(Co);
 
%% observability matrix
Ob = obsv(A,C);
Ob_rank = rank(Ob);

%% jordan form
[Q, J] = jordan(A);
Aj = Q\A*Q;
Bj = Q\B;
Cj = C*Q;
 
%% kalman decomposition
[Aco,Bco,Cco,Pco] = ctrbf(A,B,C);
[Aob,Bob,Cob,Pob] = obsvf(A,B,C);
 
%% minimal realization
sys = ss(A,B,C,D)
msys = minreal(sys)

 
 