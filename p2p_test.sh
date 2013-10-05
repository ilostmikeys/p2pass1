#!/bin/sh

# test to make sure that there is at least one argument provided 
if test $# -lt 1
then	
	echo "Not enough arugments"
	echo "Usage: $0 dataFile"
	exit 1
fi

# test to make sure the file actually exists
if test ! -f $1
then
	echo "The file $1 does not exist"
	exit 1
fi

pythonName=`echo $1 | sed "s/pl/py/"`
echo $pythonName

# if the above is true, run the original perl code and the translated
# python code with a diff
	echo "Runinng original perl file..."
	perl $1> outputPerl
	echo "Running perl2python...."
	perl perl2python.pl $1 
	python $pythonName > outputPython
	diff outputPerl outputPython
	if test $? -eq 0 
	then
		echo "Test Succeeded - output of ./perl2python.pl matched original"
	else 
		echo "Test Failed - output of ./perl2python.pl did not match original"
	fi
		


