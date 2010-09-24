#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Benchmark qw(timethese cmpthese);
use lib qw(lib);
use Readonly;
use File::Basename;
use Perl6::Slurp;

use Null;
use StripScripts;
use HTMLTidy;
use Defang;
# ToDO: Strip, Detoxify, Marpa

my %routines = (
    null => \&Null::filter,
    stripscripts => \&StripScripts::filter,
    defang=>\&Defang::filter,
    htmltidy=>\&HTMLTidy::filter,
);
Readonly my $COUNT => 10_000;

my @tests = glob 'in/*';

my %success;

foreach my $t (@tests) {
    compare($t);
}

sub compare {
    my $test = shift;
    my $basename = basename($test);
    my $input = slurp $test;

    print "**********${basename}*************\n";
    my %tests;
    my %current = %routines;
    foreach my $key (keys %current) {
        my $expected = slurp($key eq 'null' ? $test : "out/$basename");
        $tests{$key} = sub {
            my $actual = &{$current{$key}}($input);
            if ($actual eq $expected) {
                $success{$key} = $basename;
            }
            else {
                delete $routines{$key};
            }
        };               
    }
    my $result = timethese $COUNT, \%tests;
    cmpthese $result;
}

foreach my $s (keys %success) {
    print "$s: $success{$s}\n";
}


