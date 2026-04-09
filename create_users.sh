#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Scriptet måste köras som root!"
  exit 1
fi

for user in "$@"
do
  useradd -m "$user"

  mkdir -p /home/$user/Documents
  mkdir -p /home/$user/Downloads
  mkdir -p /home/$user/Work

  chown -R $user:$user /home/$user
  chmod -R 700 /home/$user

  echo "Välkommen $user" > /home/$user/welcome.txt

  for other in $(ls /home)
  do
    if [ "$other" != "$user" ]; then
      echo "$other" >> /home/$user/welcome.txt
    fi
  done
done
