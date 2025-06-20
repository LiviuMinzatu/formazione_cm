# Container ssh automatizzato con Ansible, Docker, e registry locale

Questo progetto automatizza la creazione, il build, il push e l'avvio di container Docker (Debian e Rocky) configurati per l'accesso SSH tramite chiave pubblica. L'automazione è realizzata tramite Ansible e coinvolge l'uso di un registry Docker locale.

## Struttura della directory

```
formazione_cm/S3/

Dockerfile (uno per Debian e uno per Rocky, nelle rispettive directory)
id_key_genericuser.pub          # Chiave pubblica SSH da iniettare nei container

playbook.yml                    # Playbook Ansible principale

roles/                          # Directory con ruoli Ansible modularizzati
registry/
tasks/main.yml          # Avvia il registry Docker locale

build_images/
tasks/main.yml          # Effettua il build delle immagini

push_images/
tasks/main.yml          # Tagga e pusha le immagini nel registry

run_containers/
tasks/main.yml          # Avvia i container mappando le porte SSH

vars.yml                        # Variabili comuni: nomi, percorsi, porte container

macchine/
Debian/Dockerfile           # Dockerfile per il container Debian
Rocky/Dockerfile            # Dockerfile per il container Rocky
```

## Come avviare il tutto

### 1. Playbook Principale

`playbook.yml` è il punto d'ingresso. Esegue i seguenti ruoli in ordine:

- **registry**: avvia un registry locale su `localhost:5050`
- **build_images**: costruisce le immagini usando Dockerfile e inietta la chiave pubblica nel container
- **push_images**: tagga e pusha le immagini nel registry locale
- **run_containers**: esegue i container esponendo la porta 22 SSH su una porta diversa della macchina host

### 2. Chiave SSH

Il file `id_key_genericuser.pub` è la chiave pubblica che viene passata ai Dockerfile via `--build-arg SSH_PUB_KEY`.

### 3. Dockerfile (Debian/Rocky)

Ogni Dockerfile:
- parte da una base pulita (Debian o Rocky)
- crea l'utente `genericuser` con permessi sudo senza password
- configura SSH per disabilitare l'accesso root e via password
- abilita solo l'accesso tramite chiave pubblica

### 4. Ruoli Ansible

- `registry/tasks/main.yml`: avvia il registry Docker su porta 5050
- `build_images/tasks/main.yml`: usa `community.docker.docker_image` per buildare le immagini con la chiave SSH
- `push_images/tasks/main.yml`: tagga con `docker tag` e pusha con `docker push`
- `run_containers/tasks/main.yml`: esegue i container mappando le porte 

### 5. Accesso SSH

Per connettersi ai container:

```bash
ssh -i ~/.ssh/id_ed25519 -p 8081 genericuser@localhost    # Debian
ssh -i ~/.ssh/id_ed25519 -p 8082 genericuser@localhost    # Rocky
```

## Requisiti

- Docker
- Ansible

## Esecuzione

```bash
ansible-playbook playbook.yml
```

## Reset ambiente

Per pulire tutto:

```bash
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
```
