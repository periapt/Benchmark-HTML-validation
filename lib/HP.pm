package HP;
use strict;
use warnings;
use Carp;
use HTML::Parser::Opt;

sub filter {
    my $text = shift;

    my $tidy = HTML::Parser::Opt->new;

    return $tidy->clean($text);
}   


1
