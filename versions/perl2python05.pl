#!/usr/bin/perl -w

use diagnostics;
use strict;

# array which should contain the final converted program
my @pythonArray = (); 
# array which should contain the original perl file
my @perlFile = ();

# copies an array to another by first emptying the main one to the spare
sub arrayCopy { 
	@perlFile = ();
	@perlFile = @pythonArray;
	@pythonArray = ();
}

# changes the hashbang line of the perl program to the python equivalent
sub changeHashbang { 
	print "Changing hashbang line...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /#!\/usr\/bin\/perl -w/) { 
			$line =~ s/#!\/usr\/bin\/perl -w/#!\/usr\/bin\/python/;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Hashbang line changed!\n\n";
}

sub removeSemiColons { 
	print "Removing semi colons...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /;$/) { 
			$line =~ s/;$//;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}
	print "Removed semi colons\n\n";
}

sub removeNewLines { 
	print "Removing new lines...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /^\n$/) { 
			push (@pythonArray, $line);
		} elsif ($line =~ /\\n"$/) { 
			$line =~ s/\\n"$/"/;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}
	print "Removed new lines...\n\n";
}

sub changeVariables { 
	print "Changing Variables...\n";
	
	# save array passed in into local variable
	my @file = @_;
	# while the size of the array is greater than 0
	while (@file > 0) { 
		# shift off the first element and save it into variable
		my $line = shift @file;
		# if there is a $ at the beginning of the line then it's a perl variable
		if ($line =~ /^\$/) { 
			# replace the $ with nothing
			$line =~ s/^\$//;
			# push it back onto the array
			push(@pythonArray, $line);
		# if it's none of the above cases
		} elsif ($line =~ /if/) {
			if ($line =~ /\$/) { 
				$line =~ s/\$//g;
			}
			push (@pythonArray, $line);
		} elsif ($line =~ /\$/) { 
			print "LINE HERE: $line\n";
			$line =~ s/\$//g;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Variables changed\n\n"; 
}
sub changePrints { 
	print "Changing prints...\n";
	
	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /print/) { 
			if ($line =~ /\$/) { 
				# save into a new variable for editing (might be unneccessary)
				my $varPrint .= $line;
				# we split the line so that we can replace the " and insert ()
				my @lineArray = split (' ', $varPrint);
				# traverse the array
				foreach my $i (0..$#lineArray) { 
					# we look for $ and replace it with a (
					if ($lineArray[$i] =~ /\$/) { 
						$lineArray[$i] =~ s/\$/(/;
						# splice the array at the point +1 after we find the $
						# and then add a )
						splice @lineArray, $i+1, 0, ')';
					} 
					# replaces all " with nothing
					if ($lineArray[$i] =~ /"/) { 
						$lineArray[$i] =~ s/"//g;
					}
				}
				# join the array back up 
				$varPrint = join('', @lineArray);
				# push the line back onto the array
				push (@pythonArray, $varPrint);
#			} elsif ($line !~ /\$/) { 
#				if ($line =~ /\t/) { 
#					$line =~ s/^\t//;
#					push (@pythonArray, $line);
#				}
			} else { 
				push (@pythonArray, $line);
			}
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Changed prints\n\n";
}
sub changeIfs { 
	print "Changing ifs...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /if/g) { 
			my @lineArray = split(' ', $line);
			foreach my $i (0..$#lineArray) { 
				if ($lineArray[$i] =~ /\(|\)/) { 
					$lineArray[$i] =~ s/\(|\)//g;
				}
				if ($lineArray[$i] =~ /\{/) { 
					$lineArray[$i] =~ s/\{/:\n/g;
				}
			} 
			$line = join(' ', @lineArray);
			push (@pythonArray, $line);
			$line = shift @file;
			$line =~ s/$/\n/;
			while ($line !~ /\}/) { 
				$line =~ s/^/\t/;
				push (@pythonArray, $line);
				$line = shift @file;
			}
			if ($line =~ /&&+/) { 
				print "&& HERE line: $line\n";
			}
		} else { 
			push (@pythonArray, $line);
		}
	} 

	print "Changed ifs\n\n";
}

sub removeTabs { 
	print "Removing tabs...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /^\t/) { 
			$line =~ s/^\t//g;
			push(@pythonArray, $line);
		} else { 
			push(@pythonArray, $line);
		}
	}
	
	print "Removed tabs\n";
}

foreach my $file ($ARGV[0]) { 
	open IN, $file or die "Can't open $file\n";
	
	foreach my $line (<IN>) { 
		push (@perlFile, $line);
	}
	close IN;

	my $newFile .= $file;
	$newFile =~ s/\..*/.py/;
	open OUT, "> $newFile";

	changeHashbang(@perlFile);
	arrayCopy;
	removeTabs(@perlFile);
	arrayCopy;
	removeSemiColons(@perlFile);
	arrayCopy;
	removeNewLines(@perlFile);
	arrayCopy;
	changeVariables(@perlFile);
	arrayCopy;
	changePrints(@perlFile);
	arrayCopy;
	changeIfs(@perlFile);
	arrayCopy;


	print "\nStart Python Array: \n";
	print @perlFile;
	print "End Python Array\n\n";

	# prints out to the filehandle
	foreach my $line (@perlFile) { 
		print OUT $line;
	}

	close OUT;

}


























