#!/usr/bin/perl -w

use diagnostics;
use strict;

# array which should contain the final python converted program
my @pythonArray = (); 

# changes the hashbang line of the perl program to the python equivalent
sub changeHashbang { 
	print "Changing hashbang line...\n";
	my @file = @_;
	foreach my $line (@file) { 
		if ($line =~ /#!\/usr\/bin\/perl -w/) { 
			$line =~ s/$line/#!\/usr\/bin\/python/;
			push (@pythonArray, $line);
		}
	}
	print "Hashbang line changed!\n\n";
}

sub removeSemiColons { 
	print "Removing SemiColons...\n";

	my $line = $_[0];
	if ($line =~ /\;$/) { 
		$line =~ s/\;$//;	
		push(@pythonArray, $line);
	}

	print "SemiColons removed\n\n";
}

# removes new lines \n from the end of any print statments 
# it also takes into account whether if it is just a new line as white space 
    # it will print a \n as is 
sub removeNewLines { 
	print "Removing \\n... \n";
	
	my $line = $_[0];
	print "Line: $line";
	
#	} elsif ($line =~ /\n$/) { 
#		my $new = "\n";
#		push (@pythonArray, $new);
#	} elsif ($line =~ /^\n$/) { 
#		my $new = "\n";
#		push (@pythonArray, $new);
#	if ($line =~ /\\n\"/) { 
#		print "found new line at end of \" \n";
#		my $newLine = $line;
#		$newLine =~ s/\\n\"/"/g;
#		push(@pythonArray, $newLine);
#	} elsif ($line =~ /\n$/) { 
#		my $new = "\n";
#		push (@pythonArray, $new);
#	} elsif ($line =~ /^\n$/) { 
#		my $new = "\n";
#		push (@pythonArray, $new);
#	}
	print "\\n removed\n\n";
}

foreach my $file ($ARGV[0]) { 
	open IN, $file or die "Can't open $file\n";
	
	my @file = ();
	foreach my $line (<IN>) { 
		push (@file, $line);
	}
	close IN;

	print "Start File Array: \n";
	print @file;
	print "End File Array\n\n";

	my $newFile .= $file;
	$newFile =~ s/\..*/.py/;
	open OUT, "> $newFile";

	changeHashbang(@file);
	foreach my $line (@file) {
			removeNewLines($line);
	}

	print "\nStart Python Array: \n";
	print @pythonArray;
	print "End Python Array\n\n";

	# prints out to the filehandle
	foreach my $line (@pythonArray) { 
		print OUT $line;
	}

	close IN;
	close OUT;

}


























