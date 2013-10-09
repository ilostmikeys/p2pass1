#!/usr/bin/perl -w

# Created by Michael Vuong
# Used for Assignment 1 COMP2041

$answer = 42;
if ($answer > 0) {
	print "Greater than 0\n";
}
if ($answer < 45) { 
	print "Less than 45\n";
}
if ($answer >= 1) { 
	print "Greater than or equal to 1\n";
}
if ($answer <= 50) { 
	print "Less than or equal to 50\n";
}
if ($answer != 41) { 
	print "This does not equal to 41\n";
}
if ($answer == 42) { 
 	$answer = $answer + 0;
	print "Equals to 42\n";
}
