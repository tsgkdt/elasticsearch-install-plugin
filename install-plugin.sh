#!/bin/bash

cd `dirname $0`

install-plugin () {
  #already installed?
  elasticsearch-plugin list | grep $1
  
  if [ "$?" -eq 1 ]; then
    echo "install plugin... $1"
    echo "y" |  elasticsearch-plugin install $1
  fi
}


install-plugin $1

