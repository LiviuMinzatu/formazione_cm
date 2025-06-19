Guida al Registry Docker Locale

Questa guida descrive come configurare e utilizzare un registry Docker locale per gestire immagini personalizzate, partendo dal download da Docker Hub fino alla gestione tramite Ansible.

---

1. Scaricare le immagini base da Docker Hub

Utilizzare i seguenti comandi per ottenere le immagini ufficiali:

docker pull alpine  
docker pull nginx  
docker pull redis

---

2. Taggare le immagini per il registry locale

Le immagini devono essere ritaggate con un nuovo nome che includa l’indirizzo del registry locale:

docker tag alpine localhost:5000/alpine:latest  
docker tag nginx localhost:5000/nginx:latest  
docker tag redis localhost:5000/redis:latest

---

3. Eseguire il push delle immagini nel registry locale

Una volta taggate, è possibile inviarle al registry:

docker push localhost:5000/alpine:latest  
docker push localhost:5000/nginx:latest  
docker push localhost:5000/redis:latest

---

4. Elencare le immagini disponibili nel registry

Per verificare le immagini presenti nel registry:

curl http://localhost:5000/v2/_catalog

Output atteso:
{"repositories":["alpine","nginx","redis"]}

---

5. Rimuovere un'immagine locale

È possibile rimuovere l'immagine dalla cache locale:

docker rmi localhost:5000/alpine:latest

---

6. Recuperare l'immagine dal registry locale

Per verificare il corretto funzionamento del registry:

docker pull localhost:5000/alpine:latest

---

7. Avviare un container dal registry

Per eseguire un container temporaneo:

docker run -it --rm localhost:5000/alpine:latest sh

---

8. Rimuovere le immagini inutilizzate

Per liberare spazio:

docker image prune -a

---

9. Configurazione automatizzata del Registry con Ansible

Per semplificare e rendere ripetibile l’intero processo di installazione e configurazione del registry locale, è possibile utilizzare un playbook Ansible dedicato.  
Questo playbook provvede a installare Docker, configurare l’utente, creare la directory per la persistenza dei dati e avviare il container del registry in modo automatizzato.  
L’uso di Ansible garantisce coerenza tra ambienti e semplifica notevolmente il provisioning della macchina.

Una volta eseguito il playbook, il registry sarà operativo e accessibile all’indirizzo `http://localhost:5000`.

---

Requisiti:

- Docker installato
- Ansible installato
- Registry locale in ascolto sulla porta 5000
