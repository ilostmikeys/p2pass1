#!/usr/bin/perl -w

# Created by Michael Vuong
# Used for Assignment 1 COMP2041

@numbers = (0, 1, 2, 3, 4, 5);
$answer = 42;

for ($number = 0; $number <= $#numbers; $number = $number + 1) { 
	print "$number\n";
}

if ($answer == 42) { 
	print "$answer\n";
}

foreach $number (@numbers) { 
	print $number;
}
