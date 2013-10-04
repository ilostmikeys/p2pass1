#!/usr/bin/perl -w

use diagnostics;
use strict;

# array which should contain the final converted program
my @pythonArray = (); 

# changes the hashbang line of the perl program to the python equivalent
sub changeHashbang { 
	print "Changing hashbang line...\n";
	my @file = @_;
	foreach my $line (@file) { 
		if ($line =~ /#!\/usr\/bin\/perl -w/) { 
			$line =~ s/#!\/usr\/bin\/perl -w/#!\/usr\/bin\/python/;
			push (@pythonArray, $line);
			push (@pythonArray, "\n");
		}
	}
	print "Hashbang line changed!\n\n";
}

# removes new lines and semi colons
# removes new lines \n from the end of any print statments 
# it also takes into account whether if it is just a new line as white space 
    # it will print a \n as is 
sub removeNewLinesAndSemiColons { 
	print "Removing \\n... \n";
	
	my $line = $_[0];
	if ($line =~ /\\n";/) { 
		print "HERE\n";
		$line =~ s/\n";/"/;
		push (@pythonArray, $line);
	} elsif ($line =~ /^\\n$/) { 
		push (@pythonArray, $line);
	} elsif ($line =~ /;$/) { 
		$line =~ s/;$//;
		push (@pythonArray, $line);
	}
	
	print "\\n removed\n\n";
}

sub changeVariables { 
	print "Change variables...\n";

	my $line = $_[0];
	my $print = "print";

	if ($line =~ /^\$/) { 
		$line =~ s/^\$//g;
		push (@pythonArray, $line);
	} elsif ($line =~ /print/) { 
		if ($line =~ /\$/) { 
			$line =~ s/\$//;
			push (@pythonArray, $line);
		}
	} 
	print "Variables changed\n\n"; 
}

sub removeSemiColons { 
	print "Removing semi colons...\n";

	my $line = $_[0];
	if ($line =~ /;$/) { 
		$line =~ s/;$//;
		push (@pythonArray, $line);
	}
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

	changeHashbang($file[0]);
	foreach my $i (1..$#file) { 
		removeSemiColons($file[$i]);
		changeVariables($file[$i]);
	}
#	foreach my $i (1..$#file) { 
	#	removeNewLinesAndSemiColons($file[$i]);
#		if ($file[$i] =~ /^\$/) { 
#			changeVariables($file[$i]);
#		} elsif ($file[$i] =~ /print/) {
#			changeVariables($file[$i]);
#		}# else { 
	#		removeNewLinesAndSemiColons($file[$i]);
	#	}
#	}

	#foreach my $i (1..$#file) { 
#		removeNewLinesAndSemiColons($file[$i]);
#	}

	print "\nStart Python Array: \n";
	print @pythonArray;
	print "End Python Array\n\n";

	# prints out to the filehandle
	foreach my $line (@pythonArray) { 
		print OUT $line;
	}

	close OUT;

}


























