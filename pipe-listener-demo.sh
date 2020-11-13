#!/bin/bash

pipePath=./server-commands.pipe

echo "Press <Ctrl> + <C> to quit"

while true
do
	cat $pipePath
done
