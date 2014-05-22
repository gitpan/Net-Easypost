package Net::Easypost::Label;
$Net::Easypost::Label::VERSION = '0.12';
use Carp qw(croak);
use IO::Handle;
use Moo;
use Net::Easypost::Request;

with qw(Net::Easypost::Resource);


has tracking_code => (
    is       => 'ro',
    required => 1
);


has filename => (
    is       => 'ro',
    required => '1',
);


has filetype => (
    is      => 'ro',
    lazy    => 1,
    default => sub { 'image/png' }
);



has url => (
   is        => 'ro',
   predicate => 1,
   required  => 1,
);


has rate => (
   is  => 'ro',
);




has image => (
    is        => 'ro',
    lazy      => 1,
    predicate => 1,
    default   => sub {
        my $self = shift;

        croak "can't retrieve image for " . $self->filename . " without a url"
            unless $self->has_url;

        return $self->requester->get($self->url)->content->asset->slurp;
    }
);

sub _build_role { 'label' }
sub _build_fieldnames { [qw(tracking_code url filetype filename)] }



sub save {
    my $self = shift;

    $self->image
        unless $self->has_image;

    open my $fh, ">:raw", $self->filename
        or croak "Couldn't save " . $self->filename . ": $!";

    print {$fh} $self->image;
    $fh->close;
}


sub clone {
   my $self = shift;

   return Net::Easypost::Label->new(
      map { $_ => $self->$_ }
         grep { defined $self->$_ }
            'id', @{ $self->fieldnames }
   );
}


sub serialize {
   my $self = shift;

   # want a hashref of e.g., role[field1] => foo from all defined attributes
   return {
      map { $self->role . "[$_]" => $self->$_ }
         grep { defined $self->$_ }
            @{ $self->fieldnames }
   };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Easypost::Label

=head1 VERSION

version 0.12

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

The chosen rate for this Label

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

=head2 clone

returns a new Net::Easypost::Label object that is a deep-copy of this object

=head2 serialize

serialized form for Label objects

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>, Hunter McMillen <mcmillhj@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
