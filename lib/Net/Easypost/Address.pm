package Net::Easypost::Address;
{
  $Net::Easypost::Address::VERSION = '0.07';
}

use 5.014;
use Moo;

use overload 
    '""' => \&as_string;

# ABSTRACT: Class to represent an Easypost address 


has 'street1' => (
    is => 'rw',
);


has 'street2' => (
    is => 'rw',
);


has 'city' => (
    is => 'rw',
);


has 'state' => (
    is => 'rw',
);


has 'zip' => (
    is => 'rw',
);


has 'phone' => (
    is => 'rw',
);


has 'name' => (
    is => 'rw',
);


has 'role' => (
    is => 'rw',
    required => 1,
    lazy => 1,
    default => sub { 'address' }
);


has 'order' => (
    is => 'ro',
    lazy => 1,
    default => sub { [qw(name street1 street2 city state zip phone)] }
);


sub serialize {
    my $self = shift;
    my $order = shift // $self->order;

    # want a hash of e.g., address[address1] => foo from all defined attributes 
    my %h = map { $self->role . "[$_]" => $self->$_ } 
        grep { defined $self->$_ } @{$order};

    return \%h;
}


sub clone {
    my $self = shift;

    return $self->new(
        map { $_ => $self->$_ } grep { defined $self->$_ } @{$self->order}, 'role'
    );
}


sub as_string {
    my $self = shift;

    join "\n", 
        (map { $self->$_ } grep { defined $self->$_ } qw(name phone street1 street2)),
        join " ", map { $self->$_ } grep { defined $self->$_ } qw(city state zip)
        ;
}


sub merge {
    my $self = shift;
    my $old = shift;
    my $fields = shift;

    map { $self->$_($old->$_); } grep { defined $old->$_ } @{ $fields };

    return $self;
}

1;

__END__
=pod

=head1 NAME

Net::Easypost::Address - Class to represent an Easypost address 

=head1 VERSION

version 0.07

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

=head2 role

The role of this address. For example, if this is a recipient, it is in the 'to' role.
If it's the sender's address, it's in the 'from' role. Defaults to 'address'.

=head2 order

The order attributes should be processed during serialization or cloning. Defaults to
name, street1, street2, city, state, zip, phone.

=head1 METHODS

=head2 serialize

Format the defined attributes for a call to the Easypost service. Takes an arrayref of attributes
to serialize. Defaults to the C<order> attribute.

=head2 clone

Make a new copy of this object and return it.

=head2 as_string

Format this address as it might be seen on a mailing label. This class overloads 
stringification using this method, so something like C<say $addr> should just work.

=head2 merge

This method takes a L<Net::Easypost::Address> object and an arrayref of fields to copy
into B<this> object. This method only merges fields that are defined on the other object.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

