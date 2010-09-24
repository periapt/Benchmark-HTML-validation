#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Benchmark qw(cmpthese);
use lib qw(lib);
use Readonly;
use File::Basename;
use Test::More;
use Test::Regression;
use Perl6::Slurp;

use Null;
use StripScripts;

Readonly my %ROUTINES => (
    null => \&Null::filter,
    stripscripts => \&StripScripts::filter,
);
Readonly my $COUNT => 1000;

my @tests = glob 'in/*';

plan tests => (keys %ROUTINES)*@tests*$COUNT;

foreach my $t (@tests) {
    compare($t);
}

sub compare {
    my $test = shift;
    my $basename = basename($test);

    print "**********${basename}*************\n";
    my %tests;
    foreach my $key (keys %ROUTINES) {
        $tests{$key} = sub {
            my $input = slurp $test;
            ok_regression(
                sub {return &{$ROUTINES{$key}}($input)},
                $key eq 'null' ? $test : "out/$basename",
                "$basename - $key"
            );
        };               
    }
    cmpthese $COUNT, \%tests;
}
