#!/usr/bin/perl -w

use diagnostics;
use strict;

foreach my $file ($ARGV[0]) { 
	extensionChecker ($file);
	hashbang($file);
}

sub extensionChecker { 
	my $fileToCheck = $_[0];
	print "$fileToCheck\n";
	my $extension = "";
	$extension .= $fileToCheck; 
	$extension =~ s/.*\.//g;
	if (!$extension eq "pl") { 
		print "Wrong extension \n", "Usage: $0 fileName.pl\n" if $extension ne "pl";
		exit(1);
	}
}

sub hashbang { 
	my $hb = shift;
	if ($hb =~ /#!\/usr\/bin\/python/) { 
		print "Hashbang";
	}
}


