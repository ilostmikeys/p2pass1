#!/usr/bin/perl -w

while ($line = <STDIN>) {
    unshift @lines, $line;
}
print @lines;