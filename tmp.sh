#!/usr/bin/env bash

export APPS=$HOME/apps

#$1 - tar.gz file
#$2 - destination folder
untar(){
  if [ -d $2 ]
  then
    echo "Removing existing $2"
    rm -r $2
  fi
  mkdir -p $2
  tar zxvf $1 --directory $2
}

#rfn - release from nexus
#$1 app
#$2 version
#$3 assemblyId
rfn() {
  nexusUser=deployment
  nexusPassword=deployment123
  artifactURL=http://riverside1:8081/nexus/content/repositories/releases/com/fxq/$1/$2/$1-$2-$3.tar.gz
  mkdir -p $APPS/$1
  cd $APPS/$1
  wget --user=$nexusUser --password=$nexusPassword $artifactURL

  archiveFile=$1-$2-$3.tar.gz
  untar $1-$2-$3.tar.gz $1-$2-$3
  ln -sfn $1-$2-$3 current
}

#release from nexus on all UAT servers
#$1 app
#$2 version
#$3 assemblyId
rfnUAT(){
  echo "[rfnUAT] releasing on riverside1"
  ssh fxq@riverside1 rfn $1 $2 $3
  #add more servers here if needed
}

#Special function for KdbConfig
#We can't use generic rfnUAT because each host has got different assemblyId
rfnKdbConfigUAT(){
  echo "[rfnKdbConfigUAT] releasing on riverside1"
  ssh fxq@riverside1 rfn KdbConfig $1 UAT-P1-riverside1
  #add more servers here if needed
}

