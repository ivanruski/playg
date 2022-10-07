#!/bin/bash

# https://leetcode.com/problems/word-frequency/

cat $1 | tr -s ' ' | tr ' ' '\n' | grep '[a-z]' |sort | uniq -c | sort -k 1 -r | sed -Ee 's/ *([0-9]*) ([a-z]*)/\2 \1/g'
