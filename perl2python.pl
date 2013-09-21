#!/usr/bin/perl -w

use diagnostics;
use strict;

foreach my $file ($ARGV[0]) { 
	extensionChecker($file);
}
sub extensionChecker { 
		my $fileToCheck = shift;
		my $extension = "";
		$extension .= $fileToCheck; 
		$extension =~ s/.*\.//g;
	
		print "Wrong extension \n", "Usage: $0 fileName.pl\n" if $extension ne "pl";
}

	
