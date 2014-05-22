package Net::Easypost::Parcel;
$Net::Easypost::Parcel::VERSION = '0.12';
use Moo;

with qw(Net::Easypost::PostOnBuild);
with qw(Net::Easypost::Resource);

# ABSTRACT: An object to represent an Easypost parcel


has length => (
    is => 'rw',
);


has width => (
    is => 'rw',
);


has height => (
    is => 'rw',
);


has weight => (
    is => 'rw',
);


has predefined_package => (
    is => 'rw',
);


sub _build_fieldnames { [qw(length width height weight predefined_package)] }


sub _build_role { 'parcel' }


sub _build_operation { '/parcels' }


sub clone {
    my $self = shift;

    return Net::Easypost::Parcel->new(
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                'id', $self->fieldnames
    );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Easypost::Parcel - An object to represent an Easypost parcel

=head1 VERSION

version 0.12

=head1 ATTRIBUTES

=head2 length

The length of the parcel in inches.

=head2 width

The width of the parcel in inches.

=head2 height

The height of the parcel in inches.

=head2 weight

The weight of the parcel in ounces. (There are 16 ounces in a U.S. pound.)

=head2 predefined_package

A carrier specific flat-rate package name. See L<https://www.easypost.com/docs/api/#predefined-packages> for these.

=head1 METHODS

=head2 _build_fieldnames

Attributes that make up an Parcel, from L<Net::Easypost::Resource>

=head2 _build_role

Prefix to data when POSTing to the Easypost API about Parcel objects

=head2 _build_operation

Base API endpoint for operations on Address objects

=head2 clone

returns a new Net::Easypost::Parcel object that is a deep-copy of this object

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>, Hunter McMillen <mcmillhj@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
