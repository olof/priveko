#!/usr/bin/perl
#
# Copyright (c) 2011 - Olof Johansson <olof@cpan.org>
# All rights reserved.
# 
# This program is free software; you can redistribute it and/or 
# modify it under the same terms as Perl itself.

$VERSION = '0.1';
my $APP = 'priveko';

use strict;
use warnings;
use feature qw/say/;

my @output;
my @sections;
my $opts;

sub output_section {
	my $sec = shift;
	push @output, "$sec: ";
}

sub output_element {
	my ($n,$c) = @_;
	push @output, sprintf "%s%7d # %s", $n<0 ? '-' : ' ', abs($n), $c;
}

sub output_secsum {
	my $n=0;
	push @output, '--------';
	$n+=$_ for @_;
	push @output, sprintf "%s%7d", $n<0 ? '-' : ' ', abs($n);
	push @output, '';
	return $n;
}

sub section {
	my $section = shift;
	my @items;

	output_section($section);

	while(<>) {
		chomp;
		last if /^--------/;
		my ($comment) = /#\s*(.*)$/;
		s/#.*//;
		s/\s*//g;

		unless(/^-?\d+(?:[\.,]\d+)?$/) {
			say STDERR "Error: bad input: $_ on row $.";
			exit(1);
		}
		s/,/./; # support for both , and . as decimal separator

		push @items, $_;
		output_element($_, $comment);
	}

	return output_secsum(@items);
}

sub summary {
	output_section('summary');
	my @items;
	
	foreach(@sections) {
		output_element($_->[1], $_->[0]);
		push @items, $_->[1];
	}
	output_secsum(@items);
}

my %section = (
	default => sub { my $s = shift; push @sections, [$s, section($s)] },
	summary => sub { summary() },
);

while(<>) {
	chomp;
	if(/^(\w+):/) {
		if(lc $1 eq 'summary') {
			$section{$1}->();
		} else {
			$section{default}->($1);
		}
	}
}

print join "\n", @output;

=head1 NAME 

priveko - keeping track of your private economy

=head1 USAGE

 priveko <file>

=head1 DESCRIPTION

priveko is a simple file based book keeping system for simple economy
tasks. All items are entered manually by you, directly in the text file.
You don't have to calculated the sums by yourself; this is where priveko
comes in. Just run the program and it will produce sums for each section
as well as a summary section with each section summed to a total.

=head1 FILE FORMAT

The file consists of one or more arbitrarily named sections. There is one
special section, B<summary>. This section will be completly overwritten 
when you run priveko.

Each section consists of lines with the transaction balance and a comment, 
of the format:

    123 # comment

Or possibly negative values:

 -  123 # comment

The section ends with a line consisting of eight dashes followed by the
sum of the section's items. The sections are separetad with an empty line.
The description here is of what priveko produces, not what i accepts. It
is a bit more tolerant with its input, but it's probably a good idea to 
follow this syntax.

A simple, but complete, example (the example amounts are in SEK):

 balance:
     2500 # checking account
 --------
     2500

 in:
    33000 # salery, expected 2011-03-25
      800 # housing subsidy
 --------
    23800

 out:
 -   4000 # rent
 -    600 # power costs
 -    300 # isp
 --------
 -   4900

 summary:
     2500 # balance
    33800 # in
 -   4900 # out
 --------
    31400

=head1 AVAILABILITY

The latest version is available from Github:

 https://github.com/olof/priveko

=head1 AUTHOR AND COPYRIGHT

Copyright 2011, Olof Johansson <olof@ethup.se>

Copying and distribution of this file, with or without 
modification, are permitted in any medium without royalty 
provided the copyright notice are preserved. This file is 
offered as-is, without any warranty.

