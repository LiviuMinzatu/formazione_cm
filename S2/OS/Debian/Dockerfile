# Immagine base di debian
FROM debian:bullseye

# Parametro che va a prendere surante il build
ARG SSH_PUB_KEY
# Aggiorna i pacchetti, installa openssh
RUN apt-get update && apt-get install -y openssh-server sudo

# Crea l’utente "genericuser" con shell /bin/bash e directory home
# Aggiunge anche l’utente a sudoers senza richiesta di password
RUN useradd -m -s /bin/bash genericuser && \
    echo 'genericuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Crea la cartella .ssh per l’utente, aggiunge la chiave pubblica
# imposta permessi e proprietà corretti (obbligatori per SSH)
RUN mkdir -p /home/genericuser/.ssh && \
    echo "${SSH_PUB_KEY}" > /home/genericuser/.ssh/authorized_keys && \
    chown -R genericuser:genericuser /home/genericuser/.ssh && \
    chmod 700 /home/genericuser/.ssh && \
    chmod 600 /home/genericuser/.ssh/authorized_keys

# Crea la cartella necessaria per il socket SSH
# Configura sshd_config per:
# Disabilitare l’accesso root
# Disabilitare accesso tramite password
# Abilitare accesso con chiave pubblica
# Permettere solo l’utente genericuser
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

# Espone la porta 22 per permettere connessioni SSH al container.
EXPOSE 22

# Comando eseguito all'avvio del container avvia il demone sshd 
CMD ["/usr/sbin/sshd", "-D"]
