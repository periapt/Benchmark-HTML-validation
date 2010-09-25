package Detoxifier;
use strict;
use warnings;
use Carp;
use HTML::Detoxifier qw(detoxify);

sub filter {
    my $text = shift;

    return detoxify($text);
}   

1
