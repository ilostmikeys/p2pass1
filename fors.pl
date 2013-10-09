#!/usr/bin/perl -w

@numbers = (0, 1, 2, 3, 4, 5);

for ($number = 0; $number <= $#numbers; $number = $number + 1) { 
	print "$number\n";
}
