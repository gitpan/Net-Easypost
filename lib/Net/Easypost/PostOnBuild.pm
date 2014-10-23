package Net::Easypost::PostOnBuild;
$Net::Easypost::PostOnBuild::VERSION = '0.10';
use Moo::Role;

sub BUILD {}
after BUILD => sub {
    my $self = shift;

   my $resp = $self->requester->post(
      $self->operation,
      $self->serialize,
   );
   $self->_set_id( $resp->{id} );
};


sub serialize {
   my ($self, $attrs) = @_;
   $attrs //= $self->fieldnames;

   # want a hashref of e.g., role[field1] => foo from all defined attributes
   return {
      map { $self->role . "[$_]" => $self->$_ }
         grep { defined $self->$_ }
            @$attrs
   };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Easypost::PostOnBuild

=head1 VERSION

version 0.10

=head1 METHODS

=head2 serialize

Format the defined attributes for a call to the Easypost service.
Takes an arrayref of attributes to serialize. Defaults to the C<fieldnames> attribute.

=head1 AUTHOR

Mark Allen <mrallen1@yahoo.com>, Hunter McMillen <mcmillhj@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
