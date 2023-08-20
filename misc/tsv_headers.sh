#!/usr/bin/bash 
[[ -f $1 ]] || exit
sep="{$2:-""}"
if (( $# == 1 )) ; then
    awk  'NR == 1 {for(i = 1; i<= NF; i++) print i"\t"$i ; exit}' "$1"
else 
    awk  -F "${sep}" 'NR == 1 {for(i = 1; i<= NF; i++) print i"\t"$i ; exit}' "$1"
fi