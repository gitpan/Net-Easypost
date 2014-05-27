package Net::Easypost::Rate;
$Net::Easypost::Rate::VERSION = '0.13';
use Moo;

with qw(Net::Easypost::Resource);


has carrier => (
  is      => 'ro',
  lazy    => 1,
  default => sub { 'USPS' },
);


has service => (
  is => 'ro',
);


has rate => (
  is => 'ro',
);


has shipment_id => (
  is => 'ro',
);

sub _build_fieldnames { [qw(carrier service rate shipment_id)] }
sub _build_role { 'rate' }


sub serialize {
   my $self = shift;

   return { 'rate[id]' => $self->id };
}


sub clone {
   my $self = shift;

   return Net::Easypost::Rate->new(
      map { $_ => $self->$_ }
         grep { defined $self->$_ }
            'id', @{ $self->fieldnames }
   );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Easypost::Rate

=head1 VERSION

version 0.13

=head1 ATTRIBUTES

=head2 carrier

The shipping carrier. At the current time, the United States Postal Service (USPS) is the only
supported carrier.

=head2 service

The shipping service name. For example, for the USPS, these include 'Priority', 'Express',
'Media Mail' and others.

=head2 rate

The price in US dollars to ship using the associated carrier and service.

=head2 shipment_id

ID of the shipment that this Rate object relates to

=head1 METHODS

=head2 serialize

serialized form of Rate objects

=head2 clone

returns a new Rate object that is a deep-copy of this Rate object

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>, Hunter McMillen <mcmillhj@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
