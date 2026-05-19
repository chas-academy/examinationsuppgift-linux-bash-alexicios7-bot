#!/bin/bash
# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Kör som root"
    exit 1
fi

# Loopa igenom alla användare
for user in "$@"
do
    # Skapa användaren och hemkatalog
    useradd -m "$user"

    # Skapa mappar
    mkdir -p /home/$user/Documents
    mkdir -p /home/$user/Downloads
    mkdir -p /home/$user/Work

    # Sätt rätt ägare
    chown -R $user:$user /home/$user

    # Sätt rättigheter
    chmod 700 /home/$user/Documents
    chmod 700 /home/$user/Downloads
    chmod 700 /home/$user/Work

    # Skapa welcome-fil
    echo "Välkommen $user" > /home/$user/welcome.txt

    # Lägg till lista på användare
    cut -d: -f1 /etc/passwd >> /home/$user/welcome.txt

    # Sätt rätt ägare på welcome.txt
    chown $user:$user /home/$user/welcome.txt

done
