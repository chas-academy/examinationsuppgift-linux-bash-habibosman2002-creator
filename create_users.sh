#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Scriptet måste köras som root!"
    exit 1
fi

# Loop genom användare
for user in "$@"
do
    # Skapa användare
    useradd -m "$user" 2>/dev/null

    # Skapa mappar
    mkdir -p "/home/$user/Documents" 
    mkdir -p "/home/$user/Downloads"
    mkdir -p "/home/$user/Work"

    # Sätt ägare
    chown -R "$user:$user" "/home/$user"

    # Sätt rättigheter
    chmod 700 "/home/$user"
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapa welcome.txt
    echo "Välkommen $user" > "/home/$user/welcome.txt"

    # Lägg till andra användare (från /home)
    for dir in /home/*
    do
        other=$(basename "$dir")
        if [ "$other" != "$user" ]; then
            echo "$other" >> "/home/$user/welcome.txt"
        fi
    done

done
