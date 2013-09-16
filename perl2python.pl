#!/usr/bin/perl -w

use diagnostics;

for $file ($ARGV[0]) { 
	my $extension = "";
	$extension .= $file; 
	$extension =~ s/.*\.//g;
	
	print "Wrong extension \n", "Usage: $0 fileName.pl\n" if $extension ne "pl";
}
