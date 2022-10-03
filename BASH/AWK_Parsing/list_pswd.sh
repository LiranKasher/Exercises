#!/bin/bash

awk 'FNR>2 {print $3}' users.txt 
