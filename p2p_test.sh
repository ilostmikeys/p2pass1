#!/bin/sh

# test to make sure that there is at least two argument provided 
if test $# -lt 2
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

if test ! -f $2 
then 
	echo "The file $2 does not exist"
	exit 1
fi

# if the above is true, perform both pastes and then diff
echo "Runinng original perl program"
perl $1 > originalPerlOutput
echo "Running pastes.pl on $file"a
python $2
diff pasteOutput myPaste 
if test $? -eq 0 
then
	echo "Test Succeeded - output of ./pastes.pl matched paste"
else 
	echo "Test Failed - output of ./pastes.pl did not match paste"
fi

