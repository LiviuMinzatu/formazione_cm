# Progetto Jenkins + Docker + Registry Privato

In questo progetto ho creato una macchina virtuale che ospita Jenkins, configurato in modo da poter utilizzare Docker installato nella VM.

Successivamente ho realizzato un semplice progetto di test: una mini applicazione Flask contenuta in un file `app.py`, accompagnata da un `Dockerfile` che permette di costruire un'immagine Docker eseguibile.

Una volta preparati questi file, ho configurato un Docker registry privato locale, accessibile all'indirizzo `192.168.56.10:5000`, in modo da avere un repository interno dove pushare le immagini costruite.

Per far funzionare correttamente il push verso un registry HTTP, ho dovuto configurare Docker in modo da accettare registry "insecure", modificando il file `/etc/docker/daemon.json` e riavviando il servizio Docker.

A questo punto ho realizzato una pipeline Jenkins dichiarativa (`Jenkinsfile`) che esegue i seguenti step:

1. Costruisce un'immagine Docker partendo dai file presenti nella workspace Jenkins.
2. Applica un tag progressivo utilizzando la variabile `BUILD_NUMBER`.
3. Effettua il push dell'immagine sul registry privato.

Ho evitato volutamente l’uso di plugin Jenkins come `Docker Pipeline` e ho preferito utilizzare semplici comandi `sh` all’interno della pipeline, in modo da rendere il progetto il più compatibile e controllabile possibile.

Infine ho testato il caricamento dell’immagine nel registry, visualizzando anche i tag disponibili tramite comandi `curl` su endpoint HTTP standard offerti dal registry.
