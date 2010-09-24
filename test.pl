#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Benchmark qw(cmpthese timethis);
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
Readonly my $COUNT => 100;

my @tests = glob 'in/*';

plan tests => (keys %ROUTINES)*@tests*$COUNT;

#cmpthese -1, {
#    fast => 'sleep 1',
#    slow => 'sleep 2',
#};

foreach my $t (@tests) {
    compare($t);
}

#timethis(10, 'sleep 1');

sub compare {
    my $test = shift;
    my $basename = basename($test);

    print "**********${basename}*************\n";
    foreach my $key (keys %ROUTINES) {
        timethis($COUNT, sub {
            my $input = slurp $test;
            ok_regression(
                sub {return &{$ROUTINES{$key}}($input)},
                "out/$basename",
                "$basename - $key"
            );
        });               
    }
}
