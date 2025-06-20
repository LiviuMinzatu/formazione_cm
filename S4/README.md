# Esempio Ansible Vault - Step 4

Questo progetto mostra come usare **Ansible Vault** per proteggere credenziali in un playbook Ansible.


## Contenuto dei file

### `vars/secrets.yml`

File YAML contenente variabili sensibili. Deve essere cifrato con:

```
ansible-vault encrypt vars/secrets.yml --vault-password-file ~/.vault
```

### `templates/registry.conf.j2`

Template che utilizza le variabili:

```
user={{ registry_user }}
pass={{ registry_pass }}
```

### `main.yml`

Playbook che:

- carica le variabili cifrate
- genera un file `/tmp/registry.conf`
- stampa le variabili in output

## Esecuzione

1. Crea il file `.vault` con la password:

```
echo 'livio' > ~/.vault
chmod 600 ~/.vault
```

2. Cifra il file delle variabili:

```
ansible-vault encrypt vars/secrets.yml --vault-password-file ~/.vault
```

3. Esegui il playbook:

```
ansible-playbook -i inventory main.yml --vault-password-file ~/.vault
```

## Reset completo (opzionale)

Puoi usare lo script `reset_s4.sh` per ripulire e rieseguire tutto da zero.
