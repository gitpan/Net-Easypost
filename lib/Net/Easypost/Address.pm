package Net::Easypost::Address;
$Net::Easypost::Address::VERSION = '0.13';
use Carp qw(croak);
use Moo;
use Scalar::Util;
use overload
   '""' => sub { $_[0]->as_string },
   '0+' => sub { Scalar::Util::refaddr($_[0]) },
   fallback => 1;

with qw(Net::Easypost::PostOnBuild);
with qw(Net::Easypost::Resource);

# ABSTRACT: Class to represent an Easypost address


has street1 => (
    is => 'rw',
);


has street2 => (
    is => 'rw',
);


has city => (
    is => 'rw',
);


has state => (
    is => 'rw',
);


has zip => (
    is => 'rw',
);


has phone => (
    is => 'rw',
);


has name => (
    is => 'rw',
);


sub _build_fieldnames { [qw(name street1 street2 city state zip phone)] }


sub _build_role { 'address' }


sub _build_operation { '/addresses' }


sub clone {
    my $self = shift;

    return Net::Easypost::Address->new(
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                @{ $self->fieldnames }
    );
}


sub as_string {
    my $self = shift;

    join "\n",
        (map  { $self->$_ }
            grep { defined $self->$_ } qw(name phone street1 street2)),
        join " ",
            (map  { $self->$_ }
                grep { defined $self->$_ } qw(city state zip));
}


sub merge {
    my ($self, $old, $fields) = @_;

    map { $self->$_($old->$_) }
        grep { defined $old->$_ }
            @$fields;

    return $self;
}


sub verify {
    my $self = shift;
    use Data::Dumper;

    my $verify_response =
       $self->requester->get( $self->operation . '/' . $self->id . '/verify' );

    croak 'Unable to verify address, failed with message: '
             . $verify_response->{error}
       if $verify_response->{error};

    my $new_address = Net::Easypost::Address->new(
        $verify_response->json->{address}
    );

    return $new_address->merge($self, [qw(phone name)]);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Easypost::Address - Class to represent an Easypost address

=head1 VERSION

version 0.13

=head1 ATTRIBUTES

=head2 street1

A field for street information, typically a house number, a street name and a direction

=head2 street2

A field for any additional street information like an apartment or suite number

=head2 city

The city in the address

=head2 state

The U.S. state for this address

=head2 zip

The U.S. zipcode for this address

=head2 phone

Any phone number associated with this address.  Some carrier services like Next-Day or Express
require a sender phone number.

=head2 name

A name associated with this address.

=head1 METHODS

=head2 _build_fieldnames

Attributes that make up an Address, from L<Net::Easypost::Resource>

=head2 _build_role

Prefix to data when POSTing to the Easypost API about Address objects

=head2 _build_operation

Base API endpoint for operations on Address objects

=head2 clone

Make a new copy of this object and return it.

=head2 as_string

Format this address as it might be seen on a mailing label. This class overloads
stringification using this method, so something like C<say $addr> should just work.

=head2 merge

This method takes a L<Net::Easypost::Address> object and an arrayref of fields to copy
into B<this> object. This method only merges fields that are defined on the other object.

=head2 verify

This method takes a L<Net::Easypost::Address> object and verifies its underlying
address

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>, Hunter McMillen <mcmillhj@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
