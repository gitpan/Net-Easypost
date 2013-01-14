package Net::Easypost::Label;
{
  $Net::Easypost::Label::VERSION = '0.02';
}

use 5.014;
use Moo;
use Carp qw(croak);
use IO::Handle;

with('Net::Easypost::Request');

# ABSTRACT: Object represents an Easypost label


has 'tracking_code' => (
    is => 'ro',
);


has 'filename' => (
    is => 'ro',
);


has 'filetype' => (
    is => 'ro',
    lazy => 1,
    default => sub { 'image/png' }
);



has 'url' => (
    is => 'ro',
    predicate => 1,
);


has 'rate' => (
    is => 'ro',
);



has 'image' => (
    is => 'ro',
    lazy => 1,
    predicate => 1,
    default => sub {
        my $self = shift;

        croak "can't retrieve image for " . $self->filename . 
            " without a url" unless $self->has_url; 

        return $self->get($self->url)->content->asset->slurp;
    }
);


sub save {
    my $self = shift;

    $self->image unless $self->has_image;

    open my $fh, ">:raw", $self->filename or croak "Couldn't save " . $self->filename . ": $!";
    print $fh $self->image;
    $fh->close;

}

1;

__END__
=pod

=head1 NAME

Net::Easypost::Label - Object represents an Easypost label

=head1 VERSION

version 0.02

=head1 ATTRIBUTES

=head2 tracking_code

The carrier generated tracking code for this label.

=head2 filename

The filename the Easypost API used to create the label file. (Also used
for local storage.)

=head2 filetype

The file type for the image data. Defaults to 'image/png'

=head2 url

The URL from which to download the label image.

=head2 rate

This is a L<Net::Easypost::Rate> object associated with the label.

=head2 image

This is the label image data.  It lazily downloads this information if a
URL is defined. It currently uses a L<Net::Easypost::Request> role to
get the data from the Easypost service.

=head1 METHODS

=head2 has_url

This is a predicate which tells the caller if a URL is defined in the object.

=head2 has_image

Tells the caller if an image has been downloaded.

=head2 save

Store the label image locally using the filename in the object. This will typically be
in the current working directory of the caller.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

