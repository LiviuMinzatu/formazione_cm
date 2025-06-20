#!/bin/bash

# Directory base
PROJECT_DIR="$(pwd)"
VAULT_PASS="livio"

echo "Pulizia file vecchi..."
rm -f "$PROJECT_DIR/vars/secrets.yml" ~/.vault /tmp/registry.conf

echo "Creazione nuovo file secrets.yml..."
mkdir -p "$PROJECT_DIR/vars"
cat <<EOF > "$PROJECT_DIR/vars/secrets.yml"
registry_user: admin
registry_pass: secret123
EOF

echo "Scrittura file ~/.vault con password..."
echo "$VAULT_PASS" > ~/.vault
chmod 600 ~/.vault

echo "Cifratura secrets.yml..."
ansible-vault encrypt "$PROJECT_DIR/vars/secrets.yml" --vault-password-file ~/.vault

echo "Esecuzione playbook..."
ansible-playbook -i inventory main.yml --vault-password-file ~/.vault
