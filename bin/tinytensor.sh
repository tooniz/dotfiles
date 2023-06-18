#!/usr/bin/env bash

sudo apt-get install -y locales
sudo localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

export ROOT=$USER_DEV/tinytensor
export PYTHONPATH=$ROOT:$ROOT/src:$ROOT/tests:$ROOT/bbe/build/obj/py_api:$ROOT/bbe/py_api/tests:$PYTHONPATH
export BUDA_HOME=$ROOT/bbe
export CONFIG=release
lc; cd $ROOT