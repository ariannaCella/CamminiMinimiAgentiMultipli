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
var y{k in AGENTI, i in NODI, t in 1..Tmax} binary;  ### variabile di posizione agente

### OBIETTIVO

minimize costo_minimo_totale : sum{(i,j) in ARCHI, k in AGENTI, t in 1..Tmax} x[i,j,k,t]; 

### VINCOLI

### passo per farlo muovere(per ora è inutile che ci sia o no questo)
subject to passo {t in 1..Tmax, k in AGENTI}:
    sum{(i,j) in ARCHI} x[i,j,k,t] = 1;

### Equilibrio 
subject to equilibrio{k in AGENTI,t in 1..Tmax, i in NODI diff {oi[k], di[k]}} : 
    sum{j in NODI : (i,j) in ARCHI} x[i,j,k,t] -  sum{j in NODI : (j,i) in ARCHI} x[j,i,k,t] = 0 ;


### Per evitare sovrapposizione di agenti in un nodo (è inutile per ora che ci sia o non ci sia)
###subject to NonSovrapposizioneNodiVar {i in NODI, t in 1..Tmax} :
###  sum{k in AGENTI} y[k,i,t] <= 1;

subject to NonSovrapposizioneNodi {i in NODI,t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k}:
   sum {j in NODI, m in NODI: (i,j) in ARCHI && (m,i) in ARCHI && m!=j} (x[i,j,k,t] +  x[m,i,h,t]) <= 1;

### Per evitare sovrapposizione di agenti in un arco
subject to NonSovrapposizioneArchi {(i,j) in ARCHI, t in 1..Tmax, k in AGENTI, h in AGENTI : h!=k}:
   x[i,j,k,t] + x[j,i,k,t] + x[i,j,h,t] + x[j,i,h,t] <=1;


subject to Origine {k in AGENTI}: 
    sum{j in NODI : (oi[k],j) in ARCHI } x[oi[k],j,k,1] = 1;  # L'agente parte dal nodo origine oi

subject to Destinazione {k in AGENTI}: 
    sum{t in 1..Tmax, i in NODI : (i,di[k]) in ARCHI} x[i,di[k],k,t] = 1;  # L'agente arriva al nodo destinazione di

###  inutile per ora
###subject to sorgente {k in AGENTI}:
###  y[k,oi[k],1]=1;


### Non possono tornare alla loro origine
subject to NonTornareOrigine{k in AGENTI, t in 1..Tmax}:
sum{i in NODI: (i,oi[k]) in ARCHI && i!=oi[k]} x[i,oi[k],k,t] = 0;