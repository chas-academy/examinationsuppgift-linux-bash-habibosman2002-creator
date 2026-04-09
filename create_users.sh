#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Scriptet måste köras som root!"
    exit 1
fi

# Loop genom alla användare som skickas in som argument
for user in "$@"
do
    # Skapa användare med hemkatalog
    useradd -m "$user" 2>/dev/null

    # Skapa mappar i hemkatalog
    mkdir -p "/home/$user/Documents"
    mkdir -p "/home/$user/Downloads"
    mkdir -p "/home/$user/Work"

    # Sätt ägare
    chown -R "$user:$user" "/home/$user"

    # Sätt rättigheter (endast ägare)
    chmod 700 "/home/$user"
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapa welcome.txt med exakt format som testet förväntar sig
    echo "Välkommen $user" > "/home/$user/welcome.txt"
    
    # Lägg till lista på ANDRA användare (exklusive den nya användaren)
    while IFS= read -r other_user; do
        if [ "$other_user" != "$user" ]; then
            echo "$other_user" >> "/home/$user/welcome.txt"
        fi
    done < <(cut -d: -f1 /etc/passwd)
done
