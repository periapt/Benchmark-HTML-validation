package HTML::Parser::Periapt;
use base qw(HTML::StripScripts::Parser);


sub init_attrib_whitelist  {
    my ($self) = @_;
    my %Attrib     = %{$self->SUPER::init_attrib_whitelist};
    $Attrib{a} = {
            'href'          => 'href',
            'title'         => 'text',
    };
    $Attrib{img} = {
            'src'           => 'href',
            'title'         => 'text',
            'alt'           => 'text',
            'width'         => 'number',
            'height'        => 'number',
    };
    $Attrib{div}={};
    $Attrib{p}={};
    $Attrib{em}={};
    $Attrib{strong}={};
    $Attrib{h3}={};
    return \%Attrib;
}


1;

