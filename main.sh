#!/bin/bash

if [ "${EUID}" -ne 0 ]
then
  echo "Вы должны запустить этот скрипт через sudo или от имени root."
  exit 1
fi

clear
PS3='Выберите необходимую программу: '

select Programm in "Docker" "Docker-compose" "RVM" "RBENV" "NVM" "Postgresql" "Mysql"
do
  break
done

case $Programm in
  "Docker")
  echo "Installing $Programm"
  sudo bash ./scripts/docker.sh
  ;;
  "Docker-compose")
  echo "Installing $Programm"
  sudo bash ./scripts/docker-compose.sh
  ;;
  "RVM")
  echo "Installing $Programm"
  sudo bash ./scripts/rvm.sh
  ;;
  "RBENV")
  echo "Installing $Programm"
  sudo bash ./scripts/rbenv.sh
  ;;
  "NVM")
  echo "Installing $Programm"
  sudo bash ./scripts/nvm.sh
  ;;
  "Postgresql")
  clear
  PS3='Выберите необходимую версию Postgresql: '
  select Version in "12" "14"
  do
    break
  done
  case $Version in
    "12")
    echo "Installing $Programm $Version"
    sudo bash ./scripts/postgresql-12.sh
    ;;
    "14")
    echo "Installing $Programm $Version"
    sudo bash ./scripts/postgresql-14.sh
    ;;
    *)
    echo "Вы указали неверное значение."
    ;;
  esac
  ;;
  "Mysql")
  clear
  PS3='Выберите необходимую версию Mysql: '
  select Version in "5.7" "8.0"
  do
    break
  done
  case $Version in
    "5.7")
    echo "Installing $Programm $Version"
    sudo bash ./scripts/mysql-5.7.sh
    ;;
    "8.0")
    echo "Installing $Programm $Version"
    sudo bash ./scripts/mysql-8.0.sh
    ;;
    *)
    echo "Вы указали неверное значение."
    ;;
  esac
  ;;
  *)
  echo "Вы указали неверное значение."
  ;;
esac