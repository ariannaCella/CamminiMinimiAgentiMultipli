set INTER;
set AGENTI;
param entr{AGENTI} symbolic in INTER;
param exit{AGENTI} symbolic in INTER;
set ROADS within (INTER cross INTER ); 
param Tmax;

var Use {(i, j) in ROADS, k in AGENTI, t in 1..Tmax} binary; 

minimize Total_Time:(sum {(i, j) in ROADS, k in AGENTI, t in 1..Tmax}  Use[i, j, k, t] - sum{k in AGENTI, t in 1..Tmax} Use[exit[k],exit[k],k,t]);

subject to Start {k in AGENTI}: 
    sum {(entr[k], j) in ROADS} Use[entr[k], j, k, 1] = 1; 

subject to End {k in AGENTI}: 
    sum {(i, exit[k]) in ROADS} Use[i, exit[k], k, Tmax] = 1; 

subject to NonSovrapposizioneNodi {i in INTER, t in 1..Tmax}:
   sum {k in AGENTI, (i,j) in ROADS} Use[i,j,k,t] <= 1;

subject to NonSovrapposizioneArchi {k in AGENTI, h in AGENTI, t in 1..Tmax, (i,j) in ROADS : h != k && i<=j}:
    Use[i,j,k,t] + Use[j,i,h,t] <= 1;

subject to NodiAdiacenti {k in AGENTI, t in 2..Tmax, i in INTER}:
    sum {(i, j) in ROADS} Use[i, j, k, t] = sum {(m, i) in ROADS} Use[m, i, k, t-1];