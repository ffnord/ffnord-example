#!/bin/bash

#init all git repros
for dir in fastd/* icvpn; do ( cd ${dir} ; git init ; git add --all ; git commit -m "Initial commit" ) done
