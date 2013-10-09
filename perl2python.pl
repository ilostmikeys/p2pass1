#!/usr/bin/perl -w

# Created by Michael Vuong
# Used for Assignment 1 COMP2041 

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
#	print "Changing hashbang line...\n";
	
	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line contains the perl hashbang line
		if ($line =~ /#!\/usr\/bin\/perl -w/) { 
			# replace with the python hashbang line
			$line =~ s/#!\/usr\/bin\/perl -w/#!\/usr\/bin\/python/;
			# push the replaced line back onto the array
			push (@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Hashbang line changed!\n\n";
}

# removes all semi colons
sub removeSemiColons { 
#	print "Removing semi colons...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line contains any ;'s
		if ($line =~ /;$/) { 
			# replace them with nothing
			$line =~ s/;$//;
			# push the replaced line back onto the array			
			push (@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Removed semi colons\n\n";
}

# removes all \n though it shouldn't remove any new lines 
sub removeNewLines { 
#	print "Removing new lines...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line is just a new line
		if ($line =~ /^\n$/) { 
			# push it back onto the array
			push (@pythonArray, $line);
		# check if the line has a new line followed by a " at the end of the line
		} elsif ($line =~ /\\n"$/) { 
			# replace the \n with nothing and keep the " 
			$line =~ s/\\n"$/"/;
			# push it back onto the array
			push (@pythonArray, $line);
		# check if the line just has a new line and a close bracket
		} elsif ($line =~ /\\n\)$/) { 
			# replace it with a close bracket
	        $line =~ s/\\n\)$/)/;
			# push it back onto the array
            push (@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Removed new lines...\n\n";
}

# just removes the $ from variables 
sub changeVariables { 
#	print "Changing Variables...\n";

	# reads the array parsed into a local variable	
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line contains a $ so then it's a variable
		if ($line =~ /\$/) { 
			# replace the $ with nothing
			$line =~ s/\$//g;
			# push it back onto the array
			push (@pythonArray, $line);
		# check if the line contains an @ so then it's an array
		} elsif ($line =~ /@/) { 
			# replace the @ with nothing
		    $line =~ s/@//g;
			# push it back onto the array
		    push (@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Variables changed\n\n"; 
}

# changes prints to python prints, without \n, brackets for variables
sub changePrints { 
#	print "Changing prints...\n";
	
	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line has a print 
		if ($line =~ /print/) { 
			# if this print line contains a $ 
			if ($line =~ /\$/) { 
				# save into a new variable for editing (might be unneccessary)
				my $varPrint .= $line;
				# we split the line so that we can replace the $ and insert (
				my @lineArray = split (' ', $varPrint);
				# traverse the array
				foreach my $i (0..$#lineArray) { 
					# we look for $ and replace it with a (
					if ($lineArray[$i] =~ /\$/) { 
						$lineArray[$i] =~ s/\$/\(/;
						# splice the array at the point +1 after we find the $
						# and then add a )
						splice @lineArray, $i+1, 0, ')';
					} 
					# replaces all " with nothing
					if ($lineArray[$i] =~ /"$/) { 
						$lineArray[$i] =~ s/"$//g;
					}
				}
				# join the array back up 
				$varPrint = join(' ', @lineArray);
				# push the line back onto the array
				$varPrint =~ s/$/\n/;
				# keep a counter of how many " we see
				my $count = 0;
				# if we do see one
				if ($varPrint =~ /"/) { 
					# increment the count
				    $count++;
					# replace it with nothing
				    $varPrint =~ s/"//g;
					# push the replaced line back onto the array
				    push(@pythonArray, $varPrint)
				}
			} else { 
				# this will push the line back onto the array if there is no $
				push (@pythonArray, $line);
			}
        } else {  
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Changed prints\n\n";
}

# removes all types of white space at the beginning of lines
# other subroutines will address for needed whitespace
sub removeWhiteSpace { 
#	print "Removing white space...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if there are any whitespace at the beginning of the line
		if ($line =~ /^\s+/) { 
			# replace all the white space with nothing
			$line =~ s/^\s+//g;
			# push it back onto the array
			push(@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push(@pythonArray, $line);
		}
	}
#	print "Removed white space\n";
}

# changes perl ifs to pythons ifs with : and indentation
	# also accounts for < <= > >= != == 
sub changeIfs { 
#	print "Changing ifs...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line contains an if at the beginning
		if ($line =~ /^if/) { 
			# if it does, split the line so we can access each element
			my @lineArray = split (' ', $line);
			foreach my $i (0..$#lineArray) { 
				# if there are brackets, replace them with nothing
				if ($lineArray[$i] =~ /\(|\)/) { 
					$lineArray[$i] =~ s/\(|\)//;
				}
				# if there is a { at the end of the line replace it with a :
				if ($lineArray[$i] =~ /\{$/) { 
					$lineArray[$i] =~ s/\{$/:/;
				}
			}
			# join the line back up together
			$line = join (' ', @lineArray);
			# push it back onto the array
			push (@pythonArray, $line);
			# we need to shift the line once more to check the next line
			$line = shift @file;
			# while line isn't a } 
			while ($line !~ /\}/) {
				# we added the neccessary spacing
				$line =~ s/^/\n\t/;
				# push it back onto the array
				push (@pythonArray, $line);
				# shift the counter
				$line = shift @file;
			}
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Changed ifs\n\n";
}

# changes perl whiless to pythons whiles with : and indentation
	# also accounts for < <= > >= != ==
sub changeWhiles { 
#	print "Changing whiles...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line has a while at the beginning
		if ($line =~ /^while/) { 
			# if it does, split the line so we can access each element
			my @lineArray = split (' ', $line);
			foreach my $i (0..$#lineArray) { 
				# if there are brackets, replace them with nothing
				if ($lineArray[$i] =~ /\(|\)/) { 
					$lineArray[$i] =~ s/\(|\)//;
				}
				# if there is a { at the end of the line replace it with a :
				if ($lineArray[$i] =~ /\{$/) { 
					$lineArray[$i] =~ s/\{$/:/;
				}
			}
			# join the line back up together
			$line = join (' ', @lineArray);
			# push it back onto the array
			push (@pythonArray, $line);
			# we need to shift the line once more to check the next line			
			$line = shift @file;
			# while line isn't a } 
			while ($line !~ /\}/) { 
				# we added the neccessary spacing
				$line =~ s/^/\n\t/;
				# push it back onto the array
				push (@pythonArray, $line);
				# shift the counter
				$line = shift @file;
			}
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Changed whiles\n\n";
}

# subroutine which changes the for loops.
	# only works if the array has already been predeclared
		# eg @array = (0, 1, 2, 3);
	# and if the array name is used within the intial for loop
		# eg for ($n = 0; $n < $#array; $n = $n + 1)
	# and if the for loop only increases by one.
sub changeFors { 
#	print "Changing fors...\n";
 
   	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
			# some variables to hold data
			my $variable = ""; 
			my $arrayName = "";
			my $newForLine = "";	
			# if the line only matches a for
			if ($line =~ /\bfor\b/) { 
				# if it does, split the line so we can access each element 
				my @forLine = split (' ', $line);
				# if the second array element contains the a dollar sign hence a variable
				if ($forLine[1] =~ /\$/) { 
					# save the variable name into a variable					
					$variable = $forLine[1];
					# edit the variable 
					$variable =~ s/\(\$//;
					foreach my $word (@forLine) { 
						# if there is a $# for the size of the array
						if ($word =~ /^\$#/) { 
							# save it into the variable
							$arrayName = $word;
							# remove all unneccessary meta characters
							$arrayName =~ s/^\$#//;
							$arrayName =~ s/\;$//;
						}	
					}
				}
				# create the new line with the relevant data
				$newForLine = "for $variable in $arrayName: ";
				# push it back onto the array
				push (@pythonArray, $newForLine);
				# we need to shift the line once more to check the next line			
				$line = shift @file;
				# while line isn't a } 
				while ($line !~ /\}/) {
					# we added the neccessary spacing 
					$line =~ s/^/\n\t/;
					# push it back onto the array
					push (@pythonArray, $line);
					# shift the counter
					$line = shift @file;
				}
			# else the line only matches a foreach	
			# repeat the above process
			} elsif ($line =~ /\bforeach\b/) { 
				my @foreachLine = split (' ', $line);
				if ($foreachLine[1] =~ /\$/) { 
					$variable = $foreachLine[1];
					$variable =~ s/\$//;
				} 
				if ($foreachLine[2] =~ /\(@/) { 
					$arrayName = $foreachLine[2];
					$arrayName =~ s/\(@//g;
					$arrayName =~ s/\)//g;
				}
				my $newForeachLine = "for $variable in $arrayName: ";
				push (@pythonArray, $newForeachLine);
				while ($line !~ /\}/) {
					$line =~ s/^/\n\t/;
					push (@pythonArray, $line);
					$line = shift @file;
				}
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Changed fors.\n";
}

# addresses the use of && and || 
sub changeLogicalOperators { 
#	print "Changing logical operators...\n";

	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# if the line contains a double ampersand
		if ($line =~ /\&\&/) { 
			# replace it with the python equivalent and
			$line =~ s/\&\&/and/g;
			# push it back onto the array
			push (@pythonArray, $line);
		# if the line contains a double pipe
		} elsif ($line =~ /\|\|/) { 
			# replace it with the python equivalent or			
			$line =~ s/\|\|/or/g;
			# push it back onto the array
			push (@pythonArray, $line);
		} else { 
			# for every other line, push it back onto the array
			push (@pythonArray, $line);
		}
	}
#	print "Changed logical operators\n";
}

# this subroutine should change all other commands and their lines into # lines
sub others { 
	# reads the array parsed into a local variable
	my @file = @_;
	# while there are still elements inside the array
	while (@file > 0) { 
		# shift off the first element 
		my $line = shift @file;
		# check if the line doesn't not contain any of these
		if ($line !~ /for/ or $line !~ /if/ or $line !~ /while/ or 
		    $line !~ /print/ or $line !~ /$/ or $line !~ /\&\&/ or
			$line !~ /\|\|/) { 	
				# then add comments to the front
				$line =~ s/\$/#/;
				# push it back onto the array
				push (@pythonArray, $line);
		}
	}
}

# for each file inside the args
foreach my $file ($ARGV[0]) { 
	# open a file handle or die
	open IN, $file or die "Can't open $file\n";
	# read each line
	foreach my $line (<IN>) { 
		# push it onto the array
		push (@perlFile, $line);
	}
	# close the file handle
	close IN;

	# save the file name into another variable
	my $newFile .= $file;
	# make sure it has the correct extension
	$newFile =~ s/\..*/.py/;
	# open out the file handle or die
	open OUT, "> $newFile" or die "Can't write to $newFile";

	# we need to recopy the arrays so the one we wish to constantly edit has the updated array
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
	changeIfs(@perlFile);
	arrayCopy;
	changeWhiles(@perlFile);
	arrayCopy;
	changeFors(@perlFile);
	arrayCopy;
	changeLogicalOperators(@perlFile);
	arrayCopy;
	changeVariables(@perlFile);
	arrayCopy;
	changePrints(@perlFile);
	arrayCopy;
	others(@perlFile);
	arrayCopy;

	# testing
#	print "\nStart Python Array: \n";
#	print @perlFile;
#	print "End Python Array\n\n";

	# prints out to the filehandle
	foreach my $line (@perlFile) { 
		print OUT $line;
	}

	close OUT;
}