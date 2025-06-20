# Usa l'immagine base di Rocky Linux 9
FROM rockylinux:9

# Definisce un argomento di build per ricevere la chiave pubblica SSH
ARG SSH_PUB_KEY

# Aggiorna i pacchetti e installa il server SSH, sudo e passwd 
RUN dnf -y update && dnf -y install openssh-server sudo passwd

# Crea l'utente "genericuser" con privilegi sudo senza password
RUN useradd genericuser && \
    echo 'genericuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Crea la cartella .ssh dell’utente, inserisce la chiave pubblica e imposta permessi corretti
RUN mkdir -p /home/genericuser/.ssh && \
    printf "%s\n" "$SSH_PUB_KEY" > /home/genericuser/.ssh/authorized_keys && \
    chown -R genericuser:genericuser /home/genericuser/.ssh && \
    chmod 700 /home/genericuser/.ssh && \
    chmod 600 /home/genericuser/.ssh/authorized_keys

# Configura il server SSH:
# Disabilita l'accesso root
# Disabilita l'autenticazione con password
# Abilita l'autenticazione tramite chiave pubblica
# Permette solo l'accesso dell’utente genericuser
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

# Genera le chiavi host per SSH (necessario per avviare sshd)
RUN ssh-keygen -A

# Espone la porta 22 per le connessioni SSH
EXPOSE 22

# Avvia il demone SSH in primo piano
CMD ["/usr/sbin/sshd", "-D"]
