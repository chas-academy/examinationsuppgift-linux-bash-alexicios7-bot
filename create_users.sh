#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Kör som root"
    exit 1
fi

# Loopa igenom alla användare
for user in "$@"
do
    # Skapa användare
    id "$user" &>/dev/null || useradd -m "$user"

    # Skapa mappar
    mkdir /home/$user/Documents"
    mkdir /home/$user/Downloads"
    mkdir /home/$user/Work"

    # Sätt rätt ägare
    chown -R "$user:$user" "/home/$user"

    # Sätt rättigheter
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapa welcome-fil
    echo "Välkommen $user" > "/home/$user/welcome.txt"

    # Lägg till användarlista
    cut -d: -f1 /etc/passwd >> "/home/$user/welcome.txt"

    # Rätt ägare på filen
    chown "$user:$user" "/home/$user/welcome.txt"

done
