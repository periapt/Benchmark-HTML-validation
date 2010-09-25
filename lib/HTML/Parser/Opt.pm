package HTML::Parser::Opt;
use base qw(HTML::Parser);

sub new {
    my $class = shift;
    my $self = HTML::Parser->new(
        attr_encoded=>1,
        empty_element_tags=>1,
        strict_end=>1,
        utf8_mode=>1,
    );
    bless $self, $class;

    $self->{__OUT__} = "";
    $self->handler(text=>'text_process','self, dtext');
    $self->handler(start=>'start_process','self, tagname, attr, text');
    $self->handler(end=>'end_process','self, tagname');
    $self->ignore_tags('span');

    $self->{__START__} = {
        img=>"img_start",
        a=>"a_start",
    };

    return $self;
}

sub text_process {
    my $self = shift;
    my $dtext = shift;
    $self->{__OUT__} .= $dtext;
}

sub start_process {
    my $self = shift;
    my $tagname = shift;
    my $attr = shift;

    if (exists $self->{__START__}->{$tagname}) {
        my $callback = $self->{__START__}->{$tagname};
        $self->$callback($tagname, $attr);
    }
}

sub end_process {
    my $self = shift;
    my $tagname = shift;
    $self->{__OUT__} .= "</$tagname>";
    return;
}

sub img_start {
    my $self = shift;
    my $tagname = shift;
    my $attr = shift;

    return if not my $height = $attr->{height};
    return if not my $width = $attr->{width};
    return if not my $alt = $attr->{alt};
    return if not my $title = $attr->{title};
    return if not my $src = $attr->{src};
    $self->{__OUT__}
        .= "<img alt=\"$alt\" height=\"$height\" src=\"$src\" "
        ."title=\"$title\" width=\"$width\" />";
    return;
}

sub a_start {
    my $self = shift;
    my $tagname = shift;
    my $attr = shift;

    return if not my $title = $attr->{title};
    return if not my $href = $attr->{href};
    $self->{__OUT__}
        .= "<a href=\"$href\" title=\"$title\">";
    return;
}

sub clean {
    my $self = shift;
    my $string = shift;
    $self->parse($string);
    $self->eof;

    return $self->{__OUT__};
}

1;

