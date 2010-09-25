package StripScripts;
use strict;
use warnings;
use Carp;
use HTML::Parser::Periapt;

sub filter {
    my $text = shift;

    my $tidy = HTML::Parser::Periapt->new(
    {
           Context => 'Flow',       ## HTML::StripScripts configuration
           AllowHref=>1,
           AllowSrc=>1,
           AllowRelURL=>1,
           EscapeFiltered=>0,
           BanAllBut=>[qw(div p span em strong h3 img a)],
           Rules   => {
                div=>1,
                p=>sub {
                    my ($filter, $element) = @_;
                    return 0 if $element->{content} =~ m{\A\s*\z}xms;
                    return 1;
                },
                span=>sub {
                    my ($filter, $element) = @_;
                    $element->{tag} = '';
                    return 1;                    
                },
                em=>1,
                strong=>1,
                h3=>1,
                a=>{
                    href=>qr{\A/\w[\w/\#]*\z}xms,
                    title=>1,
                    required=>[qw(href)],
                },
                img=>{
                    src=>1,
                    title=>1,
                    width=>1,
                    height=>1,
                    alt=>1,
                    required=>[qw(src width height)],
                },
            },
    },
    empty_element_tags=>1
    );

    return $tidy->filter_html($text);
}   


1
