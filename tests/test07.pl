#!/usr/bin/perl -w

die "Usage: $0 <n> <files>\n" if !@ARGV;
$nth_word = shift @ARGV;
open F, "|fmt -w 40" or die "Can nor run fmt";
while ($line = <>) {
    chomp $line;
    @words = split(/ /, $line);
    print F "$words[$nth_word]\n" if $words[$nth_word];
}
close F;