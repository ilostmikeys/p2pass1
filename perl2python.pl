#!/usr/bin/perl -w

use diagnostics;
use strict;

foreach my $file ($ARGV[0]) { 
	open IN, $file or die "Can't open $file\n";
	
	my @file = ();
	foreach my $line (<IN>) { 
		push (@file, $line);
	}
	close IN;

	my $newFile .= $file;
	$newFile =~ s/\..*/.py/;
	open OUT, "> $newFile";

	changeHashbang(@file);
	removeNewLinesAndSemiColons(@file);
#	my @newFile = (removeNewLines(@file));
	
#	print @newFile;
#	removeSemiColons(@newFile);
	
	close IN;
	close OUT;

}

sub changeHashbang { 
	print "Changing hashbang line...\n";
	my @file = @_;
	foreach my $line (@file) { 
		if ($line =~ /#!\/usr\/bin\/perl/) { 
			print "Hashbang\n";
			print OUT "#!\/usr\/bin\/python\n";
		}
	}
	print "Hashbang line changed!\n";
}

sub removeNewLinesAndSemiColons { 
	print "Removing \\n and semi colons\n";
	my @file = @_;
	foreach my $line (@file) { 
		if ($line =~ /\\n";/) { 
			$line =~ s/\\n";/"/g;
			print OUT "$line";
		}
	}
	print "\\n's and semi colons removed\n";
}























