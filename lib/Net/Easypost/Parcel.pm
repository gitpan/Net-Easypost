package Net::Easypost::Parcel;
{
  $Net::Easypost::Parcel::VERSION = '0.02';
}

use 5.014;
use Moo;

# ABSTRACT: An object to represent an Easypost parcel


has 'length' => (

    is => 'rw',
);


has 'width' => (
    is => 'rw',
);


has 'height' => (
    is => 'rw',
);


has 'weight' => (
    is => 'rw',
);


has 'predefined_package' => (
    is => 'rw',
);


sub serialize {
    my $self = shift;
    my $role = shift // 'parcel';

    # want a hash of e.g., parcel[address1] => foo from all defined attributes 
    my %h = map { $role . "[$_]" => $self->$_ } 
        grep { defined $self->$_ } qw(length width height weight predefined_package);

    return \%h;
}


sub clone {
    my $self = shift;

    return $self->new(
        map { $_ => $self->$_ } grep { defined $self->$_ } qw(length width height weight predefined_package)    
    );
}

1;

__END__
=pod

=head1 NAME

Net::Easypost::Parcel - An object to represent an Easypost parcel

=head1 VERSION

version 0.02

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

A carrier specific flat-rate package name. See L<https://www.easypost.co/api> for these.

=head1 METHODS

=head2 serialize

Format this object into a form suitable for use with the Easypost service.

=head2 clone

Make a new copy of this object.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

