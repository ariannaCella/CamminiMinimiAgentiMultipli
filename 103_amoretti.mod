set INTER;
set AGENTI;
param entr{AGENTI} symbolic in INTER;
param exit{AGENTI} symbolic in INTER;
set ROADS within (INTER cross INTER ); 
param Tmax;

var Use {(i, j) in ROADS, k in AGENTI, t in 1..Tmax} binary; 

minimize Total_Time: sum {(i, j) in ROADS, k in AGENTI, t in 1..Tmax}  Use[i, j, k,t];

subject to Start {k in AGENTI}: 
    sum {(entr[k], j) in ROADS} Use[entr[k], j, k, 1] = 1; 

subject to Balance {k in AGENTI, m in INTER diff {entr[k], exit[k]}}:
   sum {(i, m) in ROADS, t in 1..Tmax} Use[i, m, k, t] = sum {(m, j) in ROADS, t in 1..Tmax} Use[m, j, k, t]; 

subject to NonSovrapposizioneArchi {k in AGENTI, h in AGENTI, t in 1..Tmax, (i,j) in ROADS : h != k && i<=j}:
    Use[i,j,k,t] + Use[j,i,h,t] <= 1;

subject to NonSovrapposizioneNodi {i in INTER,t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k }:
   sum {(m,i) in ROADS} Use[m,i,h,t] - sum {(i,j) in ROADS} Use[i,j,k,t]  <= 1;

subject to passo {t in 1..Tmax}:
    sum{(i,j) in ROADS, k in AGENTI: i!=j} Use[i,j,k,t]= 1;


#subject to prova {t in 1..Tmax, i in INTER}:
  #  sum{(j,i) in ROADS, k in AGENTI} Use[j,i,k,t] <= 1;


### LA LOGICA DA IMPLEMENTARE è CHE SE SI HA CHE DUE AGENTI VOGLIONO ANDARE CONTEMPORANEAMENTE NELLO STESSO NODO, SOLO UNO VADA MENTRE L'ALTRO O PRENDE UNA STRADA DIVERSA O RIMANE NEL SUO SELF LOOP FINO A QUANDO NON SARà LIBERO IL NODO
# Variabili ausiliarie
#var z{(i, j) in ROADS, k in AGENTI, h in AGENTI, t in 1..Tmax, (m,i) in ROADS :  m!=j};
##var z1{(i, j) in ROADS, k in AGENTI, h in AGENTI, t in 1..Tmax, (m,i) in ROADS: m!=j} binary;

# Vincolo per linearizzare la somma delle variabili Use
    
#subject to Linearization2 {(i, j) in ROADS, t in 1..Tmax, k in AGENTI, h in AGENTI, (m,i) in ROADS :  m!=j}:
#    z1[i, j, k, h, t, m] = (if (Use[i, j, k, t] + Use[m, i, h, t]) >= 2 then 1 else 0 );

#subject to Linearization3 {(i, j) in ROADS, t in 1..Tmax, k in AGENTI, h in AGENTI, (m,i) in ROADS :  m!=j}:
 #   Use[i,j,k,t] >= z1[i, j, k, h, t, m];

#subject to Linearization4 {(i, j) in ROADS, t in 1..Tmax, k in AGENTI, h in AGENTI, (m,i) in ROADS :  m!=j}:
 #   Use[m,i,h,t] <= 1-z1[i, j, k, h, t, m];
    


