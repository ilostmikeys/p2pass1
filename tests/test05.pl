#!/usr/bin/perl -w

@lines = <STDIN>;
while (@lines) {
    print pop @lines;
}