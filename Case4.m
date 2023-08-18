clear;
clc;
G11=tf(4.05,[50 1],'InputDelay',27);
G12=tf(1.77,[60 1],'InputDelay',28);
G13=tf(5.88,[50 1],'InputDelay',27);
G21=tf(5.39,[50 1],'InputDelay',18);
G22=tf(5.72,[60 1],'InputDelay',14);
G23=tf(6.9,[40 1],'InputDelay',15);
G31=tf(4.38,[33 1],'InputDelay',20);
G32=tf(4.42,[44 1],'InputDelay',22);
G33=tf(7.2,[19 1]);

Gp=[G11 G12 G13; G21 G22 G23;G31 G32 G33];
clear G11 G12 G13 G21 G22 G23 G31 G32 G33;


Gp=c2d(ss(Gp),2);


G11=tf(1.2,[45 1],'InputDelay',27);
G12=tf(1.44,[40 1],'InputDelay',27);
G21=tf(1.52,[25 1],'InputDelay',15);
G22=tf(1.83,[20 1],'InputDelay',15);
G31=tf(1.14,[27 1]);
G32=tf(1.26,[32 1]);
Gd=[G11 G12;G21 G22;G31 G32];

clear G11 G12 G21 G22 G31 G32;

beta=1;
G11=tf(4.05+2.11*beta,[50 1],'InputDelay',27);
G12=tf(1.77-0.39*beta,[60 1],'InputDelay',28);
G13=tf(5.88+0.59*beta,[50 1],'InputDelay',27);
G21=tf(5.39+3.29*beta,[50 1],'InputDelay',18);
G22=tf(5.72-0.57*beta,[60 1],'InputDelay',14);
G23=tf(6.9+0.89*beta,[40 1],'InputDelay',15);
G31=tf(4.38+3.11*beta,[33 1],'InputDelay',20);
G32=tf(4.42-0.73*beta,[44 1],'InputDelay',22);
G33=tf(7.2+1.33*beta,[19 1]);

Gm=[G11 G12 G13; G21 G22 G23;G31 G32 G33];

clear G11 G12 G13 G21 G22 G23 G31 G32 G33;


Gm=c2d(ss(Gm),2);

Gp = setmpcsignals(Gp,'MV',[1 2 3]);
Gm = setmpcsignals(Gm,'MV',[1 2 3]);

MPCobj=mpc(Gm);
MPCobj.P=40;
MPConj.C=10;
MPCobj.MV(1).Min = -0.5;
MPCobj.MV(1).Max = 0.5;
MPCobj.MV(1).RateMin = -0.05;
MPCobj.MV(1).RateMax = 0.05

MPCobj.MV(2).Min = -0.5;
MPCobj.MV(2).Max = 0.5;
MPCobj.MV(2).RateMin = -0.05;
MPCobj.MV(2).RateMax = 0.05;

MPCobj.MV(3).Min = -0.5;
MPCobj.MV(3).Max = 0.5;
MPCobj.MV(3).RateMin = -0.05;
MPCobj.MV(3).RateMax = 0.05;


MPCobj.OV(1).Min = -0.5;
MPCobj.OV(1).Max = 0.5;
MPCobj.OV(3).Min = -0.5;


MPCobj.W.OV=[1 1 0];                         % weight
MPCobj.W.MVRate=[1.5 0.15 1.5];              %manipulated rate weights

Ts=2
Tstop = 500;                               % simulation time
Tf = round(Tstop/Ts); 

setoutdist(MPCobj,'model',Gd);% integrator for white noise
options = mpcsimopt(MPCobj);
options.OutputNoise=[randn(Tf,1) randn(Tf,1) randn(Tf,1)];
options.Model = Gp;


r=[0 0 0];


[y t u]=sim(MPCobj,Tf,r,options);

subplot(2,1,1)
plot(t,y)
xlabel('Time'); ylabel('Outputs, y(k)')
subplot(2,1,2)
stairs(t,u)
xlabel('Time'); ylabel('Inputs, y(k)')