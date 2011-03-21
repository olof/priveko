#!/usr/bin/perl
use strict;
use warnings;
use feature qw/say/;
use Test::More tests=>8;

my $minimum = << 'EOF';
balance: 
     626 # checking account
--------
     626

in: 
    4000 # selling drugs
--------
    4000

foo: 
-   2800 # rent
--------
-   2800

summary: 
     626 # balance
    4000 # in
-   2800 # foo
--------
    1826
EOF

my $update = << 'EOF';
balance: 
     626 # checking account
--------
     626

debts: 
     100 # my brother owes me some monies
-    300 # i owe my friend some money
--------
-    200

out: 
     700 # buying candy
--------
     700

summary: 
     626 # balance
-    200 # debts
     700 # out
--------
    1126
EOF

my $toosimple = << 'EOF';
balance: 
     626 # checking account
--------
     626

summary: 
     626 # balance
--------
     626
EOF

my $simple = << 'EOF';
foo: 
     300 # lorem
     800 # ipsum
--------
    1100

bar: 
       1 # smth
       2 # smth more
--------
       3

summary: 
    1100 # foo
       3 # bar
--------
    1103
EOF

my $comments = << 'EOF';
foo: 
#     300 # lorem
#     800 # ipsum
--------
       0

bar: 
       1 # smth
       2 # smth more
--------
       3

summary: 
       0 # foo
       3 # bar
--------
       3
EOF

open my $fh, '<', 't/data/02-nochange.data';
my $nochange = join '', <$fh>;
close $fh;

is(
	`perl priveko t/data/02-minimum.data`,
	$minimum,
	'Bare minimum of what the parser accepts'
);

is(
	`perl priveko t/data/02-nochange.data`,
	$nochange,
	'No difference between output and file'
);

is(
	`perl priveko t/data/02-update.data`,
	$update,
	'priveko should update some fields'
);

is(
	`perl priveko t/data/02-too_simple.data`,
	$toosimple,
	'just one value'
);

is(
	`perl priveko t/data/02-too_simple_no_summary.data`,
	$toosimple,
	'just one value (generate summary)'
);

is(
	`perl priveko t/data/02-simple.data`,
	$simple,
	'verify that priveko can do simple math'
);

is(
	`perl priveko t/data/02-comments.data`,
	$comments,
	'verify that priveko strips comments as it should'
);

is(
	system('perl priveko t/data/02-broken.data 2>/dev/null')>>8,
	1,
	'priveko should fail on syntax error'
);

