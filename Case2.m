beta=0;
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


G11=tf(1.2+0.12*beta,[45 1],'InputDelay',27);
G12=tf(1.44+0.16*beta,[40 1],'InputDelay',27);
G21=tf(1.52+0.13*beta,[25 1],'InputDelay',15);
G22=tf(1.83+0.13*beta,[20 1],'InputDelay',15);
G31=tf(1.14+0.18*beta,[27 1]);
G32=tf(1.26+0.18*beta,[32 1]);
Gd=[G11 G12;G21 G22;G31 G32];
Gm=[Gm Gd];
Gm=c2d(ss(Gm),2);

clear G11 G12 G21 G22 G31 G32 Gd;

Gm = setmpcsignals(Gm,'MV',[1 2 3],'UD',[4 5]);
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
MPCobj.Model.Disturbance = [tf(1,[1 0]); tf(1,[1 0])];  %For unmeasured input disturbances, its model is an integrator to make it integrated white noises

Ts=2
Tstop = 500;                               % simulation time
Tf = round(Tstop/Ts); 

options = mpcsimopt(MPCobj);
options.Model = Gm;
options.UnmeasuredDisturbance = [(randn(Tf,1)) (rand(Tf,1))] ;


r=[0 0 0];


[y t u]=sim(MPCobj,Tf,r,options);

subplot(2,1,1)
plot(t,y)
xlabel('Time'); ylabel('Outputs, y(k)')
subplot(2,1,2)
stairs(t,u)
xlabel('Time'); ylabel('Inputs, y(k)')