#!/usr/bin/env bash

time nice -n 0 ./myps  > /dev/null 2> /dev/null &
time nice -n 20 ./myps > /dev/null 2> /dev/null &