set INTER;
set AGENTI;
param entr{AGENTI} symbolic in INTER;
param exit{AGENTI} symbolic in INTER;
set ROADS within (INTER cross INTER );
param time {ROADS} >= 0; 

var Use {(i, j) in ROADS, k in AGENTI} >= 0; 

minimize Total_Time: sum {(i, j) in ROADS, k in AGENTI} time[i, j] * Use[i, j, k];

subject to Start {k in AGENTI}: 
    sum {(entr[k], j) in ROADS} Use[entr[k], j, k] = 1; 

subject to Balance {k in AGENTI, m in INTER diff {entr[k], exit[k]}}:
    sum {(i, m) in ROADS} Use[i, m, k] = sum {(m, j) in ROADS} Use[m, j, k]; 

subject to NonSovrapposizioneArchi {k in AGENTI, h in AGENTI,  (i,j) in ROADS : h != k}:
    Use[i,j,k] + Use[i,j,h] <= 1;

subject to NonSovrapposizioneNodi {i in INTER,k in AGENTI, h in AGENTI : h != k}:
    sum {(i,t) in ROADS} (Use[i,t,k] + Use[i,t,h]) <= 1;

data;
set INTER := a b c d e f g ;
set AGENTI := 1 2;
param entr := 
    1 a
    2 b;
param exit := 
    1 g
    2 f;

param : ROADS: time := 
    a b 50, a c 100
    b d 40, b e 20
    c d 60, c f 20
    d e 50, d f 60
    e g 70, f g 70;

