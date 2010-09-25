package MarpaParser;
use strict;
use warnings;
use Carp;
use Marpa::HTML qw(html);

sub filter {
    my $text = shift;

    my $clean = html(\$text);
    return $$clean;
}   


1
