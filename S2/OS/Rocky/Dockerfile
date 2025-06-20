# Immagine base di Rocky
FROM rockylinux:9

# Si aspetta un argomento quando si va a fare il build, quindi associa quel parametro a questo argomento
ARG SSH_PUB_KEY


# Aggiorna tutto, installa openssh e abilita sudo
RUN dnf -y update && dnf -y install openssh-server sudo passwd

# Crea l'utente genericuser e gli concede accesso sudo senza password
RUN useradd genericuser && \
    echo 'genericuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Crea la directory .ssh dell'utente poi inserisce la chiave pubblica che abbiamo ottenuto come parametro all'inzio e gli da i permessi.
RUN mkdir -p /home/genericuser/.ssh && \
    echo "${SSH_PUB_KEY}" > /home/genericuser/.ssh/authorized_keys && \
    chown -R genericuser:genericuser /home/genericuser/.ssh && \
    chmod 700 /home/genericuser/.ssh && \
    chmod 600 /home/genericuser/.ssh/authorized_keys

# Configura il server SSH:
# Disabilita l'accesso come root
# Disabilita l'autenticazione via password
# Abilita l'autenticazione con chiave pubblica
# Permette solo l'accesso dell'utente genericuser
# Questa configurazione consente il collegamento SOLO tramite chiave, questo è il metodo piu sicuro
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \  
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

# Genera le chiavi host per il server SSH (obbligatorio altrimenti sshd non parte)
RUN ssh-keygen -A

# Espone la porta 22 per permettere le connessioni SSH
EXPOSE 22

# Avvia il server SSH in modalità daemon in primo piano
CMD ["/usr/sbin/sshd", "-D"]
