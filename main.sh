#!/bin/bash

clear
PS3='Выберите необходимую программу: '

select Programm in "Docker" "Docker-compose" "RVM" "RBENV" "NVM" "Postgresql" "Mysql" "Выбрать несколько"
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
  bash ./scripts/rvm.sh
  exec bash
  ;;
  "RBENV")
  echo "Installing $Programm"
  bash ./scripts/rbenv.sh
  exec bash
  ;;
  "NVM")
  echo "Installing $Programm"
  bash ./scripts/nvm.sh
  exec bash
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
  "Выбрать несколько")
  ans6_1="false"
  ans6_2="false"
  ans7_1="false"
  ans7_2="false"
  clear
  echo "Установить Docker? [y/n] "
  read ans1
  echo "Установить Docker-compose? [y/n] "
  read ans2
  echo "Установить RVM? [y/n] "
  read ans3
  echo "Установить RBENV? [y/n] "
  read ans4
  echo "Установить NVM? [y/n] "
  read ans5
  echo "Установить Postgresql? [y/n] "
  read ans6

  if [ "$ans6" = "y" ]
  then
    PS3='Выберите необходимую версию Postgresql: '
    select Version in "12" "14"
    do
      break
    done
    case $Version in
      "12")
      ans6_1="true"
      ;;
      "14")
      ans6_2="true"
      ;;
      *)
      echo "Вы указали неверное значение."
      ;;
    esac
  fi
  echo "Установить Mysql? [y/n] "
  read ans7

  if [ "$ans7" = "y" ]
  then
    PS3='Выберите необходимую версию Mysql: '
    select Version in "5.7" "8.0"
    do
      break
    done
    case $Version in
      "5.7")
      ans7_1="true"
      ;;
      "8.0")
      ans7_2="true"
      ;;
      *)
      echo "Вы указали неверное значение."
      ;;
    esac
  fi

  if [ "$ans1" = "y" ]
  then
    echo "Installing Docker"
    sudo bash ./scripts/docker.sh
  fi
  if [ "$ans2" = "y" ]
  then
    echo "Installing Docker-compose"
    sudo bash ./scripts/docker-compose.sh
  fi
  if [ "$ans3" = "y" ]
  then
    echo "Installing RVM"
    bash ./scripts/rvm.sh
  fi
  if [ "$ans4" = "y" ]
  then
    echo "Installing RBENV"
    bash ./scripts/rbenv.sh
  fi
  if [ "$ans5" = "y" ]
  then
    echo "Installing NVM"
    bash ./scripts/nvm.sh
  fi
  if [ "$ans6" = "y" ]
  then
    if [ $ans6_1 = "true" ]
    then
      echo "Installing Postgresql 12"
      sudo bash ./scripts/postgresql-12.sh
    elif [ $ans6_2 = "true" ]
    then
      echo "Installing Postgresql 14"
      sudo bash ./scripts/postgresql-14.sh
    fi
  fi
  if [ "$ans7" = "y" ]
  then
    if [ $ans7_1 = "true" ]
    then
      echo "Installing Mysql 5.7"
      sudo bash ./scripts/mysql-5.7.sh
    elif [ $ans7_2 = "true" ]
    then
      echo "Installing Mysql 8.0"
      sudo bash ./scripts/mysql-8.0.sh
    fi
  fi
  exec bash
  ;;
  *)
  echo "Вы указали неверное значение."
  ;;
esac