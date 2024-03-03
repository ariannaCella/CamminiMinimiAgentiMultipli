set INTER;
set AGENTI;
param entr{AGENTI} symbolic in INTER;
param exit{AGENTI} symbolic in INTER;
set ROADS within (INTER cross INTER ); 
param Tmax;

var Use {(i, j) in ROADS, k in AGENTI, t in 1..Tmax} binary; 

minimize Total_Time:(sum {(i, j) in ROADS, k in AGENTI, t in 1..Tmax}  Use[i, j, k, t] - sum{i in INTER, k in AGENTI, t in 1..Tmax: i= exit[k]} Use[i,i,k,t]);

subject to Start {k in AGENTI}: 
    sum {(entr[k], j) in ROADS} Use[entr[k], j, k, 1] = 1; 

subject to End {k in AGENTI}: 
   sum {(j, exit[k]) in ROADS} Use[j,exit[k] , k, Tmax] = 1; 


subject to NonSovrapposizioneArchi {k in AGENTI, h in AGENTI, t in 1..Tmax, (i,j) in ROADS : h != k && i<=j}:
    Use[i,j,k,t] + Use[j,i,h,t] <= 1;

subject to NonSovrapposizioneNodi {i in INTER,t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k }:
   sum {(m,i) in ROADS: i<=m} Use[m,i,h,t] - sum {(i,j) in ROADS:i<=j} Use[i,j,k,t]  <= 1;

subject to Continuity {k in AGENTI, t in 2..Tmax, i in INTER}:
    sum {(i, j) in ROADS} Use[i, j, k, t] = sum {(j, i) in ROADS} Use[j, i, k, t-1];

subject to Unique_Node_Occupancy {i in INTER, t in 1..Tmax}:
    sum {j in INTER, k in AGENTI: (i,j) in ROADS} Use[i,j,k,t] <= 1;




    
