set INTER;
set AGENTI;
param entr{AGENTI} symbolic in INTER;
param exit{AGENTI} symbolic in INTER;
set ROADS within (INTER cross INTER ); 
param Tmax;

var Use {(i, j) in ROADS, k in AGENTI, t in 1..Tmax} binary; 

minimize Total_Time: (sum {(i, j) in ROADS, k in AGENTI, t in 1..Tmax}  Use[i, j, k,t])/card(AGENTI);

subject to Start {k in AGENTI}: 
    sum {(entr[k], j) in ROADS} Use[entr[k], j, k, 1] = 1; 

subject to End {k in AGENTI}: 
    sum {(j, exit[k]) in ROADS} Use[j,exit[k] , k, Tmax] = 1; 

#subject to Balance {k in AGENTI, m in INTER diff {entr[k], exit[k]}}:
 #  sum {(i, m) in ROADS, t in 1..Tmax} Use[i, m, k, t] = sum {(m, j) in ROADS, t in 1..Tmax} Use[m, j, k, t]; 

subject to NonSovrapposizioneArchi {k in AGENTI, h in AGENTI, t in 1..Tmax, (i,j) in ROADS : h != k && i<=j}:
    Use[i,j,k,t] + Use[j,i,h,t] <= 1;

subject to NonSovrapposizioneNodi {i in INTER,t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k }:
   sum {(m,i) in ROADS: i<=m} Use[m,i,h,t] - sum {(i,j) in ROADS:i<=j} Use[i,j,k,t]  <= 1;

subject to passo {t in 1..Tmax}:
    sum{(i,j) in ROADS,  k in AGENTI: i<=j} Use[i,j,k,t] = 1;

subject to NonRitorno {i in INTER, k in AGENTI, t in 1..Tmax-1}:
    sum {(i, j) in ROADS: i!=j} (Use[i, j, k, t] + Use[j, i, k, t+1]) <= 1;

