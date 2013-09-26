#!/usr/bin/perl -w

foreach $file (@ARGV) { 

	print $file;
	open my $in, ">", $file or die "Can't open $file\n";

	my $newFile .= $file;
	$newFile =~ s/\..*/.py/;

	open my $out, "<",  or die "Can't write to $newFile\n";

	writeHello($args->{out});
} 

sub writeHello { 
	print {$args->{out}} "Hello";
}
