# SSH Container con Ansible e Docker

Questo progetto crea **due container** Docker (Debian e Rocky) con:
- Porta 22 aperta
- Servizio SSH attivo
- Utente `genericuser` con accesso SOLO tramite **chiave pubblica**
- Permessi sudo abilitati senza password

---

## Struttura del progetto

```
S2/
OS/
Debian/Dockerfile              # Dockerfile dell'immagine Debian
Rocky/Dockerfile               # Dockerfile dell'imagine Rocky
id_key_genericuser.pub         # Chiave pubblica da iniettare nei container
playbook.yml                   # Playbook Ansible per build e deploy automatico
README.md                      # Documentazione del progetto
```

---

## Requisiti

- Docker installato
- Ansible installato


---

## Come avviare tutto

1. Nella directory `S2` si trova `playbook.yml`
2. Lancia il playbook:
   ```bash
   ansible-playbook playbook.yml
   ```

Questo playbook:

- Costruisce le immagini Docker per Debian e Rocky
- Inietta la chiave pubblica `id_key_genericuser.pub`
- Avvia i container mappando:
  - `2222:22` per Debian
  - `2223:22` per Rocky

---

## Accesso SSH ai container

Bisogna usare questi comandi:

```bash
ssh -p 2222 genericuser@localhost    # Per Debian
ssh -p 2223 genericuser@localhost    # Per Rocky
```

**Attenzione:** La chiave privata deve corrispondere a `id_key_genericuser.pub` nel `~/.ssh`.

---

## Pulizia 

Per rimuovere i container e immagini:

```bash
docker rm -f ssh_debian_manual ssh_rocky_manual
docker rmi -f ssh_debian_manual ssh_rocky_manual
```
