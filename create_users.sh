#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Scriptet måste köras som root!"
    exit 1
fi

# Loop genom alla användare
for user in "$@"
do
    # Skapa användare
    useradd -m "$user"

    # Skapa grupp och lägg till användare
    groupadd "$user"
    usermod -aG "$user" "$user"

    # Skapa mappar
    mkdir -p /home/$user/Documents
    mkdir -p /home/$user/Downloads
    mkdir -p /home/$user/Work

    # Sätt rättigheter
    chown -R $user:$user /home/$user
    chmod -R 700 /home/$user

    # Skapa välkomstfil
    echo "Välkommen $user" > /home/$user/welcome.txt

    # Lista andra användare
    for other in $(ls /home)
    do
        if [ "$other" != "$user" ]; then
            echo "$other" >> /home/$user/welcome.txt
        fi
    done 

done
