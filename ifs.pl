#!/usr/bin/perl -w

$answer = 42;
if ($answer > 0) {
	print "$answer\n";
}
if ($answer < 45) { 
	print "$answer\n";
}
if ($answer < 100) { 
	print "yes\n";
}
if ($answer == 42) { 
	$answer = $answer + 0;
	print "$answer\n";
}
