# Immagine base di Debian
FROM debian:bullseye

# Parametro per ricevere la chiave SSH pubblica da inserire nel container
ARG SSH_PUB_KEY

# Aggiorna i pacchetti e installa openssh server 
RUN apt-get update && apt-get install -y openssh-server sudo

# Crea l’utente "genericuser" con shell /bin/bash e lo abilita all’uso di sudo senza password
RUN useradd -m -s /bin/bash genericuser && \
    echo 'genericuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Crea la cartella .ssh, inserisce la chiave pubblica e imposta i permessi corretti
RUN mkdir -p /home/genericuser/.ssh && \
    printf "%s\n" "$SSH_PUB_KEY" > /home/genericuser/.ssh/authorized_keys && \
    chown -R genericuser:genericuser /home/genericuser/.ssh && \
    chmod 700 /home/genericuser/.ssh && \
    chmod 600 /home/genericuser/.ssh/authorized_keys

# Configura SSH per:
# Disabilitare l'accesso root
# Disabilitare l'autenticazione via password
# Abilitare solo autenticazione con chiave pubblica
# Consentire l'accesso solo all’utente genericuser
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

# Espone la porta 22 per permettere le connessioni SSH
EXPOSE 22

# Avvia il demone SSH in primo piano
CMD ["/usr/sbin/sshd", "-D"]
