#!/usr/bin/perl -w

$line_count = 0;
while (1) {
    $line = <STDIN>;
    last if !$line;
    $line_count++;
}
print "$line_count lines\n";