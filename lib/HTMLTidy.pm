package HTMLTidy;
use strict;
use warnings;
use Carp;
use HTML::Tidy;

sub filter {
    my $text = shift;

    my $tidy = HTML::Tidy->new({'show-body-only'=>1});

    return $tidy->clean($text);
}   


1
