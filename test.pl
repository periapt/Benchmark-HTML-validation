#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Benchmark qw(timethese cmpthese);
use lib qw(lib);
use Readonly;
use File::Basename;
use Perl6::Slurp;
use Text::SimpleTable;

use Null;
use StripScripts;
use HTMLTidy;
use Defang;
use MarpaParser;
use Detoxifier;
use HP;
# ToDO: Restrict, Laundry

my %routines = (
    null => \&Null::filter,
    stripscripts => \&StripScripts::filter,
#    detoxifier=> \&Detoxifier::filter,
#    defang=>\&Defang::filter,
#    htmltidy=>\&HTMLTidy::filter,
#    marpa=>\&MarpaParser::filter,
#    hp=>\&HP::filter,
);
Readonly my $COUNT => -2;

my @tests = glob 'in/*';

my %success;
my %total;

foreach my $t (@tests) {
#    next unless $t =~ /badhref/;
    compare($t);
}

my $table = Text::SimpleTable->new(10,10,10,10,10,10);
foreach my $s (keys %success) {
    my @results = @{$total{$s}};
    my @row = ($s, $success{$s});
    for(my $i = 0; $i<5; $i++) {
        push @row, sprintf("%.8f", $results[$i]/$results[5]);
    }
    $table->row(@row);
}
print $table->draw;

exit(0);

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
    totalify($result);
    cmpthese $result;
}

sub totalify {
    my $result = shift;
    foreach my $key (keys %$result) {
        if (not exists $total{$key}) {
            $total{$key} = [0,0,0,0,0,0];
        }
        for(my $i = 0; $i<6; $i++) {
            $total{$key}->[$i] += $result->{$key}->[$i];
        }
    }
}

