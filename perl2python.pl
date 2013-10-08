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

# removes all semi colons
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

# removes all \n though it shouldn't remove any new lines 
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
		} elsif ($line =~ /\\n\)$/) { 
	        $line =~ s/\\n\)$/)/;
            push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}
	print "Removed new lines...\n\n";
}

# just removes the $ from variables 
sub changeVariables { 
	print "Changing Variables...\n";
	
	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /\$/) { 
			$line =~ s/\$//g;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Variables changed\n\n"; 
}

# changes prints to python prints, without \n, brackets for variables
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
					if ($lineArray[$i] =~ /"$/) { 
					    #print "LINE HERE: $lineArray[$i]\n";
						$lineArray[$i] =~ s/"$//g;
					}
				}
				# join the array back up 
				$varPrint = join(' ', @lineArray);
				# push the line back onto the array
				$varPrint =~ s/$/\n/;
				push (@pythonArray, $varPrint);
			} else { 
				push (@pythonArray, $line);
			}
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Changed prints\n\n";
}

# removes all types of white space at the beginning of lines
sub removeWhiteSpace { 
	print "Removing white space...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /^\s+/) { 
			$line =~ s/^\s+//g;
			push(@pythonArray, $line);
		} else { 
			push(@pythonArray, $line);
		}
	}
	print "Removed white space\n";
}

# changes perl ifs to pythons ifs with : and indentation
	# also accounts for < <= > >= != == 
sub changeIfs { 
	print "Changing ifs...\n";

    my @file = @_;
    while (@file > 0) { 
        my $line = shift @file;
        if ($line =~ /if/) { 
            my @lineArray = split (' ', $line);
            foreach my $i (0..$#lineArray) { 
                if ($lineArray[$i] =~ /\(|\)/) { 
                    $lineArray[$i] =~ s/\(|\)//;
                }
                if ($lineArray[$i] =~ /\{$/) { 
                    $lineArray[$i] =~ s/\{$/:/;
                }
            }
            $line = join (' ', @lineArray);
            push (@pythonArray, $line);
            $line = shift @file;
            while ($line !~ /\}/) { 
                $line =~ s/^/\n\t/;
                push (@pythonArray, $line);
                $line = shift @file;
            }
        } else { 
            push (@pythonArray, $line);
        }
    }
	print "Changed ifs\n\n";
}

# changes perl ifs to pythons ifs with : and indentation
	# also accounts for < <= > >= != ==
sub changeWhiles { 
	print "Changing whiles...\n";

    my @file = @_;
    while (@file > 0) { 
        my $line = shift @file;
        if ($line =~ /while/) { 
            my @lineArray = split (' ', $line);
            foreach my $i (0..$#lineArray) { 
                if ($lineArray[$i] =~ /\(|\)/) { 
                    $lineArray[$i] =~ s/\(|\)//;
                }
                if ($lineArray[$i] =~ /\{$/) { 
                    $lineArray[$i] =~ s/\{$/:/;
                }
            }
            $line = join (' ', @lineArray);
            push (@pythonArray, $line);
            $line = shift @file;
            while ($line !~ /\}/) { 
                $line =~ s/^/\n\t/;
                push (@pythonArray, $line);
                $line = shift @file;
            }
        } else { 
            push (@pythonArray, $line);
        }
    }
	print "Changed whiles\n\n";
}

sub changeFors { 
    print "Changing fors...\n";
    
    my @file = @_;
    while (@file > 0) { 
        my $line = shift @file;
        if ($line =~ /for/) { 
            
        }
    }
    
    print "Changed fors.\n";
}

sub changeLogicalOperators { 
	print "Changing logical operators...\n";

	my @file = @_;
	while (@file > 0) { 
		my $line = shift @file;
		if ($line =~ /\&\&/) { 
			print "LINEHERE: $line\n";
			$line =~ s/\&\&/and/g;
			push (@pythonArray, $line);
		} elsif ($line =~ /\|\|/) { 
			$line =~ s/\|\|/or/g;
			push (@pythonArray, $line);
		} else { 
			push (@pythonArray, $line);
		}
	}

	print "Changed logical operators\n";
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
	# have to remove semicolons before newlines because of regex
	removeSemiColons(@perlFile);
	arrayCopy;
	removeNewLines(@perlFile);
	arrayCopy;
	removeWhiteSpace(@perlFile);
	arrayCopy;
	# prints have to be changed before all variables noted by $ are removed
	changePrints(@perlFile);
	arrayCopy;
	changeIfs(@perlFile);
	arrayCopy;
	changeWhiles(@perlFile);
	arrayCopy;
	changeLogicalOperators(@perlFile);
	arrayCopy;
	changeVariables(@perlFile);
	arrayCopy;
	print @perlFile;

	print "\nStart Python Array: \n";
	print @perlFile;
	print "End Python Array\n\n";

	# prints out to the filehandle
	foreach my $line (@perlFile) { 
		print OUT $line;
	}

	close OUT;

}


















