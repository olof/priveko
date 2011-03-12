#!/usr/bin/perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
	NAME => 'priveko',
	EXE_FILES => ['priveko'],
	AUTHOR => 'Olof Johansson <olof@ethup.se>',
	LICENSE => 'GNU APL',
	ABSTRACT_FROM => 'priveko',
	VERSION_FROM => 'priveko',
	MAN3PODS => {},
);

