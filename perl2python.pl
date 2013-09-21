#!/usr/bin/perl -w

use diagnostics;
use strict;

foreach my $file ($ARGV[0]) { 
	extensionChecker ($file);
	hashbang($file);
}

sub extensionChecker { 
	my $fileToCheck = $_[0];
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
	open F, $hb or die "Can't open $hb.\n";
	$hb =~ s/\..*//;
	open O, "> $hb.py";
	foreach my $line (<F>) { 
		if ($line =~ /#!\/usr\/bin\/perl/) { 
			print O "#!\/usr\/bin\/python\n";
		}
	}
	close F;
	close O;
}


