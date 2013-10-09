#!/usr/bin/perl -w

die "Usage: $0 <perl> [files]\n" if !@ARGV;
$perl_code = shift @ARGV;
foreach $filename (@ARGV) {
    $_ = $filename;
    eval $perl_code;
    die "$0: $?" if $?; # eval leaves any error message in $?
    $new_filename = $_;
    next if $filename eq $new_filename;
    -e $new_filename and die "$0: $new_filename exists already\n";
    rename $filename, $new_filename or die "$0: rename $filename -> $new_filename failed: $!\n";
}
