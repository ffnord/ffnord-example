#!/bin/bash

#starting all machines

cd ./machines
for dir in *; do ( echo ${dir}; vagrant up ${dir} ) done
cd ..
