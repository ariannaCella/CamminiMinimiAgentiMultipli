### INSIEMI

set NODI;  
set ARCHI within (NODI cross NODI);   
set AGENTI; 


### PARAMETRI

param N := card(NODI);  ### Numero dei nodi
param Agenti:= card(AGENTI);   ### Numero di agenti
param oi{i in AGENTI};   ### Nodo di origine per agente i
param di{i in AGENTI};   ### Nodo di destinazione per agente i
param Tmax;   ### Tempo massimo entro il quale tutti gli agenti devono raggiungere le loro destinazioni
###param N_percorrenze{(i,j) in ARCHI}

### VARIABILI

var x{(i,j) in ARCHI, k in AGENTI, t in 1..Tmax} binary;   ### variabile di decisione


### OBIETTIVO

minimize costo_minimo_totale : sum{(i,j) in ARCHI, k in AGENTI, t in 1..Tmax} x[i,j,k,t]; 


### VINCOLI

### Equilibrio 
###subject to equilibrio{k in AGENTI, i in NODI diff {oi[k], di[k]}} : sum{j in NODI : (i,j) in ARCHI}
###x[i,j,k] -  sum{j in NODI : (j,i) in ARCHI} x[j,i,k] = 0 ;

### Tempo massimo
subject to max_time{k in AGENTI}:
    sum{(i,j) in ARCHI, t in 1..Tmax} x[i,j,k,t] <= Tmax;

###
###subject to max_time:
###    sum{(i,j) in ARCHI} (N_Percorrenze[i,j]/Agenti) <= Tmax;
###

### Per evitare sovrapposizione di agenti in un nodo
subject to NonSovrapposizioneNodi {i in NODI, k in AGENTI, h in AGENTI, t in 1..Tmax : h!=k}:
    sum {j in NODI : (i,j) in ARCHI} x[i,j,k,t] + sum {j in NODI : (i,j) in ARCHI} x[i,j,h,t] <= 1;


### Per evitare sovrapposizione di agenti in un arco
subject to NonSovrapposizioneArchi {(i,j) in ARCHI, t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k}:
   ### x[i,j,k] + x[j,i,k] + x[i,j,h] + x[j,i,h] <= 1;
   x[i,j,k,t] + x[j,i,k,t] + x[i,j,h,t] + x[j,i,h,t] <=1;


### Agenti partono da nodo sorgente e arrivano al nodo destinazione
subject to PercorsoInizio {k in AGENTI}:
    sum {j in NODI : (oi[k],j) in ARCHI} x[oi[k],j,k,1] = 1;

subject to PercorsoFine {k in AGENTI}:
    sum {i in NODI, t in 1..Tmax : (i,di[k]) in ARCHI && t<=Tmax} x[i,di[k],k,t] = 1;

