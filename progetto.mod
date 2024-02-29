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
param c{i in NODI, k in AGENTI} default 1;
param M := 5;  # n nodi +1  sufficiente
### VARIABILI
var x{k in AGENTI, t in 1..Tmax} integer;   ### variabile che ci restituisce in quale nodo è l'agente
var z{k in AGENTI, t in 1..Tmax} binary; #ci indica se l'agente attraversa un arco al tempo t
# Variabile decisionale
var y{i in AGENTI, j in AGENTI: i!=j} integer;
var w{k in AGENTI,h in AGENTI, t in 1..Tmax} binary;

### OBIETTIVO
minimize costo_minimo_totale : sum{k in AGENTI, t in 1..Tmax} c[x[k,t],k]*z[k, t];

### VINCOLI

#vincolo origine
subject to Start {k in AGENTI}: 
    x[k,1] = oi[k]; 

#vincolo destinazione
subject to End {k in AGENTI}: 
    x[k,Tmax] = di[k]; 

#vincolo per la non sovrapposizione dei nodi
#subject to NodeOverlap {t in 1..Tmax, k in AGENTI, h in AGENTI : h != k}:
#    x[k,t] != x[h,t];

# Vincoli per linearizzare
subject to NodeOverlap1 {t in 1..Tmax, k in AGENTI, h in AGENTI : h != k}:
    x[k,t] - x[h,t] >= -M * (1 - w[k,h,t]);

subject to NodeOverlap2 {t in 1..Tmax, k in AGENTI, h in AGENTI : h != k}:
    x[h,t] - x[k,t] >= -M * w[k,h,t];

#vincolo per la non sovrapposizione degli archi
# Vincoli per linearizzare 
subject to linearization {t in 1..Tmax-1, i in AGENTI, j in AGENTI: i!=j}:
    y[i,j] >= x[i,t+1] - x[j,t] + 1;
    
subject to linearization2 {t in 1..Tmax-1, i in AGENTI, j in AGENTI: i!=j}:
    y[i,j] >= x[j,t+1] - x[i,t] + 1;

subject to at_least_one {i in AGENTI, j in AGENTI: i!=j}:
    y[i,j] >= 1;


