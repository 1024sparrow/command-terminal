#!/bin/bash

pipePath=./server-commands.pipe
dollar='--> '

function printHelp {
	local tmp=$(basename "$0")
	echo "$tmp is utility for writing commands into pipe \"$pipePath\" in interactive mode.
Run with \"--init\" argument to create pipe \"$pipePath\"."
}

function printInstantHelp {
	# there is not arguments
	echo "enter command to server
 or \"h\" for help
 or \"q\" to quit"
}

function initFifo {
	local tmp=$(dirname "$pipePath")
	if [ ! -d "$tmp" ]
	then
		mkdir -p "$tmp"
	fi
	if [ -a "$pipePath" ]
	then
		echo "Can not initialize: file \"$pipePath\" already exists"
		return 1
	fi
	mkfifo "$pipePath"
	return 0
}

function startWriting {
	if [ ! -p "$pipePath" ]
	then
		echo "file \"$pipePath\" not exists or is not a FIFO (pipe). Please exec this script with \"--init\" option first"
		exit 1
	fi
	printInstantHelp

	echo -n "$dollar"

	while read line
	do
		if [[ "$line" == "h" ]]
		then
			printInstantHelp
			echo -n "$dollar"
		elif [[ "$line" == "q" ]]
		then
			return 0
		else
			echo "$line" >> "$pipePath"
			echo -n "$dollar"
		fi
	done
	return 0 # stdin closed (redirected output case)
}

for i in $*
do
	if [[ "$i" == "--help" ]]
	then
		printHelp
		exit 0
	elif [[ "$i" == "--init" ]]
	then
		initFifo && exit 0 || exit 1
	elif [[ $i =~ -.* ]]
	then
		echo "unsupported key: " $i
		exit 1
	else
		echo "this script not takes any non-key arguments. See help."
		exit 1
	fi
done

startWriting && exit 0 || exit 1
