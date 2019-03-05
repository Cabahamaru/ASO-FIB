#!/bin/bash

clear

echo "informacio basica del sistema"

echo "Hola, $USER"

echo "La data d'avui es `date`"

echo "Aquests usuaris estan connectats ara mateix"

w | cut -d " " -f 1 | grep -v USER | sort -u

echo

echo "Aquest es un sistema `uname -s` a un processador `uname -m`"

echo

echo "informacio de l'estat actual del sistema"

uptime

echo

echo "informacio de la memoria lliure"

free
