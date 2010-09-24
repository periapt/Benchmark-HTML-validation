package Defang;
use strict;
use warnings;
use Carp;
use HTML::Defang;

sub filter {
    my $text = shift;

    my $tidy = HTML::Defang->new(
        fix_mismatched_tags => 1,
        tags_to_callback => [ qw( span ) ],
        tags_callback=>\&DefangTagsCallback,
    );
    return $tidy->defang($text);
}   

sub DefangTagsCallback {
    my ($self, $defang, $openAngle, $lcTag, $isEndTag, $attributeHash, $closeAngle, $htmlR, $outR) = @_;
    return 1 if $lcTag eq 'span';
    return 2;
}

1
