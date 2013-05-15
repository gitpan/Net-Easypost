package Net::Easypost::Rate;
{
  $Net::Easypost::Rate::VERSION = '0.05';
}

use 5.014;
use Moo;

# ABSTRACT: An object to represent an Easypost shipping rate


has 'carrier' => (
    is => 'ro',
    lazy => 1,
    default => sub { 'USPS' }
);


has 'service' => (
    is => 'ro',
);


has 'rate' => (
    is => 'ro',
);


sub serialize {
    my $self = shift;

    my %h = map { $_ => $self->$_ } 
        grep { defined $self->$_ } qw(carrier service rate);

    return \%h;
}


1;


__END__
=pod

=head1 NAME

Net::Easypost::Rate - An object to represent an Easypost shipping rate

=head1 VERSION

version 0.05

=head1 ATTRIBUTES

=head2 carrier

The shipping carrier. At the current time, the United States Postal Service (USPS) is the only
supported carrier.

=head2 service

The shipping service name. For example, for the USPS, these include 'Priority', 'Express',
'Media Mail' and others.

=head2 rate

The price in US dollars to ship using the associated carrier and service.

=head1 METHODS

=head2 serialize

Format this object into a form suitable to use with Easypost.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

